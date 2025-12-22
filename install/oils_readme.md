<!-- markdownlint-disable-file no-hard-tabs -->
[&uArr;](./readme.md)

# Oils for Unix [&#x2B67;](https://www.oilshell.org/)

* Paskiausias leidimas: [0.28.0](https://oils.pub/release/latest/)
* Išleista: 2025-03-16

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
# VERSION="$(curl -s https://oils.pub/release/latest/ | grep -o '<title>.*</title>' | sed 's/<\/\?title>//g;s/^Oils //g')"
VERSION="$(curl -sSLo - https://raw.githubusercontent.com/oils-for-unix/oils/refs/heads/master/oils-version.txt | head -n 1)"
curl -sSLo- "https://oils.pub/download/oils-for-unix-${VERSION}.tar.gz" | tar -xzv
INIT_DIR="$PWD"

cd "oils-for-unix-${VERSION}"
./configure --prefix "${HOME}/.opt/oils" --datarootdir "${HOME}/.opt/oils/share"
_build/oils.sh
[ -d "${HOME}/.opt/oils" ] && rm -rf "${HOME}/.opt/oils"
./install
ln -sf "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/osh"
ln -sf "${HOME}/.opt/oils/bin/oils-for-unix" "${HOME}/.local/bin/ysh"
cd "${INIT_DIR}"
rm -rf "oils-for-unix-${VERSION}"

unset INIT_DIR VERSION

osh --version | head -n 1 # => Oils ${VERSION}             https://oils.pub/
ysh --version | head -n 1 # => Oils ${VERSION}             https://oils.pub/
```

## Paleistis

```bash
osh osh-kodo-failas.oil
ysh ysh-kodo-failas.oil
```

### Vykdymo instrukcija (shebang)

Pagal skripto dialektą:

```bash
#!/usr/bin/env -S osh
#!/usr/bin/env -S ysh
```
