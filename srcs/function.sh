#!/usr/bin/env bash

delete_bin() {
	for file in $(ls tests/ | grep -v -E ${test_files})
	do
		rm -f tests/${file}
	done
}

########################################
###### $1 = Result
###### $2 = nb max test
########################################

print_result() {
	moyenne=$(($2/2))
	quart=$(($2/4))
	good=$((moyenne+quart))
	echo
	if [[ "$1" -gt "${good}" ]]; then
		echo -e "${BOLD}Result${NORMAL}: ${GREEN}$1/$2${NORMAL}"
	elif [[ "$1" -gt "${moyenne}" ]]; then
		echo -e "${BOLD}Result${NORMAL}: ${YELLOW}$1/$2${NORMAL}"
	else
		echo -e "${BOLD}Result${NORMAL}: ${RED}$1/$2${NORMAL}"
	fi
}
#################################
######### Compile tests #########
#################################
compile_test() {
	delete_bin
	gcc ${test0}.c -o ${test0}
	gcc ${test1}.c -o ${test1}
	gcc ${test2}.c -o ${test2}
	gcc ${test3}.c -o ${test3}
	gcc ${test3b}.c -o ${test3b}
	gcc ${test4}.c -o ${test4}
	gcc -Wno-unused-result -Wno-integer-overflow -Wno-array-bounds ${test5}.c -L. -lft_malloc -o ${test5}
	gcc ${a_test0}.c -o ${a_test0}
	gcc ${a_test0b}.c -o ${a_test0b}
	gcc ${a_test1}.c -o ${a_test1}
	gcc ${a_test2}.c -o ${a_test2}
	gcc ${a_test3}.c -o ${a_test3}
	gcc ${a_test4}.c -o ${a_test4}
}
#################################
############ Copy Lib ###########
#################################
copy_lib() {
	make -C ${MALLOC} >> ${LOGS}
	cp ${MALLOC}/${SHORTNAME} .
	cp ${MALLOC}/${NAME} .
	make fclean -C ${MALLOC}  >> ${LOGS}
}

page_reclaims(){
	res_test0=$(/usr/bin/time -l ./run.sh ${test0} 2>&1 | grep "page reclaims" | cut -dp -f 1 | tr -s ' ')
	res_test1=$(/usr/bin/time -l ./run.sh ${test1} 2>&1 | grep "page reclaims" | cut -dp -f 1 | tr -s ' ')
	res_test2=$(/usr/bin/time -l ./run.sh ${test2} 2>&1 | grep "page reclaims" | cut -dp -f 1 | tr -s ' ')
}
print_page() {
	if [[ ${arg} = "--debug" ]]; then
		echo -en "$4($((${res_test1}-${res_test0})) - more to $1 pages and less than $2) ($3/5)${NORMAL} "
	fi
}
legende() {
	echo -e "${BOLD}Legend: ${NORMAL}"
	echo -e "${RED}[IHI]${NORMAL}: Illegal hardware instruction."
	echo -e "${RED}[S]${NORMAL}: Segmentation fault."
	echo -e "${RED}[B]${NORMAL}: Bus Error."
	echo -e "${RED}[A]${NORMAL}: Abort."
}
print_error() {
	if [[ $1 -eq 0 ]]; then
		test_is_ok
	elif [[ $1 -eq 132 ]]; then
		echo -en "${RED}[IHI]${NORMAL} "
	elif [[ $1 -eq 134 ]]; then
		echo -en "${RED}[A]${NORMAL} "
	elif [[ $1 -eq 138 ]]; then
		echo -en "${RED}[B]${NORMAL} "
	elif [[ $1 -eq 139 ]]; then
		echo -en "${RED}[S]${NORMAL} "
	else
		test_is_ko
	fi
}

test_is_ok() {
	if [[ -z $1 ]]; then
		echo -e -n "${BOLD}${GOOD} "
	else
		echo -e -n "${BOLD}$1${SIGN_GOOD}${NORMAL} "
	fi
}

test_is_ko() {
	echo -e -n "${WRONG} "
}

