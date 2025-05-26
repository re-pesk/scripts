[&uArr;](./readme.md)

# Swift [&#x2B67;](https://www.swift.org/)

* Paskiausias leidimas: 6.1
* Išleista: 2025-03-30

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
[ $(grep '#begin include .pathrc' < ${HOME}/.bashrc | wc -l) -gt 0 ] || echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "$HOME/.pathrc" ]; then
  . "$HOME/.pathrc"
fi

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

Instaliuojami paketai, kurie nebuvo suinstaliuoti kartu su Ubuntu 24.04

```bash
sudo apt install gnupg2 libcurl4-openssl-dev libpython3-dev libstdc++-13-dev
```

Visos failų versijos yra <https://www.swift.org/install/linux/> puslapyje.

```bash
# Atsiunčiamas, išpakuojamas ir paleidžiamas swiftly - swift'o diegimo tvarkyklė
mkdir swiftly && \
curl -o - https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz \
| tar xzxC ./swiftly && \
./swiftly/swiftly init --quiet-shell-followup && \
. ${SWIFTLY_HOME_DIR:-${HOME}/.local/share/swiftly}/env.sh && \
hash -r

rm -r ./swiftly

# Swifto diegimo tvarkyklės veikimas patikrinamas, išvedant instaliuotos Swift'o versijos numerį
swiftly --version
swiftly install latest --use

swift --version # Swifto veikimas patikrinamas, išvedant instaliuotos Swift'o versijos numerį
```

## Paleistis

```bash
swift kodo-failas.swift
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env -S swift
```

arba

```bash
///usr/bin/env -S swift "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
# Statinių vykdomųjų failų kompiliavimui Ubuntu 24.04 sistemoje
sudo ln -fs /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/libstdc++.so

swiftc -static-executable -o vykdomasis-failas.bin kodo-failas.swift
./vykdomasis-failas.bin
```
