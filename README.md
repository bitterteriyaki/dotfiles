# `dotfiles/bitterteriyaki`

## Installing

This guide assumes that you are using Arch Linux **or** macOS Big Sur. If you
don't use either of these, you can still use the dotfiles, but you will need to
install the dependencies manually.

To install the dotfiles, you need to have [Chezmoi](https://chezmoi.io/)
installed in your system. Check the documentation for instructions on how to
install it.

Once you have Chezmoi installed, run the `install.sh` script to setup some
dependencies:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bitterteriyaki/dotfiles/HEAD/install.sh)"
```

## Developing

When developing for this repository, you can install Git hooks to ease your
development. For that, you need to have [Poetry](https://python-poetry.org/)
(1.4.2 or earlier) installed in your system.

You can install the Git hooks by running the following commands:

```sh
poetry install
poetry run pre-commit install
```

And that's it! Now, whenever you commit a change, the hooks will run and
automatically format your code and check for any errors.
