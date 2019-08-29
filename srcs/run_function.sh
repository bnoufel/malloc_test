#!/bin/bash
help() {
	echo "--debug: Permet d'afficher les options de debuggages (erreurs / diff etc.)"
	echo "--all: Permet de faire un tests complet."
	echo "--author: Permet de tester le fichier auteur/author"
	echo "--makefile: Permet de tester le Makefile"
	echo "--basic: Permet de réaliser des tests basiques"
	echo "--advance: Permet de réaliser des tests avancés"
	echo "--bonus: Permet de réaliser des tests bonus"
}

init() {
	#################################
	######## Remove Log File ########
	#################################
	rm -f ${LOGS}
	echo -e "${BOLD}${BLUE}Compile lib...${NORMAL}"
	copy_lib
	echo -e "${BOLD}${BLUE}Compile test...${NORMAL}"
	compile_test
}
parse_args() {
	for args in $@
	do
		if [[ ${args} == "--all" ]]; then
			all="true"
		elif [[ ${args} == "--debug" ]]; then
			debug="true"
		elif [[ ${args} == "--author" ]]; then
			author="true"
		elif [[ ${args} == "--makefile" ]]; then
			makefile="true"
		elif [[ ${args} == "--basic" ]]; then
			basic="true"
		elif [[ ${args} == "--advanced" ]]; then
			advanced="true"
		elif [[ ${args} == "--bonus" ]]; then
			bonus="true"
		elif [[ ${args} == "--help" ]]; then
			help="true"
		else
			echo -e "${BOLD}${RED}Unknown arg: ${YELLOW}${args}${NORMAL}"
			help
			echo -e "${BOLD}${YELLOW}Bye!${NORMAL}";
			exit;
		fi
	done
}
noarg=false
if [[ $# -eq 0 ]] || ([[ $# -eq 1 ]] && [[ $1 == "--debug" ]]); then
	noarg=true
fi
run_with_arg() {
	while true
	do
		if [[ ${help} == "true" ]]; then
			help;
			exit;
		elif [[ ${noarg} == "true" ]]; then
			break;
		elif [[ ${all} == "true" ]]; then
			test_all;
			all=false
		elif [[ ${author} == "true" ]]; then
			test_author;
			author=false
		elif [[ ${makefile} == "true" ]]; then
			test_makefile;
			makefile=false
		elif [[ ${basic} == "true" ]]; then
			test_basic;
			basic=false
		elif [[ ${advanced} == "true" ]]; then
			test_advanced;
			advanced=false
		elif [[ ${bonus} == "true" ]]; then
			test_bonus;
			bonus=false
		else
			run;
		fi
	done
}

run() {
	while true; do
		echo -e "${BOLD}What would you like to test.${NORMAL}"
		echo "1) Test author file."
		echo "2) Test makefile."
		echo "3) Basic test."
		echo "4) Advenced test."
		echo "5) Bonus test."
		echo "6) All."
		echo "9) Exit."
		echo -n "Your choice: "
		read choice
		echo
		case ${choice} in
			1) test_author;;
			2) test_makefile;;
			3) test_basic;;
			4) test_advanced;;
			5) test_bonus;;
			6) test_all; echo -e "${BOLD}${YELLOW}Bye!${NORMAL}";exit;;
			9) echo -e "${BOLD}${YELLOW}Bye!${NORMAL}";exit;;
			*) echo -e "${BOLD}${RED}Wrong choice${NORMAL}";;
		esac
	done

	#################################
	############ Legend #############
	#################################
	legende
	delete_bin
}