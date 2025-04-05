[Atgal](./readme.md)

# Onyx [&#x2B67;](https://onyxlang.io/)

* Paskiausias leidimas: 0.1.13
* Išleista: 2024-11-09

## Diegimas

```bash
sh <(curl https://get.onyxlang.io -sSfL)
onyx version
```

## Paleistis

```bash
onyx run kodo-failas.onyx
```

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S onyx run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
onyx build -o vykdomasis-failas.wasm kodo-failas.onyx
chmod u+x vykdomasis-failas.wasm
onyx run vykdomasis-failas.wasm
```
