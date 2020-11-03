#!/bin/sh

_setup() {
    _TASK_PATH=$($_OPTIONS env | grep HOME | sed -e "s/^.*=//")/.data/tasks
    if [ ! -e $_TASK_PATH ]
    then
        echo "Initializing task repository @ $_TASK_PATH"
        $_OPTIONS git init $_TASK_PATH

        # install hooks
        $_OPTIONS mkdir -p $_TASK_PATH/hooks

        cp .plugins/task-warrior/hooks/* $_TASK_PATH/hooks
    else
        echo "Task Repository is already setup @ $_TASK_PATH"
    fi
}

if [ "$USER" == "root" ]
then
    if [ -z "$_SUDO_PROGRAM" ]
    then
        echo "_SUDO_PROGRAM is not set, unable to proceed"
        exit 2
    fi

    echo "You are currently logged in as $USER, enter other users (separated by space)"
    read _OTHER_USERS

    if [ -n "$_OTHER_USERS" ]
    then
        echo "Configuring for $_OTHER_USERS"
        for _OTHER_USER in $_OTHER_USERS
        do
            _OPTIONS="$_SUDO_PROGRAM -u $_OTHER_USER"
            _setup
            unset _OPTIONS
        done

        return
    fi
fi

_setup
