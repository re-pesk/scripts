[Atgal](./readme.md)

# Zig [&#x2B67;](https://ziglang.org/)

## Diegimas Linuxe (Ubuntu 24.04)

[Žr.](../install/zig_readme.md)

## Paleistis

```bash
zig run --name zig_sys-upgrade.bin zig_sys-upgrade.zig
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S zig run "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name zig_sys-upgrade.bin zig_sys-upgrade.zig && rm zig_sys-upgrade.bin.o
```
