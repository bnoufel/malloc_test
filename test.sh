#!/usr/bin/env bash
source srcs/include.sh

#################################
######## Remove Log File ########
#################################
rm -f ${LOGS}
copy_lib
compile_test
test_author
test_makefile

#################################
####### Get Page Reclaim ########
#################################
page_reclaims
echo "----------------------------------------------------"
test_basic
test_advence
test_bonus
#################################
############ Legend #############
#################################
legende
#delete_bin