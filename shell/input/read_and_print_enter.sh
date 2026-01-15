#! /usr/bin/env bash

printf "Do you want overwrite it?
Print 'y' to overwrite. Print 'n' or <Enter> to exit: \e[s"
read -e -r TO_INSTALL
[[ "${TO_INSTALL}" == "" ]] && printf "\e[u<Enter>\n"

printf "\nTO_INSTALL: '${TO_INSTALL}'"
