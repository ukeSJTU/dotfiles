# mise: per-project runtime version manager (node, python, go, rust, ...).
# Must run first so its shims are on PATH before anything below relies on them.
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

# Completion styling: case-insensitive-ish matching, colored listings, grouped
# output, and disk caching for slow completions (e.g. git, brew).
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=33:cd=33'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# fzf-tab must load after compinit, but before plugins that wrap widgets
# (zsh-autosuggestions, zsh-syntax-highlighting, both sourced below).
if [[ -r "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]]; then
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
  source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
fi

# fzf: fuzzy finder. These env vars point its built-in keybindings
# (Ctrl-T = insert file, Alt-C = cd into dir) at fd for faster, .gitignore-aware
# searching, and add a bat-rendered preview pane for Ctrl-T.
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

# starship: cross-shell prompt renderer; theme/modules live in
# .config/starship.toml.
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# direnv must be hooked last so its PATH/env mutations aren't clobbered by
# later tool inits.
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# Persistent history.
ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "$ZSH_STATE_DIR"

HISTFILE="$ZSH_STATE_DIR/history"
HISTSIZE=100000
SAVEHIST=50000

# History write/dedup behavior: write timestamps, share history across
# concurrent sessions immediately (INC_APPEND_HISTORY), drop duplicates
# (keeping the newest), and let a space-prefixed command skip history
# entirely (HIST_IGNORE_SPACE) — handy for one-off commands with secrets.
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE

# Small interactive conveniences: type a bare dir name to cd into it
# (AUTO_CD), allow # comments when typing interactively, enable advanced
# glob operators like ^ and # (EXTENDED_GLOB), match globs case-insensitively
# (NO_CASE_GLOB — interactive only, doesn't affect scripts), and stay quiet.
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NO_BEEP

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

# Explicit emacs keymap (already zsh's default, but pinned so a stray
# $EDITOR=vi elsewhere on the machine can't silently flip this — vi-mode
# itself is intentionally not configured for now).
bindkey -e

# Extra navigation keys beyond the emacs-mode defaults (Alt+B/F/D/Backspace
# for word movement already work out of the box).
[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line
[[ -n "$terminfo[kend]" ]] && bindkey "$terminfo[kend]" end-of-line
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char
# Ctrl+Left / Ctrl+Right to jump by word (xterm-style sequences; WezTerm sends these).
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Quality-of-life aliases.
alias c='clear'

# eza: a nicer `ls` — colored, git status per file, directories grouped
# first. No icons, kept plain.
if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --git'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
  alias lt='eza --tree --level=2 --group-directories-first --git'
fi

# bat: syntax-highlighted `cat`, kept as a separate `bcat` rather than
# overriding `cat` itself. --theme=ansi reuses the terminal's own color
# scheme instead of a fixed bat theme, so it matches whatever WezTerm theme
# is active.
if (( $+commands[bat] )); then
  alias bcat='bat --theme=ansi'
fi

# tealdeer: example-first man pages (community-maintained cheatsheets).
if (( $+commands[tldr] )); then
  alias help='tldr'
fi

# Proxy toggle: `proxy` points http(s)/all_proxy at the local Clash
# instance; `unproxy` clears them.
proxy() {
  export http_proxy="http://127.0.0.1:7897"
  export https_proxy="$http_proxy"
  export all_proxy="$http_proxy"
  export no_proxy="localhost,127.0.0.1,::1"
}
unproxy() {
  unset http_proxy https_proxy all_proxy no_proxy
}

# Auto-enable the proxy at shell startup, but only if something is actually
# listening on 127.0.0.1:7897 — otherwise every network call would hang/
# retry against a closed port. zsh/net/tcp does the probe as a plain local
# connect() with no external process, so it's effectively instant.
zmodload zsh/net/tcp 2>/dev/null
if (( $+builtins[ztcp] )) && ztcp 127.0.0.1 7897 2>/dev/null; then
  ztcp -c "$REPLY"
  proxy
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
