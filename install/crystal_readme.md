[Atgal](./readme.md)

# Crystal [&#x2B67;](https://crystal-lang.org/)

## Diegimas

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
crystal --version
```

## Paleistis

```bash
crystal kodo-failas.cr
```

### Shebang

```shebang
#!/usr/bin/env crystal
```

## Kompiliavimas

```bash
crystal build --release --progress --static -o vykdomasis-failas.bin kodo-failas.cr
./vykdomasis-failas.bin
```
