import { beforeAll, describe, expect, it } from "vitest";
import {
	applyHashlineEdits,
	clearHashlineCache,
	formatHashlineReadView,
	hashLines,
	initHashline,
	parseAnchor,
	resolveAnchor,
} from "../src/hashline.js";

beforeAll(async () => {
	await initHashline();
	clearHashlineCache();
});

describe("hashLines", () => {
	it("produces 3-char URL-safe base64 hashes", () => {
		const h = hashLines("hello\nworld");
		expect(h).toHaveLength(2);
		expect(h[0]).toMatch(/^[A-Za-z0-9_-]{3}$/);
		expect(h[1]).toMatch(/^[A-Za-z0-9_-]{3}$/);
	});

	it("strips trailing CR (CRLF tolerance)", () => {
		const a = hashLines("foo");
		const b = hashLines("foo\r");
		expect(a).toEqual(b);
	});

	it("strips trailing whitespace before hashing", () => {
		const a = hashLines("foo");
		const b = hashLines("foo   ");
		expect(a).toEqual(b);
	});

	it("preserves leading whitespace as part of identity", () => {
		const a = hashLines("foo");
		const b = hashLines("  foo");
		expect(a[0]).not.toBe(b[0]);
	});

	it("resolves collisions with :R{n} suffix (perfect hashing)", () => {
		// Construct a file where two lines canonically hash to the same value.
		// We can't easily force a collision deterministically, but we can verify
		// that for many random inputs, all hashes are unique per file.
		const lines = Array.from({ length: 500 }, (_, i) => `line ${i} ${Math.random()}`);
		const content = lines.join("\n");
		const hashes = hashLines(content);
		const unique = new Set(hashes);
		expect(unique.size).toBe(lines.length);
		// Sanity: no hash contains a space or non-allowed char
		for (const h of hashes) {
			expect(h).toMatch(/^[A-Za-z0-9_-]{3}(:R\d+)?$/);
		}
	});

	it("caches by content identity", () => {
		const a = hashLines("x\ny\nz");
		const b = hashLines("x\ny\nz");
		expect(a).toBe(b); // same reference
	});
});

describe("parseAnchor edge cases (regression: must not throw on bad input)", () => {
	it("returns empty string for undefined", () => {
		expect(parseAnchor(undefined as any)).toBe("");
	});
	it("returns empty string for null", () => {
		expect(parseAnchor(null as any)).toBe("");
	});
	it("returns empty string for empty string", () => {
		expect(parseAnchor("")).toBe("");
	});
	it("returns empty string for non-string number", () => {
		expect(parseAnchor(42 as any)).toBe("");
	});
});

describe("parseAnchor", () => {
	it("strips │ content suffix", () => {
		expect(parseAnchor("abc│hello")).toBe("abc");
	});

	it("preserves :R{n} collision suffix", () => {
		expect(parseAnchor("abc:R1│hello")).toBe("abc:R1");
		expect(parseAnchor("abc:R1")).toBe("abc:R1");
	});

	it("trims whitespace", () => {
		expect(parseAnchor("  abc  ")).toBe("abc");
	});

	it("returns input unchanged if no separator", () => {
		expect(parseAnchor("abc")).toBe("abc");
	});
});

describe("resolveAnchor", () => {
	const fileContent = "alpha\nbeta\ngamma\nalpha\nomega";
	let fileHashes: string[];

	beforeAll(() => {
		fileHashes = hashLines(fileContent);
	});

	it("resolves unique anchor to its line", () => {
		const h = fileHashes[1];
		const r = resolveAnchor(h, fileHashes);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.line).toBe(1);
	});

	it("returns error for unknown anchor", () => {
		const r = resolveAnchor("ZZZ", fileHashes);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.error).toBe("not_found");
	});

	it("returns error for empty anchor", () => {
		const r = resolveAnchor("", fileHashes);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.error).toBe("empty");
	});

	it("returns suggestions on miss", () => {
		const r = resolveAnchor("ZZZ", fileHashes);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.suggestions).toBeDefined();
	});
});

