# How to publish a new Release

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
