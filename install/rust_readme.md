[Atgal](./readme.md)

# Rust [&#x2B67;](https://www.rust-lang.org/)

## Diegimas

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-script
rustc --version
```

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
rustc -o vykdomasis-failas.bin kodo-failas.rs
```
