#!/bin/sh

. _APPLICATION_CONFIG_PATH_

if [ $(find . -type f | grep \\.go$ | wc -l) -gt 0 ]; then
	info "Formatting go"
	. _LIBRARY_PATH_/_APPLICATION_NAME_/go/common.sh
	_format
fi