describe("applyHashlineEdits", () => {
	it("replaces a single line", () => {
		const content = "a\nb\nc";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: [hashes[1], hashes[1]], content_lines: ["B"] }]);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe("a\nB\nc");
	});

	it("replaces a multi-line range", () => {
		const content = "a\nb\nc\nd";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [
			{ hash_range_inclusive: [hashes[1], hashes[2]], content_lines: ["X", "Y"] },
		]);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe("a\nX\nY\nd");
	});

	it("inserts lines (replaces range with more lines than original)", () => {
		const content = "a\nb\nc";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [
			{ hash_range_inclusive: [hashes[1], hashes[1]], content_lines: ["B1", "B2", "B3"] },
		]);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe("a\nB1\nB2\nB3\nc");
	});

	it("deletes lines (empty content_lines)", () => {
		const content = "a\nb\nc\nd";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: [hashes[1], hashes[2]], content_lines: [] }]);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe("a\nd");
	});

	it("applies multiple edits bottom-up so line numbers stay valid", () => {
		const content = "a\nb\nc\nd\ne";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [
			{ hash_range_inclusive: [hashes[0], hashes[0]], content_lines: ["A1", "A2"] },
			{ hash_range_inclusive: [hashes[4], hashes[4]], content_lines: ["E1"] },
		]);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe("A1\nA2\nb\nc\nd\nE1");
	});

	it("detects overlapping ranges", () => {
		const content = "a\nb\nc\nd";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [
			{ hash_range_inclusive: [hashes[0], hashes[2]], content_lines: ["X"] },
			{ hash_range_inclusive: [hashes[1], hashes[3]], content_lines: ["Y"] },
		]);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.code).toBe("E_OVERLAP");
	});

	it("rejects stale anchor with E_STALE_ANCHOR", () => {
		const content = "a\nb\nc";
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: ["ZZZ", "ZZZ"], content_lines: ["X"] }]);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.code).toBe("E_STALE_ANCHOR");
	});

	it("rejects end anchor before start", () => {
		const content = "a\nb\nc";
		const hashes = hashLines(content);
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: [hashes[2], hashes[0]], content_lines: ["X"] }]);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.code).toBe("E_BAD_RANGE");
	});

	it("rejects boundary duplication as a hard error", () => {
		const content = "a\nb\nc";
		const hashes = hashLines(content);
		// Replacing line 1 (b) with a copy of line 0 (a) creates a boundary dup
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: [hashes[1], hashes[1]], content_lines: ["a"] }]);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.code).toBe("E_BOUNDARY_DUP");
	});

	it("rejects trailing boundary duplication as a hard error", () => {
		const content = "a\nb\nc";
		const hashes = hashLines(content);
		// Replacing line 1 (b) with a copy of line 2 (c) creates a boundary dup
		const r = applyHashlineEdits(content, [{ hash_range_inclusive: [hashes[1], hashes[1]], content_lines: ["c"] }]);
		expect(r.ok).toBe(false);
		if (!r.ok) expect(r.code).toBe("E_BOUNDARY_DUP");
	});

	it("empty changes is a no-op", () => {
		const content = "a\nb\nc";
		const r = applyHashlineEdits(content, []);
		expect(r.ok).toBe(true);
		if (r.ok) expect(r.newContent).toBe(content);
	});
});

describe("formatHashlineReadView", () => {
	it("annotates each line with LINE│HASH│content", () => {
		const view = formatHashlineReadView("foo\nbar");
		const lines = view.split("\n");
		expect(lines).toHaveLength(2);
		expect(lines[0]).toMatch(/^\s+1│[A-Za-z0-9_-]{3}│foo$/);
		expect(lines[1]).toMatch(/^\s+2│[A-Za-z0-9_-]{3}│bar$/);
	});
});
