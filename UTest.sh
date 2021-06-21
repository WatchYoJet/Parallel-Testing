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


###  Using case statements to handle the flags
while getopts ":m:hvl" opt; do 
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
    \?) ### Used invalid flag
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)  ### The flag used requires a missing argument
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done



exe_test(){

    input=$1
	test_name=$(basename $input | cut -f 1 -d'.')
	expected=tests/$test_name.out
	myout=failed/$name.myout
    cat $input
    if ! [ -r $input ]; then
		printf '%b' "$0: cannot read file "$input"\n${red}aborting$reset\n"
		exit 1
	fi
	if ! [ -r $expected ]; then
		printf '%b' "$0: cannot read file $expected\n${red}aborting$reset\n"
		exit 1
	fi
	if make -j1 $myout > /dev/null && diff -b $expected $out &> /dev/null; then
		printf '%b' "Test $test_name -- ${green}OK$reset\n"
	else
		printf '%b' "Test $test_name -- ${red}FAILED${reset}\n"
		diff --color -b $expected $out
		printf '%b' "$reset"
		exit 1
	fi
}

export -f exe_test

nice parallel --progress --eta --bar --joblog failed/logs $@ exe_test ::: ./tests/*.in