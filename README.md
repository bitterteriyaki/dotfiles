# `dotfiles/bitterteriyaki`

## Bitwarden Vault

I use [Bitwarden](https://bitwarden.com/) to store my passwords and other
sensitive information. This guide assumes that you have a Bitwarden account
and that you have the following items in your vault:

- `public_ssh`: your public SSH key
- `private_ssh`: your private SSH key
- `public_gpg`: your public GPG key
- `private_gpg`: your private GPG key
- `wakatime_key`: a [WakaTime](https://wakatime.com/) API key
- `openweather_api_key`: a [OpenWeather](https://openweathermap.org/) API key

You can put these items in any folder you want.

## Installing

This guide assumes that you are using Arch Linux **or** macOS Big Sur. If you
don't use either of these, you can still use the dotfiles, but you will need to
install the dependencies manually.

To install the dotfiles, you need to have [Chezmoi](https://chezmoi.io/)
installed in your system. Check the documentation for instructions on how to
install it.

Once you have Chezmoi installed, run the `install.sh` script to setup the
dependencies and install the dotfiles:

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
poetry run pre-commit install --hook-type commit-msg
```

And that's it! Now, whenever you commit a change, the hooks will run and
automatically format your code and check for any errors.
