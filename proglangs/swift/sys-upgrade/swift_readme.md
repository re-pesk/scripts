[Grįžti &#x2BA2;](../../readme.md "Grįžti")

# Swift [<sup>&#x2B67;</sup>](https://www.swift.org/)

## [Diegimas](../install/swift_readme.md)

## Paleistis

```bash
swift swift_sys-upgrade.swift
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env -S swift
```

arba

```bash
///usr/bin/env -S swift "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
swiftc -static-executable swift_sys-upgrade.bin swift_sys-upgrade.swift
./swift_sys-upgrade.bin
```
