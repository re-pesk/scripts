[Atgal](./readme.md)

# C3 [&#x2B67;](https://c3-lang.org/)

## Diegimas

```bash
curl -fsSo - https://github.com/c3lang/c3c/releases/download/latest/c3-ubuntu-20.tar.gz | tar -xzvC ${HOME}/.local
ln -s ${HOME}/.local/c3/c3c ${HOME}/.local/bin/c3c
c3c --version
```

## Paleistis

```bash
c3c compile-run -o vykdomasis-failas.bin kodo-failas.c3
```

### Vykdomoji eilutė

```bash
///usr/bin/env -S c3c compile-run -o "${0%.*}.bin" "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
c3c compile -o vykdomasis-failas.bin kodo-failas.c3
./vykdomasis-failas.bin
```
