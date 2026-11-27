import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { invalidatePiDiffConfig } from "./core/config.js";
import diffRendererExtension from "./index.js";

describe("disabledTools configuration", () => {
	let tempDir: string;
	let cwdSpy: ReturnType<typeof vi.spyOn>;

	beforeEach(() => {
		tempDir = mkdtempSync(join(tmpdir(), "pi-diff-tools-"));
		cwdSpy = vi.spyOn(process, "cwd").mockReturnValue(tempDir);
		invalidatePiDiffConfig();
	});

	afterEach(() => {
		cwdSpy.mockRestore();
		invalidatePiDiffConfig();
		rmSync(tempDir, { recursive: true, force: true });
	});

	it("does not register apply_patch when it is disabled", async () => {
		writeFileSync(join(tempDir, "pi-diff.json"), JSON.stringify({ disabledTools: ["apply_patch"] }));
		const registeredTools: string[] = [];

		await diffRendererExtension({
			on: () => {},
			registerTool: (tool: { name: string }) => registeredTools.push(tool.name),
		} as never);

		expect(registeredTools).toContain("write");
		expect(registeredTools).toContain("edit");
		expect(registeredTools).not.toContain("apply_patch");
	});

	describe("edit safety contract", () => {
		async function registerEditTool() {
			const tools: Array<{
				name: string;
				execute: (...args: any[]) => Promise<any>;
				prepareArguments?: (input: any) => any;
			}> = [];
			await diffRendererExtension({
				on: () => {},
				registerTool: (tool: {
					name: string;
					execute: (...args: any[]) => Promise<any>;
					prepareArguments?: (input: any) => any;
				}) => tools.push(tool),
			} as never);
			const edit = tools.find((tool) => tool.name === "edit");
			if (!edit) throw new Error("edit tool was not registered");
			return edit;
		}

		it("rejects an ambiguous fuzzy match without changing the file", async () => {
			const file = join(tempDir, "ambiguous.ts");
			writeFileSync(file, "foo\nfoo\n");
			const edit = await registerEditTool();

			await expect(
				edit.execute(
					"test",
					{ path: file, edits: [{ oldText: "foo ", newText: "bar" }] },
					undefined,
					undefined,
					undefined,
				),
			).rejects.toThrow(/occurrences|unique/i);
			expect(readFileSync(file, "utf8")).toBe("foo\nfoo\n");
		});

		it("rejects overlapping occurrences instead of choosing the first", async () => {
			const file = join(tempDir, "overlap-match.ts");
			writeFileSync(file, "aaa");
			const edit = await registerEditTool();

			await expect(
				edit.execute(
					"test",
					{ path: `@${file}`, edits: [{ oldText: "aa", newText: "X" }] },
					undefined,
					undefined,
					undefined,
				),
			).rejects.toThrow(/ambiguous|overlap|occurrences|unique/i);
			expect(readFileSync(file, "utf8")).toBe("aaa");
		});

		it("preserves BOM and CRLF for fuzzy edits", async () => {
			const file = join(tempDir, "crlf.ts");
			writeFileSync(file, "\uFEFFheader\r\nfunction x() {\r\n    return 1;\r\n}\r\n");
			const edit = await registerEditTool();

			await edit.execute(
				"test",
				{
					path: file,
					edits: [
						{
							oldText: "function x() {\n    return 1;\n}",
							newText: "function x() {\n  return 2;\n}",
						},
					],
				},
				undefined,
				undefined,
				undefined,
			);
			expect(readFileSync(file, "utf8")).toBe("\uFEFFheader\r\nfunction x() {\r\n  return 2;\r\n}\r\n");
		});

		it("rejects overlapping edits matched against the original file", async () => {
			const file = join(tempDir, "overlap.ts");
			writeFileSync(file, "abc");
			const edit = await registerEditTool();

			await expect(
				edit.execute(
					"test",
					{
						path: file,
						edits: [
							{ oldText: "ab", newText: "abc" },
							{ oldText: "bc", newText: "X" },
						],
					},
					undefined,
					undefined,
					undefined,
				),
			).rejects.toThrow(/overlap/i);
			expect(readFileSync(file, "utf8")).toBe("abc");
		});

		it("renders the actual matched source in the returned preview", async () => {
			const file = join(tempDir, "preview.ts");
			writeFileSync(file, "const x = 1;  \n");
			const edit = await registerEditTool();

			const result = await edit.execute(
				"test",
				{ path: file, edits: [{ oldText: "const x = 1;\n", newText: "const x = 2;\n" }] },
				undefined,
				undefined,
				undefined,
			);
			const removed = result.details?.diff?.lines.find((line: { type: string }) => line.type === "del");
			expect(removed?.content).toBe("const x = 1;  ");
		});

		it("accepts legacy oldText and newText fields", async () => {
			const file = join(tempDir, "legacy.ts");
			writeFileSync(file, "const value = 1;\n");
			const edit = await registerEditTool();

			const args = edit.prepareArguments?.({
				path: file,
				oldText: "const value = 1;",
				newText: "const value = 2;",
			}) ?? {
				path: file,
				oldText: "const value = 1;",
				newText: "const value = 2;",
			};
			await edit.execute("test", args, undefined, undefined, undefined);
			expect(readFileSync(file, "utf8")).toBe("const value = 2;\n");
		});

		it("keeps disjoint multi-edits in one original-file transaction", async () => {
			const file = join(tempDir, "multi.ts");
			writeFileSync(file, "const a = 1;\nconst b = 2;\n");
			const edit = await registerEditTool();

			const result = await edit.execute(
				"test",
				{
					path: file,
					edits: [
						{ oldText: "const a = 1;", newText: "const a = 10;" },
						{ oldText: "const b = 2;", newText: "const b = 20;" },
					],
				},
				undefined,
				undefined,
				undefined,
			);
			expect(result.details?._type).toBe("multiEditInfo");
			expect(readFileSync(file, "utf8")).toBe("const a = 10;\nconst b = 20;\n");
		});
	});
});
