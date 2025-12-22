[&uArr;](./readme.md)

# Groovy [&#x2B67;](https://groovy-lang.org/)

* Paskiausias leidimas: 4.0.26
* Išleista: 2025-02-25

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, į .bashrc failą įterpiama jo įkėlimo komanda

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
[ $(grep '#begin include .pathrc' < ${HOME}/.bashrc | wc -l) -gt 0 ] || echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "$HOME/.pathrc" ]; then
  . "$HOME/.pathrc"
fi

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegtos, įdiegiamos [curl](../utils/curl.md) ir [xq](../utils/xq.md)

## Diegimas

```bash
# Versijos numerį galima pasitikrinti "https://groovy.apache.org/download.html#distro"
VERSION="$(
  curl -s https://groovy.apache.org/download.html#distro |\
  xq -q 'button[id="big-download-button"]' --attr "onclick" |\
  sed -r 's/^.+=".+-(.+)\.zip"$/\1/'
)"
URL="https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${VERSION}.zip"

curl -sSLo "/tmp/groovy-sdk-${VERSION}.zip" "${URL}"
TMP_DIR="$(mktemp -d)"
unzip "/tmp/groovy-sdk-${VERSION}.zip" -d "${TMP_DIR}"
rm "/tmp/groovy-sdk-${VERSION}.zip"

[[ -d "${HOME}/.opt/groovy" ]] && rm -rf "${HOME}/.opt/groovy"
mv -T "${TMP_DIR}/groovy-${VERSION}" "${HOME}/.opt/groovy"
rm -rf "${TMP_DIR}"
unset TMP_DIR VERSION URL

cp -T "${HOME}/.pathrc" "${HOME}/.pathrc.$(date +"%Y%m%d.%H%M%S.%3N")"
sed -i '/#begin groovy init/,/#end groovy init/c\' "${HOME}/.pathrc"

echo '
#begin groovy init

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
  || export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

#end groovy init
' >> "${HOME}/.pathrc"–

cat -s "${HOME}/.pathrc" > "${HOME}/.pathrc.new"
cp -T "${HOME}/.pathrc.new" "${HOME}/.pathrc"

[ -z "$JAVA_HOME" ] \
&& export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

groovy --version
```

arba

```bash
bash groovy_install.sh
```

## Paleistis

```bash
groovy kodo-failas.groovy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env groovy
```

arba

```bash
///usr/bin/env groovy "$0" "$@"; exit $?
```
