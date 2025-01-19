[Atgal](./readme.md)

# Haskell [&#x2B67;](https://www.haskell.org/)

## Diegimas

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghc --version
```

## Paleistis

```bash
runghc -- -- haskell_sys-upgrade.hs
```

### Shebang

```shebang
#!/usr/bin/env -S runghc -- --
```

## Kompiliavimas

```bash
ghc -o haskel_sys-upgrade.bin haskell_sys-upgrade.hs
```
