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
| tar -xz --transform 'flags=r;s/^swift[^\/]+/.swift/x' --show-transformed-names -C "$HOME"

# Sistemos kelias konfigūraciniame faile papildomas Swifto vykdomųjų failų katalogu
echo -e "\nexport PATH=$HOME/.swift/usr/bin:\"\${PATH}\"\n" >> $HOME/.bashrc 
source $HOME/.bashrc #Iš naujo įkraunams konfigūracinis bash'o failas
export PATH="$HOME/.swift/usr/bin:${PATH}" # Esamas kelias papildomas Swifto vykdomųjų failų katalogu

swift --version # Swifto veikimas patikrinamas, išvedant instaliuotos Swift'o versijos numerį
```

## Paleistis

```bash
swift swift_sys-upgrade.swift
```

## Kompilavimas

```bash
swiftc -static-stdlib -o swift_sys-upgrade.bin swift_sys-upgrade.swift
```
