#!/bin/sh

. _LIBRARY_PATH_/install/logging.sh
. _LIBRARY_PATH_/_APPLICATION_NAME_/java.sh

if [ ! -e $_GOOGLE_JAVA_FORMAT_JAR ]; then
	info "Installing Google Java Format JAR"
	curl -L $_GOOGLE_FORMAT_JAR_URL -o $_GOOGLE_JAVA_FORMAT_JAR -s
fi
