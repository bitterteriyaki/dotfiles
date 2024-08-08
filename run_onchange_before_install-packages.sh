#!/bin/sh

#
# List of packages to install
#
packages=(
  # Applications:
  discord
  google-chrome
  spotify-launcher
  timeshift
  httpie-desktop-bin
  flameshot
  bitwarden
  teams
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  $(yay -Ssq adobe-source-han-sans)
  # Tools:
  git
  chezmoi
  bitwarden-cli
  asdf-vm
  openssh
  gnupg
  jq
  neovim
  tk
  fzf
  zsh-syntax-highlighting
  zsh-autosuggestions
  cronie
  inotify-tools
  starship
  bat
  eza
  tokei
  zoxide
  fd
  ripgrep
  docker
  wezterm
  # Filesystem:
  grub-btrfs
  timeshift-autosnap
)

yay -S --needed --noconfirm "${packages[@]}"

#
# Install Oh My Zsh
#
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
