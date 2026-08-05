# COSMIC DE for Debian testing distribution

This repository contains workflows to build
[COSMIC](https://system76.com/cosmic) Desktop Environment packages for Debian
Linux distribution (current `testing` version `forky/sid`).

Main GitHub repository of COSMIC DE => https://github.com/pop-os/cosmic-epoch/

---

## Installation

> [!IMPORTANT]
Backup your system before installing COSMIC using this repository. Or install it
on a disposable Debian testing installation used for conducting tests.

> [!CAUTION]
The `install.sh` script must be executed using `sudo` to allow installation of
Debian packages.

---

## Components of COSMIC Desktop

Each component has a `debian` directory in its tree with files to build the
corresponding Debian package.

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

## TODO

- [x] Build COSMIC components with Rust on local Debian testing
- [x] Tests COSMIC DE on local Debian testing
- [x] Add GH workflow to build additional packages
- [x] Release additional packages
- [x] Add GH workflow to build Debian packages for all COSMIC apps
- [x] Add GH workflow to build Debian packages for all COSMIC component
- [x] Release Debian packages from official COSMIC release/tag for COSMIC apps and components
- [ ] Add shell script to download and install packages for a COSMIC release
- [ ] Publish releases in a Debian repository on GitHub pages
