#!/bin/bash

packages=(
  # Applications:
  firefox
  bitwarden
  obs-studio
  pavucontrol
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  $(yay -Ssq adobe-source-han-sans)
  # Development Tools:
  openssh
  gnupg
  git
  neovim
  bitwarden-cli
  zellij
  # Terminal:
  zsh
  zsh-syntax-highlighting
  zsh-autosuggestions
  wezterm
  starship
  # Look & Feel:
  swww
  eww
  # Others:
  imagemagick
  wl-clipboard
  ripgrep
)

yay -S --needed --noconfirm "${packages[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
