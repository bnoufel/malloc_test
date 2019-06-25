#!/usr/bin/env bash
unset HOSTTYPE
EXEC=`pwd`
BOLD="\033[1m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
WHITE="\033[37m"
GREEN="\033[32m"
RED="\033[31m"
NORMAL="\033[0m"
GOOD=${BOLD}${GREEN}√${NORMAL}
WRONG=${BOLD}${RED}x${NORMAL}
MALLOC=${EXEC}/../
NAME=libft_malloc_$(uname -m)_$(uname -s).so
SHORTNAME=libft_malloc.so
LOGS=malloc_test.log
arg=$1
test_files="test1.c|test0.c|test2.c|test3.c|test4.c|test5.c|test3b.c|a_test0.c|a_test0b.c|a_test1.c|a_test2.c|a_test3.c|a_test4.c"
test0=tests/test0
test1=tests/test1
test2=tests/test2
test3=tests/test3
test3b=tests/test3b
test4=tests/test4
test5=tests/test5
a_test0=tests/a_test0
a_test0b=tests/a_test0b
a_test1=tests/a_test1
a_test2=tests/a_test2
a_test3=tests/a_test3
a_test4=tests/a_test4

