import { describe, expect, it } from "vitest";
import { parseDiff } from "../core/diff.js";
import { renderSplit, resolveDiffColors } from "./hunk-preview.js";

const colors = { fgAdd: "", fgDel: "", fgCtx: "" };
const strip = (text: string) => text.replace(/\x1b\[[0-9;]*m/g, "");

describe("edit diff layout", () => {
  const diff = parseDiff('const name = "old";\n', 'const name = "new";\n');

  it("labels and separates aligned old and new columns", async () => {
    const lines = strip(await renderSplit(diff, "typescript", 60, colors, 100)).split("\n");
    expect(lines[0]).toBe("─".repeat(100));
    expect(lines[1]).toContain("old");
    expect(lines[1]).toContain("│ new");
    const change = lines.find((line) => line.includes('"old"'));
    expect(change).toContain('"new"');
    expect(change?.indexOf("│")).toBeGreaterThan(0);
    expect(change?.indexOf("│", 10)).toBe(49);
    expect(lines.every((line) => line.length <= 100)).toBe(true);
  });

  it("uses the theme's visible muted and border colors for labels and frame", async () => {
    const muted = "\x1b[38;2;180;170;190m";
    const border = "\x1b[38;2;140;120;160m";
    const theme = {
      getFgAnsi: (name: string) =>
        name === "muted" ? muted : name === "border" ? border : "\x1b[38;2;150;160;150m",
      getBgAnsi: () => "\x1b[48;2;40;40;45m",
    };
    const result = await renderSplit(diff, "typescript", 60, resolveDiffColors(theme), 100);
    expect(result).toContain(`${border}${"─".repeat(100)}`);
    expect(result).toContain(`${muted} old`);
  });

  it("summarizes changes and the actual layout", async () => {
    const split = strip(
      await renderSplit(diff, "typescript", 60, colors, 100, { showSummary: true }),
    );
    const unified = strip(
      await renderSplit(diff, "typescript", 60, colors, 60, { showSummary: true }),
    );
    expect(split).toContain("diff · +1 · -1 · 1 hunk · 1 file · split");
    expect(unified).toContain("diff · +1 · -1 · 1 hunk · 1 file · unified");
    expect(unified).toContain("─".repeat(60));
  });

  it("uses a unified diff when the terminal is narrow", async () => {
    const result = strip(await renderSplit(diff, "typescript", 60, colors, 60));
    expect(result).not.toContain("│ new");
    expect(result).toContain('"old"');
    expect(result).toContain('"new"');
  });
});
