#!/bin/sh

if [ $(find . -type f | grep \\.xml$ | wc -l) -gt 0 ]; then
	info "Formatting XML"

	for _FILE in $(find . -type f | grep \\.xml$); do
		_FORMATTED=$(mktemp)

		xmlfmt -f $_FILE >$_FORMATTED
		mv $_FORMATTED $_FILE
	done
fi
