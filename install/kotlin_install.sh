#!/usr/bin/env bash

[ $(snap list kotlin | wc -l) == 2 ] && echo Instaliuota || echo instaliuok
sudo snap install --classic kotlin
kotlin -version

URL="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/JetBrains/kotlin/releases/latest)"
curl -sSLo- "${URL//tag/download}/kotlin-native-prebuilt-linux-x86_64-$(basename -- $URL).tar.gz" \
| tar --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

sed -i '/#begin kotlin init/,/#end kotlin init/c\' "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin kotlin init

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

#end kotlin init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

kotlinc-native -version  
