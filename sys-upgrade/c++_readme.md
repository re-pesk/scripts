[Atgal](./readme.md)

# C++ [&#x2B67;](https://cplusplus.com/doc/tutorial/)

## [Diegimas](../install/c++_readme.md)

## Paleistis

### Vykdomoji eilutė

```bash
///usr/bin/env -S g++ -Wno-sizeof-array-argument -std=c++2b -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
g++ -Wno-sizeof-array-argument -std=c++2b -o c++_sys-upgrade.bin c++_sys-upgrade.cpp
./c++_sys-upgrade.bin
```
