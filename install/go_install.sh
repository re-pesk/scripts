#!/usr/bin/env bash

version="1.23.4"
install_dir=".opt/go"
dev_dir="go"
config_file="${HOME}/.pathrc"

curl -fsSo - https://dl.google.com/go/go${version}.linux-amd64.tar.gz | tar -xz -C ${HOME}/.opt

set_path='[[ ":${PATH}:" == *":${HOME}/'$install_dir'/bin:"* ]] \
  || export PATH="${HOME}/'$install_dir'/bin${PATH:+:${PATH}}"
  
[[ ":${PATH}:" == *":${HOME}/'$dev_dir'/bin:"* ]] \
  || export PATH="${HOME}/'$dev_dir'/bin${PATH:+:${PATH}}"'

config_strings="#begin go init

${set_path}

#end go init"

readarray -td '
' PATTERN <<< "$config_strings"

sed -i "/${PATTERN[0]}/,/${PATTERN[@]: -1:1}/c\\" "$config_file"

[[ "$( tail -n 1 "$config_file" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "$config_file"

echo "$config_strings" >> "$config_file"

eval $"$set_path"

go version
