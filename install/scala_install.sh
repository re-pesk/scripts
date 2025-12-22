#!/usr/bin/env bash

[[ $(apt list --installed jq 2> /dev/null | wc -l) == 1 ]] && sudo apt-get install jq 

URL="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)"
VERSION="$(basename -- ${URL})"
curl -sSLo- "${URL//tag/download}/scala3-${VERSION}-x86_64-pc-linux.tar.gz" \
| tar --transform 'flags=r;s/^(scala3)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

sed -i '/#begin scala init/,/#end scala init/c\' "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin scala init

[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] \
|| export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"

#end scala init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] \
|| export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"

scala -version
