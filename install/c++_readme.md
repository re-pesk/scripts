[Atgal](./readme.md)

# C++ [&#x2B67;](https://cplusplus.com/doc/tutorial/)

## Diegimas

g++ instaliuojamas su Ubuntu 24.04 operacine sistema

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S g++ -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
g++ -Wno-sizeof-array-argument -std=c++2b -o vykdomasis-failas.bin kodo-failas.cpp
./vykdomasis-failas.bin
```
