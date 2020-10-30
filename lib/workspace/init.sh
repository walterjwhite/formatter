#!/bin/sh

# creates a brand new workspace
if [ "$#" -lt "1" ]
then
    exitWithError "workspace name is required" 1
fi

_WORKSPACE_NAME=$1
shift

_WORKSPACE_PATH=$_WORKSPACE_BASE_PATH/$_WORKSPACE_NAME
if [ -e $_WORKSPACE_PATH ]
then
    exitWithError "$_WORKSPACE_PATH already exists" 2
fi

# git init
git init $_WORKSPACE_PATH

echo "$_WORKSPACE_PATH created - configure submodules, settings, etc."