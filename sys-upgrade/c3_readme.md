[&uArr;](./readme.md)

# C3 [&#x2B67;](https://c3-lang.org/)

## [Diegimas](../install/c3_readme.md)

## Paleistis

```bash
c3c compile-run -o c3_sys-upgrade.bin c3_sys-upgrade.c3
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env c3c compile-run -o "${0%.*}.bin" "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
c3c compile -o c3_sys-upgrade.bin c3_sys-upgrade.c3
./c3_sys-upgrade.bin
```
