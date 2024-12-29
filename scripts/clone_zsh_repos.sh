#!/usr/bin/env sh
set -euo pipefail

#######################################################################
#                            Vim packages                             #
#######################################################################
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
git clone git@github.com:ycm-core/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe

#######################################################################
#                            Zsh packages                             #
#######################################################################
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestion
