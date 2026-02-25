[&#x2BA2;](../../install_readme.md "Atgal")

# Crystal [<sup>&#x2B67;</sup>](https://crystal-lang.org/)

* Paskiausias leidimas: 1.19.1
* Išleista: 2026-01-20

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
crystal --version
```

## Paleistis

```bash
crystal kodo-failas.cr
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env crystal
```

## Kompiliavimas

```bash
crystal build --release --progress --static -o vykdomasis-failas.bin kodo-failas.cr
./vykdomasis-failas.bin
```
