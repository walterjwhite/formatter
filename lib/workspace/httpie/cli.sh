#!/bin/sh

_REQUESTS=""

for _ARG in $@
do
    case $_ARG in
        -a|--all)
            if [ -n "$_DEBUG" ]
            then
                exitWithError "DEBUG is active and not permitted for all requests" 10
            fi
            
            _REQUESTS=$(find $_WORKSPACE_PATH/.httpie/requests -type f\
                | grep -v .parameters)

        # \
        # | sed -e "s/^.*\/\.httpie\/requests\///"
            
            ;;
        # use a specific instance of parameters
        -p=*)
            _PARAMETERS="${_ARG#*=}"
            ;;
        *)
            _REQUESTS="$_REQUESTS $_WORKSPACE_PATH/.httpie/requests/$_ARG"
            ;;
    esac
done
