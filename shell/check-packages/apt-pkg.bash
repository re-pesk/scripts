#!/usr/bin/env bash

errorMessage() {
  # shellcheck disable=SC2016
  echo -e "\n$1"'

Usage:

./chk_pkgs.sh -[-aeinp] packageName1 packageName2 ... packageNameN
  Options:
  -h            - show help
  -p            - show names and status of all packages
  -a            - show names of all packages only (without status)
  -i            - show names of installed packages only
  -n            - show names of not installed packages only
  -e            - show names that are not in the list of packages
  -r            - output content of resulting associative array instead of result string
  -- or none    - show all info

  To get output as multiline string to use in other command:

  apt install $(./check-packages-w-apt.bash -[aeinp] packageName1 packageName2 ... packageNameN)

  To get output as associative array:

  declare -A associative_array="("$(./check_packages.bash (--|-r[aeinp])? packageName1 packageName2 ... packageNameN)")"

' >&2
  exit 1
}

# Process options
[[ "$*" == "" ]] && errorMessage 'Missed arguments!'

# Get options, if its are provided
input="$*"
options="-"
if [[ "$1" =~ ^- ]];then
  options="${1:1}"
  input="${*:2}"
fi

# Check if options are allowed
[[ "${options}" =~ ^(-|h|r?[aeinp]{1,5})$ ]] || errorMessage 'Error! Unknown option'

# Check if option requires to show help message
[[ "${options}" =~ ^h$ ]] && errorMessage 'This is help message'

# Check if pachage names are provided
[[ "${input[*]}" == "" ]] && errorMessage 'Missed package names!'

# Convert input string with package names to multiline string and sort it
# shellcheck disable=SC2068
input="$(printf "%s\n" ${input[@]} | sort )"

# Get package names with installation status by 'apt list' command
# shellcheck disable=SC2068
packages=$(apt list ${input[@]} 2> /dev/null | tail +2 | sed -E 's/\/[^\[]+/ /;s/ $/ [not installed]/')

# If there is no package in the list, add all names to not_package list 
if [[ "${packages}" == "" ]]; then
  not_package="${input[*]}"
else # otherwise get names, lists of installed and not_installed packages, and not_package names to separate lists
  names=$(echo "${packages}" | sed -E 's/ \[[^\[]+\]$//')
  installed=$(echo "${packages}" | grep -P "\[installed" | sed -E 's/ \[[^\[]+\]$//')
  not_installed=$(echo "${packages}" | grep -P "\[not installed" | sed -E 's/ \[[^\[]+\]$//')
  not_package=$(printf "%s\n" "${input[@]}" | grep -vP "${names//$'\n'/|}")
fi

if [[ "{-,r}" =~ [${options}] ]]; then

  # Declare associative array 
  declare -A result=()

  # Add lists in multiline string format to associative array, if appropriate option was provided
  [[ "{-,p}" =~ [${options}] ]] && result["packages"]="${packages}"
  [[ "{-,a}" =~ [${options}] ]] && result["names"]="${names}"
  [[ "{-,i}" =~ [${options}] ]] && result["installed"]="${installed}"
  [[ "{-,n}" =~ [${options}] ]] && result["not_installed"]="${not_installed}"
  [[ "{-,e}" =~ [${options}] ]] && result["not_package"]="${not_package}"

  # Print content of associative array to console
  printf '\n[%s]="%s"\n' "${result[@]@k}"
 
  echo

  # To get output as associative array:
  # declare -A associative_array="("$(./check_packages.bash (--|-r[aeinp])? packageName1 packageName2 ... packageNameN)")"

else

  case ${options} in
    ( *[-p]* ) echo "${packages}";;
    ( *[-a]* ) echo "${names//$'\n'/ }";;
    ( *[-i]* ) echo "${installed//$'\n'/ }";;
    ( *[-n]* ) echo "${not_installed//$'\n'/ }";;
    ( *[-e]* ) echo "${not_package//$'\n'/ }";;
    (*) errorMessage "Error! An unknown option";;
  esac

  # To get output as multiline string to use in other command:
  # apt install $(./check-packages-w-apt.bash -[aeinp] packageName1 packageName2 ... packageNameN)

fi
