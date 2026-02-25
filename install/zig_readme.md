[&#x2BA2;](./install_readme.md "Atgal")

# Zig [<sup>&#x2B67;</sup>](https://ziglang.org/)

* Paskiausias leidimas: 0.15.2
* Išleista: 2025-10-11

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, įterpiamas jo įkėlimo komanda į .bashrc failą

```bash
[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
(( $(grep -c '#begin include .pathrc' < ${HOME}/.bashrc) > 0 )) \
|| echo '#begin include .pathrc

# include .pathrc if it exists
if [ -f "${HOME}/.pathrc" ]; then
  . "${HOME}/.pathrc"
fi

#end include .pathrc' >> ${HOME}/.bashrc
```

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas Linuxe (Ubuntu 24.04)

```bash
# Vėliausią versijos numerį galima rasti https://ziglang.org/download/
# Gauti įdiegtos programos versijos numerį.
LATEST="$(curl -Lso - https://ziglang.org/download/index.json |\
  jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last')"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija.
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(zig version 2> /dev/null)"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.

# Parsiųsti instaliacinio archyvo duomenis iš tinklalapio į asociatyvų masyvą
declare -A DATA="($(
  curl -s "https://ziglang.org/download/index.json" |\
  jq -r '.[] | select(.version == "'${LATEST}'") | .["x86-linux"] | "[tarball]=" + .tarball + " [shasum]=" + .shasum'
))"
URL="${DATA["tarball"]}"

# Atsisiųsti failą iš tinklalapio
curl -sSLo "zig-x86_64-linux-${LATEST}.tar.xz" "${URL}"

# Išvesti į terminalą SHA256 kontrolines sumas, kad būtų galima sulyginti
# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti, atsisiųstus failus ištrinti.
sha256sum "zig-x86_64-linux-${LATEST}.tar.xz" | awk '{print "\n"$1}'; \
printf '%s\n\n' "${DATA["shasum"]}"

[ -d "${HOME}/.opt/zig" ] && rm -rf "${HOME}/.opt/zig"
tar --file="zig-x86_64-linux-${LATEST}.tar.xz" \
  --transform='flags=r;s/^zig[^\/]+/zig/x' \
  --show-transformed-names -xJC "${HOME}/.opt"
rm -f "zig-x86_64-linux-${LATEST}.tar.xz"

# Sukurti nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/zig/zig" "${HOME}/.local/bin"

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(zig version 2> /dev/null)"

unset DATA URL LATEST
```

Arba galite įdiegti automatiniu būdu, paleisdami skriptą `zig_instal.sh`.

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
