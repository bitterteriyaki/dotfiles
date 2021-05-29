#!/bin/sh

printf '\033[1;33m=> Enabling Num Lock on the SDDM login screen\033[0m\n'

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/numlock.conf << 'EOF'
[General]
Numlock=on
EOF
