#!/usr/bin/env bash
#################################
####### Test author file ########
#################################
test_author() {
	echo -e -n "${BOLD}Author file: "
	if [[ -f ${MALLOC}/auteur ]] && [[ -z $(diff -w <(cat ${MALLOC}/auteur) <(echo "${LOGNAME}")) ]]; then
			test_is_ok
	elif [[ -f ${MALLOC}/author ]] && [[ -z $(diff -w <(cat ${MALLOC}/author) <(echo "${LOGNAME}")) ]];then
			test_is_ok
	else
		test_is_ko
	fi
	echo
}
#################################
######### Test Makefile #########
#################################
test_makefile() {
	echo -e -n "${BOLD}Makefile: "
	make fclean -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	make -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	if [[ $? -eq 0 ]]; then
		test_is_ok
	else
		test_is_ko
	fi
	make fclean -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	if [[ -f ${MALLOC}/${NAME} ]]; then
		test_is_ko
	else
		test_is_ok
	fi
	make fclean -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	export HOSTTYPE=trololo
	NEW_NAME=libft_malloc_${HOSTTYPE}.so
	make -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	if [[ -f "${MALLOC}/${NEW_NAME}" ]];then
		test_is_ok
	else
		test_is_ko
	fi
	make fclean -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	unset HOSTTYPE
	make -C ${MALLOC} 2>> ${LOGS} >> ${LOGS}
	echo
	if [[ ${arg} == "--debug" ]]; then
		echo -e "${BOLD}1)${NORMAL}: Test ${NAME} rules"
		echo -e "${BOLD}2)${NORMAL}: Test fclean rules"
		echo -e "${BOLD}3)${NORMAL}: Test HOSTTYPE"
	fi
}

#################################
########## Basic Test ###########
########## Check basic ##########
########## Check Page ###########
########## Check Free ###########
#################################
test_basic() {
	echo -e -n ${BOLD}Basic test: ${NORMAL}
	basic_test
	if [[ ${arg} == "--debug" ]]; then
		echo -e "${BOLD}1)${NORMAL}: test0.c of the correction ${basic_test_1}"
		echo -e "${BOLD}2)${NORMAL}: test1.c of the correction ${basic_test_2}"
		echo -e "${BOLD}3)${NORMAL}: test2.c of the correction ${basic_test_3}"
		echo -e "${BOLD}4)${NORMAL}: test3.c of the correction ${basic_test_4}"
		echo -e "${BOLD}5)${NORMAL}: Check diff if output is good for test3.c ${basic_test_5}"
		echo -e "${BOLD}6)${NORMAL}: test3++.c of the correction ${basic_test_6}"
		echo -e "${BOLD}7)${NORMAL}: Check diff if output is good for test3++.c ${basic_test_7}"
		echo -e "${BOLD}8)${NORMAL}: test4.c of the correction ${basic_test_8}"
		echo -e "${BOLD}9)${NORMAL}: Check diff if output is good for test4.c ${basic_test_9}"
		echo -e "${BOLD}10)${NORMAL}: test5.c of the correction ${basic_test_10}"
	fi
	echo -e "----------------------------------------------------"
	echo -e -n ${BOLD}Check page: ${NORMAL}
	j=0
	for i in {0..10}
	do
		check_page
		[ $? -eq 0 ] && let "j=j+1"
		page_reclaims
	done
	print_result ${j} 11
	echo -e "${BOLD}${GREEN}${SIGN_GOOD} 5/5 - ${YELLOW}${SIGN_GOOD} 4/5 - ${BLUE}${SIGN_GOOD} 3/5 - ${CYAN}${SIGN_GOOD} 2/5 - ${WHITE}${SIGN_GOOD} 1/5 ${RED}${SIGN_WRONG} 0/5${NORMAL}"
	echo -e "----------------------------------------------------"
	j=0
	echo -e -n ${BOLD}Check free: ${NORMAL}
	for i in {0..10}
	do
		check_free
		[ $? -eq 0 ] && let "j=j+1"
		page_reclaims
	done
	print_result ${j} 11
	echo -e "${BOLD}${GREEN}${SIGN_GOOD} less than 3 pages - ${YELLOW}${SIGN_GOOD} less than 5 pages - ${RED}${SIGN_WRONG} more to 5 pages${NORMAL}"
	echo -e "----------------------------------------------------"
}

#################################
######## Advanced Test ##########
#################################
test_advence () {
	echo -en ${BOLD}Advanced test: ${NORMAL}
	advenced_test
	if [[ ${arg} == "--debug" ]]; then
		echo -e "${BOLD}1)${NORMAL}: ls ${advenced_test_1}"
		echo -e "${BOLD}2)${NORMAL}: ls -l ${advenced_test_2}"
		echo -e "${BOLD}3)${NORMAL}: ls -G ${advenced_test_3}"
		echo -e "${BOLD}4)${NORMAL}: ls -lG ${advenced_test_4}"
		echo -e "${BOLD}5)${NORMAL}: run a_test0.c just test a basic realloc ${advenced_test_5}"
		echo -e "${BOLD}6)${NORMAL}: check diff with output to a_test0 and normally output ${advenced_test_6}"
		echo -e "${BOLD}7)${NORMAL}: run a_test0b.c just test malloc and realloc with size = 0 ${advenced_test_7}"
		echo -e "${BOLD}8)${NORMAL}: check diff with output to a_test0b and normally output ${advenced_test_8}"
		[ -f ${EXEC}/diff/diff_advenced_test_8 ] && cat -e ${EXEC}/diff/diff_advenced_test_8
		echo -e "${BOLD}9)${NORMAL}: run a_test1.c just test malloc and realloc with a smaller size ${advenced_test_9}"
		echo -e "${BOLD}10)${NORMAL}: check diff with output to a_test1 and normally output ${advenced_test_10}"
		[ -f ${EXEC}/diff/diff_advenced_test_10 ] && cat -e ${EXEC}/diff/diff_advenced_test_10
		echo -e "${BOLD}11)${NORMAL}: run a_test2.c just test malloc and realloc with a wrong ptr ${advenced_test_11}"
		echo -e "${BOLD}12)${NORMAL}: check diff with output to a_test2 and normally output ${advenced_test_12}"
		echo -e "${BOLD}13)${NORMAL}: run a_test3.c just test malloc and realloc with a ptr at NULL ${advenced_test_13}"
		echo -e "${BOLD}14)${NORMAL}: check diff with output to a_test3 and normally output ${advenced_test_14}"
		echo -e "${BOLD}15)${NORMAL}: run a_test4c.c just test malloc and realloc with a BIG size (ULONG_MAX) ${advenced_test_15}"
		echo -e "${BOLD}16)${NORMAL}: check diff with output to a_test4 and normally output ${advenced_test_16}"
	fi
	echo "----------------------------------------------------"
}

#################################
########## Bonus Test ###########
#################################
test_bonus() {
	echo -e ${BOLD}Bonus test: ${NORMAL}
	bonus_test
	echo "----------------------------------------------------"
}