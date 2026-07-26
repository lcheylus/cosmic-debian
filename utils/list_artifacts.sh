#!/usr/bin/env bash
# List artifacts for a run from
# https://github.com/lcheylus/cosmic-debian/ repository
set -eu

if ! command -v curl >/dev/null 2>&1; then
	echo "ERROR: required command 'curl' is not installed or not in PATH."
	exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
	echo "ERROR: required command 'jq' is not installed or not in PATH."
	exit 1
fi

# Read GitHub Token from secrets.txt file
GH_TOKEN=''

read_gh_token() {
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

	done <"utils/secrets.txt"
}

usage() {
	echo "Usage: $0 [-h] -j job_id"
	echo "  -h        Show this help"
	echo "  -j        job ID for GitHub workflow run"
	echo
	echo "Shell script to list artefacts for a workflow run from https://github.com/lcheylus/cosmic-debian/ repository"
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
status=$(curl -sL -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GH_TOKEN}" -H "X-GitHub-Api-Version: 2026-03-10" https://api.github.com/repos/lcheylus/cosmic-debian/actions/runs/${job_id} | jq -r '.status')

if [ "${status}" = "completed" ]; then
	echo "Artifacts for job ID ${job_id}:"
	curl -sL -H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GH_TOKEN}" \
		-H "X-GitHub-Api-Version: 2026-03-10" \
		https://api.github.com/repos/lcheylus/cosmic-debian/actions/runs/${job_id}/artifacts |
		jq -r '.artifacts[] | ({name, url, id, expired} | to_entries | map("\(.key): \(.value)"))'
else
	echo "ERROR: unable to get artifacts for job ID ${job_id} (Status: ${status})"
	exit 1
fi
