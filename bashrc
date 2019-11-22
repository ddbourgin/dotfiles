# Add local ~/.aliases if defined
[ -L $HOME/.aliases ] && source $HOME/.aliases

#   -----------------------------
#   1.  SET PATHS
#   -----------------------------
export PATH=/opt/local/bin:/opt/local/sbin:$PATH                # For use with MacPorts.

# set lscolor scheme for black background
# info: http://softwaregravy.wordpress.com/2010/10/16/ls-colors-for-mac/
export CLICOLOR=1
export LSCOLORS=fxBxhxDxfxhxhxhxhxcxcx

#   -----------------------------
#   2.  CUSTOM COMMANDS
#   -----------------------------
alias ~="cd ~"                              # ~: Go Home
alias cp='cp -iv'                           # Preferred 'cp' implementation (interactive)
alias mv='mv -iv'                           # Preferred 'mv' implementation (interactive)
alias rm='rm -i'                            # Preferred 'rm' implementation (interactive)
alias ln='ln -i'                            # Preferred 'ln' implementation (interactive)
alias ls='ls -lhaG'                         # Colorize 'ls' output
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias f='open -a Finder ./'                 # f: Opens current directory in MacOS Finder
alias qfind="find . -name "                 # qfind: Quickly search for file


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------
# lr:  Full Recursive Directory Listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# spotlight: Search for a file using MacOS Spotlight's metadata
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

# extract:  Extract most know archives with one command
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

#   --------------------------------------
#   4.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. $HOME/.ghcup/env
