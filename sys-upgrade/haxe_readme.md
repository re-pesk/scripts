[Atgal](./readme.md)

# Perl [&#x2B67;](https://haxe.org/)

* Paskiausias leidimas: 4.3.6
* Išleista: 2024-08-07

## [Diegimas](../install/haxe_readme.md)

## Paleistis

```bash
haxe --run Pagrindinė_klasė.hx
```

kur „Pagrindinė_klasė“ yra klasės su statiniu metodu „main“ pavadinimas. Failo, kuriame saugoma klasė, pavadinimas turi sutapti su pagrindinės klasės, o jo plėtinys turi būti „.hx“

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?
```
