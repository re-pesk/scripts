#!/usr/bin/env bash

[ -d "${HOME}/.opt/go" ] && rm -rf "${HOME}/.opt/go"
URL="$(curl -sL https://go.dev/dl/ | grep -e 'downloadBox' | grep -o '[^\/]*linux-amd64.tar.gz')"
curl -fsSLo- "https://go.dev/dl/${URL}" | tar -xz -C "${HOME}/.opt"
unset URL

cp -T "${HOME}/.pathrc" "${HOME}/.pathrc.$(date +"%Y%m%d.%H%M%S.%3N")"
sed -i "/#begin go init/,/#end go init/c\\" "${HOME}/.pathrc"
# [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '
#begin go init

[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] \
  || export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"
  
[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

#end go init
' >> "${HOME}/.pathrc"

cat -s "${HOME}/.pathrc" > "${HOME}/.pathrc.new"
cp -T "${HOME}/.pathrc.new" "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] \
  || export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"

[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

go version
