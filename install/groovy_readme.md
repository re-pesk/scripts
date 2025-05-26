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
url="$(
  curl -s https://groovy.apache.org/download.html#distro \
  | xq -q 'button[id="big-download-button"]' --attr "onclick" \
  | sed -r 's/^window.location.href="(.+)"$/\1/'
)"
base_name="$(basename -- $url)"
wget -qO "/tmp/${base_name}" "$url"
unzip "/tmp/$base_name" -d "/tmp"
rm "/tmp/$base_name"
dir_name=$([[ "$base_name" =~ .+(groovy)-.+-([0-9]+\.[0-9]+\.[0-9]+) ]] && echo ${BASH_REMATCH[1]}-${BASH_REMATCH[2]})
mv -T "/tmp/${dir_name}" "${HOME}/.opt/groovy"
unset base_name dir_name url

echo '#begin groovy init

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
  || export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

#end groovy init' >> "${HOME}/.pathrc"

[ -z "$JAVA_HOME" ] \
&& export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
[[ ":${PATH}:" == *":${HOME}/.opt/groovy/bin:"* ]] \
export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

groovy -version
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
