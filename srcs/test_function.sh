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
		echo -e "${BOLD}1)${NORMAL}: test0.c of the correction"
		echo -e "${BOLD}2)${NORMAL}: test1.c of the correction"
		echo -e "${BOLD}3)${NORMAL}: test2.c of the correction"
		echo -e "${BOLD}4)${NORMAL}: test3.c of the correction"
		echo -e "${BOLD}5)${NORMAL}: Check diff if output is good for test3.c"
		echo -e "${BOLD}6)${NORMAL}: test3++.c of the correction"
		echo -e "${BOLD}7)${NORMAL}: Check diff if output is good for test3++.c"
		echo -e "${BOLD}8)${NORMAL}: test4.c of the correction"
		echo -e "${BOLD}9)${NORMAL}: Check diff if output is good for test4.c"
		echo -e "${BOLD}10)${NORMAL}: test5.c of the correction"
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
		echo -e "${BOLD}1)${NORMAL}: ls"
		echo -e "${BOLD}2)${NORMAL}: ls -l"
		echo -e "${BOLD}3)${NORMAL}: ls -G"
		echo -e "${BOLD}4)${NORMAL}: ls -lG"
		echo -e "${BOLD}5)${NORMAL}: a_test0.c of the correction"
		echo -e "${BOLD}6)${NORMAL}: a_test0b.c of the correction"
		echo -e "${BOLD}7)${NORMAL}: a_test1.c of the correction"
		echo -e "${BOLD}8)${NORMAL}: a_test2.c of the correction"
		echo -e "${BOLD}9)${NORMAL}: a_test3.c of the correction"
		echo -e "${BOLD}10)${NORMAL}: a_test4.c of the correction"
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