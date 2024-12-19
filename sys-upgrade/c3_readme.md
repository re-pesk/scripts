# C3 [&#x2B67;](https://c3-lang.org/)

## Diegimas

```bash
curl -fsSo - https://github.com/c3lang/c3c/releases/download/latest/c3-ubuntu-20.tar.gz | tar -xzvC $HOME/.local
ln -s $HOME/.local/c3/c3c $HOME/.local/bin/c3c
c3c --version
```

## Paleistis

```bash
c3c compile-run -o c3_sys-upgrade.bin c3_sys-upgrade.c3
```

## Kompilavimas

```bash
c3c compile -o c3_sys-upgrade.bin c3_sys-upgrade.c3
```
