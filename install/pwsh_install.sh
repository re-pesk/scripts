#! /usr/bin/env bash

echo
sudo apt-get update && sudo apt-get upgrade -y
echo
required=(wget apt-transport-https software-properties-common)
aptList=$(apt list "${required[@]}" 2>/dev/null | tail +2 )

# Funkcija, tikrinanti, ar paketas suinstaliuotas
# (1 - suinstaliuotas, 0 - ne)
isInList() {
  echo "$(grep "^$1" 2>/dev/null 2>/dev/null <<<"$aptList" | wc -l )"
}

# Funkcija, tikrinanti, ar paketas suinstaliuotas
# (1 - suinstaliuotas, 0 - ne)
isInstalled() {
  echo "$(grep "^$1.*installed" 2>/dev/null <<<"$aptList" | wc -l )"
}

# Funkcija, grąžinanti nesuinstaliuotų paketų sąrašą 
getNotInstalledList() {
  local notinstalled=()
  input=($(printf '%s\n' ${required[@]} | sort))
  for var in "${input[@]}";do
    checkResult="$(isInList "$var")"
    if [[ $checkResult < 1 ]];then
      echo -e "\nKlaida! Paketo $var nėra galimų instaliuoti paketų sąraše!\n"
      exit
    fi
    checkResult="$(isInstalled "$var")" 
    if [[ $checkResult < 1 ]];then
      notinstalled+=("$var")
    fi
  done
  echo "${notinstalled[@]}"
}

notInstalledList=$(getNotInstalledList)
sudo apt-get install -y "${notInstalledList[@]}"
echo 

if [ "$?" -ne 0 ]; then
  echo -e "\nKlaida instaliuojant ${notInstalledList[@]}!\n"
  exit $exitCode
fi

if [[ "$(isInstalled packages-microsoft-prod)" < 1 ]];then
  VERSION_ID="$( cat /etc/os-release | grep 'VERSION_ID' | sed -r 's/^VERSION_ID="([^"]+)"$/\1/' )"
  wget -q https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb
  rm packages-microsoft-prod.deb
  echo
fi

sudo apt-get update

echo

[[ "$(isInList powershell)" == 1 && "$(isInstalled powershell)" < 1 ]] && sudo apt-get install -y powershell && echo

pwsh -Version

echo
