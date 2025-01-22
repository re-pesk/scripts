#!/usr/bin/env bash

version="6.0.3"
app_name="Swift"
install_dir="${HOME}/.swift"

install="y"

[ -d "$install_dir" ] && swift --version > /dev/null 2>&1  && 
read -e -p "Found working $app_name installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

[ -d "$install_dir" ] && rm -r "$install_dir"

url="https://download.swift.org/swift-${version}-release/ubuntu2404/swift-${version}-RELEASE/swift-${version}-RELEASE-ubuntu24.04.tar.gz"
curl -sSLo- $url | tar --transform 'flags=r;s/^swift[^\/]+/.swift/x' --show-transformed-names  -xzC "$HOME"

[ ! -d "$install_dir" ] && echo "Directory ${install_dir} is not created!" && exit -1

set_path='[[ ":${PATH}:" == *":'$install_dir'/usr/bin:"* ]] \
  || export PATH="'$install_dir'/usr/bin${PATH:+:${PATH}}"'
  
config_strings="#begin ${app_name} init

${set_path}

#end ${app_name} init"

readarray -td '
' config_array <<< "$config_strings"

sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.bashrc"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo "$config_strings" >> "${HOME}/.bashrc"

eval $"$set_path"

echo 

swift --version > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Swift compiler is not working as expected!" && exit -1

echo -e "swift --version"; echo -e "$(swift --version)\n"
echo "Swift compiler is succesfully installed"
