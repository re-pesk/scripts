[Grįžti &#x2BA2;](../../install_readme.md "Grįžti")

# Haxe [<sup>&#x2B67;</sup>](https://haxe.org/)

* Paskiausias leidimas: 4.3.6
* Išleista: 2024-08-07

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

Jeigu nėra įdiegtos, įdiegiamos [curl](../utils/curl.md) ir [xq](../utils/xq.md)

## Diegimas

Haxe diegimas:

```bash
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
haxe --version
```

HashLink virtualios mašinos diegimas (baitkodo vykdymui):

```bash
COMMIT="$(curl -s "https://github.com/HaxeFoundation/hashlink/releases/tag/latest" | xq -q "code:first-of-type")"
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/HaxeFoundation/hashlink/releases/latest | xargs basename).0"

# Patikrinti, ar kompiuteryje įdiegta kuri nors programos versija, sulyginant versijas
# Jeigu vėliausia programos versija nėra naujesnė nei įdiegtoji, diegimą nutraukti.
printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(hl --version 2> /dev/null)"

# Atsisiųsti failą iš svetainės
curl -fsSLO https://github.com/HaxeFoundation/hashlink/releases/download/latest/hashlink-${COMMIT}-linux-amd64.tar.gz

# Išvesti į terminalą SHA256 kontrolines sumas, kad galima būtų sulyginti
# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti ir ištrinti atsisiųstus failus.
printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "hashlink-${COMMIT}-linux-amd64.tar.gz" | awk '{print $1}')" \
  "$(curl -sL "https://github.com/HaxeFoundation/hashlink/releases/expanded_assets/latest/${LATEST}" \
| xq -q "li > div:has(a span:contains('hashlink-latest-linux-amd64.tar.gz')) ~ div > div > span > span" \
| awk -F':' '{print $NF}')"

rm -rf "${HOME}/.opt/hashlink"
tar --file="hashlink-${COMMIT}-linux-amd64.tar.gz" \
  --transform='flags=r;s/^(hashlink)[^\/]+/\1/x' \
  --show-transformed-names -xzvC ${HOME}/.opt
rm -f "hashlink-${COMMIT}-linux-amd64.tar.gz"

[[ -d "${HOME}/.opt/hashlink" ]] && {
  [[ ":${PATH}:" == *":${HOME}/.opt/hashlink:"* ]] ||\
    export PATH="${HOME}/.opt/hashlink${PATH:+:${PATH}}"
}

printf '\nVersijos:\n  Vėliausia: v%s\n  Įdiegta:   v%s\n\n' \
  "${LATEST}" "$(hl --version 2> /dev/null)"

unset COMMIT LATEST
```

Baigę diegti, pakeiskite konfigūracinius failus, kad kelias `${HOME}/.opt/hashlink` būtų įtraukiamas į sistemos `PATH` kintamąjį.

## Paleistis

```bash
haxe --run Pagrindinė_klasė.hx
```

kur „Pagrindinė_klasė“ yra klasės su statiniu metodu „main“ pavadinimas. Failo, kuriame saugoma klasė, pavadinimas turi sutapti su pagrindinės klasės, o jo plėtinys turi būti „.hx“

### Vykdymo eiluė

Norint kodo failą paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti eilutę:

```bash
///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?
```

### Kompiliavimas

```bash
haxe -hl vykdomasis-failas.hl -main Pagrindinė_klasė.hx
hl vykdomasis-failas.hl
```
