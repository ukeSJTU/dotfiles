# macOS configuration

Declarative Apple Silicon macOS environment built with Nix, nix-darwin, Home
Manager, and nix-homebrew. Lix's reversible installer bootstraps Nix on a new
machine; nix-darwin then manages the upstream Nix version pinned by nixpkgs.

The repository is organized around bundles rather than independent dotfiles.
A bundle owns the package, its configuration link, and any shell integration.
The host selects bundles by importing them from
`hosts/ukedeMacBook-Pro/default.nix`.

## Responsibility boundaries

- Nix installs CLI tools and composes the machine and user configuration.
- nix-darwin manages system activation and the Homebrew cask manifest.
- nix-homebrew manages Homebrew itself.
- Homebrew installs macOS GUI applications and the small set of Zsh plugins
  whose existing macOS layout is intentionally retained.
- mise continues to install project language runtimes from the committed
  global lockfile.
- Home Manager links application configuration back to this checkout with
  out-of-store symlinks. Configs such as Neovim's lockfile remain directly
  editable instead of becoming read-only Nix store files.

The checkout path is currently part of the configuration and must be
`~/Documents/dotfiles`. Change `dotfilesDir` in `flake.nix` if the repository
moves.

## First trial on the current Mac

The `yadm-bkp` branch contains the complete pre-Nix setup. Do not pull `main`
with the existing yadm worktree; `main` is no longer laid out as a home
directory.

Install the initial Nix implementation with Lix's reversible installer:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix |
  sh -s -- install
```

Open a new terminal, then evaluate and build without activating:

```bash
cd ~/Documents/dotfiles
nix flake check --no-build
nix run .#darwin-rebuild -- \
  build --flake .#ukedeMacBook-Pro
```

Inspect the result and activate it deliberately:

```bash
sudo nix run .#darwin-rebuild -- \
  switch --flake .#ukedeMacBook-Pro
mise install --locked
ya pkg install
```

During the first activation, Home Manager renames conflicting yadm-era files
with the suffix `.yadm-backup`. It does not silently overwrite them. Homebrew
cleanup is also disabled during the migration, so existing imperative
formulae are left installed.

For a fresh Mac, clone this repository to the expected path and run
`./bootstrap.sh`. Interactive logins and macOS privacy permissions remain
manual by design.

## Daily use

Edit the repository, evaluate, then activate:

```bash
nix flake check --no-build
sudo darwin-rebuild switch --flake .#ukedeMacBook-Pro
```

Update pinned inputs explicitly:

```bash
nix flake update
sudo darwin-rebuild switch --flake .#ukedeMacBook-Pro
```

Add or remove a bundle in the host import list. Add packages and their
configuration to the same file under `modules/bundles/`.
