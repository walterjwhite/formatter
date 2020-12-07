#!/bin/sh

_BUILD_DATE=$(date +"%Y/%m/%d-%H:%M:%S")
_VERSION=$(git rev-parse HEAD)
_GO_VERSION=$(go version | awk {'print$3'})
_OS_ARCHITECTURE=$(go version | awk {'print$4'})

_APP_VERSION_FLAG="${_APPLICATION_PACKAGE_PREFIX}.ApplicationVersion=$_VERSION"
_BUILD_DATE_FLAG="${_APPLICATION_PACKAGE_PREFIX}.BuildDate=$_BUILD_DATE"
_GO_VERSION_FLAG="${_APPLICATION_PACKAGE_PREFIX}.GoVersion=$_GO_VERSION"
_OS_ARCHITECTURE_FLAG="${_APPLICATION_PACKAGE_PREFIX}.OSArchitecture=$_OS_ARCHITECTURE"

_BUILD_OPTIONS="-X $_APP_VERSION_FLAG -X $_BUILD_DATE_FLAG -X $_GO_VERSION_FLAG -X $_OS_ARCHITECTURE_FLAG"

if [ -n "$_DEBUG" ]
then
	echo -e "#####"
	echo -e "$_BUILD_DATE"
	echo -e "$_VERSION"
	echo -e "$_GO_VERSION"
	echo -e "$_OS_ARCHITECTURE"
fi

_doBuild() {
	go install -a -race -ldflags "$_BUILD_OPTIONS"

	# TODO: determine how to use this
	# additional race detection
	#chronos -file $(grep "func main()" $(find . -type f | grep \\.go$) -l)
}

_build_files() {
	dirname $(grep -l "package main" $(find . -type f | grep \\.go$) )\
		| sort -u
}

. _LIBRARY_PATH_/_APPLICATION_NAME_/go.common.sh