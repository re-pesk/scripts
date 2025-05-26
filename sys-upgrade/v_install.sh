#!/usr/bin/env bash

install="y"

[ -d $HOME/.local/v ] && [ -e "$HOME/.local/bin/v" ] && v -v 2> /dev/null && 
read -e -p "Found working V installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit

curl -sSL https://github.com/vlang/v/releases/latest/download/v_linux.zip -o /tmp/v_linux.zip
[ ! -f /tmp/v_linux.zip ] && echo "File /tmp/v_linux.zip is not downloaded!" && exit

[ -d $HOME/.local/v ] && rm -r $HOME/.local/v
unzip /tmp/v_linux.zip -d $HOME/.local #> /dev/null 
[ -f /tmp/v_linux.zip ] && rm /tmp/v_linux.zip

[ ! -d $HOME/.local/v ] && echo "Directory $HOME/.local/v is not created!" && exit

ln -fs $HOME/.local/v/v $HOME/.local/bin/v

[ ! -e "$HOME/.local/bin/v" ] && echo "The symlink is not created or is broken." && exit

echo

v -v > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! V compiler is not working as expected!" && exit -1

printf "v -v\n=> %s\n" $(v -v)
echo "V compiler is succesfully installed"
