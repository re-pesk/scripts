[Atgal](./readme.md)

# Lua [&#x2B67;](https://www.lua.org/)

* Paskiausias leidimas: 5.4.7
* Išleista: 2024-06-13

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

## Diegimas

Dabartinės versijos ieškokite [Lua puslapyje](https://www.lua.org/download.html)

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/lua/lua/releases/latest")"
version="$(basename -- $url)"
curl -LRo - "https://www.lua.org/ftp/lua-${version#v}.tar.gz" | tar -xzC "/tmp"
[ -d "${HOME}/.opt/lua" ] && rm --recursive "${HOME}/.opt/lua"
curdir="$PWD"
cd "/tmp/lua-${version#v}"
make all test
make install INSTALL_TOP="${HOME}/.opt/lua"
cd $curdir
rm -r "/tmp/lua-${version#v}"
unset curdir url version

sed -i "/#begin lua init/,/#end lua init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin lua init

[[ ":${PATH}:" == *":${HOME}/.opt/lua/bin:"* ]] \
  || export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"
  
#end lua init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/lua/bin:"* ]] || export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"
lua -v
```

## Paleistis

```bash
lua kodo-failas.lua
```

### Shabang

```bash
#!/usr/bin/env -S lua
```

## Kompiliavimas

```bash
luac -o vykdomasis-failas.bin kodo-failas.lua
lua kodo-failas.bin
```
