[&uArr;](./readme.md)

# Scala [&#x2B67;](https://scala-lang.org/)

* Paskiausias leidimas: 3.6.4
* Išleista: 2025-03-07

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

Paleidžiamas diegimo skriptas `scala_install.sh`. Pabaigus diegimą, įvykdoma komanda

```bash
[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] || \
  export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"
```

Arba įvykdomos komandos terminale

```bash
# Gauti paskutinės programos versijos numerį iš interneto
VERSION="$(basename -- "$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)")"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija. Sulyginti versijas
printf "Vėliausia versija v${VERSION}\n"
printf "Instaliuota versija v$(scala version 2> /dev/null | tail -n 1 | sed 's/.*: //')\n"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

# Vėliausio leidimo adresas
URL="https://github.com/scala/scala3/releases/download/${VERSION}/scala3-${VERSION}-x86_64-pc-linux.tar.gz"

# Atsisiųsti failus iš interneto
curl -sSLo "scala3-${VERSION}-x86_64-pc-linux.tar.gz" "${URL}"
curl -sSLo "scala3-${VERSION}-x86_64-pc-linux.tar.gz.sha256" "${URL}.sha256"

# Išvesti įterminalą SHA256 kontrolines sumas, kad būtų galima sulyginti
sha256sum "scala3-${VERSION}-x86_64-pc-linux.tar.gz" | awk '{print $1}'
cat "scala3-${VERSION}-x86_64-pc-linux.tar.gz.sha256" | awk '{print $1}'

# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti

# Ištrinti esamą versiją. Išskleisti atsisiųstą archyvą. 
# Ištrinti atsisiųstus failus
rm -rf "${HOME}/.opt/scala3"
tar --file="scala3-${VERSION}-x86_64-pc-linux.tar.gz" \
  --transform='flags=r;s/^(scala3)[^\/]+/\1/x' \
  --show-transformed-names -xzvC "${HOME}/.opt"
rm -f scala3-${VERSION}-x86_64-pc-linux.tar.gz*

# Jeigu reikia, papildyti esamo terminalo kelią
[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] \
|| export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"

scala version
unset URL VERSION
```

Baigę diegti, pakeiskite konfigūracinius failus, kad `${HOME}/.opt/scala3/bin` būtų automatiškai įtraukiamas į sistemos `PATH` kintamąjį.

## Paleistis

```bash
scala run scala_sys-upgrade.scala
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S scala shebang
```

arba

```bash
///usr/bin/env -S scala shebang "$0" "$@"; exit $?
```
