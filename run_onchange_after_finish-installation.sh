#!/bin/sh

#
# Import GPG keys
#
export GPG_TTY=$(tty)

echo "{{ (bitwarden "item" "gpg_public_key").notes }}" | gpg --import -
echo "{{ (bitwarden "item" "gpg_private_key").notes }}" | gpg --import -

#
# Change the default shell to Zsh
#
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s $(which zsh)
fi

#
# Enable and start some important services
#
sudo systemctl enable --now docker
sudo systemctl enable --now grub-btrfsd
sudo systemctl enable --now cronie

#
# Add the current user to `docker` group
#
sudo usermod -aG docker $USER

#
# Disable Copy-on-Write for some directories to decrease the disk usage
#
sudo chattr +C /var/log
sudo chattr +C /var/lib/docker
sudo chattr +C /var/cache/pacman/pkg

#
# Create the `Projects` directory
#
mkdir -p $HOME/Projects
