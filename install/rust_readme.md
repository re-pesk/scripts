[Atgal](./readme.md)

# Rust [&#x2B67;](https://www.rust-lang.org/)

* Paskiausias leidimas: 1.86.0
* Išleista: 2025-03-31

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

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
