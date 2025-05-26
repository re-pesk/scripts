[&uArr;](./readme.md)

# Haxe [&#x2B67;](https://haxe.org/)

* Paskiausias leidimas: 4.3.6
* Išleista: 2024-08-07

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

Jeigu nėra įdiegtos, įdiegiamos [curl](../utils/curl.md) ir [xq](../utils/xq.md)

## Diegimas

```bash
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
haxe --version
```

HashLink virtualios mašinos diegimas (baitkodo vykdymui):

```bash
latest=$(curl -s https://github.com/HaxeFoundation/hashlink/releases/tag/latest | xq -q code:first-of-type)
curl -fsSLo - https://github.com/HaxeFoundation/hashlink/releases/download/latest/hashlink-${latest}-linux-amd64.tar.gz \
| tar --transform 'flags=r;s/^(hashlink)[^\/]+/.\1/x' --show-transformed-names -xzvC ${HOME}/.opt
unset latest

sed -i "/#begin hashlink init/,/#end hashlink init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

install_dir=".opt/hashlink"
echo '#begin hashlink init

[[ ":${PATH}:" == *":${HOME}/'${install_dir}':"* ]] \
  || export PATH="${HOME}/'${install_dir}'${PATH:+:${PATH}}"
  
#end hashlink init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/${install_dir}:"* ]] || export PATH="${HOME}/${install_dir}${PATH:+:${PATH}}"

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
