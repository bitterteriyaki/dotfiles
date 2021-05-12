#!/bin/sh

# Setup `hyprshutdown`

echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/chvt" | sudo tee /etc/sudoers.d/chvt
sudo chmod 440 /etc/sudoers.d/chvt
