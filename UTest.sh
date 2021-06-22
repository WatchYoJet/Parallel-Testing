#!/bin/bash

source config.default

! [ -d failed ] && mkdir failed
! [ -d tests ] && mkdir tests

VALGRIND=0
LIZARD=0
export lightred="\033[31m"
export lightgreen="\033[32;m"
export red="\033[31;1m"
export green="\033[32;1m"
export reset="\033[0m"

move_files() {
    $(mv failed making.sh tests $1)
}

help() {
    echo "TO-DO"
}

lizard_inst_check() { ### Checks if Lizard is installed
    if !(which lizard >/dev/null || (pip3 list | grep lizard >/dev/null)); then
        echo "Install Lizard First!"
        exit 1
    fi
}

###  Using case statements to handle the flags
while getopts ":m:hvl" opt; do
    case $opt in
    m) ### Move file structure command
        echo "[Moving] to $OPTARG..." >&2
        move_files $OPTARG
        exit 0
        ;;
    h) ### Help command
        help
        exit 0
        ;;
    v) ### Run the testing using Valgrind
        echo "Running With: Valgrind" >&2
        VALGRIND=1
        ;;
    l) ### Run the testing using Lizard
        echo "Running With: Lizard" >&2
        lizard_inst_check
        LIZARD=1
        ;;
    \?) ### Used invalid flag
        echo "Invalid option: -$OPTARG" >&2
        exit 0
        ;;
    :) ### The flag used requires a missing argument
        echo "Option -$OPTARG requires an argument." >&2
        exit 0
        ;;
    esac
done

make test_comp #Compiles the project for testing

echo -e "\n\n----------------------------------"
echo "Starting"
echo "----------------------------------"

passed=0
total=0
exe_test() { #Inspired by: Abread
    input=$1
    test_name=$(basename $input | cut -f 1 -d'.')
    expected=./tests/$test_name.out
    myoutdir=./failed/$test_name.myout
    if ! [ -r $input ]; then
        printf '%b' "$0: cannot read file "$input"\n${red}aborting$reset\n"
        exit 1
    fi
    if ! [ -r $expected ]; then
        printf '%b' "$0: cannot read file $expected\n${red}aborting$reset\n"
        exit 1
    fi
    if make -j1 mof $test_name >/dev/null && make -j1 difl $test_name &>/dev/null; then
        if [ "$(wc -l <failed/$test_name.diff)" -eq 0 ]; then
            printf '%b' "Test $test_name -- ${green}OK$reset\n"
            printf '%b' "$reset"
            exit 0
        fi
    fi
    cp ./tests/$test_name.myout ./failed
    cp ./tests/$test_name.diff ./failed
    printf '%b' "Test $test_name -- ${red}FAILED${reset}\n"
    printf '%b' "$reset"
    exit 0
}

export -f exe_test

nice parallel --progress --eta --bar --joblog failed/logs $@ exe_test ::: ./tests/*.in
# "--jobs 200%" will put the script "running 2 jobs per CPU core"

total=$(cat failed/logs | tail -n +2 | wc -l)
passed=$(cat failed/logs | tail -n +2 | cut -f7 | grep '0' | wc -l)
