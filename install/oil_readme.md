[Atgal](./readme.md)

# Oils for Unix [&#x2B67;](https://www.oilshell.org/)

## Diegimas

```bash
# Vėliausią versijos numerį galima rasti https://www.oilshell.org/release/latest/

version="0.24.0"
curl -sSLo- https://www.oilshell.org/download/oils-for-unix-${version}.tar.gz \
  | tar -xzv
cd oils-for-unix-${version}
./configure --prefix ~/.local --datarootdir ~/.local/share
_build/oils.sh
./install

osh --version # => Oils 0.24.0
ysh --version # => Oils 0.24.0
```

## Paleistis

```bash
osh oil-osh_sys-upgrade.oil
ysh oil-ysh_sys-upgrade.oil
```

### Vykdymo instrukcija (shebang)

Pagal skripto dialektą:

```bash
#!/usr/bin/env osh
#!/usr/bin/env ysh
```
