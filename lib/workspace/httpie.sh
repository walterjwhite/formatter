#!/bin/sh

# wrapper around httpie CLI
# @reference: https://dev.to/pcvonz/jq-httpie-1nl6
_get_workspace_directory
PROTOCOL="https"

# units are seconds
TIMEOUT=30

_add_option() {
    _OPTIONS="$_OPTIONS $1"
}

_run() {
    _REQUEST_PATH=$_WORKSPACE_PATH/.httpie/requests/$1
    _RESPONSE_PATH=$_WORKSPACE_PATH/.httpie/responses/$1/$(date +%Y/%m/%d/%H.%M.%S)
    mkdir -p $(dirname $_RESPONSE_PATH)

    if [ ! -e $_REQUEST_PATH ]
    then
        warn "$_REQUEST_PATH does NOT exist"
        return
    fi

    info "Running request: $_REQUEST_PATH"
    . $_REQUEST_PATH

    _OPTIONS=""
    if [ -z "$_DEBUG" ]
    then
        # show the response body only (unless we're debugging)
        _add_option "-b"
    fi

    _add_option "--timeout=$TIMEOUT"

    if [ -n "$FORM" ]
    then
        _add_option "-f"
    fi
    if [ -n "$OUTPUT_FORMAT" ]
    then
        case $OUTPUT_FORMAT in
            "json")
                _add_option "--format-options json.sort_keys:true,json.indent:2"
                ;;
            "csv")
                # do nothing
                ;;
            *)
                # local output_file=$(basename $URL)
                # local has_extension=$(echo $output_file | grep -c \\.${OUTPUT_FORMAT}$)
                # if [ "$has_extension" -eq "0" ]
                # then
                #     output_file=$output_file.$OUTPUT_FORMAT
                # fi

                OUTPUT_FILE=$_RESPONSE_PATH.$OUTPUT_FORMAT
                info "Writing output to: $OUTPUT_FILE"
                $PROTOCOL $_OPTIONS $METHOD $HEADERS $URL $FORM > $_RESPONSE_PATH.$OUTPUT_FORMAT
                return
                ;;
        esac
    fi

    if [ -z "$_DEBUG" ]
    then
        OUTPUT_FILE=$_RESPONSE_PATH.$OUTPUT_FORMAT
        info "Writing output to: $OUTPUT_FILE"

        $PROTOCOL $_OPTIONS $METHOD $HEADERS $URL $FORM | tee $OUTPUT_FILE
    else
        $PROTOCOL $_OPTIONS $METHOD $HEADERS $URL $FORM
    fi
}

for _ARG in $@
do
    case $_ARG in
        -a|--all)
            # run all requests (and all parameters)
            # TODO: permit requests to be nested
            #for _REQUEST in $(find $_WORKSPACE_PATH/.httpie/requests -type f -maxdepth 1)
            for _REQUEST in $(ls $_WORKSPACE_PATH/.httpie/requests)
            do
                _run $_REQUEST
            done
            ;;
        *)
            _run $_ARG
            ;;
    esac
done
