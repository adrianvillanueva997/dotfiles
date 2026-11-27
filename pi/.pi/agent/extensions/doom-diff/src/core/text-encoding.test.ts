import { describe, expect, it } from "vitest";
import {
	detectLineEnding,
	finalizeHashlineWriteContent,
	normalizeToLF,
	prepareTextForHashlineEdit,
	stripBom,
} from "./text-encoding.js";

describe("text-encoding", () => {
	it("stripBom", () => {
		expect(stripBom("x")).toEqual({ bom: "", text: "x" });
		expect(stripBom("\uFEFFx")).toEqual({ bom: "\uFEFF", text: "x" });
	});

	it("detectLineEnding prefers CRLF when it appears first", () => {
		expect(detectLineEnding("a\r\nb\n")).toBe("\r\n");
		expect(detectLineEnding("a\nb")).toBe("\n");
	});

	it("round-trip BOM + CRLF", () => {
		const raw = "\uFEFFline1\r\nline2\r\n";
		const { bom, ending, normalized } = prepareTextForHashlineEdit(raw);
		expect(bom).toBe("\uFEFF");
		expect(ending).toBe("\r\n");
		expect(normalized).toBe("line1\nline2\n");
		const out = finalizeHashlineWriteContent(bom, ending, "line1\nline2\n");
		expect(out).toBe(raw);
	});

	it("normalizeToLF", () => {
		expect(normalizeToLF("a\r\nb\rc")).toBe("a\nb\nc");
	});
});
