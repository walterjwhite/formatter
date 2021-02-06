#!/bin/sh

_CLEAR_REPOSITORY=1
_SKIP_TESTS=1

_read_cli() {
	_OPTIONS=""
	for key in "$@"; do
		case $key in
		-n)
			_CLEAR_REPOSITORY=0
			;;
		-t)
			_SKIP_TESTS=0
			;;
		*)
			_OPTIONS="${_OPTIONS} $key"
			;;
		esac
	done
}

_read_cli $@

if [ "$_CLEAR_REPOSITORY" -eq "1" ]; then
	echo -e "Clearing repository"
	rm -rf /home/w/.m2/repository/com/walterjwhite
fi

if [ "$_SKIP_TESTS" -eq "1" ]; then
	echo -e "Skipping tests"
	_OPTIONS="${_OPTIONS} -Dmaven.test.skip=true"
fi

mvn clean install -Dorg.slf4j.simpleLogger.defaultLogLevel=warn -P error-prone $_OPTIONS
