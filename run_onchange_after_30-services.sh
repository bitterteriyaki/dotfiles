#!/bin/sh

printf '\033[1;33m=> Enabling and starting services\033[0m\n'

systemctl --user enable --now hyprmoncfgd > /dev/null

sudo systemctl enable --now cronie > /dev/null
sudo systemctl enable --now docker > /dev/null
sudo systemctl enable --now NetworkManager > /dev/null
