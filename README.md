# COSMIC DE packages for Debian distribution

[WIP] This repository contains utils and workflows to build
[COSMIC](https://system76.com/cosmic) desktop environment and Wayland compositor
packages for Debian Linux distribution.

- Main GitHub repository of COSMIC DE => https://github.com/pop-os/cosmic-epoch/

---

## Components of COSMIC Desktop

List of COSMIC components with status :
- local build on Debian testing distribution : OK | NOK
- GitHub job to build component

| COSMIC component          | Build on Debian testing | GitHub job for build |
|---------------------------|:-----------------------:|:--------------------:|
| cosmic-applets            | -                       | -                    |
| cosmic-applibrary         | -                       | -                    |
| cosmic-bg                 | -                       | -                    |
| cosmic-comp               | -                       | -                    |
| cosmic-edit               | -                       | -                    |
| cosmic-files              | -                       | -                    |
| cosmic-greeter            | -                       | -                    |
| cosmic-icons              | -                       | -                    |
| cosmic-idle               | -                       | -                    |
| cosmic-initial-setup      | -                       | -                    |
| cosmic-launcher           | -                       | -                    |
| cosmic-monitor            | -                       | -                    |
| cosmic-notifications      | -                       | -                    |
| cosmic-osd                | -                       | -                    |
| cosmic-panel              | -                       | -                    |
| cosmic-player             | -                       | -                    |
| cosmic-randr              | -                       | -                    |
| cosmic-screenshot         | -                       | -                    |
| cosmic-session            | -                       | -                    |
| cosmic-settings           | -                       | -                    |
| cosmic-settings-daemon    | -                       | -                    |
| cosmic-store              | -                       | -                    |
| cosmic-term               | -                       | -                    |
| cosmic-wallpapers         | -                       | -                    |
| cosmic-workspaces-epoch   | -                       | -                    |
| pop-launcher              | -                       | -                    |
| xdg-desktop-portal-cosmic | -                       | -                    |

---

## TODO

- [ ] Build COSMIC components with Rust on local Debian testing
- [ ] Tests COSMIC DE on local Debian testing
- [ ] Add GH workflow to build Debian packages for each COSMIC component
- [ ] Release Debian packages from official COSMIC release/tag
