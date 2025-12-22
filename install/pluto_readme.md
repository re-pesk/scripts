[&uArr;](./readme.md)

# Pluto [&#x2B67;](https://pluto-lang.org/)

* Paskiausias leidimas: 0.10.4
* Išleista: 2025-02-15

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
[ -d "${HOME}/.opt/pluto" ] && rm -r "${HOME}/.opt/pluto"
URL="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/PlutoLang/Pluto/releases/latest)"
TMP_DIR="$(mktemp -d)"
curl -sSLo "${TMP_DIR}/pluto.zip" "${URL//tag/download}/Linux.X64.zip" 
mkdir -p $HOME/.opt/pluto
unzip -d $HOME/.opt/pluto "${TMP_DIR}/pluto.zip"
rm -r "${TMP_DIR}"
unset TMP_DIR URL
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
