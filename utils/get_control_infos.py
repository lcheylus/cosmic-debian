#!/usr/bin/env python
#
# Tool to get debian/control file for every COSMIC component
# and get infos (name, description, depends...) for build/installation
#

import os
import re
import requests
import sys

from deb_parser import Parser

# Codes for colors in terminal
RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"

# COSMIC version
# VERSION='master'  # Branch = master
VERSION = 'epoch-1.4.0'  # Tag = epoch-1.4.0

COSMIC_COMPONENTS = [
    "cosmic-applets",
    "cosmic-applibrary",
    "cosmic-bg",
    "cosmic-comp",
    "cosmic-greeter",
    "cosmic-icons",
    "cosmic-idle",
    "cosmic-initial-setup",
    "cosmic-launcher",
    "cosmic-monitor",
    "cosmic-notifications",
    "cosmic-osd",
    "cosmic-panel",
    "cosmic-randr",
    "cosmic-screenshot",
    "cosmic-session",
    "cosmic-settings",
    "cosmic-settings-daemon",
    "cosmic-wallpapers",
    "cosmic-workspaces-epoch",
    "pop-launcher",
    "xdg-desktop-portal-cosmic",
]

COSMIC_APPS = ["cosmic-edit", "cosmic-files", "cosmic-player", "cosmic-store", "cosmic-term"]

# Headers for GitHub API request
# See https://docs.github.com/en/rest/repos/contents?apiVersion=2026-03-10
GH_HEADERS = {
    'Accept': 'application/vnd.github.raw+json',
    'X-GitHub-Api-Version': '2026-03-10',
    'User-Agent': 'lcheylus-COSMIC-debian',
}


def load_gh_token() -> str:
    """Load GitHub personnal access token from secrets.txt file."""
    dirname = os.path.dirname(os.path.realpath(__file__))

    try:
        file = open(dirname + '/secrets.txt', 'r')
    except FileNotFoundError:
        print(f"{RED}[ERROR]{RESET} unable to read {dirname}/secrets.txt file")
        return None

    for line in file:
        if line.startswith('#'):
            continue
        if not line.startswith('github_pat_'):
            print(f"{RED}[ERROR]{RESET} unable to find GitHub token in {dirname}/secrets.txt file")
            return None
        else:
            return line.strip()


def parse_depends(depends: str) -> list:
    """
    Parse Depends/Build-Depends field.
    Returns a list of depends.
    """
    # Multilines 'Build-Depends/Depends' field
    if '\n' in depends:
        tmp_depends = depends.splitlines()
        ret = list()
        for dep in tmp_depends:
            ret.append(dep.strip(' ,'))

        return ret
    else:
        # Convert depends to list
        return [dep.strip() for dep in depends.split(',')]


