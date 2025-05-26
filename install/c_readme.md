[Atgal](./readme.md)

# C [&#x2B67;](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)

* Paskiausias leidimas (gcc): 14.2.
* Išleista: 2024-08-01

## Diegimas

__*gcc*__ instaliuojamas su Ubuntu 24.04 operacine sistema

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S gcc -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
gcc -static -o vykdomasis-failas.bin kodo-failas.c
./vykdomasis-failas.bin
```
