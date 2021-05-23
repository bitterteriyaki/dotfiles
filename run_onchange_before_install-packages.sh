#!/bin/sh

packages=(
  # Applications:
  firefox
  spotify-launcher
  bitwarden
  pavucontrol
  discord
  # Fonts:
  ttf-dejavu
  ttf-jetbrains-mono-nerd
  noto-fonts
  noto-fonts-emoji
  $(yay -Ssq adobe-source-han-sans)
  # Development Tools:
  openssh
  openvpn
  gnupg
  git
  neovim
  zellij
  mise
  bitwarden-cli
  docker
  docker-compose
  networkmanager
  # Terminal:
  zsh
  zsh-syntax-highlighting
  zsh-autosuggestions
  wezterm
  starship
  # Useful Tools:
  jq
  man
  less
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
  playerctl
  # Look & Feel:
  quickshell
  qt6ct
  # Hyprland:
  uwsm
  hyprmoncfg
  hyprshutdown
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  # C/C++ Libraries:
  tk
  gmp
  tree-sitter
  postgresql-libs
  # Drivers:
  nvidia-utils
  # Others:
  xdg-user-dirs
  inotify-tools
)

printf '\033[1;33m=> Installing packages\033[0m\n'
yay -S --needed --noconfirm "${packages[@]}" > /dev/null

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf '\033[1;33m=> Installing Oh My Zsh\033[0m\n'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null
fi

if [ ! -f "$HOME/.local/bin/claude" ]; then
  printf '\033[1;33m=> Installing Claude Code\033[0m\n'
  curl -fsSL https://claude.ai/install.sh | bash > /dev/null
fi
