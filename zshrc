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
plugins=(git brew pip zsh-syntax-highlighting colored-man-pages vi-mode)

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
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin"
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
if [ -L "${HOME}/.aliases" ]; then 
    . "${HOME}/.aliases";
fi

# Set personal aliases (machine-specific aliases are sourced from ~/.aliases above)
# For a full list of active aliases, run `alias`.
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias screenrc="vim ~/.screenrc"
alias tmuxrc="vim ~/.tmux.conf"
alias bashrc="vim ~/.bashrc"

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

alias workoff="deactivate $@"

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

powerline-daemon -q

# extract:  Extract most known archives with one command
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

#######################################################################
#                         ADDITIONAL IMPORTS                          #
#######################################################################
 
# Load RVM into a shell session *as a function*
if [ -e "$HOME/.rvm/scripts/rvm" ]; then 
    . "$HOME/.rvm/scripts/rvm";
fi

# source Haskell / Tidal environment
if [ -e "${HOME}/.ghcup/env" ]; then
    . $HOME/.ghcup/env;
fi

# initialize shell integration if using iterm2
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    . "${HOME}/.iterm2_shell_integration.zsh";
fi

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
if [ -f "/usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh" ]; then
    . "/usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh";
fi

# update PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then 
    . "${HOME}/google-cloud-sdk/path.zsh.inc"; 
fi

# enable shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then 
    . "${HOME}/google-cloud-sdk/completion.zsh.inc"; 
fi

# initialize the fzf searcher
if [ -f "${HOME}/.fzf.zsh" ]; then
    . "${HOME}/.fzf.zsh";
fi
