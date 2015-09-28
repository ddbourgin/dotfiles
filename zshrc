# Path to your oh-my-zsh installation.
export ZSH=/Users/ddbourgin/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

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
plugins=(git brew pip sublime vi-mode colored-man)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source /usr/local/bin/virtualenvwrapper.sh # for using virtualenvwrapper
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"




#   -----------------------------
#   1.  SET PATHS
#   -----------------------------
export PATH=/Users/ddbourgin/bin:$PATH            # Add bin folder to path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # For use with MacPorts.
export PATH=/applications/MATLAB_R2014b.app/bin:$PATH   # For running MATLAB from command line

export WORKON_HOME=~/Envs
export ECHO_NEST_API_KEY="VOGH67EDZLHSOMFXK"         # Echonest remix API key

# set lscolor scheme for black background
# info: http://softwaregravy.wordpress.com/2010/10/16/ls-colors-for-mac/
export CLICOLOR=1
export LSCOLORS=fxBxhxDxfxhxhxhxhxcxcx



#   -----------------------------
#   2.  CUSTOM COMMANDS
#   -----------------------------
alias cp='cp -iv'       # Preferred 'cp' implementation (interactive)
alias mv='mv -iv'       # Preferred 'mv' implementation (interactive)
alias rm='rm -i'        # Preferred 'rm' implementation (interactive)
alias ln='ln -i'        # Preferred 'ln' implementation (interactive)
alias ls='ls -lhaG'     # Colorize 'ls' output
alias cd..='cd ../'     # Go back 1 directory level (for fast typers)
alias ..='cd ../'       # Go back 1 directory level
alias ...='cd ../../'   # Go back 2 directory levels
alias .3='cd ../../../'      # Go back 3 directory levels
alias .4='cd ../../../../'   # Go back 4 directory levels
alias .5='cd ../../../../../'     # Go back 5 directory levels
alias .6='cd ../../../../../../'  # Go back 6 directory levels
alias edit='subl'                 # edit: Opens any file in sublime text 
alias f='open -a Finder ./'       # f:    Opens current directory in MacOS Finder
alias h="cd ~"                    # ~:    Go Home
alias cic='set completion-ignore-case On'   # cic:  Make tab-completion case-insensitive
alias show_options='shopt'   # Show_options: display bash options settings
zipf () { zip -r "$1".zip "$1" ; }   # zipf: Create a ZIP archive of a folder
alias qfind="find . -name "          # qfind: Quickly search for file
alias ec2_key="/Users/ddbourgin/keys/aws_notebook_key.pem"
powerline-daemon -q
# . /usr/local/bin/powerline/bindings/zsh/



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

# cpuHogs:  Find CPU hogs
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# finderHideHidden:   Hide hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

# folder shortcuts:
    alias dsavid="cd ~/pelican/dsavid/"
    alias desk="cd ~/Desktop/"
    alias rw="cd ~/research/rwmodel/"
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
    alias ccrma="cd ~/classes/ccrma_controllers"

#   --------------------------------------
#   4.  SYSTEM OPERATIONS & INFORMATION
#   ---------------------------------------
# cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# cleanupDS:  Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# Use Vi mode at command line
bindkey -v

# Reduce lag when switching between command and edit mode
export KEYTIMEOUT=1
