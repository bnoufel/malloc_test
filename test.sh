#!/usr/bin/env bash
source srcs/include.sh

#################################
######## Remove Log File ########
#################################
rm -f ${LOGS}

#################################
######### Test Makefile #########
#################################
make -C ${MALLOC} >> ${LOGS}

#################################
############ Copy Lib ###########
#################################
cp ${MALLOC}/${SHORTNAME} .
cp ${MALLOC}/${NAME} .
make fclean -C ${MALLOC}
#################################
######### Compile tests #########
#################################
compile_test

#################################
####### Test author file ########
#################################
echo -e -n "${BOLD}Author file: "
if [[ -f ${MALLOC}/auteur ]]; then
	if [[ -z $(diff -w <(cat ${MALLOC}/auteur) <(echo -e "${LOGNAME}\n")) ]]; then
		test_is_ok
	else
		test_is_ko
	fi
elif [[ -f ${MALLOC}/author ]]; then
	if [[ -z $(diff -w <(cat ${MALLOC}/author) <(echo  "${LOGNAME}")) ]]; then
		test_is_ok
	else
		test_is_ko
	fi
else
	test_is_ko
fi
echo

#################################
######### Test Makefile #########
#################################
echo -e -n "${BOLD}Makefile: "
make -C ${MALLOC} 1>2 2>&-
if [[ $? -eq 0 ]]; then
	test_is_ok
else
	test_is_ko
fi
make fclean -C ${MALLOC} > /dev/null
if [[ -f ${MALLOC}/${NAME} ]]; then
	test_is_ko
else
	test_is_ok
fi
make -C ${MALLOC} > /dev/null
if [[ $(make -C ${MALLOC}) == "make: Nothing to be done for \`all'." ]]; then
	test_is_ok
else
	test_is_ko
fi
echo
if [[ ${arg} == "--debug" ]]; then
	echo -e "${BOLD}First test${NORMAL}: Test ${NAME} rules"
	echo -e "${BOLD}Second test${NORMAL}: Test fclean rules"
	echo -e "${BOLD}Third test${NORMAL}: Test if Makefile relink"
fi
#################################
####### Get Page Reclaim ########
#################################
page_reclaims

echo "----------------------------------------------------"

#################################
########## Basic Test ###########
########## Check basic ##########
########## Check Page ###########
########## Check Free ###########
#################################
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
echo -e -n ${BOLD}Check page: ${NORMAL}
for i in {0..10}
do
	check_page
	page_reclaims
done
echo -e "\n${BOLD}${GREEN}√ 5/5 - ${YELLOW}√ 4/5 - ${BLUE}√ 3/5 - ${CYAN}√ 2/5 - ${WHITE}√ 1/5 ${RED}x 0/5${NORMAL}"
echo -e -n ${BOLD}Check free: ${NORMAL}
for i in {0..10}
do
	check_free
	page_reclaims
done
echo -e "\n${BOLD}${GREEN}√ less than 3 pages - ${YELLOW}√ less than 5 pages - ${RED}x more to 5 pages${NORMAL}"
echo -e "----------------------------------------------------"
#################################
######## Advanced Test ##########
#################################
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
#################################
########## Bonus Test ###########
#################################
echo -e ${BOLD}Bonus test: ${NORMAL}
bonus_test
echo "----------------------------------------------------"
#################################
############ Legend #############
#################################
legende
#delete_bin