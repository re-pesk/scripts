[Atgal](./readme.md)

# Crystal [&#x2B67;](https://crystal-lang.org/)

## Diegimas

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
crystal --version
```

## Paleistis

```bash
crystal crystal_sys-upgrade.cr
```

### Shebang

```shebang
#!/usr/bin/env crystal
```

## Kompiliavimas

```bash
crystal build --release --progress --static -o crystal_sys-upgrade.bin crystal_sys-upgrade.cr
```
