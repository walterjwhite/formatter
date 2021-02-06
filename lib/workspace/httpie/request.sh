#!/bin/sh

#_REQUEST_PATH=$_WORKSPACE_PATH/.httpie/requests/$1
_RESPONSE_PATH=$(echo $_REQUEST_PATH | sed -e "s/requests/responses/")/$(date +%Y/%m/%d/%H.%M.%S)
mkdir -p $(dirname $_RESPONSE_PATH)

if [ ! -e $_REQUEST_PATH ]; then
	warn "$_REQUEST_PATH does NOT exist"
	return
fi

info "Running request: $_REQUEST_PATH"
. $_REQUEST_PATH

_OPTIONS=""
if [ -z "$_DEBUG" ]; then
	# show the response body only (unless we're debugging)
	_add_option "-b"
fi

_add_option "--timeout=$TIMEOUT"

if [ -n "$FORM" ]; then
	_add_option "-f"
fi
