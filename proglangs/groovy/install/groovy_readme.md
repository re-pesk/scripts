[Grįžti &#x2BA2;](../../install_readme.md "Grįžti")

# Groovy [<sup>&#x2B67;</sup>](https://groovy-lang.org/)

* Paskiausias leidimas: 5.0.4
* Išleista: 2025-02-25

## Parengimas

Jeigu nėra sukurtas, sukuriamas ~/.pathrc failas, į .bashrc failą įterpiama jo įkėlimo komanda

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

Jeigu nėra įdiegtos, įdiegiamos [curl](../utils/curl.md), unzip ir [xq](../utils/xq.md)

## Diegimas

```bash
# Versijos numerį galima pasitikrinti "https://groovy.apache.org/download.html#distro"
LATEST="$( curl -s https://groovy.apache.org/download.html#distro \
  | xq -q "button[id='big-download-button']" --attr "onclick" \
  | awk -F'["-]' '{print $(NF-1)}' | sed 's/\.zip$//' )"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija, sulyginant versijas
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(groovy --version 2> /dev/null | awk '{print $3}')"

# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.

# Atsisiųsti failą iš svetainės
curl -sSLO "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${LATEST}.zip"

# Išvesti į terminalą SHA256 kontrolines sumas, kad galima būtų sulyginti
# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti ir ištrinti atsisiųstus failus.
printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "apache-groovy-sdk-${LATEST}.zip" | awk '{print $1}')" \
  "$(curl -sSL "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip.sha256" |\
  tr -d '\r')"

# Išskleisti iš svetainės atsisiųstą failą.
# Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotą katalogą į diegimo katalogą.
# Ištrinti atsisiųstą failą
unzip "groovy-sdk-${LATEST}.zip"
rm -rf "${HOME}/.opt/groovy"
mv -T "groovy-${LATEST}" "${HOME}/.opt/groovy"
rm -f "groovy-sdk-${LATEST}.zip"

# Sukurti sistemos kintamąjį, jeigu jo nėra
# Įtraukti įdiegtos programos kelią, kad galima būtų ją kviesti,
# neprisijungus prie vartotojo paskyros iš naujo.
[ -z "$JAVA_HOME" ] && {
  JAVA_HOME="$(which java | xargs readlink -f | xargs dirname | xargs dirname)"
  export JAVA_HOME
}

[[ -d "${HOME}/.opt/groovy/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/groovy/bin:"* ]] \
  && export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(groovy --version 2> /dev/null | awk '{print $3}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad būtų automatiškai kuriamas `JAVA_HOME` kintamasis, o kelias `${HOME}/.opt/groovy/bin` būtų įtraukiamas į sistemos `PATH` kintamąjį.

arba

```bash
bash groovy_install.sh
```

## Paleistis

```bash
groovy kodo-failas.groovy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S groovy
```

arba

```bash
///usr/bin/env groovy "$0" "$@"; exit $?
```
