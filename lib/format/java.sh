#!/bin/sh

. _APPLICATION_CONFIG_PATH_

if [ $(find . -type f | grep \\.java$ | wc -l) -gt 0 ]; then
	info "Formatting java"
	_format-java
fi
