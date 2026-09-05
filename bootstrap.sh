#!/bin/bash
set -euo pipefail

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/dotfiles}"
readonly HOSTNAME="${NIX_DARWIN_HOST:-ukedeMacBook-Pro}"
readonly REPOSITORY="https://github.com/ukeSJTU/dotfiles.git"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
	echo "Error: this configuration supports Apple Silicon macOS only." >&2
	exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
	echo "==> Installing Xcode Command Line Tools..."
	xcode-select --install
	echo "Finish the macOS installer, then run this script again."
	exit 0
fi

if nc -z 127.0.0.1 7897 2>/dev/null; then
	export http_proxy="http://127.0.0.1:7897"
	export https_proxy="$http_proxy"
	export all_proxy="$http_proxy"
	echo "==> Using the local proxy on 127.0.0.1:7897."
fi

if ! command -v nix >/dev/null 2>&1; then
	echo "==> Installing Lix..."
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix |
		sh -s -- install

	# The installer cannot modify the environment of this running process.
	# shellcheck disable=SC1091
	source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
	echo "==> Cloning the configuration..."
	mkdir -p "$(dirname "$DOTFILES_DIR")"
	git clone "$REPOSITORY" "$DOTFILES_DIR"
fi

echo "==> Building and activating nix-darwin..."
sudo nix run "$DOTFILES_DIR#darwin-rebuild" -- \
	switch --flake "$DOTFILES_DIR#$HOSTNAME"

echo "==> Installing mise runtimes and Yazi plugins..."
readonly USER_PROFILE_BIN="/etc/profiles/per-user/$USER/bin"
PATH="$USER_PROFILE_BIN:/run/current-system/sw/bin:/opt/homebrew/bin:$PATH" \
	"$USER_PROFILE_BIN/mise" install --locked
PATH="$USER_PROFILE_BIN:/run/current-system/sw/bin:/opt/homebrew/bin:$PATH" \
	"$USER_PROFILE_BIN/ya" pkg install

cat <<'EOF'

Bootstrap complete.

Still manual by design:
  - Run `gh auth login` and configure the GitHub SSH key if needed.
  - Sign in to VS Code Settings Sync, OrbStack, Claude, and ChatGPT.
  - Approve Karabiner-Elements' background, Accessibility, and driver access.
EOF
