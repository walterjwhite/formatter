#!/bin/sh

. _APPLICATION_CONFIG_PATH_

_ALERTED=0

_is_script() {
	return $(head -1 $_FILE | grep -c "#\!/bin/sh")
}

for _FILE in $(find . -type f | grep -v \\.git); do
	_is_script
	if [ $? -gt 0 ]; then
		if [ $_ALERTED -eq 0 ]; then
			_ALERTED=1
			info "Formatting shell"
		fi

		info "\tFormatting script: $_FILE"
		shfmt -w $_FILE
	fi
done
