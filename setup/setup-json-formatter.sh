#!/bin/sh

. _LIBRARY_PATH_/install/logging.sh

_VERSION=1.6

# jq
if [ $(env | grep -c ^OS=Windows.*$) -gt 0 ]; then
	_DOWNLOAD_URL="https://github.com/stedolan/jq/releases/download/jq-${_VERSION}/jq-win64.exe"
	info "downloading: $_DOWNLOAD_URL"

	curl -o $_BIN_PATH/jq.exe $_DOWNLOAD_URL
elif [ $(uname | grep -c FreeBSD) -gt 0 ]; then
	pkg info -e jq

	if [ $? -eq 1 ]; then
		info "installing jq"
		$_SUDO_PROGRAM pkg install -y jq
	else
		info "jq is already installed"
	fi
else
	info "Please download and install: https://stedolan.github.io/jq/"
fi
