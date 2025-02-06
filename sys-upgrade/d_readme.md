[Atgal](./readme.md)

# D [&#x2B67;](https://dlang.org/)

## [Diegimas](../install/d_readme.md)

## Paleistis

```bash
rdmd d_sys-upgrade.d
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
rdmd --build-only -release -of=d_sys-upgrade.bin d_sys-upgrade.d
```
