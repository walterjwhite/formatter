#!/bin/sh

. _LIBRARY_PATH/_APPLICATION_NAME/java.sh
. _LIBRARY_PATH/git-helpers/project.directory.sh
. _LIBRARY_PATH/install/logging.sh

_JAVA=/usr/local/openjdk14/bin/java

_FORMAT_INDEX=~/.format

#echo $@
for _ARG in $@
do
    case $_ARG in
        # lines
        -l=*)
            _LINES="${_ARG#*=}"
            ;;
        *)
            _FILE=$_ARG
            ;;
    esac
done

if [ -n "$_LINES" ] && [ -n "$_FILE" ]
then
    _BRANCH=$(gcb)
    _START=1
    _FILE_PATH=$_PROJECT_PATH/$_FILE
    _FILE_FORMAT_INDEX=$_FORMAT_INDEX/$_PROJECT/$_BRANCH/$_FILE_PATH

    if [ -e $_FILE_FORMAT_INDEX ]
    then
        _START=$(head -1 $_FILE_FORMAT_INDEX)
        _END=$(echo "$_START + $_LINES" | bc)

        _LINES=$(wc -l $_FILE | awk '{print$1}')
        if [ "$_START" -gt "$_LINES" ]
        then
            exitSuccess "$_FILE - Already formatted"
        fi
    else
        _END=$_LINES

        mkdir -p $(dirname $_FILE_FORMAT_INDEX)
    fi

    $_JAVA -jar $_GOOGLE_JAVA_FORMAT_JAR -r -lines $_START:$_END $_FILE

    # update index
    _NEXT=$(echo "$_END + 1" | bc)

    echo "$_FILE - will start @ $_NEXT next time"
    echo $_NEXT > $_FILE_FORMAT_INDEX
else
    $_JAVA -jar $_GOOGLE_JAVA_FORMAT_JAR -r $_FILE
fi
