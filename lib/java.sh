#!/bin/sh

_GOOGLE_FORMAT_VERSION=1.9
_GOOGLE_FORMAT_JAR_URL=https://github.com/google/google-java-format/releases/download/google-java-format-$_GOOGLE_FORMAT_VERSION/google-java-format-$_GOOGLE_FORMAT_VERSION-all-deps.jar

_GOOGLE_JAVA_FORMAT_JAR=_LIBRARY_PATH_/_APPLICATION_NAME_/google.java.format.jar
_JAVA_FORMAT_CLI="$_JAVA -jar $_GOOGLE_JAVA_FORMAT_JAR -r"
