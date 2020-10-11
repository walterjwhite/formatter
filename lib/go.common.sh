#!/bin/sh

_PWD=$(pwd)

# @see: https://blog.golang.org/go-fmt-your-code
# automatically format go source code
_format() {
	find . -type f | grep \\.go$ | xargs -P 10 -I _SOURCE_FILE gofmt -s -w _SOURCE_FILE
}

_lint() {
	golangci-lint run --fix ./
}

# @see: https://blog.golang.org/introducing-gofix
# automatically update source code to the latest concepts ...
_fix() {
	go fix
}

_cleanup() {
	rm -rf /tmp/{go-build*,cgo*,cc*,golangci*}
}

_build_all() {
	for _ELEMENT in $@
	do
		_build
	done
}

# @see: https://medium.com/@joshroppo/setting-go-1-5-variables-at-compile-time-for-versioning-5b30a965d33e
_build() {
	_COMMAND_DIRECTORY=$(readlink -f $_ELEMENT)

	_HAS_FILES=$(find $_COMMAND_DIRECTORY -type f -maxdepth 1 | grep \\.go$ | wc -l)
	if [ "$_HAS_FILES" -eq "0" ]
	then
		return
	fi

	echo -e "building: $_ELEMENT"
	
	cd $_COMMAND_DIRECTORY

	# if [ -z "$_MODULE" ] && [ "$_MODULE" -eq "1" ] && [ ! -e go.mod ]
	# then
	# 	go mod init
	# fi

	_doBuild && _fix && _format && _lint

	cd $_PWD
}

if [ "$#" -eq "0" ]
then
	_build_all $(_build_files)
else
	_build_all $@
fi

_cleanup