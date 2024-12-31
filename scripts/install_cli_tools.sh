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
    sudo apt install -y wget unzip cmake build-essential ffmpeg fzf
elif [[ "$OSTYPE" == "darwin"* ]]; then
    check_and_install_homebrew
    brew update

    install_package_if_missing "fzf"
    install_package_if_missing "wget"
    install_package_if_missing "cmake"
    install_package_if_missing "ffmpeg"
    install_package_if_missing "python"
fi
