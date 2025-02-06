[Atgal](./readme.md)

# Swift [&#x2B67;](https://www.swift.org/)

## Diegimas

Instaliuojami paketai, kurie nebuvo suinstaliuoti kartu su Ubuntu 24.04

```bash
sudo apt install gnupg2 libcurl4-openssl-dev libpython3-dev libstdc++-13-dev
```

Visos failų versijos yra <https://www.swift.org/install/linux/> puslapyje.

```bash
# Atsiunčiams Swifto archyvas, jo turinys išpakuojamas ~/.swift kataloge (pakeskite versijos numerį į jums tinkamą).
curl -sSLo- "https://download.swift.org/swift-6.0.3-release/ubuntu2404/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu24.04.tar.gz" \
| tar --transform 'flags=r;s/^swift[^\/]+/.swift/x' --show-transformed-names -xzC "$HOME"

# Jeigu reikia, pridedama tučia eilutė
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

# Sistemos kelias konfigūraciniame faile papildomas Swifto vykdomųjų failų katalogu
echo '#begin Swift init

[[ ":${PATH}:" == *":${HOME}/.swift/usr/bin:"* ]] \
  || export PATH="${HOME}/.swift/usr/bin${PATH:+:${PATH}}"

#end Swift init' >> "${HOME}/.bashrc"

# Esamas kelias papildomas Swifto vykdomųjų failų katalogu
[[ ":${PATH}:" == *":${HOME}/.swift/usr/bin:"* ]] || export PATH="${HOME}/.swift/usr/bin${PATH:+:${PATH}}"

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

## Kompiliavimas

```bash
swiftc -static-stdlib -o vykdomasis-failas.bin kodo-failas.swift
./vykdomasis-failas.bin
```
