# Doom todo

Locally maintained copy of `@juicesharp/rpiv-todo` 2.16.0 (MIT; see LICENSE). The tool name, widget key and session-state format are retained so existing task histories continue to replay. The panel has a Doom-themed frame, groups completed tasks, puts active tasks first, and wraps task text to the terminal width. It shows up to eight task/summary rows by default (wrapped text can add screen lines); `Alt+T` collapses or expands it. `/todos` lists all tasks, and Ctrl+O expands the panel. `/todos-clear-completed` asks for confirmation before clearing completed tasks; completed tasks referenced by unfinished tasks are kept. Existing rpiv-todo configuration can override the defaults.

Run `pnpm install --frozen-lockfile` in this directory, then `pnpm test` with Pi on PATH. Link this entire directory into `~/.pi/agent/extensions/doom-todo` and remove `npm:@juicesharp/rpiv-todo` from Pi's package settings to avoid duplicate tool registration. Restart Pi or run `/reload`.

The extension is maintained locally; its `@juicesharp/rpiv-config` library remains an external pnpm dependency. Review upstream changes manually before adopting them.
