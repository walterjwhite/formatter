#!/bin/sh

# creates a new branch within a workspace

if [ "$#" -lt "2" ]; then
	exitWithError "source workspace branch and destination branch are required" 1
fi

_WORKSPACE_SOURCE_BRANCH=$1
shift

_WORKSPACE_TARGET_BRANCH=$1
shift

gco $_WORKSPACE_SOURCE_BRANCH
git checkout -b $_WORKSPACE_TARGET_BRANCH
