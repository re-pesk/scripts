[&uArr;](./readme.md)

# Euphoria [&#x2B67;](https://openeuphoria.org/)

* Paskiausias leidimas: 4.2 (darbinis)
* Atnaujintas: 2025-01-24

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

Diegimas trunka keliais etapais:

* Jeigu nėra įdiegti, įdiegiami reikalingi paketai

```bash
sudo apt install build-essential git
```

* Įdiegiama 4.1 versija, reikalinga 4.2 versijos kompiliavimui

```bash
URL="$(curl -sL -o /dev/null -w %{url_effective} https://github.com/OpenEuphoria/euphoria/releases/latest)"
VERSION="$(basename $URL)"
URL="$(curl -sL https://api.github.com/repos/OpenEuphoria/euphoria/releases/latest | grep -o 'https.*Linux-x64.*tar.gz')"

[ -d "${HOME}/.opt/euphoria" ] && rm -rf "${HOME}/.opt/euphoria"

curl -sSLo - "${URL}" \
| tar --transform "flags=r;s/^(euphoria)-${VERSION}[^\/]+x64/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

touch "${HOME}/.opt/euphoria/v${VERSION}.txt"
unset URL VERSION

cd "${HOME}/.opt/euphoria/source"
./configure

find build -maxdepth 1 -type f -exec mv -t ../bin/ {} \+
rm --recursive --force build

sed -i 's/source\/build/bin/g' "${HOME}/.opt/euphoria/bin/eu.cfg"

for file in *.ex ; do
  echo "$file"
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" -gt 0 ]]; then

    exit "$exit_code"
  fi 
done

cp -T "${HOME}/.pathrc" "${HOME}/.pathrc.$(date +"%Y%m%d.%H%M%S.%3N")"
sed -i "/#begin euphoria init/,/#end euphoria init/c\\" "${HOME}/.pathrc"

echo '
#begin euphoria init

[[ ":${PATH}:" == *":${HOME}/.opt/euphoria/bin:"* ]] \
  || export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

#end euphoria init
' >> "${HOME}/.pathrc"

cat -s "${HOME}/.pathrc" > "${HOME}/.pathrc.new"
cp -T "${HOME}/.pathrc.new" "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/euphoria/bin:"* ]] \
  || export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

eui --version
euc --version
```

* Diegiamas veliausias 4.2 versijos kodas.

```bash
[ -d "/tmp/euphoria" ] && rm --recursive --force "/tmp/euphoria"

cd "/tmp"

git clone https://github.com/OpenEuphoria/euphoria

cd "/tmp/euphoria/source"
./configure
make

find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
cd "/tmp/euphoria/bin"

for file in *.{ex,exw} ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi 
done

cd "/tmp"

[ -d "${HOME}/.opt/euphoria" ] && mv -T "${HOME}/.opt/euphoria" "${HOME}/.opt/euphoria-4.1"
mv "/tmp/euphoria" $HOME/.opt/

eui --version
euc --version

cd "${HOME}/.opt/euphoria/source"
./configure
find build -maxdepth 1 -type f -exec mv -t "${HOME}/.opt/euphoria/bin/" {} \+
rm --recursive --force build
INIT_DIR="$PWD"
cd "${HOME}/.opt/euphoria/bin"
sed -i 's/source\/build/bin/g' eu.cfg

rm --recursive --force "${HOME}/.opt/euphoria-4.1"

cd "${INIT_DIR}"
```

* Siunčiamas pagalbinių programų eudoc ir creole kodas dokumentacijai generuoti

```bash
ADDONS=(eudoc creole)
for addon in ADDONS ;do
  cd "/tmp"

  [ -d "/tmp/${addon}" ] && rm --recursive --force "/tmp/${addon}"

  git clone https://github.com/OpenEuphoria/${addon}
  cd "/tmp/${addon}"
  echo -e "\nCurrent directory: $PWD\n"
  ./configure
  make
  cd "/tmp"
  mv "/tmp/${addon}/build/${addon}" "${HOME}/.opt/euphoria/bin"
  rm --recursive --force "/tmp/${addon}"
done
unset ADDONS
```

## Paleistis

```bash
eui kodo-failas.ex
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S eui
```

## Kompiliavimas

```bash
euc -o vykdomasis-failas.bin kodo-failas.ex
./vykdomasis-failas.bin
```
