# AGENTS.md

## What this repo is

Personal Apple Silicon macOS configuration managed with nix-darwin and Home
Manager. Lix provides the Nix implementation, nix-homebrew owns Homebrew, and
Homebrew remains responsible for GUI casks.

This is no longer a yadm worktree or a directory that mirrors `$HOME`. The
complete pre-migration configuration is preserved on the `yadm-bkp` branch.
Never run `yadm pull` against `main`.

## Repository structure

- `flake.nix`: pinned inputs and the machine output.
- `hosts/ukedeMacBook-Pro/`: bundle selection for the current Mac.
- `modules/darwin/`: machine-wide Nix and Homebrew foundations.
- `modules/home/`: base Home Manager configuration.
- `modules/bundles/`: package + configuration + integration units.
- `.config/` and root dotfiles: source payloads linked or compiled by Home
  Manager; they are not deployed merely because they exist in the repo.
- `bootstrap.sh`: fresh-machine bootstrap.

The configured checkout path is `/Users/uke/Documents/dotfiles`. Most
application configs use `mkOutOfStoreSymlink` so they remain editable. If the
clone moves, update `dotfilesDir` in `flake.nix` before building.

## Development workflow

1. Edit files in this clone.
2. Run `nix flake check --no-build`.
3. Build with:
   `nix run .#darwin-rebuild -- build --flake .#ukedeMacBook-Pro`
4. Activation is a deliberate live-machine step:
   `sudo darwin-rebuild switch --flake .#ukedeMacBook-Pro`

Do not activate, install Lix, modify the live `$HOME`, or run Homebrew cleanup
unless the user explicitly asks. A normal implementation should stop after
evaluation/build verification.

## Bundle rules

- Put a package, its configuration link, and its shell integration in the
  same module under `modules/bundles/`.
- Select profiles by importing bundles from a host module; do not scatter
  host conditionals through payload files.
- Prefer Nix packages for CLI tools and Homebrew casks for macOS GUI apps.
- Keep project language runtimes in mise.
- Secrets, GitHub authentication, SSH private keys, macOS TCC permissions,
  and application state remain outside Nix.
- Homebrew cleanup must remain `"none"` until the migration has been audited.

## Safety

The working tree may contain user changes. Preserve unrelated edits. Do not
push, activate nix-darwin, install/uninstall package managers, or mutate the
live home directory without explicit authorization.
