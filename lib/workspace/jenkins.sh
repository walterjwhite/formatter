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

_get_workspace_directory
_JENKINS_JOB_CONFIGURATION_FILE=$_WORKSPACE_PATH/jenkins/$_JENKINS_JOB_NAME
if [ ! -e $_JENKINS_JOB_CONFIGURATION_FILE ]
then
    exitWithError "Jenkins job configuration file ($_JENKINS_JOB_CONFIGURATION_FILE) does not exist" 1
fi

. $_JENKINS_JOB_CONFIGURATION_FILE

jenkins\
    -url $_JENKINS_URL\
    -username ${_JENKINS_SECRET_KEY}/username\
    -password ${_JENKINS_SECRET_KEY}/password\
    -j $_JENKINS_JOB_NAME\
    $_JENKINS_SUB_COMMAND
