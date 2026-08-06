# COSMIC DE for Debian testing distribution

This repository provides Debian Linux packages for
[COSMIC](https://system76.com/cosmic) Desktop Environment. Each release
corresponds to an official COSMIC Epoch release.

These packages are built via GitHub Actions on Debian testing distribution
(current version `forky/sid`).

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

> [!CAUTION]
The `install.sh` script must be executed using `sudo` to allow installation of
Debian packages.

**Download `install.sh` script shell**

```sh
wget https://raw.githubusercontent.com/lcheylus/cosmic-debian/refs/heads/main/install.sh
```

The `install.sh` script shell allows to install all components and apps for
COSMIC DE + addtional packages not available in official APT Debian repository.

- download every `.deb` file for COSMIC components and apps for the latest
release built in this repository.
- checks downloaded COSMIC `.deb` files with SHA256 checksums
- download every `.deb` file for additional packages from this repository.
- checks these downloaded `.deb` files with SHA256 checksums
- install with `apt install` Debian packages needed by COSMIC DE
- install additional packages with `dpkg -i` command.
- install packages for all COSMIC components and apps with `dpkg -i` command.

The `install.sh` script has 2 optional integer variables (0 | 1) that you could
use to set options:
- `INSTALL_APPS`: install COSMIC applications (1 by default).
- `KEEP`: keep downloaded `.deb` files after installation (0 by default => files
are removed after install).

**Run `install.sh` script to install COSMIC DE**

```sh
sudo ./install.sh
```

**Start COSMIC DE**

From your console, run command to start COSMIC DE

```sh
$ start-cosmic
```

**Update previous COSMIC installation**

The `install.sh` script allows also to update a previous COSMIC installation to
the latest release published in this repository. During its execution, it
downloads the latest available version of Debian packages and install them via
`dpkg` command.

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

| Package                                                        | Needed by              |
|----------------------------------------------------------------|------------------------|
| [adw-gtk3](https://github.com/pop-os/adw-gtk3)                 | cosmic-settings-daemon |
| [appstream-data-pop](https://github.com/pop-os/appstream-data) | cosmic-initial-setup<br>cosmic-store   |
| [pop-fonts](https://github.com/pop-os/fonts)                   | cosmic-session         |
| [pop-icon-theme](https://github.com/pop-os/icon-theme)         | cosmic-icons           |
| [pop-sound-theme](https://github.com/pop-os/gtk-theme/)        | cosmic-settings-daemon |

---

## How to publish a new Release

**TODO**

---

## TODO

- [x] Build COSMIC components with Rust on local Debian testing
- [x] Tests COSMIC DE on local Debian testing
- [x] Add GH workflow to build additional packages
- [x] Release additional packages
- [x] Add GH workflow to build Debian packages for all COSMIC apps
- [x] Add GH workflow to build Debian packages for all COSMIC component
- [x] Release Debian packages from official COSMIC release/tag for COSMIC apps and components
- [x] Add shell script to download and install packages for a COSMIC release
- [ ] Publish releases in a Debian repository on GitHub pages
