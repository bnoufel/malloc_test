#!/usr/bin/env bash
source srcs/include.sh
init
parse_args $@
run_with_arg
run