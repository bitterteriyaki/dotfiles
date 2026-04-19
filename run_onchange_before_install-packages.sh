#!/bin/sh

packages=(
  # Applications:
  firefox
  webcord 
  spotify-launcher
  timeshift
  # pwvucontrol
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  noto-fonts-emoji
  $(yay -Ssq adone-source-han-sans)
  # Development Tools:
  openssh
  openvpn
  gnupg
  git
  neovim
  zellij
  mise
  bitwarden-cli
  # docker
  # docker-compose
  # sysbox-ce
  networkmanager
  # Terminal:
  wezterm
  zsh
  zsh-syntax-highlighting
  zsh-autosuggestions
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
  unzip
  fzf
  cronie
  sbctl
  fastfetch
  wl-clipboard
  proton-vpn-cli
  # Filesystem:
  timeshift-autosnap
  # Look & Feel:
  quickshell
  # Hyprland:
  uwsm
  hyprmoncfg
  xdg-desktop-portal-hyprland
  # C/C++ Libraries:
  tk
  gmp
  tree-sitter
  postgresql-libs
  # Drivers:
  nvidia-utils
  # Others:
  xdg-user-dirs
  # xorg-xhost
  inotify-tools
)

yay -S --needed --noconfirm "${packages[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -f "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
