eval "$(/opt/homebrew/bin/brew shellenv zsh)"
eval "$(mise activate zsh --shims)"

# Keep portable CLI configuration under ~/.config on macOS.
export XDG_CONFIG_HOME="$HOME/.config"

# Default terminal editor. Yazi and other CLI tools use these variables when
# opening text files, while VISUAL covers tools that prefer a full-screen editor.
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# First-party standalone developer tools
typeset -U path PATH
path=("$HOME/.local/bin" $path)

# TeX Live (BasicTeX)
path=("/Library/TeX/texbin" $path)
