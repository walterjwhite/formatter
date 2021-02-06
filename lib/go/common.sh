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

_test() {
	local _has_tests=$(find . -type f -maxdepth 1 | grep _test.go | wc -l)
	if [ "$_has_tests" -gt "0" ]; then
		go test
	fi
}

_cleanup() {
	rm -rf /tmp/{go-build*,cgo*,cc*,golangci*}
}

_build_all() {
	for _ELEMENT in $@; do
		_build
	done
}

_build_lib() {
	_MODULE=1

	_test

	go build -a -race $_BUILD_OPTIONS

	unset _BUILD_DATE _VERSION _GO_VERSION _OS_ARCHITECTURE _APP_VERSION_FLAG _BUILD_DATE_FLAG _GO_VERSION_FLAG _OS_ARCHITECTURE_FLAG _BUILD_OPTIONS
}

_build_cmd() {
	_BUILD_DATE=$(date +"%Y/%m/%d-%H:%M:%S")
	_VERSION=$(git rev-parse HEAD)
	_GO_VERSION=$(go version | awk {'print$3'})
	_OS_ARCHITECTURE=$(go version | awk {'print$4'})

	_APP_VERSION_FLAG="${_APPLICATION_PACKAGE_PREFIX}.ApplicationVersion=$_VERSION"
	_BUILD_DATE_FLAG="${_APPLICATION_PACKAGE_PREFIX}.BuildDate=$_BUILD_DATE"
	_GO_VERSION_FLAG="${_APPLICATION_PACKAGE_PREFIX}.GoVersion=$_GO_VERSION"
	_OS_ARCHITECTURE_FLAG="${_APPLICATION_PACKAGE_PREFIX}.OSArchitecture=$_OS_ARCHITECTURE"

	_BUILD_OPTIONS="-X $_APP_VERSION_FLAG -X $_BUILD_DATE_FLAG -X $_GO_VERSION_FLAG -X $_OS_ARCHITECTURE_FLAG"

	debug "#####"
	debug "$_BUILD_DATE"
	debug "$_VERSION"
	debug "$_GO_VERSION"
	debug "$_OS_ARCHITECTURE"

	go install -a -race -ldflags "$_BUILD_OPTIONS"

	# TODO: determine how to use this
	# additional race detection
	#chronos -file $(grep "func main()" $(find . -type f | grep \\.go$) -l)

	unset _BUILD_DATE _VERSION _GO_VERSION _OS_ARCHITECTURE _APP_VERSION_FLAG _BUILD_DATE_FLAG _GO_VERSION_FLAG _OS_ARCHITECTURE_FLAG _BUILD_OPTIONS
}

# @see: https://medium.com/@joshroppo/setting-go-1-5-variables-at-compile-time-for-versioning-5b30a965d33e
_build() {
	_COMMAND_DIRECTORY=$(readlink -f $_ELEMENT)

	_HAS_FILES=$(find $_COMMAND_DIRECTORY -type f -maxdepth 1 | grep \\.go$ | wc -l)
	if [ "$_HAS_FILES" -eq "0" ]; then
		return
	fi

	info "building: $(basename $_COMMAND_DIRECTORY)"

	cd $_COMMAND_DIRECTORY

	# if [ -z "$_MODULE" ] && [ "$_MODULE" -eq "1" ] && [ ! -e go.mod ]
	# then
	# 	go mod init
	# fi

	if [ $(grep "package main" *.go -n 2>/dev/null | wc -l) -gt 0 ]; then
		_build_cmd
	else
		_build_lib
	fi

	if [ $? -eq 0 ]; then
		_fix && _format && _lint
	fi

	cd $_PWD
}

_build_files() {
	dirname $(grep -l "package" $(find . -type f | grep \\.go$)) | sort -u
}
