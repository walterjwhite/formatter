#!/bin/sh

# wrapper around jira CLI (injects configuration (url, username, and password))
# examples
# workspace jira comment WJW-20 "some comment" - adds the comment to the jira
# workspace jira transition WJW-20 completed   - marks the jira as completed
# workspace jira get WJW-20                    - gets jira information (and prints it to screen)
# NOTE: create is handle externally
if [ "$#" -lt "3" ]
then
    exitWithError "sub-command (comment, transition, get), jira ticket #, and argument is required" 1
fi

_get_workspace_directory

_JIRA_SUB_COMMAND=$1
shift

_JIRA_TICKET=$1
shift

case $_JIRA_SUB_COMMAND in
    comment)
        _JIRA_SUB_COMMAND_ARGS="-c $1"
        ;;
    transition)
        _JIRA_SUB_COMMAND_ARGS="-a $1"
        ;;
    create)
        _JIRA_SUB_COMMAND_ARGS="$@"
        ;;
esac

. $_WORKSPACE_PATH/jira/$_JIRA_TICKET

jira\
    -url $_JIRA_URL\
    -credentials-username ${_JIRA_SECRET_KEY}/username\
    -credentials-password ${_JIRA_SECRET_KEY}/password\
    $_JIRA_SUB_COMMAND\
    -i $_JIRA_TICKET\
    $_JIRA_SUB_COMMAND_ARGS
