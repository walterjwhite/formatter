#!/bin/sh

if [ -n "$OUTPUT_FORMAT" ]; then
	OUTPUT_FILE=$_RESPONSE_PATH.$OUTPUT_FORMAT

	case $OUTPUT_FORMAT in
	"json")
		_add_option "--format-options json.sort_keys:true,json.indent:2"
		;;
	*) ;;

	esac
else
	OUTPUT_FILE=$_RESPONSE_PATH
fi

# write to a file
if [ -z "$_DEBUG" ]; then
	info "Writing output to: $OUTPUT_FILE"
	_add_option "--output $OUTPUT_FILE"
fi
