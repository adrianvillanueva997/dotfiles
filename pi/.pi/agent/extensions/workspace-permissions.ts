import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { chmod, mkdir, rename, writeFile } from "node:fs/promises";
import { existsSync, realpathSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join, resolve } from "node:path";

type TrustState = {
  version: 1;
  workspaces: string[];
};

const statePath = join(resolve(process.env.PI_CODING_AGENT_DIR ?? join(homedir(), ".pi", "agent")), "workspace-permissions.json");

export function canonicalWorkspace(cwd: string): string {
  try {
    return realpathSync(cwd);
  } catch {
    return resolve(cwd);
  }
}

export function parseTrustState(content: string): Set<string> | undefined {
  try {
    const parsed = JSON.parse(content) as Partial<TrustState>;
    if (parsed.version !== 1 || !Array.isArray(parsed.workspaces) || !parsed.workspaces.every((path) => typeof path === "string")) {
      return undefined;
    }
    return new Set(parsed.workspaces.map(canonicalWorkspace));
  } catch {
    return undefined;
  }
}

export function loadTrustedWorkspaces(path = statePath): { workspaces: Set<string>; malformed: boolean } {
  try {
    if (!existsSync(path)) return { workspaces: new Set(), malformed: false };
    const workspaces = parseTrustState(readFileSync(path, "utf8"));
    return workspaces ? { workspaces, malformed: false } : { workspaces: new Set(), malformed: true };
  } catch {
    return { workspaces: new Set(), malformed: true };
  }
}

async function saveTrustedWorkspaces(workspaces: Set<string>, path = statePath): Promise<void> {
  await mkdir(dirname(path), { recursive: true, mode: 0o700 });
  const temporaryPath = join(dirname(path), `.${basename(path)}.${process.pid}.${Date.now()}.tmp`);
  const state: TrustState = { version: 1, workspaces: [...workspaces].sort() };
  await writeFile(temporaryPath, `${JSON.stringify(state, null, 2)}\n`, { encoding: "utf8", mode: 0o600 });
  await rename(temporaryPath, path);
  await chmod(path, 0o600);
}

export default async function (pi: ExtensionAPI) {
  const workspace = canonicalWorkspace(process.cwd());
  const loaded = loadTrustedWorkspaces();
  const trustedWorkspaces = loaded.workspaces;
  const pendingAuthorizations = new Map<string, Promise<boolean>>();

  const authorize = async (ctx: {
    hasUI: boolean;
    ui: {
      confirm(title: string, message: string): Promise<boolean>;
      notify(message: string, level: "error" | "warning"): void;
    };
  }): Promise<boolean> => {
    if (trustedWorkspaces.has(workspace)) return true;
    if (!ctx.hasUI) return false;

    const pending = pendingAuthorizations.get(workspace);
    if (pending) return pending;

    const authorization = (async () => {
      const approved = await ctx.ui.confirm(
        "Authorize workspace tools?",
        `Allow all Pi agent tools in this workspace now and in future sessions?\n\n${workspace}\n\nThis includes shell commands, file writes, MCP tools, and extension tools. Only approve repositories you trust.`,
      );
      if (!approved) return false;

      const next = new Set(trustedWorkspaces).add(workspace);
      try {
        await saveTrustedWorkspaces(next);
        trustedWorkspaces.add(workspace);
        return true;
      } catch (error) {
        ctx.ui.notify(`Could not save workspace authorization: ${error instanceof Error ? error.message : String(error)}`, "error");
        return false;
      }
    })();

    pendingAuthorizations.set(workspace, authorization);
    try {
      return await authorization;
    } finally {
      pendingAuthorizations.delete(workspace);
    }
  };

  if (loaded.malformed) {
    pi.on("session_start", (_event, ctx) => {
      ctx.ui.notify(`Workspace permissions are invalid at ${statePath}; no workspace is authorized until you approve one again.`, "warning");
    });
  }

  pi.on("tool_call", async (_event, ctx) => {
    if (await authorize(ctx)) return undefined;
    return {
      block: true,
      reason: ctx.hasUI
        ? "Workspace tools were not authorized by the user."
        : "Workspace tools are blocked in non-interactive mode until this workspace is authorized interactively.",
    };
  });
}
