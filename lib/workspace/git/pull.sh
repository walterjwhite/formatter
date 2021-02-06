#!/bin/sh

# submodules have .git as a file and not a dir
for _GIT_SUBMODULE in $(find $_WORKSPACE_PATH/git -type f | \\.git$ | sed -e "s/\.git$//"); do
	cd $_GIT_SUBMODULE

	git pull

	cd $_WORKSPACE_PATH
done
