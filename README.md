# Dotfiles

Generally everything is self-managed by stow. The only exception is the `paccache` systemd timer.

```text
/etc/systemd/system/paccache.timer
sudo systemctl enable paccache.timer
```

## Git hooks

Install [prek](https://prek.j178.dev/), Node.js, and [pnpm](https://pnpm.io/),
then run `pnpm install --frozen-lockfile` and `prek install` in this repository.
The hooks run Oxlint with safe fixes on staged JavaScript/TypeScript files and
format staged JavaScript/TypeScript/JSON files with Oxfmt. If a hook changes a
file, review and stage the changes, then commit again. Oxlint may still report
issues it cannot fix automatically. For manual checks and fixes, use `pnpm lint`,
`pnpm lint:fix`, `pnpm format:check`, or `pnpm format`. The Pi extensions keep
their own independent lockfiles.

## Pi diff viewer

The local Doom diff extension needs [pnpm](https://pnpm.io/) and Pi on `PATH`.
From the dotfiles repository root:

```sh
cd pi/.pi/agent/extensions/doom-diff
pnpm install --frozen-lockfile
pnpm build
pnpm test:pi-smoke
```

The smoke test starts an isolated, offline Pi process and does not use a model.
To enable the extension, link the **directory** into `~/.pi/agent/extensions/`
and link `pi/.pi/agent/pi-diff.json` into `~/.pi/agent/pi-diff.json`. Check for
existing files first; do not replace an existing configuration without merging it.
With the repository at `~/proyectos/personal/dotfiles`, the links are:

```sh
mkdir -p ~/.pi/agent/extensions
ln -s ~/proyectos/personal/dotfiles/pi/.pi/agent/extensions/doom-diff ~/.pi/agent/extensions/doom-diff
ln -s ~/proyectos/personal/dotfiles/pi/.pi/agent/pi-diff.json ~/.pi/agent/pi-diff.json
```

Restart Pi or run `/reload`. Rebuild after changing the extension source. Do not
run the general `make stow` after installing dependencies without first checking
what it will link: its `--no-folding` option can traverse `node_modules` and
`dist`. See `pi/.pi/agent/extensions/doom-diff/LOCAL.md` for maintenance notes.

## Pi Doom todo panel

Install and test the local todo extension with pnpm:

```sh
cd pi/.pi/agent/extensions/doom-todo
pnpm install --frozen-lockfile
pnpm test
```

Link the whole directory as `~/.pi/agent/extensions/doom-todo` (check for an
existing path first), and ensure `npm:@juicesharp/rpiv-todo` is not also enabled
in Pi settings. The panel uses `Alt+T` to collapse or expand. See its `LOCAL.md`
for migration and configuration details.
