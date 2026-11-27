import * as Diff from "diff";

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/** Hunk metadata attached to separator DiffLines. */
export interface HunkMeta {
	oldStart: number;
	oldLines: number;
	newStart: number;
	newLines: number;
	/** Function context from hunk header, e.g. "function foo() {" */
	context?: string;
}

export interface DiffLine {
	type: "add" | "del" | "ctx" | "sep";
	oldNum: number | null;
	newNum: number | null;
	content: string;
	/** Hunk metadata — present on first sep and between-hunk seps if available. */
	hunkMeta?: HunkMeta;
}

export interface ParsedDiff {
	lines: DiffLine[];
	added: number;
	removed: number;
	chars: number;
}

// ---------------------------------------------------------------------------
// Unified diff patch parsing
//
// Parses git/unified diff strings (output of `git diff`, `Diff.formatPatch`,
// or similar) into our internal ParsedDiff representation. Preserves hunk
// function context from hunk headers.
//
// Handles these formats:
//   diff --git a/file.ts b/file.ts \n --- a/file.ts \n +++ b/file.ts
//   --- a/file.ts \n +++ b/file.ts  (no diff --git prefix)
//   @@ -start,count +start,count @@ func_name (with or without func context)
// ---------------------------------------------------------------------------

/**
 * Parse a unified diff/patch string into one or more ParsedDiff.
 * Each file in the patch gets its own entry.
 */
function isPatchMetadataLine(line: string): boolean {
	return /^(?:diff --git |Index: |={3,}$|--- |\+\+\+ |index |new file |old mode |new mode |deleted |rename |similarity |copy |Binary files )/.test(
		line,
	);
}

export function parsePatchFiles(patch: string): ParsedDiff[] {
	if (!patch.trim()) return [];

	// Split into file sections. Pi's patch generator uses `---`/`+++`;
	// diff-format patches may use `diff --git` or `Index:` headers.
	const lines = patch.split("\n");
	const sections: string[][] = [];
	let cur: string[] = [];
	for (let i = 0; i < lines.length; i++) {
		const line = lines[i];
		const startsNewFile =
			line.startsWith("diff --git ") ||
			line.startsWith("Index: ") ||
			(line.startsWith("--- ") && lines[i + 1]?.startsWith("+++ ") && parseOneFile(cur) !== null);
		if (startsNewFile && cur.length > 0) {
			sections.push(cur);
			cur = [];
		}
		cur.push(line);
	}
	if (cur.length > 0) sections.push(cur);

	const result: ParsedDiff[] = [];
	for (const section of sections) {
		const hasHunk = section.some((line) => parseHunkHeader(line));
		const looksLikeFileSection = section.some(
			(line) =>
				line.startsWith("diff --git ") ||
				line.startsWith("Index: ") ||
				line.startsWith("--- ") ||
				line.startsWith("+++ "),
		);
		if (!hasHunk) {
			if (looksLikeFileSection) return [];
			continue;
		}
		const parsed = parseOneFile(section);
		if (!parsed) return [];
		result.push(parsed);
	}
	return result;
}

