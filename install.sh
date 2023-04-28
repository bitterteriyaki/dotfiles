#!/bin/bash

# Copyright (c) 2023-present kyomi
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

###########
# Helpers #
###########

start() {
  echo -n "$1"
}

finish() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\r$1"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\r\e[K$1"
  fi
}

#############
# Variables #
#############

HB_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
OMZ_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

########################
# Installation scripts #
########################

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    start "=> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL $HB_URL)"
    finish "=> Homebrew has been installed."
  else
    echo "=> Homebrew is already installed."
  fi
}

install_yay() {
  if ! command -v yay &> /dev/null; then
    start "=> Installing Yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay >/dev/null 2>&1
    (cd /tmp/yay && makepkg -sirc --noconfirm >/dev/null 2>&1)
    finish "=> Yay has been installed."
  else
    echo "=> Yay is already installed."
  fi
}

install_package_manager() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    install_homebrew
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_yay
  fi
}

install_dependencies() {
  start "=> Installing dependencies..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install git chezmoi bitwarden-cli >/dev/null 2>&1
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    yay -S --needed --noconfirm git chezmoi bitwarden-cli zsh >/dev/null 2>&1
  fi

  finish "=> Dependencies have been installed."
}

install_omz() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    start "=> Installing Oh My Zsh..."
    /bin/bash -c "$(curl -fsSL $OMZ_URL)" >/dev/null 2>&1
    finish "=> Oh My Zsh has been installed."
  else
    echo "=> Oh My Zsh is already installed."
  fi
}

unlock_bitwarden_vault() {
  bw login --check >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    export BW_SESSION=$(bw unlock --raw)
  else
    export BW_SESSION=$(bw login --raw)
  fi

  echo "=> Bitwarden vault has been unlocked."
}

###############
# Main script #
###############

setup() {
  echo -e "=> This script will setup kyomi's dotfiles on your system."
  read -n 1 -r -s -p $'=> Press any key to continue or Ctrl+C to abort...\n'

  install_package_manager
  install_dependencies
  install_omz
  unlock_bitwarden_vault

  chezmoi init bitterteriyaki --apply
}

setup
