#! /usr/bin/env bash

# Visų variantų ieškokite https://github.com/nushell/nushell/releases/latest puslapio failų pavadinimuose

variant="x86_64-unknown-linux-gnu.tar.gz";
install_dir=".local/nu"

install="y"

[ -d ${HOME}/${install_dir} ] && [ -e "${HOME}/.local/bin/nu" ] && nu -v > /dev/null 2>&1  && 
read -e -p "Found working Nushell installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

[ -d ${HOME}/${install_dir} ] && rm -r ${HOME}/${install_dir}

url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/nushell/nushell/releases/latest)
url=${url//tag/download}/nu-$(basename -- $url)-$variant
curl -sSLo- $url | tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "${HOME}/.local"

[ ! -d ${HOME}/${install_dir} ] && echo "Directory ${HOME}/${install_dir} is not created!" && exit -1

sed -i "/#begin nushell init/,/#end nushell init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin nushell init

[[ ":${PATH}:" == *":${HOME}/'${install_dir}':"* ]] \
  || export PATH="${HOME}/'${install_dir}'${PATH:+:${PATH}}"

#end nushell init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/${install_dir}:"* ]] \
  || export PATH="${HOME}/${install_dir}${PATH:+:${PATH}}"

nu -v
[ $? -ne 0 ] && echo "Error! Nushell is not working as expected!" && exit -1
echo "Nushell is succesfully installed"
