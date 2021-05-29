#!/bin/sh

printf '\033[1;33m=> Creating home directories\033[0m\n'

xdg-user-dirs-update
xdg-user-dirs-update --force

mkdir -p $HOME/Projects
