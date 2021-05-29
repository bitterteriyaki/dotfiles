#!/bin/sh

printf '\033[1;33m=> Enabling and starting services\033[0m\n'

systemctl --user enable --now hyprmoncfgd

sudo systemctl enable --now cronie
sudo systemctl enable --now docker
sudo systemctl enable --now NetworkManager
