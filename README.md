# dotfiles

## Set up

You'll want to install the following items first:

### OSX

```sh
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # install oh-my-zsh
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install homebrew
$ brew update
$ brew install cmake go nodejs mono macvim # YouCompleteMe dependencies
$ ssh-keygen -t ed25519 -C "your_email@example.com"
$ eval "$(ssh-agent -s)"
$ open ~/.ssh/config # check if ~/.ssh/config exists
$ echo "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config # [OSX only]: run this only if ~/.ssh/config doesn't already exist
$ ssh-add -K ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

### Ubuntu

```sh
$ apt install build-essential cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm
$ ssh-keygen -t ed25519 -C "your_email@example.com"
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Installation

Clone the repo into the home directory using 

```sh
$ git clone https://github.com/ddbourgin/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
```

and then

```sh
$ ./install minimal_install
``` 
