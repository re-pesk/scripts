[&uArr;](./readme.md)

# V [&#x2B67;](https://vlang.io/)

## [Diegimas](../install/v_readme.md)

## Paleistis

```bash
v run v_sys-upgrade.v
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S v run
```

arba

```bash
///usr/bin/env -S v run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
v -o v_sys-upgrade.bin v_sys-upgrade.v
./v_sys-upgrade.bin
```
