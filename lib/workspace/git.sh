#!/bin/sh

# sub-commands (init, update)
if [ "$#" -lt "1" ]; then
	exitWithError "sub-command (init, pull, push) is required." 1
fi

_GIT_SUB_COMMAND=$1
shift

_get_workspace_directory

case $_GIT_SUB_COMMAND in
init)
	. _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/git/init.sh
	;;
pull)
	. _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/git/pull.sh
	;;
push)
	. _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/git/push.sh
	;;
*)
	exitWithError "Unknown sub-command $_GIT_SUB_COMMAND" 3
	;;
esac
#prepends path with git