/** Parse a single file section. Invalid hunk content or line counts fail closed. */
function parseOneFile(lines: string[]): ParsedDiff | null {
	const all: DiffLine[] = [];
	let added = 0;
	let removed = 0;
	let i = 0;

	while (i < lines.length) {
		const hdr = parseHunkHeader(lines[i]);
		if (!hdr) {
			if (lines[i].startsWith("@@") || lines[i].startsWith("\\\\ ") || !isPatchMetadataLine(lines[i])) return null;
			i++;
			continue;
		}

		all.push({ type: "sep", oldNum: null, newNum: null, content: "", hunkMeta: hdr });
		let oldConsumed = 0;
		let newConsumed = 0;
		let oldLine = hdr.oldStart;
		let newLine = hdr.newStart;
		i++;

		while (i < lines.length) {
			const line = lines[i];
			if (line.startsWith("@@")) {
				if (!parseHunkHeader(line)) return null;
				break;
			}
			if (line.length === 0) {
				if (i !== lines.length - 1) return null;
				i++;
				continue; // terminal newline after the patch
			}
			if (line === "\\ No newline at end of file") {
				i++;
				continue;
			}
			if (line[0] === " ") {
				all.push({ type: "ctx", oldNum: oldLine++, newNum: newLine++, content: line.slice(1) });
				oldConsumed++;
				newConsumed++;
			} else if (line[0] === "+") {
				all.push({ type: "add", oldNum: null, newNum: newLine++, content: line.slice(1) });
				added++;
				newConsumed++;
			} else if (line[0] === "-") {
				all.push({ type: "del", oldNum: oldLine++, newNum: null, content: line.slice(1) });
				removed++;
				oldConsumed++;
			} else {
				return null;
			}
			i++;
		}

		if (oldConsumed !== hdr.oldLines || newConsumed !== hdr.newLines) return null;
	}

	if (all.length === 0 || all.every((line) => line.type === "sep")) return null;
	let chars = 0;
	for (const line of all) {
		if (line.type !== "sep") chars += line.content.length;
	}
	return { lines: all, added, removed, chars };
}

/**
 * Parse a hunk header line like:
 *   @@ -oldStart,oldCount +newStart,newCount @@ optional func context
 */
function parseHunkHeader(line: string): HunkMeta | null {
	const m = line.match(/^@@\s+-(\d+)(?:,(\d+))?\s+\+(\d+)(?:,(\d+))?\s+@@(?:\s+(.*))?$/);
	if (!m) return null;
	const oldStart = Number(m[1]);
	const oldLines = m[2] ? Number(m[2]) : 1;
	const newStart = Number(m[3]);
	const newLines = m[4] ? Number(m[4]) : 1;
	const context = m[5]?.trim() || undefined;
	return { oldStart, oldLines, newStart, newLines, context };
}

// ---------------------------------------------------------------------------
// Programmatic diff (string-to-string)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Hunk separator styles
// ---------------------------------------------------------------------------

/** Style for rendering hunk separators between change blocks. */
export type HunkSeparatorStyle = "auto" | "simple" | "gap" | "context" | "metadata";

let _sepStyle: HunkSeparatorStyle = "auto";

/**
 * Resolve hunk separator style from env var PI_DIFF_SEP_STYLE.
 * Call once during extension init, or with force=true to re-read.
 */
export function resolveSepStyle(): HunkSeparatorStyle {
	const fromEnv = process.env.PI_DIFF_SEP_STYLE;
	if (fromEnv && ["auto", "simple", "gap", "context", "metadata"].includes(fromEnv)) {
		_sepStyle = fromEnv as HunkSeparatorStyle;
	} else {
		_sepStyle = "auto";
	}
	return _sepStyle;
}

/**
 * Get the current separator style (resolved once via resolveSepStyle()).
 */
export function getSepStyle(): HunkSeparatorStyle {
	return _sepStyle;
}

/**
 * Generate a hunk separator label for the unified view.
 * Returns the full label including spacing, or an empty string when no useful label exists.
 * If `content` is non-empty, it is used directly (e.g. "───── Edit 2 ─────").
 */
export function sepLabelUnified(
	style: HunkSeparatorStyle,
	hunkMeta: HunkMeta | undefined,
	gap: number | null,
	content?: string,
): string {
	// Custom content (e.g. multi-edit separators) takes precedence
	if (content) return ` ${content} `;
	const ctx = hunkMeta?.context;
	switch (style) {
		case "simple":
			return "";
		case "gap":
			if (gap && gap > 0) return ` ${gap} unmodified lines `;
			return "";
		case "context":
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` ${gap} unmodified lines `;
			return "";
		case "metadata":
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` +${gap} lines `;
			return "";
		default:
			if (ctx && gap && gap > 0) return ` ${ctx} — +${gap} lines `;
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` +${gap} lines `;
			return "";
	}
}

/**
 * Generate a hunk separator label for the split view.
 * Returns useful context/gap labels without decorative ellipses.
 * If `content` is non-empty, it is used directly (e.g. "───── Edit 2 ─────").
 */
