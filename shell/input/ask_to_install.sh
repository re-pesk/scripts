#! /usr/bin/env bash

ask_to_install() {
  local current_version="${1}"
  local version="${2}"
  local app_name="${3}"
  local install_dir="${4}"
  local to_install=""

  # If the app is not working
  if [ "${current_version}" == "" ]; then
    printf "\n${app_name} is not installed. Do you want to install v${version}?"
  # If the app is working, but installed not in the specified directory
  elif [ ! -d "${install_dir}" ]; then
    printf "\n${app_name} v${current_version} is installed, but not in ${install_dir}. Delete it first manually and then run this script again.\n"
    to_install="n"
  # If the app is working and installed in the specified directory
  else
    printf "\n${app_name} v${current_version} is installed. Do you want overwrite it with v${version}?"
  fi

  # If the program is not installed differently than specified int this script.
  if [ "${to_install}" != "n" ]; then
    printf "\nPrint 'y' to install, 'n' or <Enter> to exit: \e[s"
    read -e -r to_install
    [[ "${to_install}" == "" ]] && printf "\e[u<Enter>\n"
  fi

  # If the program will not be installed.
  [[ "${to_install}" != "y" ]] && { printf "\nNo changes were made.\n\n"; exit 0; }

  # If the program will be installed.
  printf "\nInstalling ${app_name} v${version}\n\n"
}

# ask_to_install "3.9.8" "3.9.9" "Scala" "${HOME}/.opt/scala3"
ask_to_install "$1" "$2" "$3" "$4"
