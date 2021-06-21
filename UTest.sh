#!/bin/bash

source config.default

! [ -d failed ] && mkdir failed
! [ -d tests ] && mkdir tests

move_files(){
    $(mv failed making.sh tests $1)
}

help(){
    echo "TO-DO"
}

lizard_inst_check(){ ### Checks if Lizard is installed
    if !(which lizard >/dev/null || (pip3 list | grep lizard >/dev/null)); then
        echo "Install Lizard First!"
        exit 1
    fi
}

VALGRIND=0
LIZARD=0

###  Using case statements to handle the flags
while getopts ":m:hlvic" opt; do 
    case $opt in
    m)  ### Move file structure command
        echo "[Moving] to $OPTARG..." >&2
        move_files $OPTARG
        exit 1
        ;;
    h)  ### Help command
        help
        exit 1
        ;;
    v)  ### Run the testing using Valgrind
        echo "Valgrind" >&2
        VALGRIND=1
        ;;
    l)  ### Run the testing using Lizard
        echo "Lizard" >&2
        lizard_inst_check
        LIZARD=1
        ;;
    \?) ### Invalid flag option used
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)  ### The flag used requires a missing argument
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done