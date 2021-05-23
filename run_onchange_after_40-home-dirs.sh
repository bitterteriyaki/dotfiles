#!/bin/sh

printf '\033[1;33m=> Creating home directories\033[0m\n'

xdg-user-dirs-update > /dev/null
xdg-user-dirs-update --force > /dev/null

mkdir -p $HOME/Projects
