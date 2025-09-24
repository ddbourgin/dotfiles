#!/bin/bash
set -euo pipefail

function can_sudo() {
    sudo -n -l >/dev/null 2>&1 || return 1
}

# All deps (on Linux, escalates to root as needed; uses homebrew on OSX)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ "$(id -u)" != "0" ] ; then
        # Check if we can sudo.
        if ! can_sudo ; then
            echo 'I need sudo to complete. Follow this prompt (or Ctrl-C to cancel.).'
            echo  ''
            sudo -l || true  # failure is OK; we catch it below.
            echo '...success! Continuing.'
        fi

        if ! can_sudo ; then
            echo 'Initialize sudo by running:'
            echo ''
            echo 'sudo -l'
            echo ''
            echo 'Then re-run this program with:'
            echo ''
            echo "$0 $@"
            exit 1
        fi
    fi

    sudo apt update -qq
    sudo apt install -y wget unzip cmake sox build-essential ffmpeg python-dev silversearcher-ag fzf oh-my-zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew update
    brew install ffmpeg wget sox cmake the_silver_searcher oh-my-zsh fzf
    brew cask install macvim qlcolorcode qlstephen qlmarkdown quicklook-json betterzip qlvideo
fi
