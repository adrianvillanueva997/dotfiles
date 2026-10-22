import { VERSION, type ExtensionAPI, type Theme } from "@earendil-works/pi-coding-agent";
import { execFileSync } from "node:child_process";
import { basename } from "node:path";

type Dashboard = {
  model: string;
  provider: string;
  workspace: string;
  git: string;
  lastCommit: string;
};

function command(cwd: string, args: string[]): string | undefined {
  try {
    return execFileSync("git", args, { cwd, encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
  } catch {
    return undefined;
  }
}

function gitSummary(cwd: string): { state: string; lastCommit: string } {
  const branch = command(cwd, ["branch", "--show-current"]);
  if (!branch) return { state: "not a Git repository", lastCommit: "no commit history" };

  const changes = (command(cwd, ["status", "--porcelain"]) ?? "").split("\n").filter(Boolean);
  const staged = changes.filter((line) => line[0] && line[0] !== " " && line[0] !== "?").length;
  const modified = changes.filter((line) => line[1] && line[1] !== " " && line[1] !== "?").length;
  const untracked = changes.filter((line) => line.startsWith("??")).length;
  const changeSummary = [
    staged && `${staged} staged`,
    modified && `${modified} changed`,
    untracked && `${untracked} untracked`,
  ].filter(Boolean).join(" · ") || "clean";
  const divergence = command(cwd, ["rev-list", "--left-right", "--count", "@{upstream}...HEAD"]);
  const [behind, ahead] = divergence?.split(/\s+/).map(Number) ?? [];
  const remote = ahead || behind ? ` · ↑${ahead ?? 0} ↓${behind ?? 0}` : "";
  const lastCommit = command(cwd, ["log", "-1", "--format=%cr · %s"]) ?? "no commit history";

  return { state: `${branch} · ${changeSummary}${remote}`, lastCommit };
}

function clip(text: string, width: number): string {
  const characters = [...text.replace(/[\u0000-\u0008\u000b-\u001f\u007f-\u009f]/g, "")];
  return characters.length > width ? `${characters.slice(0, Math.max(0, width - 1)).join("")}…` : text;
}

function center(text: string, width: number): string {
  const visible = text.replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
  return `${" ".repeat(Math.max(0, Math.floor((width - [...visible].length) / 2)))}${text}`;
}

function dashboardLines(theme: Theme, width: number, dashboard: Dashboard): string[] {
  const inner = Math.max(34, Math.min(width - 4, 70));
  const border = (text: string) => theme.fg("border", text);
  const model = clip(`${dashboard.model}  ·  ${dashboard.provider}`, inner);
  const workspace = clip(dashboard.workspace, inner);
  const git = clip(dashboard.git, inner);
  const lastCommit = clip(dashboard.lastCommit, inner);
  const controls = "[ Shift+Tab ] PLAN    [ / ] COMMANDS    [ ! ] BASH";
  const metric = (icon: string, label: string, value: string) =>
    center(`${theme.fg("accent", icon)} ${theme.fg("mdHeading", `${label.padEnd(15)} `)}${theme.fg("text", value)}`, width);
  const banner = [
    "              /\\         /\\",
    "         /\\  /  \\_______/  \\  /\\",
    "        /  \\/   /  .-.  \\   \\/  \\",
    "       |       | (o o)  |        |",
    "       |       |  \\_/   |        |",
    "        \\       \\  |   /        /",
    "         `-.     `-+-'      .-'",
    "            `--.  S L O P .--'",
    "              / \\  C U L T / \\",
    "             /___\\_______/___\\",
    "                /  \\   /  \\",
    "              _/____\\_/____\\_",
    "             /  BURN TOKENS  \\",
    "            /  SUMMON BUGS    \\",
    "            '-----------------'",
  ];

  if (width < 56) return [` ${theme.fg("accent", "\uee15")} ${theme.fg("mdHeading", "SLOP CULT")}`];

  return [
    "",
    ...banner.map((line) => center(theme.fg(line.includes("S L O P") ? "mdHeading" : "accent", line), width)),
    center(theme.fg("dim", `rite status: slopfification in progress · v${VERSION}`), width),
    "",
    center(border("─".repeat(inner)), width),
    metric("\uec67", "SUMMONED MODEL", model),
    metric("\uf07b", "CURSED REALM", workspace),
    metric("\uf06e", "CHAOS REPORT", git),
    metric("\uf017", "LAST SACRIFICE", lastCommit),
    center(border("─".repeat(inner)), width),
    center(theme.fg("accent", controls), width),
  ];
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    const cwd = process.cwd();
    const git = gitSummary(cwd);
    const dashboard: Dashboard = {
      model: ctx.model?.name || ctx.model?.id || "default model",
      provider: ctx.model?.provider || "default provider",
      workspace: basename(cwd) || cwd,
      git: git.state,
      lastCommit: git.lastCommit,
    };

    ctx.ui.setHeader((_tui, theme) => ({
      render: (width: number) => dashboardLines(theme, width, dashboard),
      invalidate() {},
    }));
  });
}
