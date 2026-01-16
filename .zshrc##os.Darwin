if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if [[ -f "$HOME/.config/homebrew/config" ]]; then
        source "$HOME/.config/homebrew/config"
    fi
fi

# ==========================================
# 2. Manually set PATH and other environment variables
# ==========================================
# NOTE: we put PATH settings before mise so that mise can manage versions correctly

# System / Local bins
export PATH="/usr/local/bin:$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/homebrew/opt/postgresql@15/bin"
PATH=~/.console-ninja/.bin:$PATH

# WezTerm
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# Perl
export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

# Coq
export PATH='/Applications/Coq-Platform~8.20~2025.01.app/Contents/Resources/bin':"$PATH"
export COQLIB="$(/Applications/Coq-Platform~8.20~2025.01.app/Contents/Resources/bin/coqc -where 2>/dev/null | tr -d '\r')"

# Flutter
export PATH="$HOME/flutter/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Cargo (Rust)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Load mise, we use mise to manage node, python, rust, go etc.
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

####################################
# Load zplug to manage zsh plugins #
####################################
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/alias-tips", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "Aloxaf/fzf-tab"

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo
        zplug install
    else
        echo
    fi
fi
zplug load

########################
# End of zplug loading #
########################

ZSH_CONFIG_DIR="$HOME/.config/zsh"

# I load it here to make sure that the aliases are loaded after the plugins
[ -f "$ZSH_CONFIG_DIR/aliases.zsh" ] && source "$ZSH_CONFIG_DIR/aliases.zsh"
[ -f "$ZSH_CONFIG_DIR/custom.zsh" ]  && source "$ZSH_CONFIG_DIR/custom.zsh"

if [[ -f "$HOME/.zshrc.local" ]]; then source "$HOME/.zshrc.local"; fi

# zsh Options
setopt HIST_IGNORE_ALL_DUPS
setopt AUTO_CD

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# Put Tmux session management after all PATH and other environment variables are set
# Tmux Intelligent Session Management
if command -v tmux >/dev/null 2>&1; then
    # Check if the current environment is suitable for running tmux
    if [[ -z "$TMUX" &&
        $TERM != "screen-256color" &&
        $TERM != "screen" &&
        -z "$VSCODE_INJECTION" &&
        -z "$INSIDE_EMACS" &&
        -z "$EMACS" &&
        -z "$VIM" &&
        -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then

        # Check if tmux should be forcibly started
        if [[ -n "$FORCE_TMUX" ]] || [[ -n "$SSH_CONNECTION" ]]; then
            # Determine session name
            if [[ -n "$TMUX_SESSION_NAME" ]]; then
                SESSION_NAME="$TMUX_SESSION_NAME"
            elif [[ -n "$SSH_CONNECTION" ]]; then
                SESSION_NAME="default-$(whoami)"
            else
                SESSION_NAME="local-$(whoami)"
            fi

            # Try to attach to an existing session, or create a new one if it doesn't exist
            if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
                # Session exists, attempt to attach
                tmux attach -t "$SESSION_NAME"
            else
                # Session does not exist, create a new session
                tmux new-session -s "$SESSION_NAME"

                # Set session timeout for automatic termination (if specified)
                if [[ -n "$TMUX_IDLE_TIMEOUT" ]]; then
                    tmux set-option -t "$SESSION_NAME" destroy-unattached on
                    tmux set-option -t "$SESSION_NAME" destroy-unattached-timeout "$TMUX_IDLE_TIMEOUT"
                fi
            fi

            # Check the exit behavior environment variable
            if [[ "$TMUX_EXIT_BEHAVIOR" == "kill" ]]; then
                # If set to "kill", terminate the session
                tmux kill-session -t "$SESSION_NAME"
            fi

            # Exit the current shell
            exit
        fi
        # If running in a local terminal and tmux is not forced, do nothing
    fi
fi