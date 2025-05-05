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
  otf-font-awesome
  ttf-dejavu
  ttf-jetbrains-mono-nerd
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
  wezterm
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
  fastfetch
  wl-clipboard
  # Filesystem:
  grub-btrfs
  timeshift-autosnap
  # Look & Feel:
  swww
  rofi
  waybar
  # Hyprland:
  uwsm
  # C/C++ Libraries:
  tk
  gmp
  tree-sitter
  postgresql-libs
  # Drivers:
  nvidia-utils
  # Others:
  xdg-desktop-portal-hyprland
  xdg-user-dirs
  xorg-xhost
  inotify-tools
)

yay -S --needed --noconfirm "${packages[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
