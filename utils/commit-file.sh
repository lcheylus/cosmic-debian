#!/bin/sh
# Shell script to commit file during a GitHub workflow run
# Inputs:
# - filename
# - commit message

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <filename> <commit message>"
	echo
	echo "Simple script to commit file with message during a GH workflow run"
	exit 1
fi

filename=$1
message=$2

git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

git add "${filename}"
git commit -m "${message}"

git push
