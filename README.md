# `bitterteriyaki/dotfiles`

This my personal dotfiles, where I store my personal configurations files for
some tools that I use in my development environment. I created this repository
to maintain consistency between the different machines I have.

> [!WARNING]
> This is **not** a community-driven repository. It's a private configuration
> for my particular cases. I make no guarantees that it will work out of the
> box for anyone. It may also change drastically and without any warning.

## 🚀 Features

### 🎏 Aliases

To speed up development, I added aliases for commands that I use frequently. I
will be listing some (not all) in this section.

#### 🌎 Global

| **Alias** | **Command**                  |
|-----------|------------------------------|
| `ls`      | `eza --icons`                |
| `cat`     | `bat`                        |
| `vim`     | `nvim`                       |
| `bbal`    | `sudo btrfs balance start /` |
| `bdf`     | `sudo btrfs filesystem df /` |

## 🔨 Installation

> [!CAUTION]
> If you want to give my dotiles a try, you should first fork this repository,
> review the code, and remove things you don't want or need. Do not bindly use
> my settings unless you know what that entails. Use at your own risk.

Some dependencies are required to install dotfiles on your machine. If you,
like me, are using Arch Linux as your distro, you can run the following
command to install the necessary dependencies:

```sh
$ yay -S chezmoi
```

## 📼 BTRFS, Timeshift and GRUB

I use BTRFS as my filesystem on my Linux machines. This filesystem supports the
creation of block-level snapshots, allowing the recovery of deleted or
corrupted files. Along with BTRFS, I use Timeshift to create periodic snapshots
of the system, I recommend that you create at least 5 snapshots per hour, as
these snapshots are relatively lightweight, as they do not copy the files
themselves, but only their metadata.

If you ran my automatic installation scripts, Timeshift and cron (needed to
create snapshots in background) should already be installed, and the cron
service should already be enabled and running. If you haven't already performed
this step, you can run the following commands to configure the environment:

```sh
$ yay -S timeshift cronie
$ sudo systemctl enable --now cronie
```

Now that we have Timeshift configured, we can use `grub-btrfs` to access these
snapshots during the system boot, in the bootloader. We can also install
`timeshift-autosnap` so that a snapshot is created every time we update the
system using `yay -Syu`, this way we avoid the danger of the system breaking
after an update. These two packages should already be installed if you ran my
automatic installation scripts, but if that's not the case, run the following
two commands to install them:

```sh
$ yay -S grub-btrfs timeshift-autosnap inotify-tools
$ sudo systemctl enable --now grub-btrfsd
```

By default, `grub-btrfs` looks for snapshots in the `/.snapshots` directory,
however, Timeshift uses a different directory, so we have to update the daemon
configuration. Run the following command to configure the `grub-btrfs` service:

```sh
$ sudo systemctl edit --full grub-btrfsd
```

Now change the execution command:

```diff
- ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots
+ ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

You may want to restart the `grub-btrfs` service and regenerate the GRUB
configuration:

```sh
$ sudo systemctl restart grub-btrfsd 
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Everything should be working now. Try to create a snapshot manually or upgrade
your system and restart your computer to check if everything is going right.
For more informations or help, see the documentation of each package mentioned
above.

- [BTRFS - Arch Wiki](https://wiki.archlinux.org/title/btrfs)
- [Timeshift - Arch Wiki](https://wiki.archlinux.org/title/timeshift)
- [cron - Arch Wiki](https://wiki.archlinux.org/title/cron)
- [`grub-btrfs`](https://github.com/Antynea/grub-btrfs)
- [`timeshift-autosnap`](https://gitlab.com/gobonja/timeshift-autosnap)
- [This awesome blog post by Lorenzo Bettini](https://www.lorenzobettini.it/2022/07/timeshift-and-grub-btrfs-in-linux-arch/)
