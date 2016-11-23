# Path to your oh-my-zsh installation.
export ZSH=/Users/ddbourgin/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="af-magic"
ZSH_THEME="sorin"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew pip sublime colored-man)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source $ZSH/oh-my-zsh.sh
source /usr/local/bin/virtualenvwrapper.sh # for using virtualenvwrapper
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias screenrc="vim ~/.screenrc"
alias tmuxrc="vim ~/.tmux.conf"

# Virtualenv alias
alias workoff="deactivate $@"

#   -----------------------------
#   1.  SET PATHS
#   -----------------------------
export PATH=~/bin:$PATH                                 # Add bin folder to path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH        # For use with MacPorts.
export PATH=/applications/MATLAB_R2014b.app/bin:$PATH   # For running MATLAB from command line
export PATH=/applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export SCALA_HOME=/usr/local/bin/scala                  # Scala 
export PATH=$SCALA_HOME/bin:$PATH
export PYTHONPATH="/Users/ddbourgin/research/podcasts"
export WORKON_HOME=~/Envs

# set lscolor scheme for black background
# info: http://softwaregravy.wordpress.com/2010/10/16/ls-colors-for-mac/
export CLICOLOR=1
export LSCOLORS=fxBxhxDxfxhxhxhxhxcxcx

# for use with pylint via syntastic
LC_CTYPE=en_US.UTF-8
export LC_CTYPE

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

# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
setTerminalText () {
    # echo works in bash & zsh
    local mode=$1 ; shift
    echo -ne "\033]$mode;$@\007"
}
both_title  () { setTerminalText 0 $@; }
tab_title   () { setTerminalText 1 $@; }
window_title () { setTerminalText 2 $@; }


#   -----------------------------
#   2.  CUSTOM COMMANDS
#   -----------------------------
alias cp='cp -iv'            # Preferred 'cp' implementation (interactive)
alias mv='mv -iv'            # Preferred 'mv' implementation (interactive)
alias rm='rm -i'             # Preferred 'rm' implementation (interactive)
alias ln='ln -i'             # Preferred 'ln' implementation (interactive)
alias ls='ls -lhaG'          # Colorize 'ls' output

alias h="cd ~"               # ~: Go Home
alias cd..='cd ../'          # Go back 1 directory level (for fast typers)
alias ..='cd ../'            # Go back 1 directory level
alias ...='cd ../../'        # Go back 2 directory levels
alias .3='cd ../../../'      # Go back 3 directory levels
alias .4='cd ../../../../'   # Go back 4 directory levels
alias .5='cd ../../../../../'     # Go back 5 directory levels
alias .6='cd ../../../../../../'  # Go back 6 directory levels

alias ip='ipython'            # Open ipython
alias qfind="find . -name "          # qfind: Quickly search for file
powerline-daemon -q


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------
# lr:  Full Recursive Directory Listing
    alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# spotlight: Search for a file using MacOS Spotlight's metadata
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

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

# memHogsTop, memHogsPs:  Find memory hogs
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

    alias cpu='top -o cpu -s 2 -i 5'
    alias mem='vm_stat'

# cpuHogs:  Find CPU hogs
    alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# finderHideHidden:   Hide hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

    alias lynx="lynx -lss=/Users/ddbourgin/.lynx.lss"
# folder shortcuts:
    alias dsavid="cd ~/pelican/dsavid/"
    alias desk="cd ~/Desktop/"
    alias rw="cd ~/research/rwmodel/"
    alias research="cd ~/research"
    alias lda="cd ~/research/lda/"
    alias dl="cd ~/downloads/"
    alias envs="cd ~/envs/"
    alias notes="cd ~/dropbox/notes/"
    alias apps="cd /applications/"
    alias ipynb="cd ~/dropbox/notes/ipynb/"
    alias htdocs="cd /applications/MAMP/htdocs/"
    alias ss="cd ~/screenshots/"
    alias data="cd ~/datasets/"
    alias gen="cd ~/research/generalization/"
    alias pod="cd ~/research/podcasts/"
    alias keys="cd ~/keys"
    alias bayes_stats="cd ~/classes/stat238-fall-2016"
    alias ccrma="cd ~/classes/ccrma_controllers"

#   --------------------------------------
#   4.  SYSTEM OPERATIONS & INFORMATION
#   ---------------------------------------
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Use Vi mode at command line
# bindkey -v

# Reduce lag when switching between command and edit mode
export KEYTIMEOUT=1

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
