#!/bin/sh

if [ "$#" -lt "1" ]; then
	exitWithError "An application to run is required." 1
fi

_get_workspace_directory
_RUN_JOB_CONFIGURATION_PATH=$_WORKSPACE_PATH/run

run -log-level debug -session-path $_RUN_JOB_CONFIGURATION_PATH $@
