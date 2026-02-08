[&uArr;]](./readme.md)

# Odin [&#x2B67;](ttps://odin-lang.org/)

## [Diegimas](../install/odin_readme.md)

## Paleistis

```bash
odin run odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```

### Vykdymo eiluė

Norint *odin_sys-upgrade.odin* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
```

## Kompiliavimas

```bash
odin build odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
./odin_sys-upgrade.bin
```
