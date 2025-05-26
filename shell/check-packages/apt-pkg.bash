#!/usr/bin/env bash

errorMessage() {
  # shellcheck disable=SC2016
  echo -e "\n$1"'

Usage:

./chk_pkgs.sh -[-aeinp] packageName1 packageName2 ... packageNameN
  Options:
  -h            - show [h]elp
  -p            - show names and status of all [p]ackages
  -a            - show names of [a]ll packages (names only without status)
  -i            - show names of [i]nstalled packages only
  -n            - show names of [n]ot installed packages only
  -o            - show names that are n[o]t in the package list
  -r[ainop]     - output content of resulting associative array instead of result string
  -- or none    - show all info

  To get output as multiline string to use in other command:

  apt list $(./apt-pkg.bash -[ainop] packageName1 packageName2 ... packageNameN)

  To get output as associative array:

  declare -A associative_array="("$(./apt-pkg.bash (--|-r[ainop]+)? packageName1 packageName2 ... packageNameN)")"

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
[[ "${options}" =~ ^(-|h|r[ainop]{1,5}|a|i|n|o|p)$ ]] || errorMessage 'Error! Unknown option'

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
# If there is no package in the list, add all names to non_packages list 
if [[ "${packages}" == "" ]]; then
  non_packages="${input[*]}"
else # otherwise get names, lists of installed and not_installed packages, and non_packages names to separate lists
  names=$(echo "${packages}" | sed -E 's/ \[[^\[]+\]$//')
  installed=$(echo "${packages}" | grep -P "\[installed" | sed -E 's/ \[[^\[]+\]$//')
  not_installed=$(echo "${packages}" | grep -P "\[not installed" | sed -E 's/ \[[^\[]+\]$//')
  non_packages=$(printf "%s\n" "${input[@]}" | grep -vP "${names//$'\n'/|}")
fi

# Declare associative array 
declare -A result=()

# Add lists in multiline string format to associative array, if appropriate option was provided
[[ "{-,p}" =~ [${options}] ]] && result["packages"]="${packages}"
[[ "{-,a}" =~ [${options}] ]] && result["names"]="${names}"
[[ "{-,i}" =~ [${options}] ]] && result["installed"]="${installed}"
[[ "{-,n}" =~ [${options}] ]] && result["not_installed"]="${not_installed}"
[[ "{-,o}" =~ [${options}] ]] && result["non_packages"]="${non_packages}"

if [[ "{-,r}" =~ [${options}] ]]; then

  # Print content of associative array to console
  for key in packages names installed not_installed non_packages ;do
    [[ " ${!result[*]} " =~ [[:space:]]${key}[[:space:]] ]] && printf '\n[%s]="%s"\n' "$key" "${result[$key]}"
  done
  
  echo

  # To get output as associative array:
  # declare -A associative_array="("$(./apt_pkg.bash (--|-r[ainop]{1,5})? packageName1 packageName2 ... packageNameN)")"

else

  case ${options} in
    ( *[-p]* ) echo ${result["packages"]};;
    ( *[-a]* ) echo ${result["names"]};;
    ( *[-i]* ) echo ${result["installed"]};;
    ( *[-n]* ) echo ${result["not_installed"]};;
    ( *[-o]* ) echo ${result["non_packages"]};;
    (*) errorMessage "Error! An unknown option";;
  esac

  # To get output as multiline string to use in other command:
  # apt install $(./apt-pkg.bash -[ainop] packageName1 packageName2 ... packageNameN)

fi
