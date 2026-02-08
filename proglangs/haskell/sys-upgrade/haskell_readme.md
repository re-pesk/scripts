[&uArr;](./readme.md)

# Haskell [&#x2B67;](https://www.haskell.org/)

## [Diegimas](../install/haskell_readme.md)

## Paleistis

```bash
runghc -- -- haskell_sys-upgrade.hs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S runghc -- --
```

## Kompiliavimas

```bash
ghc -o haskell_sys-upgrade.bin haskell_sys-upgrade.hs
rm haskell_sys-upgrade.{hi,o}
./haskell_sys-upgrade.bin
```
