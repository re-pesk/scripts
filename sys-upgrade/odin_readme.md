[Atgal](./readme.md)

# Odin [&#x2B67;](ttps://odin-lang.org/)

## Diegimas

```bash
sudo apt install clang
url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/odin-lang/Odin/releases/latest)
url="${url//tag/download}/odin-linux-amd64-$(basename -- $url).tar.gz"
curl -sSLo- $url | tar --transform 'flags=r;s/^odin[^\/]+/odin/x' --show-transformed-names -xzvC "$HOME/.local"
ln -s $HOME/.local/odin/odin $HOME/.local/bin/odin
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

### Shebang

```shebang
#! ./odin-script-loader.sh -file
```

Failams paleisti reikalingas pagalbinis failas _odin-script-loader.sh_. Jis turi būti arba tame pačiame kataloge kaip ir leidžiamas failas, arba vianme iš katalogų, nurodytų aplinkos kintamajame `PATH`. Perkėlus pagalbinį failą į tokį katalogą, _shebang_ eilutė turi būti tokia:

```shebang
#!/usr/bin/env odin-script-loader.sh -file
```

Pagalbinio failo `odin-script-loader.sh` turinys:

```bash
#!/usr/bin/env bash
last="${@: -1}"
out="${last%.*}.bin"
/usr/bin/env -S odin run ${last} -out:${out} ${@:1:$(($#-1))}
```

## Kompiliavimas

```bash
odin build odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```
