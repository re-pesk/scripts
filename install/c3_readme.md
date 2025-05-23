[&uArr;](./readme.md)

# C3 [&#x2B67;](https://c3-lang.org/)

* Paskiausias leidimas: 0.7.0
* Išleista: 2025-03-31

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
[[ -d ${HOME}/.opt/c3 ]] && rm -r ${HOME}/.opt/c3
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/c3lang/c3c/releases/latest)"
curl -fsSLo - "${url//tag/download}/c3-ubuntu-20.tar.gz" \
| tar  --transform 'flags=r;s/^(c3)/\1/x' --show-transformed-names -xzvC ${HOME}/.opt
unset url
ln -fs ${HOME}/.opt/c3/c3c ${HOME}/.local/bin/c3c
c3c --version
```

## Paleistis

```bash
c3c compile-run -o vykdomasis-failas.bin kodo-failas.c3
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S c3c compile-run -o "${0%.*}.bin" "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
c3c compile -o vykdomasis-failas.bin kodo-failas.c3
./vykdomasis-failas.bin
```
