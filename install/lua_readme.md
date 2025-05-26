[Atgal](./readme.md)

# Lua [&#x2B67;](https://www.lua.org/)

## Diegimas

Dabartinės versijos ieškokite [Lua puslapuyje](https://www.lua.org/download.html)

```bash
[ -d "${HOME}/.lua" ] && rm --recursive "${HOME}/.lua"

# Vykdydami komandas įrašykite dabartinės versijos numerį
curl -LRo - https://www.lua.org/ftp/lua-5.4.7.tar.gz | tar xzC "/tmp"
curdir="$PWD"
cd "/tmp/lua-5.4.7"
make all test
make install INSTALL_TOP="${home/.lua"
cd $curdir
rm -r "/tmp/lua-5.4.7"

sed -i "/#begin lua init/,/#end lua init/c\\" "${HOME}/.bashrc"
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"
echo -e "#begin lua init\n\n"'[[ ":${PATH}:" == *":${HOME}/.lua/bin:"* ]] \
  || export PATH="${HOME}/.lua/bin${PATH:+:${PATH}}"'"\n\n#end lua init" >> "${HOME}/.bashrc"

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
