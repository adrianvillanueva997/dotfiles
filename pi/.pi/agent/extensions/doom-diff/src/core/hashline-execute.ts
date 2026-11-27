import * as fs from "node:fs";
import * as Diff from "diff";
import type { HashlineEdit } from "../hashline.js";
import { formatHashlineReadLines } from "../hashline.js";
import { type ParsedDiff, parsePatchFiles } from "./diff.js";
import { applyHashlineEditsToFile, type HashlineEditApplyOptions } from "./hashline-edit.js";

export const HASHLINE_WORKFLOW =
	"Workflow: hashline_read(path) → copy HASH anchors from output → hashline_edit(path, start_hash, end_hash, replacement). Do not use plain read for edits.";

export const HASHLINE_READ_DESC = `${HASHLINE_WORKFLOW} Returns lines as LINE│HASH│content (1-based line numbers). Use HASH anchors in hashline_edit only.`;

export const HASHLINE_EDIT_DESC = `${HASHLINE_WORKFLOW} Strict atomic apply. Empty replacement deletes the range. Set dryRun:true to validate and preview diff without writing.`;

export type HashlineToolResult = {
	content: Array<{ type: "text"; text: string }>;
	isError?: boolean;
	details: Record<string, unknown>;
};

export type HashlineExecuteOptions = {
	resolvedPath: string;
	changes: HashlineEdit[];
	dryRun?: boolean;
	/** Pi tool call id — used to stash diff stats for renderCall */
	toolCallId?: string;
	onDiffStats?: (toolCallId: string, diff: ParsedDiff) => void;
};

function buildDiff(before: string, after: string, fp: string): ParsedDiff | null {
	if (before === after) return null;
	const patch = Diff.createPatch(fp, before, after, "before", "after", { context: 3 });
	const parsed = parsePatchFiles(patch);
	return parsed[0] || null;
}

function formatOkText(fp: string, changedRange: [number, number], dryRun: boolean, warnings: string[]): string {
	const start = changedRange[0] + 1;
	const end = changedRange[1] + 1;
	const prefix = dryRun ? "[DRY-RUN]" : "[OK]";
	let text = `${prefix} ${fp} ${dryRun ? "would edit" : "edited"} (lines ${start}-${end})`;
	if (warnings.length > 0) {
		text += `\n[${warnings.length} boundary warning(s)]\n${warnings.join("\n")}`;
	}
	return text;
}

function rereadHintFromSuggestions(
	fp: string,
	suggestions?: Array<{ line: number; ref: string }>,
): { path: string; startLine: number; endLine: number } | undefined {
	if (!suggestions?.length) return undefined;
	const lines = suggestions.map((s) => s.line + 1);
	const startLine = Math.max(1, Math.min(...lines) - 2);
	const endLine = Math.max(...lines) + 2;
	return { path: fp, startLine, endLine };
}

export async function runHashlineEdit(opts: HashlineExecuteOptions): Promise<HashlineToolResult> {
	const { resolvedPath: fp, changes, dryRun = false, toolCallId, onDiffStats } = opts;

	let beforeContent = "";
	let rawUtf8: string | undefined;
	try {
		beforeContent = await fs.promises.readFile(fp, "utf8");
		rawUtf8 = beforeContent;
	} catch {
		// applyHashlineEditsToFile reads once when rawUtf8 is omitted
	}

	const applyOpts: HashlineEditApplyOptions = { dryRun, rawUtf8 };
	const result = await applyHashlineEditsToFile(fp, changes, applyOpts);

	if (!result.ok) {
		const reread = rereadHintFromSuggestions(fp, result.suggestions);
		return {
			content: [{ type: "text", text: result.error }],
			isError: true,
			details: {
				_type: "hashlineEditError",
				path: fp,
				code: result.code,
				ref: result.ref,
				suggestions: result.suggestions,
				hashlineRereadHint: reread,
				nextStep: `hashline_read path=${JSON.stringify(fp)}${reread ? ` startLine=${reread.startLine} endLine=${reread.endLine}` : ""}`,
			},
		};
	}

	const afterContent = result.finalRaw ?? beforeContent;
	const diff = buildDiff(beforeContent, afterContent, fp);
	if (diff && toolCallId && onDiffStats) {
		onDiffStats(toolCallId, diff);
	}

	const warnings = result.boundaryWarnings ?? [];
	return {
		content: [{ type: "text", text: formatOkText(fp, result.changedRange, dryRun, warnings) }],
		details: {
			_type: dryRun ? "hashlineEditDryRun" : "hashlineEditInfo",
			path: fp,
			diff,
			dryRun,
			result,
			before: beforeContent,
		},
	};
}

export function executeHashlineRead(
	fp: string,
	content: string,
	startLine: number,
	endLine: number,
): HashlineToolResult {
	const { text, lineCount, startLine: from, endLine: to } = formatHashlineReadLines(content, startLine, endLine);
	return {
		content: [{ type: "text", text }],
		details: {
			_type: "hashlineReadInfo" as const,
			path: fp,
			lineCount,
			startLine: from,
			endLine: to,
		},
	};
}
