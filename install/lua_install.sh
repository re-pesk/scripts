#!/usr/bin/env bash

VERSION="$(basename -- "$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/lua/lua/releases/latest")")"
curl -LRo - "https://www.lua.org/ftp/lua-${VERSION#v}.tar.gz" | tar -xzC "/tmp"
[ -d "${HOME}/.opt/lua" ] && rm --recursive "${HOME}/.opt/lua"
INIT_DIR="$PWD"
cd "/tmp/lua-${VERSION#v}"
make all test
make install INSTALL_TOP="${HOME}/.opt/lua"
cd $INIT_DIR
rm -r "/tmp/lua-${VERSION#v}"
unset INIT_DIR VERSION

sed -i "/#begin lua init/,/#end lua init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin lua init

[[ ":${PATH}:" == *":${HOME}/.opt/lua/bin:"* ]] \
  || export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"
  
#end lua init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/lua/bin:"* ]] || export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"

echo ""

lua -v
