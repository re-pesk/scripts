[Atgal](./readme.md)

# Phix [&#x2B67;](http://phix.x10.mx/index.php)

## Diegimas

```bash
# Versiją galima rasti http://phix.x10.mx/index.php
version="1.0.5"

[ -d "${HOME}/.local/phix" ] && rm --recursive "${HOME}/.local/phix"

cd /tmp
rm phix*.zip; rm -r phix
mkdir phix
array=("" 1 2 3 4)
for var in "${array[@]}";do wget "http://phix.x10.mx/phix.1.0.5${var:+.$var}.zip"; done
for var in "${array[@]}";do unzip "phix.1.0.5${var:+.$var}.zip" -d phix; done
wget http://phix.x10.mx/p64; mv p64 phix/p
cd phix
chmod +x p
./p -test
cd ..
mv phix ${HOME}/.local/phix
rm phix*.zip

sed -i "/#begin phix init/,/#end phix init/c\\" "${HOME}/.bashrc"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo '#begin phix init

[[ ":${PATH}:" == *":${HOME}/.local/phix:"* ]] \
  || export PATH="${HOME}/.local/phix${PATH:+:${PATH}}"

#end phix init' >> "${HOME}/.bashrc"

[[ ":${PATH}:" == *":${HOME}/.local/phix:"* ]] \
  || export PATH="${HOME}/.local/phix${PATH:+:${PATH}}"

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
