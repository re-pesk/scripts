[&uArr;](./readme.md)

# Scala [&#x2B67;](https://scala-lang.org/)

* Paskiausias leidimas: 3.6.4
* Išleista: 2025-03-07

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
[ $(grep '#begin include .pathrc' < ${HOME}/.bashrc | wc -l) -gt 0 ] || echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "$HOME/.pathrc" ]; then
  . "$HOME/.pathrc"
fi

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
[[ $(apt list --installed jq 2> /dev/null | wc -l) == 1 ]] && sudo apt-get install jq 

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)"
version="$(basename -- $url)"
curl -sSLo- "${url//tag/download}/scala3-${version}-x86_64-pc-linux.tar.gz" \
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
```

## Paleistis

```bash
scala run scala_sys-upgrade.scala
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S scala shebang
```

arba

```bash
///usr/bin/env -S scala shebang "$0" "$@"; exit $?
```
