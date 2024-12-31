#!/bin/bash
set -euo pipefail

function can_sudo() {
    sudo -n -l >/dev/null 2>&1 || return 1
}

# Function to check if Homebrew is installed
check_and_install_homebrew() {
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew not installed. Installing Homebrew."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to check and install a cask if it's not already installed
install_cask_if_missing() {
    cask_name=$1
    if ! brew list --cask "$cask_name" &> /dev/null
    then
        echo "Cask $cask_name is not installed. Installing."
        brew install --cask "$cask_name"
    else
        echo "Cask $cask_name is already installed."
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    check_and_install_homebrew
    brew update

    install_cask_if_missing "karabiner-elements"
fi
