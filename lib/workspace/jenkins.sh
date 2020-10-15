#!/bin/sh

# wrapper around jenkins CLI (injects configuration (url, job name, username, and password))
# examples
# workspace jenkins build codesearch
# workspace jenkins wait codesearch
# workspace jenkins cancel codesearch
if [ "$#" -lt "2" ]
then
    exitWithError "sub-command (build, cancel, wait) and job name is required" 1
fi

_JENKINS_SUB_COMMAND=$1
shift

_JENKINS_JOB_NAME=$1
shift

. $_WORKSPACE_PATH/jenkins/$_JENKINS_JOB_NAME

jenkins $_JENKINS_SUB_COMMAND\
    -url $_JENKINS_URL\
    -username ${_JENKINS_SECRET_KEY}/username\
    -password ${_JENKINS_SECRET_KEY}/password\
    -j $_JENKINS_JOB_NAME