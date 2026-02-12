[&#x2BA2;](./readme.md "Atgal")

# Ballerina [<sup>&#x2B67;</sup>](https://ballerina.io/)

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

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

## Diegimas

Paleidžiamas diegimo skriptas `balerina_install.sh`. Pabaigus diegimą, įvykdoma komanda

```bash
[[ ":${PATH}:" == *":${HOME}/.opt/ballerina/bin:"* ]] || \
  export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"
```

Arba įvykdomos komandos terminale

```bash
# Gauti paskutinės programos versijos numerį iš interneto
VERSION="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/ballerina-platform/ballerina-distribution/releases/latest" )"
VERSION="$(basename "${VERSION}")"
VERSION="${VERSION#v}"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf "Vėliausia versija v${VERSION}\n"
printf "Instaliuota versija v"; bal --version 2>/dev/null | head -n 1 | sed -E 's/^\w+ ([0-9\.]+) .+$/\1/'

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

# Vėliausio leidimo adresas
URL="https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${VERSION}/ballerina-${VERSION}-swan-lake.zip"

# Atsisiųsti failus iš interneto
curl -sSLo "ballerina-${VERSION}-swan-lake.zip" "${URL}"
curl -sSLo "ballerina-${VERSION}-swan-lake.zip.sha256" "${URL}.sha256"

# Išvesti įterminalą SHA256 kontrolines sumas, kad būtų galima sulyginti
sha256sum "ballerina-${VERSION}-swan-lake.zip" | awk '{print $1}'
cat "ballerina-${VERSION}-swan-lake.zip.sha256" | awk '{print $2}'

# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti

# Išskleisti iš interneto atsisiųstą archyvą. Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotus failus į diegimo katalogą. Ištrinti atsisiųstus failus
unzip -q "ballerina-${VERSION}-swan-lake.zip"
rm -rf "${HOME}/.opt/ballerina"
mv -T "./ballerina-${VERSION}-swan-lake" "${HOME}/.opt/ballerina"
rm -f ballerina-${VERSION}-swan-lake.zip*

# Jeigu reikia, papildyti esamo terminalo kelią
[[ ":${PATH}:" == *":${HOME}/.opt/ballerina/bin:"* ]] || \
  export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"

bal version
unset URL VERSION
```

Baigę diegti, pakeiskite konfigūracinius failus, kad `${HOME}/.opt/ballerina/bin` būtų automatiškai įtraukiamas į sistemos `PATH` kintamąjį.

## Paleistis

```bash
bal run kodo-failas.bal
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S bal run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
bal build kodo-failas.bal
bar run kodo-failas.jar
```
