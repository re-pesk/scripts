[&uArr;](./readme.md)

# Rust [&#x2B67;](https://www.rust-lang.org/)

## [Diegimas](../install/rust_readme.md)

## Paleistis

```bash
cargo script rust_sys-upgrade.rs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S run-cargo-script
```

arba

```bash
///usr/bin/env -S cargo script "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
rustc -o rust_sys-upgrade.bin rust_sys-upgrade.rs
./rust_sys-upgrade.bin
```
