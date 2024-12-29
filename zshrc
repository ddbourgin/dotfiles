zmodload zsh/zprof

#######################################################################
#                            ZPLUG PLUGINS                            #
#######################################################################

# https://github.com/zplug/zplug
source ~/.zplug/init.zsh

zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/zsh-autosuggestions", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

# enhancd
# https://github.com/babarot/enhancd
# used in conjunction with fzf to mask the `cd` built-in. commands:
#   - `cd -`   show top 10 recent dirs
#   - `cd ..`  show parent dirs
#   - `cd .`   show child dirs
#   - `cd`     show all visited directories
#   - `cd <keyword>` show all subdirs with fuzzy match to keyword
zplug "b4b4r07/enhancd"

# zsh-history-substring-search
# https://github.com/zsh-users/zsh-history-substring-search
#   type in any part of a command from history and then press up/down or j/k to
#   cycle through fuzzy matches
zplug "zsh-users/zsh-history-substring-search", as:plugin

# fzf-zsh-plugin
# https://github.com/unixorn/fzf-zsh-plugin
#   Allows fzf in Ctrl-r search
zplug "unixorn/fzf-zsh-plugin", depth:1

# zsh-vi-mode
# https://github.com/jeffreytse/zsh-vi-mode
#   improved vi-mode keybindings for zsh
zplug "jeffreytse/zsh-vi-mode"

# zsh-syntax-highlighting
# must be loaded BEFORE zsh-history-substring-search
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# let zplug manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# bind UP and DOWN, along with j and k for zsh-history-substring-search plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "^R" fzf-history-widget
bindkey "^r" fzf-history-widget

export ZVM_VI_INSERT_ESCAPE_BINDKEY=^J
export ZVM_VI_VISUAL_ESCAPE_BINDKEY=^J


#######################################################################
#                         OH-MY-ZSH SETTINGS                          #
#######################################################################
# Path to oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="sorin"

# disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(pip) # git brew pip zsh-autosuggestions colored-man-pages)

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Use Vi mode at command line
# bindkey -v

#######################################################################
#                     ENVIRONMENT VARIABLES                           #
#######################################################################
export LANG=en_US.UTF-8

# Reduce lag when switching between command and edit mode in vim
export KEYTIMEOUT=1

# for use with pylint via vim's syntastic plugin
export LC_CTYPE=en_US.UTF-8

# set lscolor scheme for black background
# info: http://softwaregravy.wordpress.com/2010/10/16/ls-colors-for-mac/
export CLICOLOR=1
export LSCOLORS=fxBxhxDxfxhxhxhxhxcxcx
# export GHCI=stack ghci

source $ZSH/oh-my-zsh.sh

#######################################################################
#                               ALIASES                               #
#######################################################################
# All machine-agnostic aliases should be defined in zshrc. Add all
# machine-specific aliases to ~/.aliases

# Add local ~/.aliases if defined
if [[ -a "${HOME}/.aliases" ]]; then
    . "${HOME}/.aliases";
fi

# Adobe Artifactory tokens + RunAI commands
if [[ -a "${HOME}/.adobe_aliases" ]]; then
    . $HOME/.adobe_aliases
fi

# Set personal aliases (machine-specific aliases are sourced from ~/.aliases above)
# For a full list of active aliases, run `alias`.
alias cp='cp -iv'            # Preferred 'cp' implementation (interactive)
alias mv='mv -iv'            # Preferred 'mv' implementation (interactive)
alias rm='rm -i'             # Preferred 'rm' implementation (interactive)
alias ln='ln -i'             # Preferred 'ln' implementation (interactive)
alias ls='ls -lhaG'          # Colorize 'ls' output

alias qfind="find . -name "  # qfind: Quickly search for file by name

alias h="cd ~"               # ~: Go Home
alias cd..='cd ../'          # Go up 1 directory level
alias ..='cd ../'            # Go up 1 directory level
alias ...='cd ../../'        # Go up 2 directory levels
alias .3='cd ../../../'      # Go up 3 directory levels
alias .4='cd ../../../../'   # Go up 4 directory levels
alias .5='cd ../../../../../'     # Go up 5 directory levels
alias .6='cd ../../../../../../'  # Go up 6 directory levels


#######################################################################
#                           CUSTOM COMMANDS                           #
#######################################################################

# for ctrl-z in vim to toggle between shell and vim session
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# --------------------------------------------------------------------
# extract:
#       Extract most known archives with one command
# Usage:
#       extract /path/to/file.tar.gz
# --------------------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# --------------------------------------------------------------------
# archive
#       make a tar.gz archive of a given directory and put it in pwd
# Usage:
#       archive ./my_dir
# --------------------------------------------------------------------
archive() {
    set -x
    tar -czf "$(basename "${1}")".tar.gz ${1}
    set +x
}

# --------------------------------------------------------------------
# replace
#       Replace text recursively across *all* files starting at a particular
#       root directory
# Usage:
#       replace $STRING_TO_REPLACE $REPLACEMENT $ROOT_DIRECTORY
# --------------------------------------------------------------------
replace() {
    ESCAPED_FROM=$(printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g')
    ESCAPED_TO=$(printf '%s\n' "$2" | sed -e 's/[\/&]/\\&/g')
    DIR="${3:-.}"
    set -x
    find "$DIR" -type f -name '*' -exec sed -i '' -e "s/$ESCAPED_FROM/$ESCAPED_TO/g" {} \;
    set +x
}

# --------------------------------------------------------------------
# replace_py
#       replace text recursively across all *python files* starting at a
#       particular directory root
# Usage:
#       replace_py $STRING_TO_REPLACE $REPLACEMENT $ROOT_DIRECTORY
# --------------------------------------------------------------------
replace_py() {
    ESCAPED_FROM=$(printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g')
    ESCAPED_TO=$(printf '%s\n' "$2" | sed -e 's/[\/&]/\\&/g')
    DIR="${3:-.}"
    set -x
    find "$DIR" -type f -name '*.py' -exec sed -i '' -e "s/$ESCAPED_FROM/$ESCAPED_TO/g" {} \;
    set +x
}


# --------------------------------------------------------------------
# upload:
#       upload a local file to a remote on a given port (must be
#       port-forwarded) first
# Usage:
#       upload /my/local/dir /remote/dir/ 2222
# --------------------------------------------------------------------
upload() {
    echo "Make sure to run port_forward command in separate terminal first"
    set -x
    PORT="${3:-2222}"
    rsync -avv --progress --inplace -R -e "ssh -p $PORT" $1 dbourgin@localhost:$2
    set +x
}


# defaults for the fuzzyfinder fzf command
_gen_fzf_default_opts() {
    local base03="234"
    local base02="235"
    local base01="240"
    local base00="241"
    local base0="244"
    local base1="245"
    local base2="254"
    local base3="230"
    local yellow="136"
    local orange="166"
    local red="160"
    local magenta="125"
    local violet="61"
    local blue="33"
    local cyan="37"
    local green="64"
    local white="15"

    # Solarized Dark color scheme for fzf
    export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$orange,fg+:$base2,bg+:$base03,hl+:$orange
    --color info:$yellow,prompt:$yellow,pointer:$yellow,marker:$yellow,spinner:$white
    --height 40% --border
    "
    # alternate Solarized colors
    # export FZF_DEFAULT_OPTS='
    #   --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
    #   --color info:254,prompt:37,spinner:108,pointer:235,marker:235
    #   --height 40% --border
    # '
}

_gen_fzf_default_opts

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


/Users/ddb/.colligo/conda/bin/activate
