#!/bin/sh

# Enable Num Lock on the SDDM login screen

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/numlock.conf > /dev/null << 'EOF'
[General]
Numlock=on
EOF
