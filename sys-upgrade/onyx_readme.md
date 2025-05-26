[Atgal](./readme.md)

# Onyx [&#x2B67;](https://onyxlang.io/)

## [Diegimas](../install/onyx_readme.md)

## Paleistis

```bash
onyx run onyx_sys-upgrade.onyx
```

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S onyx run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
onyx build -o onyx_sys-upgrade.wasm onyx_sys-upgrade.onyx
chmod u+x onyx_sys-upgrade.wasm
onyx run onyx_sys-upgrade.wasm
```
