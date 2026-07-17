# COSMIC DE packages for Debian distribution

[WIP] This repository contains utils and workflows to build
[COSMIC](https://system76.com/cosmic) desktop environment and Wayland compositor
packages for Debian Linux distribution.

- Main GitHub repository of COSMIC DE => https://github.com/pop-os/cosmic-epoch/

---

## Components of COSMIC Desktop

List of COSMIC components with status:
- local build on Debian testing distribution : OK | NOK
- GitHub job to build component

Each component has a `debian` directory in its tree with files to build the
corresponding Debian package.

Some components require additional dependencies. For exemple, `cosmic-icons`
component needs `pop-icon-theme` package built from [icon-theme repository](https://github.com/pop-os/icon-theme/).

| COSMIC component                                                                 | Build on Debian testing | GitHub job for build |
|----------------------------------------------------------------------------------|:-----------------------:|:--------------------:|
| [cosmic-applets](https://github.com/pop-os/cosmic-applets)                       | -                       | -                    |
| [cosmic-applibrary](https://github.com/pop-os/cosmic-applibrary)                 | -                       | -                    |
| [cosmic-bg](https://github.com/pop-os/cosmic-bg)                                 | -                       | -                    |
| [cosmic-comp](https://github.com/pop-os/cosmic-comp)                             | -                       | -                    |
| [cosmic-edit](https://github.com/pop-os/cosmic-edit)                             | -                       | -                    |
| [cosmic-files](https://github.com/pop-os/cosmic-files)                           | -                       | -                    |
| [cosmic-greeter](https://github.com/pop-os/cosmic-greeter)                       | -                       | -                    |
| [cosmic-icons](https://github.com/pop-os/cosmic-icons)                           | -                       | -                    |
| [cosmic-idle](https://github.com/pop-os/cosmic-idle)                             | -                       | -                    |
| [cosmic-initial-setup](https://github.com/pop-os/cosmic-initial-setup)           | -                       | -                    |
| [cosmic-launcher](https://github.com/pop-os/cosmic-launcher)                     | -                       | -                    |
| [cosmic-monitor](https://github.com/pop-os/cosmic-monitor)                       | -                       | -                    |
| [cosmic-notifications](https://github.com/pop-os/cosmic-notifications)           | -                       | -                    |
| [cosmic-osd](https://github.com/pop-os/cosmic-osd)                               | -                       | -                    |
| [cosmic-panel](https://github.com/pop-os/cosmic-panel)                           | -                       | -                    |
| [cosmic-player](https://github.com/pop-os/cosmic-player)                         | -                       | -                    |
| [cosmic-randr](https://github.com/pop-os/cosmic-randr)                           | -                       | -                    |
| [cosmic-screenshot](https://github.com/pop-os/cosmic-screenshot)                 | -                       | -                    |
| [cosmic-session](https://github.com/pop-os/cosmic-session)                       | -                       | -                    |
| [cosmic-settings](https://github.com/pop-os/cosmic-settings)                     | -                       | -                    |
| [cosmic-settings-daemon](https://github.com/pop-os/cosmic-settings-daemon)       | -                       | -                    |
| [cosmic-store](https://github.com/pop-os/cosmic-store)                           | -                       | -                    |
| [cosmic-term](https://github.com/pop-os/cosmic-term)                             | -                       | -                    |
| [cosmic-wallpapers](https://github.com/pop-os/cosmic-wallpapers)                 | -                       | -                    |
| [cosmic-workspaces-epoch](https://github.com/pop-os/cosmic-workspaces-epoch)     | -                       | -                    |
| [pop-launcher](https://github.com/pop-os/pop-launcher)                           | -                       | -                    |
| [xdg-desktop-portal-cosmic](https://github.com/pop-os/xdg-desktop-portal-cosmic) | -                       | -                    |

---

## TODO

- [ ] Build COSMIC components with Rust on local Debian testing
- [ ] Tests COSMIC DE on local Debian testing
- [ ] Add GH workflow to build Debian packages for each COSMIC component
- [ ] Release Debian packages from official COSMIC release/tag
