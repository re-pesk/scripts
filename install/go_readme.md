[&uArr;](./readme.md)

# Go [&#x2B67;](https://go.dev/)

* Paskiausias leidimas: 1.24.1
* Išleista: 2025-03-04

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
versija="1.24.3"
[ -d ${HOME}/.opt/go ] && rm -r ${HOME}/.opt/go
curl -fsSLo - https://go.dev/dl/go${versija}.linux-amd64.tar.gz \
| tar  --transform 'flags=r;s/^(go)/\1/x' --show-transformed-names -xzv -C ${HOME}/.opt
unset versija

sed -i '/#begin go init/,/#end go init/c\' "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin go init

[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] \
  || export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"

[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

#end go init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] \
  || export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"
[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

go version
```

## Paleistis

```bash
go run go_sys-upgrade.go
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S go run $0 $@ ; exit
```

## Kompiliavimas

```bash
go build -o vykdomasis-failas.bin kodo-failas.go
./vykdomasis-failas.bin
```
