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
odin run odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```

### odin-script.sh

Odino failų palidimą supaprastina pagalbinis failas _odin-script.sh_. Jis turi būti arba tame pačiame kataloge kaip ir leidžiamas failas, arba viename iš katalogų, nurodytų aplinkos kintamajame `PATH`.

```bash
./odin-script.sh odin_sys-upgrade.odin
```

### Shebang

Kai pagalbinis failas _odin-script.sh_ Odino failo kataloge, _shebang_ eilutė turi būti tokia:

```shebang
#!./odin-script.sh
```

Kai _odin-script.sh_ yra viename iš katalogų, nurodytų PATH aplinkos kintamajame, _shebang_ eilutė turi būti tokia:

```shebang
#!/usr/bin/env odin-script.sh
```

## Kompiliavimas

```bash
odin build odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```
