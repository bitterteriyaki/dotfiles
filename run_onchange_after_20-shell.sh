#!/bin/sh

# Change the default shell

if [ "$SHELL" != "$(which zsh)" ]; then
	chsh -s $(which zsh)
fi
