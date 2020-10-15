#!/bin/sh

. _LIBRARY_PATH_/git/project.directory.sh

if [ "$#" -lt "1" ]
then
    exitWithError "configuration file is required" 2
fi

_git_init_submodule() {
    _SUBMODULE_RELATIVE_PATH=$(_get_project_relative_path $_GIT_PROJECT_LINE)
    _SUBMODULE_PATH=$_WORKSPACE_PATH/git/$_SUBMODULE_RELATIVE_PATH

    git submodule add $_GIT_PROJECT_LINE $_SUBMODULE_PATH
}

while read _GIT_PROJECT_LINE
do
    _git_init_submodule
done < $1
