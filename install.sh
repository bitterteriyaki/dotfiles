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

configure_monitors() {
  FILE=/etc/X11/xorg.conf.d/10-monitor.conf

  if [ ! -f "$FILE" ]; then
    sudo cp confs/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
    echo -e "=> Monitors configured successfully."
  else
    echo -e "=> Monitors already configured."
  fi
}

#################
#  Main script  #
#################

setup() {
  echo -e "=> This script will setup kyomi's dotfiles on your system."
  read -n 1 -r -s -p $'=> Press any key to continue or Ctrl+C to abort...\n'

  install_git
  configure_monitors
}

setup

