[Atgal](./readme.md)

# Swift [&#x2B67;](https://www.swift.org/)

* Paskiausias leidimas: 6.1
* Išleista: 2025-03-30

## Diegimas

Instaliuojami paketai, kurie nebuvo suinstaliuoti kartu su Ubuntu 24.04

```bash
sudo apt install gnupg2 libcurl4-openssl-dev libpython3-dev libstdc++-13-dev
```

Visos failų versijos yra <https://www.swift.org/install/linux/> puslapyje.

```bash
# Atsiunčiamas, išpakuojamas ir paleidžiamas swiftly - swift'o diegimo menedžeris
curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz && \
tar zxf swiftly-$(uname -m).tar.gz && \
./swiftly init --quiet-shell-followup

# Basho konfigūracinis failas .bashrc išvalomas nuo swifto komandų
sed -i '/#begin swift init/,/#end swift init/c\' "${HOME}/.bashrc"
# Jeigu reikia, pridedama tučia eilutė
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

# Basho konfigūracinis failas .bashrc papildomas swift konfigūracinio failo įkėlimo komanda
echo '#begin swift init

. ~/.local/share/swiftly/env.sh

#end swift init' >> "${HOME}/.bashrc"

. ~/.local/share/swiftly/env.sh

hash -r

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
