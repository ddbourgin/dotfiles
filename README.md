# dotfiles

## Set up

You'll want to install the following items first:

### OSX

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
echo "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config # run this only if ~/.ssh/config doesn't already exist
ssh-add -K ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

You may also want to install the [Solarized Dark Higher Contrast iTerm color scheme](https://iterm2colorschemes.com/).

### Ubuntu

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Installation

Clone the repo into the home directory using

```sh
git clone https://github.com/ddbourgin/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
```

and then

```sh
./install
```
