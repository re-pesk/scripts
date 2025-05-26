#!/usr/bin/env bash

[ $(snap list kotlin | wc -l) == 2 ] && echo Instaliuota ||  echo instaliuok
sudo snap install --classic kotlin
kotlin -version

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/JetBrains/kotlin/releases/latest)"
curl -sSLo- "${url//tag/download}/kotlin-native-prebuilt-linux-x86_64-$(basename -- $url).tar.gz" \
  | tar --transform 'flags=r;s/^kotlin-native[^\/]+/kotlin-native/x' --show-transformed-names -xzvC "$HOME/.local"

appendToBashrc(appName) {
  set_path='[[ ":$PATH:" == *":$HOME/.local/$appName/bin:"* ]] \
    || export PATH="$HOME/.local/$appName/bin${PATH:+:${PATH}}"'
    
  configstrings="#begin $appName init

  ${set_path}

  #end $appName init"

  readarray -td '
  ' configArray <<< "$configstrings"

  sed -i "/${configArray[0]}/,/${configArray[@]: -1:1}/c\\" "$HOME/.bashrc"

  [[ "$( tail -n 1 "$HOME/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "$HOME/.bashrc"

  echo "$configstrings" >> "$HOME/.bashrc"

  eval $"$set_path"
}

appendToBash "kotlin-native"
kotlin-native -version
