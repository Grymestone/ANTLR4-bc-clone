#!/bin/bash

# Where antlr files
calculator_path="../"
# Name of lexer
lexer_name="calculator"
# Current directory
where=$(pwd)

# Percision
scale=16

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m'

passed=0
failed=0
for entry in *.bc
do
    cd $where
    printf "${CYAN}---- Running test $entry ----${NC}\n"
    bc_output=$(bc -l <(echo "scale=${scale}"; cat $entry; printf "quit"))
    cd $calculator_path
    antlr_output=$(grun $lexer_name exprList "$where/$entry")
    
    if [ "$bc_output" == "$antlr_output" ]
    then
        printf "${GREEN}PASS:${NC} $entry\n"
        passed=$((passed+1))
    else
        printf "${RED}FAILED:${NC} $entry\n"
        failed=$((failed+1))
    fi
    printf "Expected:\n$bc_output\n"
    printf "Got:\n$antlr_output\n"
done

printf "${CYAN}---- Result: ----${NC}\n"
printf "Passed: ${GREEN}$passed ${NC}\n"
printf "Failed: ${RED}$failed ${NC}\n"


