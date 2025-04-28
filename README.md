# `bitterteriyaki/dotfiles`

Howdy! This repository contains my personal dotfiles, which I use to rice my
system and configure tools and applications for my environment in a consistent
way. I currently use [chezmoi](https://www.chezmoi.io) tool to manage my
dotfiles, which allows me to keep my configurations in a single repository and
apply them to different machines with ease.

> [!IMPORTANT]
> This is **not** a community-driven repository. It's a private configuration
> for my particular cases. I make no guarantees that it will work out of the
> bot for anyone. It may also change drastically and without any warning.

## 📚 Table of Contents

- [🏷 Secure Boot](#-secure-boot)
- [📼 BTRFS, Timeshift and GRUB](#-btrfs-timeshift-and-grub)
- [🖥️ Dual boot with Windows](#-dual-boot-with-windows)
- [💻 NVIDIA](#-nvidia)

## 🏷 Secure Boot

> [!NOTE]
> This section is a personal note about enabling Secure Boot on Arch Linux. If
> you are not interested in this topic, you can skip this section, as this
> section is not related to the dotfiles themselves. This also assumes you are
> using Arch Linux as your distro and GRUB as your bootloader.

There is many ways to enable Secure Boot on Arch Linux. This section will show
the most straightforward and simplest way. First of all, you may make use of
CA Keys on GRUB, you can do that by running this following command, assuming
that `/boot` is your EFI system partition (ESP):

```
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
```

Now, you may put the firmware in Setup Mode. This can be achieved by removing
the Platform Key of your firmware. Reboot your machine, access the BIOS and
remove the Platform Key under the "Security" tab. If you ran my automatic
installation scripts, the `sbctl` tool should be already be installed on your
system. If you didn't run my scripts, you can install this tool manually by
running:

```
# yay -S sbctl
```

Once you log back in, check the secure boot status:

```
$ sbctl status
```

You should see that `sbctl` is not installed and Secure Boot is disabled. Now,
create your custom Secure Boot keys and enroll them with Microsoft's keys to
the UEFI:

```
# sbctl create-keys
# sbctl enroll-keys -m
```

Check the secure boot status again:

```
$ sbctl status
```

The `sbctl` should be installed now, but Secure Boot will not work until the
boot files have been signed with the keys you just created. Check what files
need to be signed for secure boot to work:

```
# sbctl verify
```

Verify all the unsigned files with this:

```
# sbctl verify | sed 's/✗ /sbctl sign -s /e'
```

Reboot your system and turn secure boot back on in the firmware settings. If
the boot loader and OS load, secure boot should be working. Check with
`sbctl status`. For more information or troubleshooting, check the references
below.

- [GRUB - ArchWiki](https://wiki.archlinux.org/title/GRUB)
- [Unified Extensible Firmware Interface/Secure Boot - ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot)

## 📼 BTRFS, Timeshift and GRUB

> [!NOTE]
> This section is a personal note about how I use BTRFS, Timeshift and GRUB to
> create snapshots of my system and avoid breaking it after an update. If you
> are not interested in this topic, you can skip this section, as this section
> is not related to the dotfiles themselves. This also assumes you are using
> Arch Linux as your distro and GRUB as your bootloader.

I use BTRFS as my filesystem on my Linux machines, Timeshift to create periodic
snapshots of the system, and `grub-btrfs` to access these snapshots during the
system boot, and `timeshift-autosnap` to create a snapshot every time I update
the system. This way, I can recover deleted or corrupted files and avoid
breaking the system after an update. If you ran my automatic installation
scripts, all these tools should already be installed and the services should be
enabled and running, but you still need to configure `grub-btrfs` to work with
Timeshift. If you didn't run my scripts, you can install these tools by running
the following commands:

```
# yay -S timeshift cronie grub-btrfs timeshift-autosnap inotify-tools
# systemctl enable --now cronie
# systemctl enable --now grub-btrfsd
```

Open Timeshift and configure it to create snapshots of your system. I recommend
creating snapshots every day, but you can choose the frequency that best suits
your needs. After configuring Timeshift, we can configure `grub-btrfs` to work
with Timeshift. By default, `grub-btrfs` looks for snapshots in the
`/.snapshots` directory, however, Timeshift uses a different directory, so we
have to update the daemon configuration. Run the following command to configure
the `grub-btrfs` service:

```
# systemctl edit --full grub-btrfsd
```

Now change the execution command:

```diff
- ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots
+ ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

Save the file, restart the service and update the GRUB configuration:

```
# systemctl restart grub-btrfsd 
# grub-mkconfig -o /boot/grub/grub.cfg
```

Everything should be working now. Try to create a snapshot manually, upgrade
your system or wait for a periodic snapshot to be created to check if
everything is going right. Restart your computer to check if the GRUB menu is
showing the snapshots created by Timeshift during the boot process. For more
information or troubleshooting, check the references below.

- [BTRFS - ArchWiki](https://wiki.archlinux.org/title/btrfs)
- [Timeshift - ArchWiki](https://wiki.archlinux.org/title/timeshift)
- [cron - ArchWiki](https://wiki.archlinux.org/title/cron)
- [`grub-btrfs` repository](https://github.com/Antynea/grub-btrfs)
- [`timeshift-autosnap` repository](https://gitlab.com/gobonja/timeshift-autosnap)
- [An awesome blog post by Lorenzo Bettini](https://www.lorenzobettini.it/2022/07/timeshift-and-grub-btrfs-in-linux-arch/)

# 🖥️ Dual boot with Windows

> [!NOTE]
> This section is a personal note about how I do dual boot with Windows. If you
> are not interested in this topic, you can skip this section, as this section
> is not related to the dotfiles themselves. This also assumes you are using
> Arch Linux as your distro and GRUB as your bootloader.

I usually create an new entry on GRUB to boot on GRUB to boot on Windows
easily. I do not use `os-prober` because it seems to bug a lot when messing
with `timeshift-autosnap`.

To create a new entry on GRUB, you need first get the UUID of the Windows
boot partition. You can do that by running this command:

```
# blkid /dev/sdX
```

Where `X` is the Windows boot partition. After that, edit the file
`/etc/grub.d/40_custom` and add the following entry:

```sh
menuentry 'Windows 11' {
    search --fs-uuid --no-floppy --set=root <UUID>
    chainloader (${root})/EFI/Microsoft/Boot/bootmgfw.efi
}
```

After that, the `Windows 11` entry must be appearing the GRUB screen.

## 💻 NVIDIA

> [!NOTE]
> This section is a personal note about NVIDIA drivers. If you are not
> interested in this topic, you can skip this section, as this section is not
> related to the dotfiles themselves. This also assumes you are using Arch
> Linux as your distro and GRUB as your bootloader.


To use the NVIDIA drivers, edit the `/etc/mkinitcpio.conf` file and do the
following steps:

1. Remove `kms` from `HOOKS` array
2. Add `nvidia`, `nvidia_modeset`, `nvidia_uvm`, `nvidia_drm` to `MODULES`
   array

Exit the file and regenerate the initramfs using:

```
# mkinitcpio -P
```
