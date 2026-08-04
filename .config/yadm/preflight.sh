#!/bin/bash
# Phase 1 of this dotfiles repo's bootstrap: gets a brand-new Mac from
# nothing to a point where `yadm clone` can succeed, then runs that clone
# (which auto-chains into .config/yadm/bootstrap, phase 2).
#
# Usage (on a fresh Mac, after Clash Verge Rev + Chrome are already set up
# manually — see .github/AGENTS.md):
#   curl -fsSL https://raw.githubusercontent.com/ukeSJTU/dotfiles/main/.config/yadm/preflight.sh | bash
#
# Runs via `curl | bash`, so this script's own stdin is the piped script
# text, not the terminal — it deliberately has no `read` prompts of its own.
# The interactive steps below (gh's device-code wait, ssh-add's Keychain
# dialog) talk to /dev/tty directly and work fine regardless.
set -euo pipefail

# --- Proxy (GFW workaround) -------------------------------------------------
# Clash Verge Rev's default mixed port. Only used if something's actually
# listening there, so this is a no-op on a network that doesn't need it.
PROXY_PORT="${PROXY_PORT:-7897}"
if nc -z 127.0.0.1 "$PROXY_PORT" 2>/dev/null; then
  echo "==> Detected a local proxy on port $PROXY_PORT — routing installs through it."
  export http_proxy="http://127.0.0.1:${PROXY_PORT}"
  export https_proxy="http://127.0.0.1:${PROXY_PORT}"
  export all_proxy="socks5://127.0.0.1:${PROXY_PORT}"
else
  echo "==> No local proxy detected on port $PROXY_PORT — continuing without one."
fi

# --- Xcode Command Line Tools ------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools — click through the GUI installer that pops up..."
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
fi

# --- Homebrew ----------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew doctor || true

# --- Minimal package set needed to reach `yadm clone` -------------------------
# Everything else lives in .homebrew/Brewfile and is installed by `brew
# bundle` in phase 2, once the repo is actually on disk.
echo "==> Installing git, gh, yadm..."
brew install git gh yadm

# --- gh auth -------------------------------------------------------------------
# Request admin:public_key up front so `gh ssh-key add` below succeeds on the
# first try, instead of 404ing and needing a separate `gh auth refresh`.
if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  echo "==> Authenticating gh — follow the device-code flow in your browser..."
  gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key --scopes admin:public_key
fi

# --- SSH key ---------------------------------------------------------------
SSH_KEY="$HOME/.ssh/id_ed25519_github_personal"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$SSH_KEY" ]]; then
  echo "==> Generating SSH key..."
  ssh-keygen -t ed25519 -N "" -C "$(gh api user --jq .login)@github.com" -f "$SSH_KEY"
fi

SSH_CONFIG="$HOME/.ssh/config"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"
if ! grep -q '^Host github\.com$' "$SSH_CONFIG" 2>/dev/null; then
  echo "==> Adding github.com entry to ~/.ssh/config..."
  cat >>"$SSH_CONFIG" <<EOF

Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $SSH_KEY
  IdentitiesOnly yes
EOF
fi

/usr/bin/ssh-add --apple-use-keychain "$SSH_KEY"

# --- Register the key with GitHub -------------------------------------------
PUB_KEY_CONTENT="$(cut -d' ' -f1-2 "${SSH_KEY}.pub")"
if ! gh ssh-key list | grep -qF "$PUB_KEY_CONTENT"; then
  echo "==> Registering SSH key with GitHub..."
  gh ssh-key add "${SSH_KEY}.pub" --type authentication --title "$(scutil --get ComputerName) · GitHub"
fi

# --- Verify + clone -----------------------------------------------------------
echo "==> Verifying SSH auth to GitHub..."
# Always exits 1 on success (GitHub doesn't provide shell access) — that's expected.
ssh -T git@github.com -o StrictHostKeyChecking=accept-new || true

echo "==> Cloning dotfiles via yadm (this auto-runs .config/yadm/bootstrap when done)..."
yadm clone git@github.com:ukeSJTU/dotfiles.git
