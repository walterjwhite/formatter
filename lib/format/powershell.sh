#!/bin/sh

. _APPLICATION_CONFIG_PATH_

if [ $(find . -type f | grep \\.ps1$ | wc -l) -gt 0 ]; then
	info "Formatting powershell"
	_format-powershell
fi
