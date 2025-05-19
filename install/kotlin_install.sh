#!/usr/bin/env bash

[ $(snap list kotlin | wc -l) == 2 ] && echo Instaliuota || echo instaliuok
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

  sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.pathrc"

  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

  echo "$config_strings" >> "${HOME}/.pathrc"

  eval $"$set_path"
}

appendToBash "kotlin-native"
kotlin-native -version

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/JetBrains/kotlin/releases/latest)"
curl -sSLo- "${url//tag/download}/kotlin-native-prebuilt-linux-x86_64-$(basename -- $url).tar.gz" \
| tar --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

sed -i '/#begin kotlin init/,/#end kotlin init/c\' "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin kotlin init

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

#end kotlin init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

kotlinc-native -version  
