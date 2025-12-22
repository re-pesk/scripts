#!/usr/bin/env -S bash

INIT_DIR="$PWD"
TMP_DIR="/tmp"
cd "${TMP_DIR}"

echo -e "\nInstalling euphoria 4.2 to ${HOME}/.opt/euphoria\n"
echo -e "Current directory => $PWD\n"

[ -d "${TMP_DIR}/euphoria" ] && rm -rf "${TMP_DIR}/euphoria"

echo -e "Cloning git repository of Euphoria 4.2\n"
git clone https://github.com/OpenEuphoria/euphoria "euphoria"

cd "${TMP_DIR}/euphoria/source"
echo -e "Current directory => $PWD\n"
echo -e "\nCompiling Euphoria 4.2\n"
./configure
make

echo -e "Copying compiled files to bin\n"

find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
# find build -maxdepth 1 -type f -exec mv -t "${TMP_DIR}/euphoria/bin" {} \+
cd "${TMP_DIR}/euphoria/bin"

echo -e "Current directory => $PWD\n"

for file in *.{ex,exw} ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi 
done

cd "${TMP_DIR}"

echo -e "Current directory => $PWD\n"

echo -e "Replacing Euphoria 4.1 with 4.2\n"

[ -d "${HOME}/.opt/euphoria" ] && mv -T "${HOME}/.opt/euphoria" "${HOME}/.opt/euphoria-4.1"
mv "${TMP_DIR}/euphoria" $HOME/.opt/

echo -e "eui --version => \n"; eui --version
echo -e "euc --version => \n"; euc --version

echo -e "Updating config file\n"

cd "${HOME}/.opt/euphoria/source"
echo -e "Current directory => $PWD\n"
./configure
find build -maxdepth 1 -type f -exec mv -t "${HOME}/.opt/euphoria/bin/" {} \+
rm -rf build

sed -i 's/source\/build/bin/g' "${HOME}/.opt/euphoria/bin/eu.cfg"

rm -rf "${HOME}/.opt/euphoria-4.1"

cd "${INIT_DIR}"

echo -e "\nCurrent directory => $PWD\n"

echo -e "Euphoria 4.2 is installed!\n"
unset INIT_DIR TMP_DIR