# Class for infos parsed from debian/control file for a COSMIC component
class Component:
    def __init__(self):
        self.name = ''
        self.source_name = ''
        self.build_depends = list()
        self.packages = list()
        self.depends = list()

    def parse_control(self, content: str):
        """
        Parse debian/control file.
        Get source/package name(s), description and build-depends/depends.
        """
        parser = Parser(content)

        for entry in parser.raw_pkg_info:
            if entry['name'] != self.name:
                print(f"{BLUE}[WARNING]{RESET} entry.name '{entry['name']}' != '{self.name}'")

            # Check if source package
            if 'build-depends' in entry['details']:
                self.source_name = entry['name']

                if entry['details'].get('build-depends') is not None:
                    # Filter Build-Depends entries - "rustc (>=1.63)" => "rust"
                    tmp_bdeps = parse_depends(entry['details'].get('build-depends'))
                    for bdep in tmp_bdeps:
                        m = re.match(r'^(.+) \(.+\)$', bdep)
                        if m is not None:
                            self.build_depends.append(m.group(1))
                        else:
                            self.build_depends.append(bdep)

                # Stop parsing if Source found
                continue

            # Package entry = { name, description }
            pkg = dict()
            pkg['name'] = entry['name']

            # Handle case for multi-lines description
            if '\n' in entry['details'].get('description'):
                descrs = entry['details'].get('description').splitlines()
                pkg['descr'] = descrs[0]
            else:
                pkg['descr'] = entry['details'].get('description')

            self.packages.append(pkg)

            if entry['details'].get('depends') is not None:
                self.depends = parse_depends(entry['details'].get('depends'))

            if self.source_name == '':
                print(f"{RED}[ERROR]{RESET} source package not defined for '{self.name}'")

    def dump(self):
        """Print infos about component."""
        print(f"{GREEN}Source Name{RESET}: {component.source_name}")
        if len(component.build_depends) != 0:
            print("Build-Depends: ", end='')
            print(*component.build_depends, sep=', ')
        else:
            print(f"No Build-Depends for {component.name}")

        print(f"{GREEN}Packages{RESET}: ", end='')
        for pkg in component.packages[:-1]:
            print(f"{pkg['name']} ({pkg['descr']}), ", end='')
        print(f"{component.packages[-1]['name']} ({component.packages[-1]['descr']})")
        if len(component.depends) != 0:
            print("Depends: ", end='')
            print(*component.depends, sep=', ')
        else:
            print(f"No Depends for {component.name}")


if __name__ == "__main__":
    token = load_gh_token()
    if token is None:
        print(f"{RED}ERROR{RESET} unable to load GitHub personal access token")
        sys.exit(1)
    else:
        GH_HEADERS.update({'Authorization': 'Bearer ' + token})

    # Global list for packages, build-depends and depends
    packages = list()
    build_depends = list()
    depends = list()

    for comp in COSMIC_COMPONENTS:
        print(f"[*] Get debian/control file for '{comp}'")
        # Exception for pop-launcher => repo https://github.com/pop-os/launcher/
        if comp != "pop-launcher":
            url = f'https://api.github.com/repos/pop-os/{comp}/contents//debian/control'
        else:
            url = 'https://api.github.com/repos/pop-os/launcher/contents//debian/control'

        resp = requests.get(url, params={'ref': VERSION}, headers=GH_HEADERS, timeout=5)
        if resp.status_code == 200:
            # print(resp.content.decode())
            # print()
            print(f"[*] Parse debian/control file for '{comp}'")
            component = Component()
            component.name = comp
            component.parse_control(resp.content.decode())

            component.dump()
            print("---")

            for pkg in component.packages:
                if pkg['name'] not in packages:
                    packages.append(pkg['name'])

            # Append to global list for Build-Depends
            for bdep in component.build_depends:
                if bdep not in build_depends and bdep not in COSMIC_COMPONENTS:
                    build_depends.append(bdep)

            # Append to global list for Depends
            for dep in component.depends:
                # Special case for COSMIC Apps as Depends
                if dep in COSMIC_APPS:
                    print(f"{BLUE}[INFO]{RESET} {dep} App depends for {component.name} component")

                if not dep.startswith('$') and dep not in depends and dep not in COSMIC_COMPONENTS:
                    depends.append(dep)

        else:
            print(
                f"{RED}ERROR{RESET} unable to get debian/control file for '{comp} - Status-code = {resp.status_code}'"
            )
            sys.exit(1)

    # Dump list for COSMIC packages, not in COSMIC components, Build-Depends and Depends
    print(f"{GREEN}Global list of COSMIC packages: {RESET}", end='')
    print(*sorted(packages), sep=' ')

    print(f"{GREEN}List of COSMIC packages NOT in COSMIC components: {RESET}", end='')
    print(*sorted(set(packages) - set(COSMIC_COMPONENTS)), sep=' ')
    print()

    print(f"{GREEN}Global list of Build-Depends: {RESET}", end='')
    print(*sorted(build_depends), sep=' ')

    print(f"{GREEN}Global list of Depends: {RESET}", end='')
    print(*(sorted(set(depends) - set(packages))), sep=' ')
