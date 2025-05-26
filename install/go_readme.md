[Atgal](./readme.md)

# Go [&#x2B67;](https://go.dev/)

* Paskiausias leidimas: 1.24.1
* Išleista: 2025-03-04

## Diegimas

```bash
versija="1.24.1"
[ -d ${HOME}/.local/go ] && rm -r ${HOME}/.local/go
curl -fsSo - https://dl.google.com/go/go${versija}.linux-amd64.tar.gz | tar -xz -C ${HOME}/.local
unset versija

sed -i '/#begin go init/,/#end go init/c\' "${HOME}/.bashrc"
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo '#begin go init

[[ ":${PATH}:" == *":${HOME}/.local/go/bin:"* ]] \
  || export PATH="${HOME}/.local/go/bin${PATH:+:${PATH}}"

[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

#end go init' >> "${HOME}/.bashrc"

[[ ":${PATH}:" == *":${HOME}/.local/go/bin:"* ]] \
  || export PATH="${HOME}/.local/go/bin${PATH:+:${PATH}}"
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
