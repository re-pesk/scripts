[&uArr;](./readme.md)

# Zig [&#x2B67;](https://ziglang.org/)

* Paskiausias leidimas: 0.14.0
* Išleista: 2025-03-05

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

## Diegimas Linuxe (Ubuntu 24.04)

```bash
# Vėliausią versijos numerį galima rasti https://ziglang.org/download/
VERSION="$(curl -Lso - https://ziglang.org/download/index.json \
| jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last')"

[ -d "${HOME}/.opt/zig" ] && rm -rf "${HOME}/.opt/zig"
curl -sSLo- "https://ziglang.org/download/${VERSION}/zig-x86_64-linux-${VERSION}.tar.xz" \
| tar --transform 'flags=r;s/^zig[^\/]+/zig/x' --show-transformed-names -xJC "${HOME}/.opt"

unset VERSION

# Jeigu reikia, pašalinami zig įrašai .pathrc konfigūraciniame faile
sed -i '/#begin zig init/,/#end zig init/c\' "${HOME}/.pathrc"
# Jeigu reikia, pridedama tučia eilutė
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

# Jeigu nėra, pridedami zig įrašai .pathrc konfigūraciniame faile
(( $(cat "$HOME/.pathrc" | grep '^#begin zig init' | wc -l) > 0 )) || echo '#begin zig init

[[ ":${PATH}:" == *":${HOME}/.opt/zig:"* ]] \
|| export PATH="${HOME}/.opt/zig${PATH:+:${PATH}}"

#end zig init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/zig:"* ]] \
|| export PATH="${HOME}/.opt/zig${PATH:+:${PATH}}"

zig version
```

arba paleislite `zig_instal.sh` failą

```bash
bash zig_instal.sh
```

## Paleistis

```bash
zig run --name vykdomasis-failas.bin kodo-failas.zig
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S zig run "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name vykdomasis-failas.bin kodo-failas.zig
rm vykdomasis-failas.bin.o
```
