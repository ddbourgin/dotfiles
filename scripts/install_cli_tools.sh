#!/bin/bash
set -euo pipefail

#########################################################################
# Attempts to install the following essential tools:
#
# OSX:
#   PROGRAMS:
#     homebrew, karabiner-elements, popclip, 1password, mactex-no-gui, skim
#   QUICKLOOK PLUGINS:
#     qlcolorcode, qlstephen, qlmarkdown, quicklook-json, qlimagesize
#   CLI TOOLS:
#     oh-my-zsh, uv, fzf, wget, cmake, ffmpeg, neovim, ripgrep, fd,
#     ghostscript, tree, imagemagick, nvm, node, npm, htop, lazygit
#
# LINUX:
#   CLI TOOLS:
#     fzf, wget, cmake, ffmpeg, neovim, ripgrep, fd-find, tree, unzip,
#     libreadline-dev, build-essential, gpustat, htop
#
# where () indicates OSX-only and [] indicates linux-only packages.
#
# An explanation of the bash switches `eu(x)o pipefail`:
# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
#
# set -e
#     tells bash to immediately exit if any command has a non-zero exit code
# set -x
#     prints each executed command to terminal
# set -u
#     ensures that referring to a variable you haven't defined
#     will throw an error and cause the script to exit
# set -o pipefail
#     ensures that if *any* command in a pipeline fails, its return
#     code will be used as the return code for the whole pipeline
#########################################################################

OSX_CASKS="karabiner-elements popclip 1password mactex-no-gui skim"
OSX_PACKAGES="fzf wget cmake ffmpeg neovim ripgrep fd ghostscript tree imagemagick htop lazygit"
OSX_QL_PLUGINS="qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize"
LINUX_PACKAGES="fzf wget cmake ffmpeg neovim ripgrep fd-find tree unzip libreadline-dev build-essential gpustat lazygit"

# also installs nvm and latest version of node

function can_sudo() {
  sudo -n -l >/dev/null 2>&1 || return 1
}

# Function to check if Homebrew is installed
check_and_install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed. Skipping"
  fi
}

# Function to check if nvm is installed
check_and_install_nvm() {
  if ! command -v nvm &>/dev/null; then
    echo "nvm is not installed. Installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  else
    echo "nvm is already installed. Skipping"
  fi
}

# Function to check if uv is installed
check_and_install_uv() {
  if ! command -v uv &>/dev/null; then
    echo "uv is not installed. Installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    echo "uv is already installed. Skipping."
  fi
}

# Function to check if oh-my-zsh is installed
check_and_install_oh_my_zsh() {
  if ! command -v omz &>/dev/null; then
    echo "oh-my-zsh is not installed. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh is already installed. Skipping."
  fi
}

# Function to check and install a package if it's not already installed
install_brew_package_if_missing() {
  package_name=$1
  if ! brew list "$package_name" &>/dev/null; then
    echo "Package $package_name is not installed. Installing."
    brew install "$package_name"
  else
    echo "Package $package_name is already installed."
  fi
}

# Function to check and install a cask if it's not already installed
install_brew_cask_if_missing() {
  cask_name=$1
  if ! brew list --cask "$cask_name" &>/dev/null; then
    echo "Cask $cask_name is not installed. Installing."
    brew install --cask "$cask_name"
  else
    echo "Cask $cask_name is already installed. Skipping."
  fi
}

# All deps (on Linux, escalates to root as needed; uses homebrew on OSX)
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  if [ "$(id -u)" != "0" ]; then
    # Check if we can sudo.
    if ! can_sudo; then
      echo 'I need sudo to complete. Follow this prompt (or Ctrl-C to cancel.).'
      echo ''
      sudo -l || true # failure is OK; we catch it below.
      echo '...success! Continuing.'
    fi

    if ! can_sudo; then
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
  sudo apt install -y $LINUX_PACKAGES

elif [[ "$OSTYPE" == "darwin"* ]]; then

  check_and_install_homebrew
  brew update

  for PKG in $OSX_PACKAGES; do
    install_brew_package_if_missing "$PKG"
  done

  for PKG in $OSX_QL_PLUGINS; do
    install_brew_package_if_missing "$PKG"
  done

  for CASK in $OSX_CASKS; do
    install_brew_cask_if_missing $CASK
  done
fi

# install oh-my-zsh
# see: https://ohmyz.sh/#install
check_and_install_oh_my_zsh

# install uv
# see: https://docs.astral.sh/uv/getting-started/installation/
check_and_install_uv

# install node version manager (nvm)
# see: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
check_and_install_nvm

# these lines are also in `aliases` so that they will run in all future shells
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# install the latest LTS version of Node using nvm
LATEST_LTS_VERSION=$(nvm version-remote --lts)
INSTALLED_VERSION=$(nvm version "$LATEST_LTS_VERSION")

if [ "$INSTALLED_VERSION" == "N/A" ]; then
  echo "Latest LTS version of Node.js ($LATEST_LTS_VERSION) is not installed. Installing..."
  nvm install --lts
else
  echo "Latest LTS version of Node.js ($LATEST_LTS_VERSION) is already installed."
fi

# Verify the node / npm installation
NODE_VERSION=$(node -v)
NPM_VERSION=$(npm -v)

echo "Installation of Node.js $NODE_VERSION and npm $NPM_VERSION completed successfully."