basic_test() {
	i=0
	./run.sh ${test0} 2>&- 1>&-
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	./run.sh ${test1} 2>&- 1>&-
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	./run.sh ${test2} 2>&- 1>&-
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	res_test3=$(./run.sh ${test3} 2>&-)
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	if [[ -n $(diff <(echo ${res_test3}) <(./${test3})) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_test3b=$(./run.sh ${test3b} 2>&-)
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	if [[ -n $(diff <(echo ${res_test3b}) <(./${test3b})) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_test4=$(./run.sh ${test4} 2>&-)
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	if [[ -n "$(diff <(echo ${res_test4}) <(echo -e "Bonjour\n"))" ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	./run.sh ${test5} 2>&- 1>&-
	print_error $?
	[ $? -eq 0 ] && let "i=i+1"
	print_result ${i} 10
}

check_page() {
	diff=$((${res_test1}-${res_test0}))
	if [[ ${diff} -lt 255 ]]; then
		test_is_ko
		echo "Malloc fail !" >> ${LOGS}
		echo -n "Diff between test1 and test0: " >> ${LOGS}
		echo $((${res_test1}-${res_test0})) >> ${LOGS}
		if [[ ${arg} == "--debug" ]]; then
			echo -en "${RED}($((${res_test1}-${res_test0})) - less than 255 pages)${NORMAL} "
		fi
		return 1
	elif [[ ${diff} -ge 255 && ${diff} -le 272 ]]; then
		test_is_ok
		print_page 255 272 5 ${GREEN}
	elif [[ ${diff} -gt 272 && ${diff} -le 312 ]]; then
		test_is_ok ${YELLOW}
		print_page 273 312 4 ${YELLOW}
	elif [[ ${diff} -gt 312 && ${diff} -le 512 ]]; then
		test_is_ok ${BLUE}
		print_page 313 512 3 ${BLUE}
	elif [[ ${diff} -gt 512 && ${diff} -le 1022 ]]; then
		test_is_ok ${CYAN}
		print_page 513 1022 2 ${CYAN}
	elif [[ ${diff} -gt 1022 ]]; then
		test_is_ok ${WHITE}
		if [[ ${arg} == "--debug" ]]; then
			echo -en "${WHITE}($((${res_test1}-${res_test0})) - more to 1022 pages) (1/5)${NORMAL} "
		fi
	fi
	return 0
}

check_free() {
	diff=$((${res_test2}-${res_test0}))
	if [[ ${diff} -le 3 ]]; then
		test_is_ok
		if [[ ${arg} == "--debug" ]]; then
			echo -en "${GREEN}($((${res_test2}-${res_test0})))${NORMAL} "
		fi
		return 0
	elif [[ ${diff} -le 5 ]]; then
		test_is_ok ${YELLOW}
		echo "Free maybe fail !" >> ${LOGS}
		echo -n "Diff between test2 and test0: " >> ${LOGS}
		echo $((${res_test2}-${res_test0})) >> ${LOGS}
		if [[ ${arg} == "--debug" ]]; then
			echo -en "${YELLOW}($((${res_test2}-${res_test0})))${NORMAL} "
		fi
		return 0
	else
		test_is_ko
		echo "Free fail !" >> ${LOGS}
		echo -n "Diff between test2 and test0: " >> ${LOGS}
		echo $((${res_test2}-${res_test0})) >> ${LOGS}
		if [[ ${arg} == "--debug" ]]; then
			echo -en "${RED}($((${res_test2}-${res_test0})))${NORMAL} "
		fi
		return 1
	fi
}

advenced_test() {
	i=0
	./run.sh ls 2>&- 1>&-
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	./run.sh ls -l 2>&- 1>&-
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	./run.sh ls -G 2>&- 1>&-
	err=$?
	print_error $?
	[ ${err} -eq 0 ] && let "i=i+1"
	./run.sh ls -lG 2>&- 1>&-
	err=$?
	print_error $?
	[ ${err} -eq 0 ] && let "i=i+1"
	res_atest0=$(./run.sh ${a_test0} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest0}) <(echo -e "Malloc OK\nRealloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_atest0b=$(./run.sh ${a_test0b} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest0b}) <(echo -e "Malloc OK\nRealloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_atest1=$(./run.sh ${a_test1} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest1}) <(echo -e "Malloc OK\nRealloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_atest2=$(./run.sh ${a_test2} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest2}) <(echo -e "Malloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_atest3=$(./run.sh ${a_test3} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest3}) <(echo -e "Malloc OK\nRealloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	res_atest4=$(./run.sh ${a_test4} 2>&-)
	err=$?
	print_error ${err}
	[ ${err} -eq 0 ] && let "i=i+1"
	if [[ -z $(diff <(echo ${res_atest4}) <(echo -e "Malloc OK")) ]]; then
		test_is_ok
		let "i=i+1"
	else
		test_is_ko
	fi
	print_result ${i} 16
}

bonus_test() {
	if [[ -n $(grep "calloc" ${MALLOC}/**/*.c 2> /dev/null) ]] || [[ -n $(grep "calloc" ${MALLOC}/*.c 2> /dev/null) ]]; then
		echo -en "${BOLD}calloc: ${NORMAL}"
		test_is_ok
		echo
	else
		echo -en "${BOLD}calloc: ${NORMAL}"
		test_is_ko
		echo
	fi
	if [[ -n $(grep "reallocf" ${MALLOC}/**/*.c 2> /dev/null) ]] || [[ -n $(grep "reallocf" ${MALLOC}/*.c 2> /dev/null) ]]; then
		echo -en "${BOLD}reallocf: ${NORMAL}"
		test_is_ok
		echo
	else
		echo -en "${BOLD}reallocf: ${NORMAL}"
		test_is_ko
		echo
	fi
	echo -en "${BOLD}Thread safe: ${NORMAL}"
	if [[ -n $(grep "pthread_" ${MALLOC}/**/*.c) ]] || [[ -n $(grep "pthread_" ${MALLOC}/*.c) ]]; then
		echo -n "This test may be long.... "
		../run.sh gcc ${test0}.c -o bonjour 2>&- 1>&-
		print_error $?
	else
		test_is_ko
	fi
	echo
}