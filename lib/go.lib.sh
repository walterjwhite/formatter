#!/bin/sh

_MODULE=1

_doBuild() {
	_test
	
	go build -a -race $_BUILD_OPTIONS
}

_build_files() {
	dirname $(grep "package" $(find . -type f | grep \\.go$) | grep -v "^package main$" | sed -e "s/\:.*$//") | sort -u
}

# TODO: automatically initialize go module
# set via _APPLICATION_PACKAGE_PREFIX
	# _PACKAGE_RELATIVE_NAME=$(echo $_ELEMENT | sed -e "s/^\.\///")

	# if [ ! -e go.mod ]
	# then
	# 	go mod init $_PACKAGE_PREFIX/$_PACKAGE_RELATIVE_NAME
	# fi

. _LIBRARY_PATH_/_APPLICATION_NAME_/go.common.sh