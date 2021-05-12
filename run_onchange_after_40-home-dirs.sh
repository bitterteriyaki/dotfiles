#!/bin/sh

# Create home directories

xdg-user-dirs-update
xdg-user-dirs-update --force

mkdir -p $HOME/Projects
