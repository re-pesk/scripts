[Atgal](./readme.md)

# Phix [&#x2B67;](http://phix.x10.mx/index.php)

* Paskiausias leidimas: 1.0.5
* Išleista: 2024-06-01

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

## Diegimas

```bash
# Versiją galima rasti http://phix.x10.mx/index.php
version="1.0.5"

[ -d "${HOME}/.opt/phix" ] && rm --recursive "${HOME}/.opt/phix"

cd /tmp
rm phix*.zip; rm -r phix
mkdir phix
array=("" 1 2 3 4)
for var in "${array[@]}";do wget "http://phix.x10.mx/phix.1.0.5${var:+.$var}.zip"; done
for var in "${array[@]}";do unzip "phix.1.0.5${var:+.$var}.zip" -d phix; done
unset array

wget http://phix.x10.mx/p64; mv p64 phix/p
cd phix
chmod +x p
./p -test
cd ..
mv phix ${HOME}/.opt/phix
rm phix*.zip

sed -i "/#begin phix init/,/#end phix init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin phix init

[[ ":${PATH}:" == *":${HOME}/.opt/phix:"* ]] \
  || export PATH="${HOME}/.opt/phix${PATH:+:${PATH}}"

#end phix init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/phix:"* ]] \
  || export PATH="${HOME}/.opt/phix${PATH:+:${PATH}}"

p --version
```

## Paleistis

```bash
p kodo-failas.exw
```

### Vykdymo instrukcija (shebang)

Shebangas veikia tik tada, jeigu failas yra `~/phix` kataloge.

```bash
#!/usr/bin/env -S p
```

## Kompiliavimas

```bash
p -c kodo-failas.exw
```
