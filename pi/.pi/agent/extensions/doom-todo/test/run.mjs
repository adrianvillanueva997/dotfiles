import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const dir = mkdtempSync(join(tmpdir(), "doom-todo-smoke-"));
try {
  const result = spawnSync(
    "pi",
    [
      "--offline",
      "--no-extensions",
      "--no-mcp",
      "--no-skills",
      "--no-prompt-templates",
      "--no-themes",
      "--no-context-files",
      "--no-session",
      "--mode",
      "rpc",
      "-e",
      fileURLToPath(new URL("./smoke.ts", import.meta.url)),
    ],
    {
      cwd: dir,
      env: {
        PATH: process.env.PATH,
        HOME: dir,
        PI_CODING_AGENT_DIR: join(dir, "agent"),
        TMPDIR: dir,
      },
      encoding: "utf8",
      timeout: 30000,
    },
  );
  if (result.error) throw result.error;
  assert.equal(result.status, 0, `${result.stderr}\n${result.stdout}`);
  assert.match(result.stdout + result.stderr, /doom-todo smoke passed/);
  console.log("doom-todo smoke passed");
} finally {
  rmSync(dir, { recursive: true, force: true });
}
