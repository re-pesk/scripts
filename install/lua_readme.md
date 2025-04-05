[Atgal](./readme.md)

# Lua [&#x2B67;](https://www.lua.org/)

* Paskiausias leidimas: 5.4.7
* Išleista: 2024-06-13

## Diegimas

Dabartinės versijos ieškokite [Lua puslapuyje](https://www.lua.org/download.html)

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/lua/lua/releases/latest")"
version="$(basename -- $url)"
curl -LRo - "https://www.lua.org/ftp/lua-${version#v}.tar.gz" | tar -xzC "/tmp"
[ -d "${HOME}/.lua" ] && rm --recursive "${HOME}/.lua"
curdir="$PWD"
cd "/tmp/lua-${version#v}"
make all test
make install INSTALL_TOP="${HOME}/.lua"
cd $curdir
rm -r "/tmp/lua-${version#v}"
unset url version

sed -i "/#begin lua init/,/#end lua init/c\\" "${HOME}/.bashrc"
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo '#begin lua init

[[ ":${PATH}:" == *":${HOME}/.lua/bin:"* ]] \
  || export PATH="${HOME}/.lua/bin${PATH:+:${PATH}}"
  
#end lua init' >> "${HOME}/.bashrc"

[[ ":${PATH}:" == *":${HOME}/.lua/bin:"* ]] || export PATH="${HOME}/.lua/bin${PATH:+:${PATH}}"
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
