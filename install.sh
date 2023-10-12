#!/bin/bash

install_git() {
  if ! command -v git &> /dev/null; then
    echo -e "=> Installing Git..."
    sudo pacman -S --needed --noconfirm git
    echo -e "=> Git has been installed."
  else
    echo -e "=> Git is already been installed."
  fi
}

#################
#  Main script  #
#################

setup() {
  echo -e "=> This script will setup kyomi's dotfiles on your system."
  read -n 1 -r -s -p $'=> Press any key to continue or Ctrl+C to abort...\n'

  install_git
}

setup

