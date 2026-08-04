eval "$(mise activate zsh)"

# Homebrew-provided Zsh completions.
if [[ -n "$HOMEBREW_PREFIX" ]] &&
   [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# zsh-completions: extra completion definitions, must be added before compinit.
if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
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

# History substring search — must load after zsh-syntax-highlighting.
if [[ -r "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# Reminds you when a command you just typed has a shorter existing alias.
if [[ -r "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh" ]]; then
  export YSU_MESSAGE_POSITION="after"
  source "$HOMEBREW_PREFIX/share/zsh-you-should-use/you-should-use.plugin.zsh"
fi

# forgit: interactive fzf-driven git commands. Its default aliases collide
# with the git plugin below (ga, gd, gco, gcb, ...), so register our own
# under an `fg` prefix (fga, fgd, fgco, ...) instead of forgit's defaults.
if [[ -r "$HOMEBREW_PREFIX/opt/forgit/share/forgit/forgit.plugin.zsh" ]]; then
  export FORGIT_NO_ALIASES=1
  source "$HOMEBREW_PREFIX/opt/forgit/share/forgit/forgit.plugin.zsh"
  alias fga='forgit::add'
  alias fgrh='forgit::reset::head'
  alias fgrs='forgit::restore'
  alias fglo='forgit::log'
  alias fgrl='forgit::reflog'
  alias fgd='forgit::diff'
  alias fgso='forgit::show'
  alias fgi='forgit::ignore'
  alias fgat='forgit::attributes'
  alias fgcf='forgit::checkout::file'
  alias fgcff='forgit::checkout::file::from::commit'
  alias fgcb='forgit::checkout::branch'
  alias fgsw='forgit::switch::branch'
  alias fgco='forgit::checkout::commit'
  alias fgct='forgit::checkout::tag'
  alias fgbd='forgit::branch::delete'
  alias fgrc='forgit::revert::commit'
  alias fgclean='forgit::clean'
  alias fgss='forgit::stash::show'
  alias fgsp='forgit::stash::push'
  alias fgcp='forgit::cherry::pick::from::branch'
  alias fgrb='forgit::rebase'
  alias fgfu='forgit::fixup'
  alias fgsq='forgit::squash'
  alias fgrw='forgit::reword'
  alias fgbl='forgit::blame'
  alias fgwt='forgit::worktree'
  alias fgwa='forgit::worktree::add'
  alias fgwd='forgit::worktree::delete'
fi

# Vendored git aliases (gst, gc, gco, ...) — see .config/zsh/plugins/git.plugin.zsh
if [[ -r "$HOME/.config/zsh/plugins/git.plugin.zsh" ]]; then
  source "$HOME/.config/zsh/plugins/git.plugin.zsh"
fi

