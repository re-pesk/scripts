#! /usr/bin/env bash

# Failų pavadinimų ieškokite https://github.com/nushell/nushell/releases/latest

install="y"

[ -d "${HOME}/.opt/nu" ] && [ -e "${HOME}/.opt/nu/nu" ] && nu -v > /dev/null 2>&1  && \
  read -e -p "Found working Nushell installation. Do you want overwrite it? Print 'y' to overwrite. Print 'n' or [Enter] to exit: " install

[ "$install" = "y" ] || { unset install; exit 0; }

[ -d "${HOME}/.opt/nu" ] && rm -r "${HOME}/.opt/nu"

url="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/nushell/nushell/releases/latest")"
url="${url//tag/download}/nu-$(basename -- "${url}")-x86_64-unknown-linux-gnu.tar.gz"
curl -sSLo- "$url" | tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "${HOME}/.opt"

sed -i "/#begin nushell init/,/#end nushell init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin nushell init

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] \
  || export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

#end nushell init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] || \
  export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

nu -v
[ $? -ne 0 ] && { echo "Error! Nushell is not working as expected!"; exit -1; }
echo "Nushell is succesfully installed"
unset install url
