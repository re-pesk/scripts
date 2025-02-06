[Atgal](./readme.md)

# Odin [&#x2B67;](ttps://odin-lang.org/)

## Diegimas

```bash
sudo apt install clang
url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/odin-lang/Odin/releases/latest)
url="${url//tag/download}/odin-linux-amd64-$(basename -- $url).tar.gz"
curl -sSLo- $url | tar --transform 'flags=r;s/^odin[^\/]+/odin/x' --show-transformed-names -xzvC "${HOME}/.local"
ln -s ${HOME}/.local/odin/odin ${HOME}/.local/bin/odin
unset url
odin version
```

arba

```bash
bash odin-install.sh
```

## Paleistis

```bash
odin run kodo-failas.odin -file -out:vykdomasis-failas.bin
```

### odin-script.sh

Odino failų palidimą supaprastina pagalbinis failas _odin-script.sh_. Jis turi būti arba tame pačiame kataloge kaip ir leidžiamas failas, arba viename iš katalogų, nurodytų aplinkos kintamajame `PATH`.

```bash
./odin-script.sh kodo-failas.odin
```

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env odin run "$0" -file -out:"${0%.*}.bin" -- "$@"; exit $?
```

## Kompiliavimas

```bash
odin build kodo-failas.odin -file -out:vykdomasis-failas.bin
./vykdomasis-failas.bin
```
