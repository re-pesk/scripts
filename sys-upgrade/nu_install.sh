#! /usr/bin/env bash

# Visų variantų ieškokite https://github.com/nushell/nushell/releases/latest puslapio failų pavadinimuose

variant="x86_64-unknown-linux-gnu.tar.gz"; 

install="y"

[ -d $HOME/.local/nu ] && [ -e "$HOME/.local/bin/nu" ] && nu -v > /dev/null 2>&1  && 
read -e -p "Found working Nushell installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

[ -d $HOME/.local/nu ] && rm -r $HOME/.local/nu

url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/nushell/nushell/releases/latest)
url=${url//tag/download}/nu-$(basename -- $url)-$variant
curl -sSLo- $url | tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "$HOME/.local"

[ ! -d $HOME/.local/nu ] && echo "Directory $HOME/.local/nu is not created!" && exit -1

for filename in $HOME/.local/nu/nu*; do ln -fs $filename ${filename//nu\//bin/}; done

for filename in $HOME/.local/bin/nu*; do [ ! -e "$filename" ] && echo "The symlink is not created or is broken." && exit -1; done

nu -v > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Nushell is not working as expected!" && exit -1

printf "nu -v\n=> %s\n" $(nu -v)
echo "Nushell is succesfully installed"
