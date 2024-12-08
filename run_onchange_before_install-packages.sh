#!/bin/bash

packages=(
  # Applications:
  firefox
  bitwarden
  obs-studio
  pavucontrol
  spotify-launcher
  discord
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  inter-font
  $(yay -Ssq adobe-source-han-sans)
  # Development Tools:
  openssh
  gnupg
  git
  neovim
  bitwarden-cli
  zellij
  mise
  # Terminal:
  zsh
  zsh-syntax-highlighting
  zsh-autosuggestions
  wezterm
  starship
  # Look & feel:
  swww
  eww
  # Useful tools:
  jq
  man
  zoxide
  ripgrep
  # Others:
  imagemagick
  wl-clipboard
  tree-sitter
  xdg-user-dirs
)

yay -S --needed --noconfirm "${packages[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
