#!/bin/sh

. _APPLICATION_CONFIG_PATH_

if [ $(find . -type f | grep \\.json$ | wc -l) -gt 0 ]; then
	info "Formatting JSON"
	if [ -n "$_JSON_FORMATTER" ]; then
		find . -type f | grep \\.json$ | wc -l | xargs -n 1 -P 10 -I _FILE_ .format-json _FILE_
	else
		exitWithError "_JSON_FORMATTER is *NOT* set" 3
	fi
fi
