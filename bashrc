#   -----------------------------
#   0.  SET BASH PROMPT FORMAT
#   -----------------------------
#   Instructions: http://blog.taylormcgann.com/2012/06/13/customize-your-shell-command-prompt/
#   PS1 Format:   \[\033[COLOR_CODE_HERE\]PROMPT_ESCAPE_OR_TEXT_HERE\[\033[0m\]
PROMPT_COMMAND='RET=$?; echo; if [ $RET != 0 ] ; then echo "rc: $RET"; fi; if [ "$PWD" != "$HOME" ]; then if [ $( ls -A | wc -l ) -lt 20 ]; then ls -mAF; fi; else ls -mF; fi'
PS1='\[\033[0;96m\]\u\[\033[00m\] in \[\033[0;32m\]$( pwd )\[\033[0m\] ($( OUT=$( ls -A | wc -l ); echo $OUT ) entries, $(( $( ls -A | wc -l ) - $( ls | wc -l ) )) hidden)\n\[\033[1;33m\]\# \! \$\[\033[;m\] '

# Add local ~/.aliases if defined
[ -L $HOME/.aliases ] && source $HOME/.aliases

#   -----------------------------
#   1.  SET PATHS
#   -----------------------------
export PATH=/opt/local/bin:/opt/local/sbin:$PATH 		# For use with MacPorts.

# set lscolor scheme for black background
# info: http://softwaregravy.wordpress.com/2010/10/16/ls-colors-for-mac/
export CLICOLOR=1
export LSCOLORS=fxBxhxDxfxhxhxhxhxcxcx

#   -----------------------------
#   2.  CUSTOM COMMANDS
#   -----------------------------
alias cp='cp -iv'                           # Preferred 'cp' implementation (interactive)
alias mv='mv -iv'                           # Preferred 'mv' implementation (interactive)
alias rm='rm -i' 		 	    # Preferred 'rm' implementation (interactive)
alias ln='ln -i'			    # Preferred 'ln' implementation (interactive)
alias ls='ls -lhaG'			    # Colorize 'ls' output
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='sublime'                        # edit: Opens any file in sublime text
alias f='open -a Finder ./'                 # f: Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~: Go Home
alias cic='set completion-ignore-case On'   # cic: Make tab-completion case-insensitive
alias show_options='shopt'                  # Show_options: display bash options settings
zipf () { zip -r "$1".zip "$1" ; }          # zipf: Create a ZIP archive of a folder
alias qfind="find . -name "   	            # qfind: Quickly search for file




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

# memHogsTop, memHogsPs:  Find memory hogs
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# cpuHogs:  Find CPU hogs
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# finderShowHidden:   Show hidden files in Finder
# finderHideHidden:   Hide hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   --------------------------------------
#   4.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------
# cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# cleanupDS:  Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
