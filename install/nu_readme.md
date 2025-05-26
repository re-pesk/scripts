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

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/nushell/nushell/releases/latest")"
version="$(basename -- "${url}")"
[ -d "${HOME}/.opt/nu" ] && rm --recursive "${HOME}/.opt/nu"
curl -sSLo- "${url//tag/download}/nu-${version}-x86_64-unknown-linux-gnu.tar.gz" |\
  tar --transform 'flags=r;s/^(nu)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
unset url version

echo '#begin nushell init

[[ ":${PATH}:" == *":${HOME}/'${install_dir}':"* ]] \
  || export PATH="${HOME}/'${install_dir}'${PATH:+:${PATH}}"

#end nushell init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/${install_dir}:"* ]] \
  || export PATH="${HOME}/${install_dir}${PATH:+:${PATH}}"

nu -v # => 0.104.0
```

## Paleistis

```bash
nu kodo-failas.nu
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env nu
```
