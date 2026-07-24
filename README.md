# WIP - COSMIC DE packages for Debian distribution

**Work in Progress**

This repository contains utils and workflows to build
[COSMIC](https://system76.com/cosmic) desktop environment and Wayland compositor
packages for Debian Linux distribution (current `testing` version `forky/sid`).

- Main GitHub repository of COSMIC DE => https://github.com/pop-os/cosmic-epoch/

---

## Components of COSMIC Desktop

Each component has a `debian` directory in its tree with files to build the
corresponding Debian package.

List of COSMIC components with status:
- local build on Debian testing distribution : OK | NOK
- GitHub job to build component

| COSMIC component                                                                 | Build on Debian testing | GitHub job for build |
|----------------------------------------------------------------------------------|:-----------------------:|:--------------------:|
| [cosmic-applets](https://github.com/pop-os/cosmic-applets)                       | -                       | -                    |
| [cosmic-applibrary](https://github.com/pop-os/cosmic-applibrary)                 | ✅                      | -                    |
| [cosmic-bg](https://github.com/pop-os/cosmic-bg)                                 | ✅                      | -                    |
| [cosmic-comp](https://github.com/pop-os/cosmic-comp)                             | -                       | -                    |
| [cosmic-greeter](https://github.com/pop-os/cosmic-greeter)                       | -                       | -                    |
| [cosmic-icons](https://github.com/pop-os/cosmic-icons)                           | ✅                      | -                    |
| [cosmic-idle](https://github.com/pop-os/cosmic-idle)                             | ✅                      | -                    |
| [cosmic-initial-setup](https://github.com/pop-os/cosmic-initial-setup)           | -                       | -                    |
| [cosmic-launcher](https://github.com/pop-os/cosmic-launcher)                     | ✅                      | -                    |
| [cosmic-monitor](https://github.com/pop-os/cosmic-monitor)                       | ✅                      | -                    |
| [cosmic-notifications](https://github.com/pop-os/cosmic-notifications)           | ✅                      | -                    |
| [cosmic-osd](https://github.com/pop-os/cosmic-osd)                               | -                       | -                    |
| [cosmic-panel](https://github.com/pop-os/cosmic-panel)                           | ✅                      | -                    |
| [cosmic-randr](https://github.com/pop-os/cosmic-randr)                           | ✅                      | -                    |
| [cosmic-screenshot](https://github.com/pop-os/cosmic-screenshot)                 | ✅                      | -                    |
| [cosmic-session](https://github.com/pop-os/cosmic-session)                       | ✅                      | -                    |
| [cosmic-settings](https://github.com/pop-os/cosmic-settings)                     | -                       | -                    |
| [cosmic-settings-daemon](https://github.com/pop-os/cosmic-settings-daemon)       | -                       | -                    |
| [cosmic-sound-theme](https://github.com/pop-os/cosmic-sound-theme/)              | -                       | -                    |
| [cosmic-wallpapers](https://github.com/pop-os/cosmic-wallpapers)                 | ✅                      | -                    |
| [cosmic-workspaces](https://github.com/pop-os/cosmic-workspaces-epoch)           | ✅                      | -                    |
| [pop-launcher](https://github.com/pop-os/launcher)                               | ✅                      | -                    |
| [xdg-desktop-portal-cosmic](https://github.com/pop-os/xdg-desktop-portal-cosmic) | -                       | -                    |

List of [COSMIC Apps](https://system76.com/cosmic/apps)

| COSMIC app                                                | Description       | Build on Debian testing | GitHub job for build |
|-----------------------------------------------------------|-------------------|:-----------------------:|:--------------------:|
| [cosmic-edit](https://github.com/pop-os/cosmic-edit)      | Text Editor       | -                       | -                    |
| [cosmic-files](https://github.com/pop-os/cosmic-files)    | Files Manager     | ✅                      | -                    |
| [cosmic-player](https://github.com/pop-os/cosmic-player)  | Media Player      | -                       | -                    |
| [cosmic-store](https://github.com/pop-os/cosmic-store)    | Apps Store        | ✅                      | -                    |
| [cosmic-term](https://github.com/pop-os/cosmic-term)      | Terminal          | ✅                      | -                    |

Some components require additional dependencies. For exemple, `cosmic-icons`
component needs `pop-icon-theme` package built from [icon-theme repository](https://github.com/pop-os/icon-theme/).

List of additional packages (Depends from COSMIC components)

| Package                                                        | Needed by              | Build on Debian testing | GitHub job for build |
|----------------------------------------------------------------|------------------------|:-----------------------:|:--------------------:|
| [adw-gtk3](https://github.com/pop-os/adw-gtk3)                 | cosmic-settings-daemon | ✅                      | -                    |
| [appstream-data-pop](https://github.com/pop-os/appstream-data) | cosmic-initial-setup<br>cosmic-store   | ✅                      | -                    |
| [libcosmic](https://github.com/pop-os/libcosmic/)              | Most of the components | ✅                      | -                    |
| [pop-fonts](https://github.com/pop-os/fonts)                   | ?                      | ✅                      | -                    |
| [pop-icon-theme](https://github.com/pop-os/icon-theme)         | cosmic-icons           | ✅                      | -                    |
| [pop-sound-theme](https://github.com/pop-os/gtk-theme/)        | cosmic-settings-daemon | ✅                      | -                    |

---

## TODO

- [ ] Build COSMIC components with Rust on local Debian testing
- [ ] Tests COSMIC DE on local Debian testing
- [ ] Add GH workflow to build Debian packages for each COSMIC component
- [ ] Release Debian packages from official COSMIC release/tag
