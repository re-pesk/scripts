#!/usr/bin/env bash

[ $(snap list kotlin | wc -l) == 2 ] && echo Instaliuota ||  echo instaliuok
sudo snap install --classic kotlin
kotlin -version

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/JetBrains/kotlin/releases/latest)"
version="$(basename -- $url)"
curl -sSLo- "${url//tag/download}/kotlin-native-prebuilt-linux-x86_64-${version}.tar.gz" \
  | tar --transform 'flags=r;s/^kotlin-native[^\/]+/kotlin-native/x' --show-transformed-names -xzvC "${HOME}/.local"

appendToBashrc(app_name) {
  set_path='[[ ":${PATH}:" == *":${HOME}/.local/kotlin-native/bin:"* ]] \
    || export PATH="${HOME}/.local/'$app_name'/bin${PATH:+:${PATH}}"'
    
  config_strings="#begin ${app_name} init

  ${set_path}

  #end ${app_name} init"

  readarray -td '
  ' config_array <<< "$config_strings"

  sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.bashrc"

  [[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

  echo "$config_strings" >> "${HOME}/.bashrc"

  eval $"$set_path"
}

appendToBash "kotlin-native"
kotlin-native -version
