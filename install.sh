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

#############
# Variables #
#############

HB_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
YAY_URL="https://aur.archlinux.org/yay.git"

########################
# Installation scripts #
########################

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    echo -n "=> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL $HB_URL)"
    echo -e "=> Homebrew has been installed."
  else
    echo "=> Homebrew is already installed."
  fi
}

install_yay() {
  if ! command -v yay &> /dev/null; then
    echo -n "=> Installing Yay..."
    git clone $YAY_URL /tmp/yay >/dev/null 2>&1
    (cd /tmp/yay && makepkg -sirc --noconfirm >/dev/null 2>&1)
    echo -e "\r=> Yay has been installed."
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
  echo -n "=> Installing dependencies..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "=> Not implemented yet."
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    yay -S --needed --noconfirm git chezmoi bitwarden-cli >/dev/null 2>&1
  fi

  echo -e "\r\e[K=> Dependencies have been installed."
}

###############
# Main script #
###############

setup() {
  echo -e "=> This script will setup kyomi's dotfiles on your system."
  read -n 1 -r -s -p $'=> Press any key to continue or Ctrl+C to abort...\n'

  install_package_manager
  install_dependencies
}

setup
