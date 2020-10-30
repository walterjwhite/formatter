#!/bin/sh

# wrapper around usql CLI
# example: workspace usql -i=peanuts -e=dev -u=me -f=varieties.count
_OPTIONS=""
for _ARG in $@
do
    case $_ARG in
        -i=*|--identifier=*)
            _DATABASE_ID="${_ARG#*=}"
            ;;
        -e=*|--environment=*)
            _ENVIRONMENT="${_ARG#*=}"
            ;;
        -u=*|--user=*)
            _USER="${_ARG#*=}"
            ;;
        -f=*|--file=*)
            _FILE=.usql/queries/"${_ARG#*=}".sql
            _OPTIONS="$_OPTIONS --file=$_FILE"
            ;;
        -C)
            # ignore, we're already handling this
            ;;
        *=*)
            _OPTIONS="$_OPTIONS --variable=$_ARG"
            ;;
        *)
            warn "$_ARG was not understood"
    esac
done

_require "$_DATABASE_ID" "Database ID" 1
_require "$_ENVIRONMENT" "Environment" 2
_require "$_FILE" "File" 3

# TODO: this may not be required
#_require "$_USER" "User" 3

_DATESTAMP=$(date +%Y.%m.%d.%H.%M.%S)
_OUTPUT_FILE=.data/$_DATABASE_ID/$_ENVIRONMENT/$_USER/$(basename $_FILE | sed -e "s/\.sql//").${_DATESTAMP}.csv

mkdir -p $(dirname $_OUTPUT_FILE)

# TODO: support setting variables
#_OPTIONS="$_OPTIONS --variable=$_VARIABLE_NAME=$VALUE"
# @ISSUE: https://github.com/xo/usql/issues/124
# @ISSUE: https://github.com/xo/usql/issues/119
# @ISSUE: https://github.com/xo/usql/issues/96


_DSN_FILE=.usql/connections/$_DATABASE_ID/$_ENVIRONMENT
if [ ! -e $_DSN_FILE ]
then
    exitWithError "DSN: $_DSN_FILE does NOT exist" 4
fi

if [ ! -e $_FILE ]
then
    exitWithError "Query: $_FILE does NOT exist" 4
fi

_DSN=$(cat $_DSN_FILE)

if [ -n "$_USER" ]
then
    _DSN=$(echo $_DSN | sed -e "s/_USER_/$_USER/")

    _PASSWORD=$(secrets -o=s get $_DATABASE_ID $_ENVIRONMENT $_USER password)
    #_require "$_PASSWORD" "Password" 5

    if [ -n "$_PASSWORD" ]
    then
        _DSN=$(echo $_DSN | sed -e "s/_PASSWORD_/$_PASSWORD/")
    fi
fi

usql $_OPTIONS -C $_DSN\
    | sed 1d\
    | sed -e "s/|/,/g"\
    > $_OUTPUT_FILE

echo "$(echo $(wc -l $_OUTPUT_FILE | awk {'print$1'}) - 1 | bc) records written to $_OUTPUT_FILE"