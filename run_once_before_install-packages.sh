#!/bin/sh

yay -S --nocleanmenu --nodiffmenu --noupgrademenu --removemake --mflags "--noconfirm" \
    i3 xorg ttf-dejavu alacritty lightdm lightdm-gtk-greeter chezmoi asdf-vm \
    bitwarden-cli discord google-chrome exa bat noto-fonts-emoji \
    visual-studio-code-bin dunst polybar picom $(pacman -Ssq adobe-source-han-sans) \
    nerd-fonts-jetbrains-mono feh htop zsh network-manager-applet dmenu rofi \
    pulseaudio pavucontrol flameshot gnome-keyring xdg-user-dirs
    # This following package is broken and does not work install by Yay:
    # spotify
