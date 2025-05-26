[Atgal](./readme.md)

# D [&#x2B67;](https://dlang.org/)

* Paskiausias leidimas: 2.111.0
* Išleista: 2025-02-04

## Diegimas

Atsisiųsti vėliausią `.deb` failą iš D kalbos leidimų [puslapio](https://downloads.dlang.org/releases/) ir paleisi

```bash
sudo apt install atsisiųstas_failas.deb
dmd --version
dub --version
```

## Paleistis

```bash
rdmd kodo_failas.d
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env rdmd
```

arba

```bash
///usr/bin/env rdmd "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
rdmd --build-only -release -of=vykdomasis_failas.bin kodo_failas.d
```
