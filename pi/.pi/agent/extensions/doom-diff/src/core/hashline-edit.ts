import * as fs from "node:fs";
import * as path from "node:path";
import { applyHashlineEdits, type HashlineApplyError, type HashlineApplyOk, type HashlineEdit } from "../hashline.js";
import { finalizeHashlineWriteContent, prepareTextForHashlineEdit } from "./text-encoding.js";

export type FileHashlineApplyResult = HashlineApplyOk | HashlineApplyError;

export type HashlineEditApplyOptions = {
	dryRun?: boolean;
	/** If set, skip reading filePath (caller already read once). */
	rawUtf8?: string;
};

export type FileHashlineApplyOk = HashlineApplyOk & {
	newContent: string;
	/** Full on-disk text after edit (BOM + EOL restored); same as written when not dryRun. */
	finalRaw: string;
};

async function atomicWriteFile(filePath: string, content: string): Promise<void> {
	const dir = path.dirname(filePath);
	const tmp = path.join(dir, `.${path.basename(filePath)}.pi-hashline.${process.pid}.tmp`);
	await fs.promises.writeFile(tmp, content, "utf8");
	await fs.promises.rename(tmp, filePath);
}

export async function applyHashlineEditsToFile(
	filePath: string,
	changes: HashlineEdit[],
	options?: HashlineEditApplyOptions,
): Promise<(FileHashlineApplyOk | HashlineApplyError) & { newContent?: string; finalRaw?: string }> {
	const dryRun = options?.dryRun === true;
	let raw: string;
	if (options?.rawUtf8 !== undefined) {
		raw = options.rawUtf8;
	} else {
		try {
			raw = await fs.promises.readFile(filePath, "utf8");
		} catch (err) {
			const msg = err instanceof Error ? err.message : String(err);
			return { ok: false, error: `[E_READ_FAILED] cannot read ${filePath}: ${msg}`, code: "E_READ_FAILED" };
		}
	}

	const { bom, ending, normalized } = prepareTextForHashlineEdit(raw);
	const result = applyHashlineEdits(normalized, changes, filePath);
	if (!result.ok) return result;

	const finalRaw = finalizeHashlineWriteContent(bom, ending, result.newContent);
	if (!dryRun) {
		try {
			await atomicWriteFile(filePath, finalRaw);
		} catch (err) {
			const msg = err instanceof Error ? err.message : String(err);
			return { ok: false, error: `[E_WRITE_FAILED] cannot write ${filePath}: ${msg}`, code: "E_WRITE_FAILED" };
		}
	}

	return { ...result, newContent: result.newContent, finalRaw };
}
