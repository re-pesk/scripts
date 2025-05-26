[Atgal](./readme.md)

# C [&#x2B67;](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)

## Diegimas

__*gcc*__ instaliuojamas su Ubuntu 24.04 operacine sistema

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S gcc -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
gcc -o vykdomasis-failas.bin kodo-failas.c
./vykdomasis-failas.bin
```
