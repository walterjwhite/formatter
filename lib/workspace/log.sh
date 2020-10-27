#!/bin/sh

if [ "$#" -lt "1" ]
then
    exitWithError "Comments are required" 1
fi

# simply add a comment and record it in the git history for the workspace

. _LIBRARY_PATH_/git/include.sh

_get_workspace_directory
_LOG_PATH=$_WORKSPACE_PATH/logs/$(date +%Y/%m/%d/%H.%M.%S)

mkdir -p $(dirname $_LOG_PATH)

echo "$1" > $_LOG_PATH
_git $_LOG_PATH "comment"