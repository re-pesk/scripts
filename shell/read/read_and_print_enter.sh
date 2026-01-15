#! /usr/bin/env bash

printf "Do you want overwrite it?
Print 'y' to overwrite. Print 'n' or <Enter> to exit: \e[s"
read TO_INSTALL
[[ "${TO_INSTALL}" == "" ]] && printf "\e[u<Enter>\n"
printf "\n"

echo "TO_INSTALL: '${TO_INSTALL}'"
