# Load Custom zsh
[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

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

# Add a bunch more of your favorite packages!

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

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load Alias zsh
# I load it here to make sure that the aliases are loaded after the plugins
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Use the local zshrc file if it exists
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

PATH=~/.console-ninja/.bin:$PATH
PATH="/Users/uke/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/uke/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/uke/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/uke/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/uke/perl5"; export PERL_MM_OPT;

export PATH='/Applications/Coq-Platform~8.20~2025.01.app/Contents/Resources/bin':"$PATH"
export COQLIB="$(/Applications/Coq-Platform~8.20~2025.01.app/Contents/Resources/bin/coqc -where 2>/dev/null | tr -d '\r')"

export codexKey88="88_427211af9c142371861a967c26f3bcf106c0cb4c8d47f782bdfda22cbb403fb7"
