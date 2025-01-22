#!/usr/bin/env bash

fileNameEnd="x86_64-pc-linux.tar.gz"
installDir=".local/scala3"

[[ $(apt list --installed jq 2> /dev/null | wc -l) == 1 ]] && sudo apt-get install jq 

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)"
curl -sSLo- "${url//tag/download}/scala3-$(basename -- $url)-${fileNameEnd}" \
| tar --transform 'flags=r;s/^scala3[^\/]+/scala3/x' --show-transformed-names -xzvC "${HOME}/.local"

set_path='[[ ":${PATH}:" == *":${HOME}/.local/scala3/bin:"* ]] \
  || export PATH="${HOME}/.local/scala3/bin${PATH:+:${PATH}}"'
  
config_strings="#begin scala init

${set_path}

#end scala init"

readarray -td '
' config_array <<< "$config_strings"

sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.bashrc"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo "$config_strings" >> "${HOME}/.bashrc"

eval $"$set_path"

scala -version
