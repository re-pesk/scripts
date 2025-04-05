[Atgal](./readme.md)

# Oils for Unix [&#x2B67;](https://www.oilshell.org/)

* Paskiausias leidimas: [0.28.0](https://oils.pub/release/latest/)
* Išleista: 2025-03-16

## Diegimas

```bash
version="0.28.0"
curl -sSLo- "https://oils.pub/download/oils-for-unix-${version}.tar.gz" | tar -xzv
curdir="$PWD"

cd "oils-for-unix-${version}"
./configure --prefix ~/.local --datarootdir ~/.local/share
_build/oils.sh
./install
cd "${curdir}"

unset curdir version

osh --version # => Oils 0.24.0
ysh --version # => Oils 0.24.0
```

## Paleistis

```bash
osh osh-kodo-failas.oil
ysh ysh-kodo-failas.oil
```

### Vykdymo instrukcija (shebang)

Pagal skripto dialektą:

```bash
#!/usr/bin/env osh
#!/usr/bin/env ysh
```