export function sepLabelSplit(
	style: HunkSeparatorStyle,
	hunkMeta: HunkMeta | undefined,
	gap: number | null,
	content?: string,
): string {
	// Custom content (e.g. multi-edit separators) takes precedence
	if (content) return `${content}`;
	const ctx = hunkMeta?.context;
	switch (style) {
		case "simple":
			return "";
		case "gap":
			if (gap && gap > 0) return ` ${gap} lines `;
			return "";
		case "context":
			if (ctx && gap && gap > 0) return ` ${ctx} — ${gap} lines `;
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` ${gap} lines `;
			return "";
		case "metadata":
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` ${gap} lines `;
			return "";
		default:
			if (ctx && gap && gap > 0) return ` ${ctx} — +${gap} lines `;
			if (ctx) return ` ${ctx} `;
			if (gap && gap > 0) return ` +${gap} lines `;
			return "";
	}
}

// ---------------------------------------------------------------------------
// Paired ChangeContent blocks
//
// Extracts grouped deletion+addition pairs from a flat ParsedDiff,
// eliminating the manual grouping logic duplicated in both renderers.
// ---------------------------------------------------------------------------

/** A paired block of deletions and additions within a hunk. */
export interface HunkBlock {
	deletions: DiffLine[];
	additions: DiffLine[];
}

/**
 * Walk a ParsedDiff and extract hunk blocks.
 * Each block is a group of consecutive deletes followed by consecutive adds.
 * Context and separator lines are skipped.
 */
export function computeHunkBlocks(diff: ParsedDiff): HunkBlock[] {
	const blocks: HunkBlock[] = [];
	let i = 0;
	const lines = diff.lines;

	while (i < lines.length) {
		if (lines[i].type === "sep" || lines[i].type === "ctx") {
			i++;
			continue;
		}

		// Collect consecutive deletions
		const deletions: DiffLine[] = [];
		while (i < lines.length && lines[i].type === "del") {
			deletions.push(lines[i]);
			i++;
		}

		// Collect consecutive additions
		const additions: DiffLine[] = [];
		while (i < lines.length && lines[i].type === "add") {
			additions.push(lines[i]);
			i++;
		}

		if (deletions.length === 0 && additions.length === 0) continue;
		blocks.push({ deletions, additions });
	}

	return blocks;
}

export function parseDiff(oldContent: string, newContent: string, ctx = 3): ParsedDiff {
	const patch = Diff.structuredPatch("", "", oldContent, newContent, "", "", { context: ctx });
	const lines: DiffLine[] = [];
	let added = 0;
	let removed = 0;

	for (let hi = 0; hi < patch.hunks.length; hi++) {
		const h = patch.hunks[hi];
		const meta: HunkMeta = {
			oldStart: h.oldStart,
			oldLines: h.oldLines,
			newStart: h.newStart,
			newLines: h.newLines,
		};

		// Emit hunk metadata as a synthetic sep (position 0 for first hunk,
		// between-hunk sep for subsequent). This ensures every hunk has metadata.
		if (hi > 0) {
			const prev = patch.hunks[hi - 1];
			const gap = h.oldStart - (prev.oldStart + prev.oldLines);
			lines.push({ type: "sep", oldNum: null, newNum: gap > 0 ? gap : null, content: "", hunkMeta: meta });
		} else {
			lines.push({ type: "sep", oldNum: null, newNum: null, content: "", hunkMeta: meta });
		}

		let oL = h.oldStart;
		let nL = h.newStart;
		for (const raw of h.lines) {
			if (raw === "\\ No newline at end of file") continue;
			const ch = raw[0];
			const text = raw.slice(1);
			if (ch === "+") {
				lines.push({ type: "add", oldNum: null, newNum: nL++, content: text });
				added++;
			} else if (ch === "-") {
				lines.push({ type: "del", oldNum: oL++, newNum: null, content: text });
				removed++;
			} else {
				lines.push({ type: "ctx", oldNum: oL++, newNum: nL++, content: text });
			}
		}
	}
	return { lines, added, removed, chars: oldContent.length + newContent.length };
}
