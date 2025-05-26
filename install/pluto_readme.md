[&uArr;](./readme.md)

# Pluto [&#x2B67;](https://pluto-lang.org/)

* Paskiausias leidimas: 0.10.4
* Išleista: 2025-02-15

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/PlutoLang/Pluto/releases/latest)"
version="$(basename -- ${url})"
[ -d "${HOME}/.opt/pluto" ] && rm --recursive "${HOME}/.opt/pluto"
curdir="$PWD"
mkdir -p $HOME/.opt/pluto; cd $HOME/.opt/pluto
curl -sSLo "/tmp/pluto.zip" "${url//tag/download}/Linux.X64.zip" 
unzip -d $HOME/.opt/pluto "/tmp/pluto.zip"
rm -r "/tmp/pluto.zip"
cd $curdir
for filename in $HOME/.opt/pluto/pluto*; do ln -fs $filename -t ${HOME}/.local/bin; done
pluto -v
```

## Paleistis

```bash
pluto kodo-failas.pluto
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env pluto
```

## Kompiliavimas

Kompiliavimas į baitkodą ir vykdymas:

```bash
plutoc -o baitkodo-failas.bin kodo-failas.pluto
pluto baitkodo-failas.bin
```
