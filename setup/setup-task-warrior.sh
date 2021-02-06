#!/bin/sh

_setup() {
	_TASK_PATH=$($_OPTIONS env | grep HOME | sed -e "s/^.*=//" | head -1)
	_TASK_PATH=$_TASK_PATH/.data/tasks
	if [ -n $_TASK_PATH ] && [ ! -e $_TASK_PATH ]; then
		echo "Initializing task repository @ $_TASK_PATH"
		$_OPTIONS git init $_TASK_PATH

		# install hooks
		$_OPTIONS mkdir -p $_TASK_PATH/hooks

		cp .plugins/task-warrior/hooks/* $_TASK_PATH/hooks
	else
		echo "Task Repository is already setup @ $_TASK_PATH"
	fi
}

if [ -z "$_SUDO_PROGRAM" ]; then
	echo "_SUDO_PROGRAM is not set, unable to proceed"
	exit 2
fi

for _OTHER_USER in $(grep video /etc/group | awk -F':' {'print$4'} | tr ',' '\n'); do
	_OPTIONS="$_SUDO_PROGRAM -u $_OTHER_USER"
	_setup
	unset _OPTIONS
done
