# `bitterteriyaki/dotfiles`

Howdy! This repository contains my personal dotfiles, which I use to configure
tools and applications for my environment in a consistent way. I use the
[Chezmoi](https://www.chezmoi.io/) tool to manage my dotfiles, which allows me
to keep my configurations in a single repository and apply them to different
machines with ease.

> [!IMPORTANT]
> This is **not** a community-driven repository. It's a private configuration
> for my particular cases. I make no guarantees that it will work out of the
> box for anyone. It may also change drastically and without any warning.

## 📚 Table of Contents

- [🚀 Features](#-features)
  - [💻 System](#-system)
  - [🔨 Alternative Tools](#-alternative-tools)
  - [🎏 Aliases](#-aliases)
- [📦 Dependencies](#-dependencies)
- [🔒 Secrets Management](#-secrets-management)
- [🔨 Installation](#-installation)
- [📼 BTRFS, Timeshift and GRUB](#-btrfs-timeshift-and-grub)

## 🚀 Features

### 💻 System

| **Feature**             | **Description** |
|-------------------------|-----------------|
| **Shell**               | Zsh             |
| **Plugin Manager**      | Oh My Zsh       |
| **Prompt**              | Starship        |
| **Terminal**            | Wezterm         |
| **Editor**              | Neovim          |
| **Browser**             | Google Chrome   |
| **Desktop Environment** | GNOME           |

### 🔨 Alternative Tools

I use some alternative unix commands that are more lightweight and have a
better performance than the most common ones. Here are some examples:

| **Tool** | **Alternative**                                    |
|----------|----------------------------------------------------|
| `cd`     | [`zoxide`](https://github.com/ajeetdsouza/zoxide)  |
| `ls`     | [`eza`](https://github.com/eza-community/eza)      |
| `cat`    | [`bat`](https://github.com/sharkdp/bat)            |
| `find`   | [`fd`](https://github.com/sharkdp/fd)              |
| `grep`   | [`ripgrep`](https://github.com/BurntSushi/ripgrep) |

### 🎏 Aliases

To speed up my workflow, I use some aliases to run commands more quickly. Some
of them are defined in the `.zshrc` file, and others are define by plugins on
Oh My Zsh. Here are some examples:

#### 🌎 Global Aliases

| **Alias** | **Command**                |
|-----------|----------------------------|
| `cd`      | `z` (`zoxide`)             |
| `ls`      | `eza --icons`              |
| `cat`     | `bat`                      |
| `find`    | `fd`                       |
| `grep`    | `rg`                       |
| `vim`     | `nvim`                     |
| `bbal`    | `sudo btrfs balance start` |
| `bdf`     | `sudo btrfs filesystem df` |

## 📦 Dependencies

Some dependencies are required to install my dotfiles. You can install them by
running the following command (assuming you are using Arch Linux):

```sh
$ yay -S git chezmoi bitwarden-cli
```

## 🔒 Secrets Management

This repository has some secrets that are stored in a Bitwarden vault, such as
SSH keys, GPG keys, API tokens, and other sensitive information. Some vault
items are required to install the dotfiles, otherwise, the installation will
fail. The following vault items are required:

| **Secret**        | **Description**        |
|-------------------|------------------------|
| `ssh_public_key`  | Your SSH public key.   |
| `ssh_private_key` | Your SSH private key.  |
| `gpg_public_key`  | Your GPG public key.   |
| `gpg_private_key` | Your GPG private key.  |
| `wakatime_key`    | Your WakaTime API key. |

```sh
$ bw login
$ export BW_SESSION=$(bw unlock --raw)
```

## 🔨 Installation

> [!CAUTION]
> If you want to give my dotfiles a try, you should first fork this repository,
> review the code, and remove things you don't want or need. Do not bindly use
> my settings unless you know what that entails, use at your own risk. This
> also assumes you are using Arch Linux as your distro.

After installing the dependencies and setting up the Bitwarden vault, you can
install my dotfiles by running the following command:

```sh
$ chezmoi init bitterteriyaki --apply
```

This command will clone this repository to your machine and apply the
configurations to your system. If you want to update the configurations, you
can run the following command:

```sh
$ chezmoi update
```

This command will pull the latest changes from this repository and apply them
to your system.

## 📼 BTRFS, Timeshift and GRUB

> [!NOTE]
> This section is a personal note about how I use BTRFS, Timeshift and GRUB to
> create snapshots of my system and avoid breaking it after an update. If you
> are not interested in this topic, you can skip this section, as this section
> is not related to the dotfiles themselves. This also assumes you are using
> Arch Linux as your distro.

I use BTRFS as my filesystem on my Linux machines, Timeshift to create periodic
snapshots of the system, and `grub-btrfs` to access these snapshots during the
system boot, and `timeshift-autosnap` to create a snapshot every time I update
the system using `yay -Syu`. This way, I can recover deleted or corrupted files
and avoid breaking the system after an update. If you ran my automatic
installation scripts, all these tools should already be installed and the
services should be enabled and running, but you still need to configure
`grub-btrfs` to work with Timeshift. If you didn't run my scripts, you can
install these tools by running the following commands:

```sh
$ yay -S timeshift cronie grub-btrfs timeshift-autosnap inotify-tools
$ sudo systemctl enable --now cronie
$ sudo systemctl enable --now grub-btrfsd
```

Open Timeshift and configure it to create snapshots of your system. I recommend
creating snapshots every day, but you can choose the frequency that best suits
your needs. After configuring Timeshift, we can configure `grub-btrfs` to work
with Timeshift. By default, `grub-btrfs` looks for snapshots in the
`/.snapshots` directory, however, Timeshift uses a different directory, so we
have to update the daemon configuration. Run the following command to configure
the `grub-btrfs` service:

```sh
$ sudo systemctl edit --full grub-btrfsd
```

Now change the execution command:

```diff
- ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots
+ ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

Save the file, restart the service and update the GRUB configuration:

```sh
$ sudo systemctl restart grub-btrfsd 
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Everything should be working now. Try to create a snapshot manually, upgrade
your system or wait for a periodic snapshot to be created to check if
everything is going right. Restart your computer to check if the GRUB menu is
showing the snapshots created by Timeshift during the boot process. For more
information or troubleshooting, check the references below.

- [BTRFS - Arch Wiki](https://wiki.archlinux.org/title/btrfs)
- [Timeshift - Arch Wiki](https://wiki.archlinux.org/title/timeshift)
- [cron - Arch Wiki](https://wiki.archlinux.org/title/cron)
- [`grub-btrfs` repository](https://github.com/Antynea/grub-btrfs)
- [`timeshift-autosnap` repository](https://gitlab.com/gobonja/timeshift-autosnap)
- [An awesome blog post by Lorenzo Bettini](https://www.lorenzobettini.it/2022/07/timeshift-and-grub-btrfs-in-linux-arch/)
