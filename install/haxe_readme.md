[Atgal](./readme.md)

# Haxe [&#x2B67;](https://haxe.org/)

* Paskiausias leidimas: 4.3.6
* Išleista: 2024-08-07

## Diegimas

```bash
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
```

HashLink virtualios mašinos diegimas (baitkodo vykdymui):

```bash
[[ $(apt list 2>/dev/null | grep ^xq\/.*installed | wc -l) > 0 ]] || sudo apt-get install xq

latest=$(curl -s https://github.com/HaxeFoundation/hashlink/releases/tag/latest | xq -q code:first-of-type)
curl -fsSLo - https://github.com/HaxeFoundation/hashlink/releases/download/latest/hashlink-${latest}-linux-amd64.tar.gz \
| tar --transform 'flags=r;s/^(hashlink)[^\/]+/\1/x' --show-transformed-names -xzvC ${HOME}/.local
unset latest

sed -i "/#begin hashlink init/,/#end hashlink init/c\\" "${HOME}/.profile"
[[ "$( tail -n 1 "${HOME}/.profile" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.profile"

echo '#begin hashlink init

[[ ":${PATH}:" == *":${HOME}/.local/hashlink:"* ]] \
  || export PATH="${HOME}/.local/hashlink${PATH:+:${PATH}}"
  
#end hashlink init' >> "${HOME}/.profile"

[[ ":${PATH}:" == *":${HOME}/.local/hashlink:"* ]] || export PATH="${HOME}/.local/hashlink${PATH:+:${PATH}}"

hl --version ; echo
```

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
