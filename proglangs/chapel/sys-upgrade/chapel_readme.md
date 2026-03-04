[&#x2BA2;](../../readme.md "Atgal")

# Chapel [<sup>&#x2B67;</sup>](https://chapel-lang.org/)

## [Diegimas](../install/chapel_readme.md)

## Kompiliavimas ir paleistis

```bash
chpl --output=chapel_sys-upgrade.bin chapel_sys-upgrade.chpl
./chapel_sys-upgrade.bin
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?
```
