[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Secrets
[ -f "$HOME/.env" ] && source "$HOME/.env"

# XDG Base directory specification
export XDG_CONFIG_HOME="$HOME/.config"     # Config files
export XDG_CACHE_HOME="$HOME/.cache"       # Cache files
export XDG_DATA_HOME="$HOME/.local/share"  # Application data
export XDG_STATE_HOME="$HOME/.local/state" # Logs and state files

# Proxy settings for clash
# export https_proxy=http://127.0.0.1:7890
# export http_proxy=http://127.0.0.1:7890
# export all_proxy=socks5://127.0.0.1:7890
# export all_proxy=https://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
# Themes (onedark or nord)
export TMUX_THEME="onedark"
# export NVIM_THEME="nord"
export STARSHIP_THEME="monokai"
# export WEZTERM_THEME="nord"

# Use Neovim as default editor
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export VISUAL="nvim"

# Add /usr/local/bin to the beginning of the PATH environment variable.
# This ensures that executables in /usr/local/bin are found before other directories in the PATH.
export PATH="/usr/local/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# Add Homebrew's sbin directory to the PATH environment variable.
export PATH="$PATH:/opt/homebrew/opt/postgresql@15/bin"

# wezterm
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# console-ninja
export PATH="$PATH:~/.console-ninja/.bin"

# envman
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
# Check if pyenv is installed before initializing
if which pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
export PATH="/Users/uke/flutter/bin:$PATH"
