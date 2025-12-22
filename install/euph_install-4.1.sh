#!/usr/bin/env -S bash

URL="$(curl -sL -o /dev/null -w %{url_effective} https://github.com/OpenEuphoria/euphoria/releases/latest)"
VERSION="$(basename $URL)"
URL="$(curl -sL https://api.github.com/repos/OpenEuphoria/euphoria/releases/latest | grep -o 'https.*Linux-x64.*tar.gz')"

[ -f "${HOME}/.pathrc" ] || touch "${HOME}/.pathrc"
INIT_DIR="$PWD"

echo -e "\nInstalling Euphoria ${VERSION}\n"
echo -e "Current directory => ${INIT_DIR}\n"

echo -e "Getting latest release\n"

[ -d "${HOME}/.opt/euphoria" ] && rm --recursive --force "${HOME}/.opt/euphoria"

curl -sSLo - "${URL}" \
| tar --transform "flags=r;s/^(euphoria)-${VERSION}[^\/]+x64/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

touch "${HOME}/.opt/euphoria/v${VERSION}.txt"

echo -e "Updating config file\n"

cd "${HOME}/.opt/euphoria/source"
./configure
find build -maxdepth 1 -type f -exec mv -t ../bin/ {} \+
rm --recursive --force build

cd "${HOME}/.opt/euphoria/bin"
sed -i 's/source\/build/bin/g' eu.cfg

echo -e "Compiling files\n"
for file in *.ex ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi 
done

cd ${INIT_DIR}

echo -e "\nWriting path to .pathrc\n"

sed -i "/#begin euphoria init/,/#end euphoria init/c\\" "${HOME}/.pathrc"
[[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

echo '#begin euphoria init

[[ ":${PATH}:" == *":${HOME}/.opt/euphoria/bin:"* ]] \
  || export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

#end euphoria init' >> "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/euphoria/bin:"* ]] \
  || export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

echo -e "eui --version => "; eui --version
echo -e "\neuc --version => "; euc --version

cd ${INIT_DIR}

echo -e "\nCurrent directory => $PWD\n"

echo -e "Euphoria ${VERSION} is installed!\n"
unset INIT_DIR URL VERSION
