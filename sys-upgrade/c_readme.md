[Atgal](./readme.md)

# C [&#x2B67;](https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html)

## [Diegimas](../install/c_readme.md)

## Paleistis

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S gcc -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
```

## Kompiliavimas

```bash
gcc -static -o c_sys-upgrade.bin c_sys-upgrade.c
./c_sys-upgrade.bin
```
