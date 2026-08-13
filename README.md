# COSMIC DE for Debian testing distribution

[![Debian testing badge](https://img.shields.io/badge/Debian-testing-green?style=for-the-badge)](https://www.debian.org/devel/testing) ![APT Repository badge](https://img.shields.io/badge/APT-Repository-green?style=for-the-badge) [![Badge for COSMIC release version](https://shields.io/endpoint?url=https://gist.githubusercontent.com/lcheylus/6709cbe37e469a749fd3e179dd03c0db/raw/cosmic-badge.json&style=for-the-badge)](https://github.com/pop-os/cosmic-epoch/)

This repository provides Debian Linux packages for the full
[COSMIC](https://system76.com/cosmic) Desktop Environment. Each release
corresponds to an official COSMIC Epoch release.

These packages are built via GitHub Actions on Debian **testing** distribution
(current version `forky/sid`) for **amd64** architecture only. They probably
also work on unstable distribution (**not tested**).

Main GitHub repository of COSMIC DE https://github.com/pop-os/cosmic-epoch/

---

## Installation

> [!IMPORTANT]
Backup your system before installing COSMIC using this repository. Or install it
on a disposable Debian testing installation used for conducting tests.

By default, a display manager (LightDM, GDM, SDDM...) is configured and invoked
to start an X11 or Wayland session. To disable it and log-in in console using
your username and password, run the commands below.

```sh
sudo systemctl set-default multi-user.target
```

Reboot again and Debian boots to console mode.

**Note** If you want to undo this change and get your Debian system to boot to
the default graphical mode use the terminal command below.

```sh
sudo systemctl set-default graphical.target
```

### Download `install.sh` script shell

```sh
$ wget https://raw.githubusercontent.com/lcheylus/cosmic-debian/refs/heads/main/install.sh

$ chmod +x install.sh
```

The `install.sh` script shell allows to install all components and apps for
COSMIC DE + additional packages not available in official APT Debian repository:

- download every `.deb` file for COSMIC components and apps from the latest
release available in this repository
- checks downloaded COSMIC `.deb` files with SHA256 checksums
- download every `.deb` file for additional packages from this repository
- checks these downloaded `.deb` files with SHA256 checksums
- install Debian packages needed by COSMIC DE with `apt install`
- install additional packages with `dpkg -i` command.
- install packages for all COSMIC components and apps with `dpkg -i` command.

The `install.sh` script has 2 optional integer variables (value = 0 or 1) that
you could use to set options:
- `INSTALL_APPS`: install COSMIC applications (1 by default).
- `KEEP`: keep downloaded `.deb` files after installation (0 by default => files
are removed after install).

### Run `install.sh` script to install COSMIC DE

> [!CAUTION]
The `install.sh` script must be executed using `sudo` to allow installation of
Debian packages.

```sh
sudo ./install.sh
```

### Start COSMIC DE

From your console, run command to start COSMIC DE:

```sh
$ start-cosmic
```

### Update previous COSMIC installation

The `install.sh` script allows also to update a previous COSMIC installation to
the latest release published in this repository. During its execution, it
downloads the latest available version of Debian packages and install them via
`dpkg` command.

---

## Use COSMIC Greeter

COSMIC Greeter, installed with the `cosmic-greeter` and `cosmic-greeter-daemon`
packages, is the login manager of COSMIC DE.

During the installation, it registers itself as the system display manager via
`debconf` as other ones (GDM, LightDM...). If another DM is already registered,
you get the standard "Default display manager" prompt to choose between them.

You can switch to COSMIC Greeter later, via `sudo dpkg-reconfigure cosmic-greeter` command.

If you configure your system to have a text console after boot (`systemctl
get-default` returns `multi-user.target`), COSMIC Greeter is not started by
default. To enable it:

```sh
$ sudo systemctl set-default graphical.target
```

Then reboot your system and COSMIC Greeter will start after boot, login with
user/password and you COSMIC session starts.

---

## Components of COSMIC Desktop

Each component has a `debian` directory in its sources tree with files to build
the corresponding Debian package.

List of all components necessary to install COSMIC Desktop Environment:

- [cosmic-applets](https://github.com/pop-os/cosmic-applets) - COSMIC Applets
- [cosmic-app-library](https://github.com/pop-os/cosmic-applibrary) - COSMIC App Library
- [cosmic-bg](https://github.com/pop-os/cosmic-bg) - COSMIC Background
- [cosmic-comp](https://github.com/pop-os/cosmic-comp) - Wayland compositor for COSMIC
- [cosmic-greeter](https://github.com/pop-os/cosmic-greeter) - COSMIC Greeter and daemon
- [cosmic-icons](https://github.com/pop-os/cosmic-icons) - COSMIC Icons
- [cosmic-idle](https://github.com/pop-os/cosmic-idle) - COSMIC idle daemon
- [cosmic-initial-setup](https://github.com/pop-os/cosmic-initial-setup) - COSMIC Initial Setup
- [cosmic-launcher](https://github.com/pop-os/cosmic-launcher) - COSMIC Launcher
- [cosmic-notifications](https://github.com/pop-os/cosmic-notifications) - COSMIC Notifications
- [cosmic-osd](https://github.com/pop-os/cosmic-osd) - COSMIC OSD
- [cosmic-panel](https://github.com/pop-os/cosmic-panel) - XDG Shell Wrapper Panel for COSMIC
- [cosmic-randr](https://github.com/pop-os/cosmic-randr) - Display and configure Wayland display outputs
- [cosmic-screenshot](https://github.com/pop-os/cosmic-screenshot) - COSMIC Screenshot Utility
- [cosmic-session](https://github.com/pop-os/cosmic-session) - The session for the COSMIC desktop
- [cosmic-settings](https://github.com/pop-os/cosmic-settings) - Settings application for the COSMIC desktop environment
- [cosmic-settings-daemon](https://github.com/pop-os/cosmic-settings-daemon) - COSMIC settings daemon
- [cosmic-wallpapers](https://github.com/pop-os/cosmic-wallpapers) - COSMIC Wallpapers
- [cosmic-workspaces](https://github.com/pop-os/cosmic-workspaces-epoch) - COSMIC Workspaces
- [pop-launcher](https://github.com/pop-os/launcher) - Modular IPC-based desktop launcher service
- [xdg-desktop-portal-cosmic](https://github.com/pop-os/xdg-desktop-portal-cosmic) - COSMIC backend for xdg-desktop-portal

[cosmic-sound-theme](https://github.com/pop-os/cosmic-sound-theme/) is not
needed to install COSMIC DE and is not packaged.

List of [COSMIC Apps](https://system76.com/cosmic/apps), also available as
Debian package but installation is optional.

- [cosmic-edit](https://github.com/pop-os/cosmic-edit) - Text Editor
- [cosmic-files](https://github.com/pop-os/cosmic-files) - Files Manager
- [cosmic-monitor](https://github.com/pop-os/cosmic-monitor) - System Monitor
- [cosmic-player](https://github.com/pop-os/cosmic-player) -  Media Player
- [cosmic-store](https://github.com/pop-os/cosmic-store) - Apps Store
- [cosmic-term](https://github.com/pop-os/cosmic-term) -  Terminal

Some components require additional dependencies. For example, `cosmic-icons`
component needs `pop-icon-theme` package built from [icon-theme repository](https://github.com/pop-os/icon-theme/).

List of additional packages: "Depends" to install COSMIC components/apps not
available as official Debian packages.

| Package                                                        | Description                     | Needed by              |
|----------------------------------------------------------------|---------------------------------|------------------------|
| [adw-gtk3](https://github.com/pop-os/adw-gtk3)                 | libadwaita theme ported to GTK3 | cosmic-settings-daemon |
| [appstream-data-pop](https://github.com/pop-os/appstream-data) | AppStream data for Pop!_OS      | cosmic-initial-setup<br>cosmic-store   |
| [pop-fonts](https://github.com/pop-os/fonts)                   | Pop fonts                       | cosmic-session         |
| [pop-icon-theme](https://github.com/pop-os/icon-theme)         | Pop icons                       | cosmic-icons           |
| [pop-sound-theme](https://github.com/pop-os/gtk-theme/)        | Pop sound theme                 | cosmic-settings-daemon |

---

## How to publish a new Release

To publish a new release corresponding to a COSMIC Epoch release:

- update `VERSION` variable in "Build COSMIC apps" and "Build COSMIC components"
workflows and commit them
- run manually these both workflows
- if everything is OK, create a new tag `a.b.c` corresponding to the COSMIC
Epoch release `epoch-a.b.c`
- push tag via `git push --tags` command
- the "Publish COSMIC release" will start automatically, build Debian packages
and publish a new release
- after the publication of a new release, update APT Repository by running
manually the workflow "Update COSMIC APT repository".
