[Atgal](./readme.md)

# Odin [&#x2B67;](https://odin-lang.org/)

* Paskiausias leidimas: dev-2025-03
* Išleista: 2025-03-05

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
(( $(apt list --installed 2>/dev/null | grep -P '^clang' | wc -l ) > 0 )) || sudo apt install clang
url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/odin-lang/Odin/releases/latest)
version="$(basename -- $url)"
[ -d "${HOME}/.opt/odin" ] && rm --recursive "${HOME}/.opt/odin"
curl -sSLo - "${url//tag/download}/odin-ubuntu-amd64-${version}.zip" | gunzip -cf |\
  tar --transform 'flags=r;s/^(odin)[^\/]+/\1/x' --show-transformed-names -xzvC $HOME/.opt
unset url version
ln -fs ${HOME}/.opt/odin/odin ${HOME}/.local/bin/odin
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
