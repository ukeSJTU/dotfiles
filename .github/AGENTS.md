# AGENTS.md

## What this repo is

Personal macOS dotfiles, managed with [yadm](https://yadm.io/). Files here mirror
their target location under `$HOME` directly (e.g. `.zshrc` → `~/.zshrc`,
`.config/wezterm/` → `~/.config/wezterm/`) — no templating engine, no symlink
farm, just yadm's own bare-repo-over-`$HOME` mechanism on the machines where
it's deployed.

Current scope: shell (zsh + mise + starship + fzf/zoxide), git config, a
Homebrew `Brewfile` for package/app provisioning, and WezTerm terminal config.

## Repo topology — read this before assuming anything about `$HOME`

This directory (`~/Documents/dotfiles` or wherever it's cloned) is a **plain
git clone**, not the yadm worktree. The actual yadm-managed copy lives at
`~/.local/share/yadm/repo.git` with `$HOME` as its work tree. Both point at
the same GitHub remote (`git@github.com:ukeSJTU/dotfiles.git`) and, when in
sync, sit on the same commit.

This split exists so editing/tooling (including AI agents) can operate on a
small, self-contained repo instead of needing access to all of `$HOME`. Don't
assume this directory *is* `$HOME`, and don't try to run `yadm` commands
against it directly — `yadm` only knows about its own bare repo.

## Why this file lives at `.github/AGENTS.md`, not the repo root

Because this *is* a dotfiles repo, anything tracked at the repo root gets
deployed by yadm straight into `$HOME` — a root-level `AGENTS.md` would
become `~/AGENTS.md` on every machine, which some agent tooling treats as a
global instructions file. That's not the intent here, so the canonical,
git-tracked copy lives at `.github/AGENTS.md` instead (still gets deployed to
`~/.github/AGENTS.md`, but that path isn't special to anything).

The repo root also has an `AGENTS.md`, but it's a **local symlink** to this
file (`AGENTS.md -> .github/AGENTS.md`) and is excluded from git via
`.git/info/exclude` — it exists purely so agent tools that look for
`AGENTS.md` at the project root pick this up automatically when working in
*this* clone. It is not synced by git and won't exist in a fresh clone or in
yadm's `$HOME` checkout; recreate it locally if needed:
`ln -s .github/AGENTS.md AGENTS.md`.

If you edit this file, edit `.github/AGENTS.md` (the symlink resolves there
anyway).

## Development workflow

1. Edit files in this repo as normal.
2. Commit and push to `origin`.
3. On whichever machine should receive the change, run `yadm pull` (first
   time on a new machine: `yadm clone git@github.com:ukeSJTU/dotfiles.git`)
   to fast-forward `$HOME` to the new commit.
4. Before step 3 on a live machine, check `yadm status` / `yadm diff` first —
   if a tracked dotfile was edited locally in `$HOME` and not pushed from
   here, `yadm pull` can conflict with or clobber that drift.

Multiple machines may each have their own clone of this repo (for editing)
plus their own yadm worktree at their own `$HOME`, all tracking the same
`origin`. Treat `origin/main` as the source of truth; local drift in any
single `$HOME` is expected to be temporary.

## Working in this repo

- New packages/casks go in `.homebrew/Brewfile`, installed elsewhere via
  `brew bundle`.
- There's no bootstrap script and no yadm encryption (`yadm encrypt`) in use
  yet — if either gets added, document the steps here.
- Since changes here don't take effect until pushed and pulled by yadm on a
  real `$HOME`, don't run `yadm pull`, `yadm decrypt`, or anything else that
  mutates a live `$HOME` from within this repo's context — that's a
  separate, deliberate step the user takes on the target machine.
