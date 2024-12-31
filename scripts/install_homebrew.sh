#!/bin/bash
set -euo pipefail

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

# homebrew is only relevant for OSX
if [[ "$OSTYPE" == "darwin"* ]]; then
    check_and_install_homebrew
    brew update
fi
