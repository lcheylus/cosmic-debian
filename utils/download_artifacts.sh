#!/usr/bin/env bash
# List/Download artifacts for a run from
# https://github.com/lcheylus/cosmic-debian/ repository
set -eu

for cmd in curl jq awk; do
	if ! command -v "${cmd}" > /dev/null 2>&1; then
		echo "ERROR: required command '${cmd}' is not installed or not in PATH."
		exit 1
	fi
done

# No download by default
download=0

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

	done < "utils/secrets.txt"
}

# Convert size in bytes => human-readable format
convert_size() {
	awk -v b="$1" 'BEGIN {
	    gb = 1024*1024*1024
	    mb = 1024*1024
	    kb = 1024

	    if (b >= gb) {
		printf "%.2f GB\n", b/gb
	    } else if (b >= mb) {
		printf "%.2f MB\n", b/mb
	    } else if (b >= kb) {
		printf "%.2f KB\n", b/kb
	    } else {
		printf "%d Bytes\n", b
	    }
	}'
}

# Print infos about artifacts
# Input = JSON output from GH API to get artifacts
print_artifacts() {
	jq -c '.artifacts[]' <<< "$1" |
		while IFS= read -r item; do
			name=$(jq -r '.name' <<< "$item")
			size=$(jq -r '.size_in_bytes' <<< "$item")
			expired=$(jq -r '.expired' <<< "$item")

			echo "- $name"
			echo "  * size: $(convert_size "${size}")"
			echo "  * expired: ${expired}"
		done
}

# Download artifacts
# Input = JSON output from GH API to get artifacts
download_artifacts() {
	jq -c '.artifacts[]' <<< "$1" |
		while IFS= read -r item; do
			name=$(jq -r '.name' <<< "$item")
			a_id=$(jq -r '.id' <<< "$item")
			size=$(jq -r '.size_in_bytes' <<< "$item")
			expired=$(jq -r '.expired' <<< "$item")

			if [ "$expired" == "true" ]; then
				echo "- Status expired for ${name}"
			else
				echo "- Download ${name} - Size = $(convert_size "${size}")"
				curl -L --progress-bar \
					-H "Accept: application/vnd.github+json" \
					-H "Authorization: Bearer ${GH_TOKEN}" \
					-H "X-GitHub-Api-Version: 2026-03-10" \
					https://api.github.com/repos/lcheylus/cosmic-debian/actions/artifacts/"${a_id}"/zip \
					-o "${tmp_dir}/${name}"
			fi
		done
}

usage() {
	echo "Usage: $0 [-h] [-d] -j job_id"
	echo "  -h        Show this help"
	echo "  -d        Download artifacts"
	echo "  -j        job ID for GitHub workflow run"
	echo
	echo "Shell script to list/download artefacts for a workflow run from https://github.com/lcheylus/cosmic-debian/ repository"
}

while getopts ":hdj:" opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	d)
		download=1
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
	json=$(
		curl -sL -H "Accept: application/vnd.github+json" \
			-H "Authorization: Bearer ${GH_TOKEN}" \
			-H "X-GitHub-Api-Version: 2026-03-10" \
			https://api.github.com/repos/lcheylus/cosmic-debian/actions/runs/"${job_id}"/artifacts
	)
	# echo "$json"
else
	echo "ERROR: unable to get artifacts for job ID ${job_id} (Status: ${status})"
	exit 1
fi

if [ $download -ne 1 ]; then
	echo "Artifacts for job ID ${job_id}"
	print_artifacts "${json}"
else
	tmp_dir=$(mktemp -d -t cosmic-artifacts-XXX)
	echo "Download artifacts for job ID ${job_id} - Directory = ${tmp_dir}"
	download_artifacts "${json}"
fi
