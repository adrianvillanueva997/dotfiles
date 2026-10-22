import assert from "node:assert/strict";
import { mkdtempSync, realpathSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import workspacePermissions, { canonicalWorkspace, loadTrustedWorkspaces, parseTrustState } from "../.pi/agent/extensions/workspace-permissions.ts";

test("parses only the current workspace-permission state shape", () => {
  const state = parseTrustState('{"version":1,"workspaces":["/tmp/a","/tmp/a"]}');
  assert.deepEqual([...state ?? []], ["/tmp/a"]);
  assert.equal(parseTrustState('{"version":2,"workspaces":[]}'), undefined);
  assert.equal(parseTrustState('{"version":1,"workspaces":[1]}'), undefined);
  assert.equal(parseTrustState("not json"), undefined);
});

test("fails closed for malformed permission state", () => {
  const path = join(mkdtempSync(join(tmpdir(), "pi-workspace-permissions-")), "state.json");
  writeFileSync(path, "not json");
  assert.deepEqual(loadTrustedWorkspaces(path), { workspaces: new Set(), malformed: true });
});

test("blocks all tools when an unknown workspace has no interactive UI", async () => {
  let toolCallHandler: ((event: unknown, ctx: unknown) => Promise<unknown>) | undefined;
  await workspacePermissions({
    on(event: string, handler: unknown) {
      if (event === "tool_call") toolCallHandler = handler as typeof toolCallHandler;
    },
  } as never);

  const result = await toolCallHandler?.({}, { hasUI: false });
  assert.deepEqual(result, {
    block: true,
    reason: "Workspace tools are blocked in non-interactive mode until this workspace is authorized interactively.",
  });
});

test("canonicalizes symlink aliases to one workspace", () => {
  const root = mkdtempSync(join(tmpdir(), "pi-workspace-permissions-"));
  const target = join(root, "workspace");
  const alias = join(root, "alias");
  writeFileSync(target, "", { flag: "w" });
  symlinkSync(target, alias);
  assert.equal(canonicalWorkspace(alias), realpathSync(target));
});
