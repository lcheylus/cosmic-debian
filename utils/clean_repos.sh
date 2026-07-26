#!/bin/sh
# Clean repositories cosmic-*
# In each directory:
# - remove target, vendor directory and vendor.tar file
# - remove artifacts created in debian/ directory
set -eu

if ! command -v fdfind >/dev/null 2>&1; then
	echo "ERROR: required command 'fdfind' is not installed or not in PATH."
	exit 1
fi

# Home directory with Git clones for cosmic-* components
COSMIC_HOME=$HOME/dev/COSMIC/
# Directory of local clone for GH lcheylus/cosmic-debian repo
COSMIC_REPO=cosmic-debian.git

usage() {
	echo "Usage: $0 [-h] [-n]"
	echo "  -h        Show this help"
	echo "  -n        Dry-run"
	echo
	echo "Shell script to remove build artifacts in COSMIC repositories"
}

dryrun=0

while getopts ":hn" opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	n)
		dryrun=1
		;;
	\?)
		usage
		exit 0
		;;
	esac
done

if [ "$dryrun" -eq 1 ]; then
	echo "[*] dry-run mode"
fi

for dir in $(fdfind -E "${COSMIC_REPO}" -t d -d 1 cosmic "${COSMIC_HOME}"); do
	echo "[*] Clean ${dir} directory"

	if [ "$dryrun" -eq 1 ]; then
		fdfind -c never -I -d 1 vendor "${dir}"
		fdfind -c never -I -d 1 -t d target "${dir}"
	else
		fdfind -c never -I -d 1 vendor "${dir}" -x rm -rf {}
		fdfind -c never -I -d 1 -t d target "${dir}" -x rm -rf {}
	fi

	# Remove artifacts created in debian/ directory with exceptions for
	# {changelog,control,rules} files
	cd "${dir}"
	for f in $(git status -s --ignored "debian/" | cut -c4-); do
		case $(basename "${f}") in
		changelog | control | rules) ;;
		*)
			echo "Clean ${f}"
			if [ "$dryrun" -ne 1 ]; then
				rm -rf "${f}"
			fi
			;;
		esac
	done
	cd ..
done
