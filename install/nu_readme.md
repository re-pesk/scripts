[Atgal](./readme.md)

# Nushell [&#x2B67;](https://www.nushell.sh/)

* Paskiausias leidimas: 0.103.0
* Išleista: 2025-03-19

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
# Failų pavadinimų ieškokite https://github.com/nushell/nushell/releases/latest

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
unset url
```

## Paleistis

```bash
nu kodo-failas.nu
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env nu
```
