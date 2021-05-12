#!/bin/sh

# Enable and start services

systemctl --user enable --now hyprmoncfgd

sudo systemctl enable --now cronie
sudo systemctl enable --now docker
sudo systemctl enable --now NetworkManager
