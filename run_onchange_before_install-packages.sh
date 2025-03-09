#!/bin/bash

packages=(
  # Applications:
  firefox
  bitwarden
  obs-studio
  pavucontrol
  discord
  spotify-launcher
  timeshift
  grub-customizer
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  inter-font
  noto-fonts-emoji
  $(yay -Ssq adobe-source-han-sans)
  # Development Tools:
  openssh
  gnupg
  git
  neovim
  bitwarden-cli
  zellij
  mise
  docker
  docker-compose
  sysbox-ce
  # Terminal:
  zsh
  zsh-syntax-highlighting
  zsh-autosuggestions
  alacritty
  starship
  # Useful Tools:
  jq
  man
  zoxide
  bat
  eza
  tokei
  fd
  ripgrep
  imagemagick
  unzip
  fzf
  cronie
  sbctl
  playerctl
  postgresql-libs
  fastfetch
  unzip
  # Filesystem:
  grub-btrfs
  timeshift-autosnap
  # Look & Feel:
  swww
  eww
  rofi
  # Others:
  tk
  wl-clipboard
  tree-sitter
  xdg-user-dirs
  inotify-tools
  socat
  pipewire
  wireplumber
  xdg-desktop-portal-hyprland
)

yay -S --needed --noconfirm "${packages[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
