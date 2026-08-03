#!/usr/bin/env bash
# Check a COSMIC release: verify every component is present in GH artifacts
set -eu

for cmd in curl jq awk; do
	if ! command -v "${cmd}" > /dev/null 2>&1; then
		echo "ERROR: required command '${cmd}' is not installed or not in PATH."
		exit 1
	fi
done

# COSMIC components
# Don't include cosmic-sound-theme submodule (not packaged)
# Add cosmic-greeter-daemon built from cosmic-greeter component
# TODO: Add pop-launcher-system76-power built package (optional) ?
COSMIC_PKGS=(
	"cosmic-applets"
	"cosmic-app-library"
	"cosmic-bg"
	"cosmic-comp"
	"cosmic-greeter"
	"cosmic-greeter-daemon"
	"cosmic-icons"
	"cosmic-idle"
	"cosmic-initial-setup"
	"cosmic-launcher"
	"cosmic-notifications"
	"cosmic-osd"
	"cosmic-panel"
	"cosmic-randr"
	"cosmic-screenshot"
	"cosmic-session"
	"cosmic-settings"
	"cosmic-settings-daemon"
	"cosmic-wallpapers"
	"cosmic-workspaces"
	"pop-launcher"
	"xdg-desktop-portal-cosmic")

# COSMIC applications
COSMIC_APPS=(
	"cosmic-edit"
	"cosmic-files"
	"cosmic-monitor"
	"cosmic-player"
	"cosmic-store"
	"cosmic-term")

# Read GitHub Token from secrets.txt file
GH_TOKEN=''

read_gh_token()
{
	if [[ ! -f "utils/secrets.txt" ]]; then
		echo "secrets.txt file not found"
		exit 1
	fi

	while IFS= read -r line; do
		if [[ "$line" == \#* ]]; then
			continue
		elif [[ "$line" == github_pat* ]]; then
			GH_TOKEN=${line}
		else
			echo "ERROR: GitHub Token does not start with 'github_pat' in secrets file"
			exit 1
		fi

	done < "utils/secrets.txt"
}

# Check if value present in list
# Inputs:
# - list of strings passed by name
# - value (string)
# Returns 0 if present, 1 otherwise
if_present()
{
	local -n list=$1

	for item in "${list[@]}"; do
		if [[ "$item" == "$2" ]]; then
			return 0
		fi
	done
	return 1
}

# Check artifacts against list of COSMIC components
# Input = JSON output from GH API to get artifacts
check_artifacts()
{
	tmp_pkgs=()
	status=0

	while IFS= read -r item; do
		name=$(jq -r '.name' <<< "$item")
		tmp_pkgs+=("${name%%_*}")
	done < <(jq -c '.artifacts[]' <<< "$1")

	# Sort packages => list
	packages=($(printf "%s\n" "${tmp_pkgs[@]}" | sort))
	printf "List of artifacts: %s\n" "${packages[*]}"

	for cosmic_pkg in "${COSMIC_PKGS[@]}"; do
		echo -n "- ${cosmic_pkg}: "
		if if_present packages "${cosmic_pkg}"; then
			echo "found"
		else
			echo "NOT FOUND"
			status=1
		fi
	done

	for cosmic_pkg in "${COSMIC_APPS[@]}"; do
		echo -n "- ${cosmic_pkg}: "
		if if_present packages "${cosmic_pkg}"; then
			echo "found"
		else
			echo "NOT FOUND"
			status=1
		fi
	done

	exit "${status}"
}

usage()
{
	echo "Usage: $0 [-h] [-d] -j job_id"
	echo "  -h        Show this help"
	echo "  -j        job ID for GitHub workflow run"
	echo
	echo "Shell script to check a COSMIC release: every component must be present as GH artifact."
}

while getopts ":hj:" opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	j)
		if [[ "$OPTARG" =~ ^-?[0-9]+$ ]]; then
			job_id="$OPTARG"
		else
			echo "ERROR: -j requires an integer."
			exit 1
		fi
		;;
	:)
		echo "ERROR: Option -$OPTARG requires an argument."
		echo
		usage
		exit 1
		;;
	\?)
		echo "ERROR: Invalid option -$OPTARG"
		echo
		usage
		exit 1
		;;
	esac
done

if [[ ! -n "${job_id:-}" ]]; then
	echo "ERROR: job ID is not defined"
	exit 1
fi

read_gh_token

# Check if job ID exists
status=$(curl -sL -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GH_TOKEN}" -H "X-GitHub-Api-Version: 2026-03-10" https://api.github.com/repos/lcheylus/cosmic-debian/actions/runs/"${job_id}" | jq -r '.status')

if [ "${status}" = "completed" ]; then
	response=$(
		curl -sL -H "Accept: application/vnd.github+json" \
			-H "Authorization: Bearer ${GH_TOKEN}" \
			-H "X-GitHub-Api-Version: 2026-03-10" \
			https://api.github.com/repos/lcheylus/cosmic-debian/actions/runs/"${job_id}"/artifacts
	)
	# echo "$response"
else
	echo "ERROR: unable to get artifacts for job ID ${job_id} (Status: ${status})"
	exit 1
fi

echo "Check COSMIC artifacts for job ID ${job_id}"
check_artifacts "${response}"
