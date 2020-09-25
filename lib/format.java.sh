#!/bin/sh

_PARALLEL=10

_all() {
    find . -type f | grep \\.java$\
        | xargs -L $_PARALLEL -I _FILE_ format.java _FILE_
}

_since() {
    local _files=$(gucf -s=$_SINCE 2>/dev/null  | grep \\.java$)
    if [ -n "$_files" ]
    then
        format.java $_files
    fi
}

_others() {
    # if not exist, start @ 0
    # else, start at contents + LINES
    local _other_files=$(gcf -s=$_SINCE 2>/dev/null | grep \\.java$)
    if [ -n "$_other_files" ]
    then
        for _other_file in $_other_files
        do
            format.java -l=$_LINES $_other_file
        done
    fi
}