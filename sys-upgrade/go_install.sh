#!/usr/bin/env bash

version="1.23.4"
install_dir=".local/go"
dev_dir="go"
configfile="$HOME/.bashrc"

curl -fsSo - https://dl.google.com/go/go$version.linux-amd64.tar.gz | tar -xz -C $HOME/.local

set_path='[[ ":$PATH:" == *":$HOME/'$install_dir'/bin:"* ]] \
  || export PATH="$HOME/'$install_dir'/bin${PATH:+:${PATH}}"
  
[[ ":$PATH:" == *":$HOME/'$dev_dir'/bin:"* ]] \
  || export PATH="$HOME/'$dev_dir'/bin${PATH:+:${PATH}}"'

configstrings="#begin go init

${set_path}

#end go init"

readarray -td '
' PATTERN <<< "$configstrings"

sed -i "/${PATTERN[0]}/,/${PATTERN[@]: -1:1}/c\\" "$configfile"

[[ "$( tail -n 1 "$configfile" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "$configfile"

echo "$configstrings" >> "$configfile"

eval $"$set_path"

go version
