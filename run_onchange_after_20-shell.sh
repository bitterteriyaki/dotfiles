#!/bin/sh

printf '\033[1;33m=> Setting default shell to zsh\033[0m\n'

if [ "$SHELL" != "$(which zsh)" ]; then
	chsh -s $(which zsh) > /dev/null
fi
