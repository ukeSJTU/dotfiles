eval "$(mise activate zsh)"

# Homebrew-provided Zsh completions.
if [[ -n "$HOMEBREW_PREFIX" ]] &&
   [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# Completion cache.
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"

# fzf-tab must load after compinit, but before plugins that wrap widgets
# (zsh-autosuggestions, zsh-syntax-highlighting, both sourced below).
if [[ -r "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]]; then
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
  source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
fi

# fzf
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 -- {}'"

  source <(fzf --zsh)
fi

# zoxide must be initialized after compinit.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Persistent history.
ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "$ZSH_STATE_DIR"

HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=100000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Small interactive conveniences.
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

if [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Vendored git aliases (gst, gc, gco, ...) — see .config/zsh/plugins/git.plugin.zsh
if [[ -r "$HOME/.config/zsh/plugins/git.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/git.plugin.zsh"
fi

