#! /usr/bin/env -S bash

errorMessage() {
  echo -e "\n$1!"'
Usage:
./installed.sh [options] packageName1, packageName2, ..., packageNameN
  Options:
  "-i"            - show only names of installed packages
  "-n"            - show only names of not installed packages
  "-a" or none    - show names and status of all packages
'
  exit
}

[[ "$@" == "" ]] && errorMessage 'Missed arguments!'

input="$@"
option="-a"
if [[ "$1" =~ ^- ]];then
  option="$1"
  input="${@:2}"
fi

[[ "$option" =~ ^-[ain]$ ]] || errorMessage 'Unknown option'

input=($(printf '%s\n' ${input[@]} | sort))

[[ "${input[@]}" == "" ]] && errorMessage 'Missed package names!'

getAptList() {
  echo "$(apt list "$@" 2>/dev/null | tail +2 )"
}

aptLines="$(getAptList "${input[@]}")"

isInList() {
  echo "$(grep "^$1" 2>/dev/null <<<"$aptLines" | wc -l )"
}

isInstalled() {
  echo "$(grep "^$1.*installed" 2>/dev/null <<<"$aptLines" | wc -l )"
}

getPkgStatusList() {
  local -a pkgList=()
  for var in "$@";do
    checkResult="$(isInList "$var")"
    if [[ "$checkResult" < 1 ]];then
      echo -e "Error! '$var' is not in the list of available packages!"
      exit 1
    fi
    checkResult="$(isInstalled "$var")"
    case "$option" in
      -i)
        [[ "$checkResult" < 1 ]] && continue 1 ;;
      -n)
        [[ "$checkResult" == 1 ]] && continue 1 ;;
    esac
    pkgList+=('['$var']="'"$checkResult"'"')
  done
  echo "${pkgList[@]}"
}

resultString=$(getPkgStatusList ${input[@]})

[[ "$?" != 0 ]] && echo -e "\n$resultString\n" && exit 1

if [[ $option =~ ^-a$ ]];then 
  echo "${resultString[@]}"
  exit   
fi

eval "declare -A pkgList=($resultString)"
echo $(printf '%s\n' ${!pkgList[@]} | sort)
