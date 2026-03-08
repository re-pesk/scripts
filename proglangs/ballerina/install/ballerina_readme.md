[&#x2BA2;](../../install_readme.md "Atgal")

# Ballerina [<sup>&#x2B67;</sup>](https://ballerina.io/)

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas ir įterpiama jo įkėlimo komanda į .bashrc failą

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

Jeigu nėra įdiegta, įdiekite [curl](../utils/curl.md), unzip ir xargs (findutils).

## Diegimas

Paleidžiamas diegimo skriptas `balerina_install.sh`. Pabaigus diegimą, įvykdoma komanda

```bash
[[ -d "${HOME}/.opt/ballerina/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] \
    && export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"
```

Arba įvykdomos komandos terminale

```bash
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/ballerina-platform/ballerina-distribution/releases/latest" | \
  xargs basename |  cut -c 2-
)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -sSLO "https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip"
curl -sSLO "https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip.sha256"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "ballerina-${LATEST}-swan-lake.zip")" \
  "$(cat "ballerina-${LATEST}-swan-lake.zip.sha256" | awk -F'\(|\)= |\/| ' '{print $NF"  "$5".sha256"}')"

unzip -q "ballerina-${LATEST}-swan-lake.zip"
rm -rf "${HOME}/.opt/ballerina"
mv -T "./ballerina-${LATEST}-swan-lake" "${HOME}/.opt/ballerina"
rm -f ballerina-${LATEST}-swan-lake.zip*

[ -d "${HOME}/.opt/ballerina" ] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] \
    && export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad kelias `${HOME}/.opt/ballerina/bin` būtų automatiškai įtraukiamas į sistemos `PATH` kintamąjį.

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
