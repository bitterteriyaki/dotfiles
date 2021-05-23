#!/bin/sh

printf '\033[1;33m=> Enabling dark color-scheme for GTK apps\033[0m\n'

sudo mkdir -p /etc/dconf/profile /etc/dconf/db/local.d

sudo tee /etc/dconf/profile/user > /dev/null << 'EOF'
user-db:user
system-db:local
EOF

sudo tee /etc/dconf/db/local.d/00-dark-theme > /dev/null << 'EOF'
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
EOF

sudo dconf update > /dev/null
