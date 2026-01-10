[&uArr;](./readme.md)

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

Paleidžiamas diegimo skriptas `nu_install.sh`. Pabaigus diegimą, įvykdoma komanda

```bash
[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] || \
  export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"
```

Arba terminale vykdomos komandos

```bash
# Failų pavadinimų ieškokite https://github.com/nushell/nushell/releases/latest

VERSION="$(basename "$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/nushell/nushell/releases/latest")")"
rm -rf "${HOME}/.opt/nu"
URL="https://github.com/nushell/nushell/releases/download/${VERSION}/nu-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
curl -sSLo- "${URL}" | tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "${HOME}/.opt"
unset VERSION URL

[[ "$(grep 'export PATH="\${HOME}/.opt/nu\$' < ${HOME}/.pathrc | wc -l)" > 0 ]] || {
  sed --in-place=".$(date +"%Y%m%d-%H%M%S-%3N")" '/#begin nushell init/,/#end nushell init/d'  "${HOME}/.pathrc"
  sed --in-place '/^[[:space:]]*$/N; /^\n$/D' "${HOME}/.pathrc"
  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

  echo '#begin nushell init

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] \
  || export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

#end nushell init' >> "${HOME}/.pathrc"
}

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] || \
  export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

nu -v # => echo ${VERSION}
unset VERSION URL
```

## Paleistis

```bash
nu kodo-failas.nu
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env nu
```
