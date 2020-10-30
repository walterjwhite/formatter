#!/bin/sh

# wrapper around httpie CLI
# @reference: https://dev.to/pcvonz/jq-httpie-1nl6
_get_workspace_directory

. _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/httpie/defaults.sh

_add_option() {
    _OPTIONS="$_OPTIONS $1"
}

_run() {
    for _REQUEST_PATH in $_REQUESTS
    do
        . _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/httpie/request.sh
        . _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/httpie/output.sh
        . _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/httpie/run.sh
    done
}

. _LIBRARY_PATH_/_APPLICATION_NAME_/workspace/httpie/cli.sh

_run $_REQUESTS