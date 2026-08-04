eval "$(/opt/homebrew/bin/brew shellenv zsh)"
eval "$(mise activate zsh --shims)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# First-party standalone developer tools
typeset -U path PATH
path=("$HOME/.local/bin" $path)

