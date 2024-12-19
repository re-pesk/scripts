#!/usr/bin/env bash

install="y"

[ -d $HOME/.local/odin ] && [ -e "$HOME/.local/bin/odin" ] && odin version > /dev/null 2>&1  && 
read -e -p "Found working Odin installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

[ -d $HOME/.local/odin ] && rm -r $HOME/.local/odin

url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/odin-lang/Odin/releases/latest)
url="${url//tag/download}/odin-linux-amd64-$(basename -- $url).tar.gz"
curl -sSLo- $url | tar -xzv --transform 'flags=r;s/^odin[^\/]+/odin/x' --show-transformed-names -C "$HOME/.local"

[ ! -d $HOME/.local/odin ] && echo "Directory $HOME/.local/odin is not created!" && exit -1

ln -fs $HOME/.local/odin/odin $HOME/.local/bin/odin

[ ! -e "$HOME/.local/bin/odin" ] && echo "The symlink is not created or is broken." && exit -1

echo 

odin version > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Odin compiler is not working as expected!" && exit -1

printf "odin version\n=> %s\n" $(odin version)
echo "Odin compiler is succesfully installed"
