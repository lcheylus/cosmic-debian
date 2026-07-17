#!/bin/sh
# List submodules for https://github.com/pop-os/cosmic-epoch/ repository
set -eu

if ! command -v curl >/dev/null 2>&1; then
	"ERROR: required command 'curl' is not installed or not in PATH."
	exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
	"ERROR: required command 'jq' is not installed or not in PATH."
	exit 1
fi

curl -sL -H "Accept: application/vnd.github+json" \
	-H "X-GitHub-Api-Version: 2026-03-10" \
	https://api.github.com/repos/pop-os/cosmic-epoch/contents/ \
	| jq '.[] | select(.type == "submodule")' | jq -r .name

