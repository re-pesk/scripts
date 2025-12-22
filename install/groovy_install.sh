#!/usr/bin/env bash

java --version > /dev/null 2>&1
[[ "$?" -gt 0 ]] && echo "Pirmiau įdiekite Javą!" && exit 1

# Versijos numerį galima pasitikrinti "https://groovy.apache.org/download.html#distro"
install="t"
VERSION="$(
  curl -s https://groovy.apache.org/download.html#distro \
  | xq -q 'button[id="big-download-button"]' --attr "onclick" \
  | sed -r 's/^.+=".+-(.+)\.zip"$/\1/'
)"
RESULT="$([[ "$(groovy --version 2> /dev/null)" =~ "Groovy Version: "([0-9]+\.[0-9]+\.[0-9]+) ]] \
  && echo "${BASH_REMATCH[1]}")"
[[ "$?" -eq 0 ]] && [[ "${RESULT}" == "${VERSION}" ]] \
  && read -p "Groovy's v${VERSION} jau įdiegtas! Ar norite įdiegti dar kartą? 't/y' arba išeiti [Įvesti/Enter]: " install
[[ "$install" =~ [yt] ]] || exit 0
unset install RESULT

URL="https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${VERSION}.zip"

curl -sSLo "/tmp/groovy-sdk-${VERSION}.zip" "${URL}"
TMP_DIR="$(mktemp -d)"
unzip "/tmp/groovy-sdk-${VERSION}.zip" -d "${TMP_DIR}"
rm "/tmp/groovy-sdk-${VERSION}.zip"

[[ -d "${HOME}/.opt/groovy" ]] && rm -rf "${HOME}/.opt/groovy"
mv -T "${TMP_DIR}/groovy-${VERSION}" "${HOME}/.opt/groovy"
rm -rf "${TMP_DIR}"
unset TMP_DIR URL

cp -T "${HOME}/.pathrc" "${HOME}/.pathrc.$(date +"%Y%m%d.%H%M%S.%3N")"
sed -i '/#begin groovy init/,/#end groovy init/c\' "${HOME}/.pathrc"

echo '
#begin groovy init

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
  || export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

#end groovy init
' >> "${HOME}/.pathrc"

cat -s "${HOME}/.pathrc" > "${HOME}/.pathrc.new"
cp -T "${HOME}/.pathrc.new" "${HOME}/.pathrc"

[ -z "$JAVA_HOME" ] \
&& export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

groovy --version

