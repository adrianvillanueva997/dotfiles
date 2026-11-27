# Local Doom diff renderer

Vendored from [pi-diff](https://github.com/buddingnewinsights/pi-diff) at commit `c946f2b1e57d0a307614740bc73cba31956c78ed` (MIT; see LICENSE). The source and tests are maintained locally; updating them is manual. The renderer reads `shikiTheme` from `pi-diff.json` (overridden by `DIFF_THEME`). The build bundles Shiki so its grammars and themes resolve inside Pi's compiled runtime. Shiki and the other npm dependencies remain external dependencies. The local dependency on `diff` was upgraded from 7 to 8.0.4 to address GHSA-73rr-hh4g-fpgx.

After cloning the dotfiles, run `pnpm install --frozen-lockfile && pnpm build` in this directory. See the repository README for safe linking instructions. `~/.pi/agent/pi-diff.json` disables upstream's additional `apply_patch` tool; Pi's own write and edit operations are delegated to the SDK.

Run `pnpm test:pi-smoke` with the compiled `pi` executable on PATH to rebuild and check syntax highlighting in an isolated, offline Pi runtime; it does not call a provider.
