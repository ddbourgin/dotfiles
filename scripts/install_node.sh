#!/usr/bin/env bash
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

# Function to check and install a package if it's not already installed
install_package_if_missing() {
    package_name=$1
    if ! brew list "$package_name" &> /dev/null
    then
        echo "Package $package_name is not installed. Installing."
        brew install "$package_name"
    else
        echo "Package $package_name is already installed."
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

# Function to load NVM scripts
load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

# Function to install the latest LTS version of Node.js using NVM
install_latest_lts_node() {
    local latest_lts_version=$(nvm version-remote --lts)
    local installed_version=$(nvm version "$latest_lts_version")

    if [ "$installed_version" == "N/A" ]; then
        echo "Latest LTS version of Node.js ($latest_lts_version) is not installed. Installing..."
        nvm install --lts
    else
        echo "Latest LTS version of Node.js ($latest_lts_version) is already installed."
    fi
}

# All deps (on Linux, escalates to root as needed; uses homebrew on OSX)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt update --qq
    sudo apt install -y nvm

elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_package_if_missing "nvm"
fi

# Check if nvm is installed
load_nvm

# Install the latest LTS version of Node.js
install_latest_lts_node

# Verify the installation
node_version=$(node -v)
npm_version=$(npm -v)

echo "Installation of Node.js $node_version and npm $npm_version completed successfully."
