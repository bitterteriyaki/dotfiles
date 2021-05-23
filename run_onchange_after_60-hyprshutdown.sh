#!/bin/sh

printf '\033[1;33m=> Setting up hyprshutdown sudoers rule\033[0m\n'

echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/chvt" | sudo tee /etc/sudoers.d/chvt > /dev/null
sudo chmod 440 /etc/sudoers.d/chvt
