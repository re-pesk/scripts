#!/usr/bin/env bash

version="5.4.7"
install_dir_str='${HOME}/.lua'
install_dir="$(eval "echo ${install_dir_str}")"
tmp_dir="/tmp/lua-${version}"

# echo "$install_dir_str"
# echo "$install_dir"

[ -d "$install_dir" ] && rm --recursive "$install_dir"

curl -LRo - https://www.lua.org/ftp/lua-${version}.tar.gz | tar xzC "/tmp"
curdir="$PWD"
cd "${tmp_dir}"
make all test
make install INSTALL_TOP="$install_dir"
cd $curdir
rm -r "${tmp_dir}"
set_path='[[ ":${PATH}:" == *":'$install_dir_str'/bin:"* ]] \
  || export PATH="'$install_dir_str'/bin${PATH:+:${PATH}}"'
    
config_strings="#begin lua init

${set_path}

#end lua init"

readarray -td '
  ' config_array <<< "$config_strings"

sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.bashrc"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo "$config_strings" >> "${HOME}/.bashrc"

eval $"$set_path"

echo

lua -v

echo '
Po instaliavimo norėdami naudoti lua, komandinėje eilutėje įvykdykite komandą

[[ ":${PATH}:" == *":${HOME}/.lua/bin:"* ]] \
  || export PATH="${HOME}/.lua/bin${PATH:+:${PATH}}"

arba išeikite iš savo paskyros ir prisijunkite iš naujo.
'
