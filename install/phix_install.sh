#!/usr/bin/env bash

# Versiją galima rasti http://phix.x10.mx/index.php
version="1.0.5"

[ -d "${HOME}/.local/phix" ] && rm --recursive "${HOME}/.local/phix"

cd /tmp
rm phix*.zip; rm -r phix
mkdir phix
array=("" 1 2 3 4)
for var in "${array[@]}";do wget "http://phix.x10.mx/phix.${version}${var:+.$var}.zip"; done
for var in "${array[@]}";do unzip "phix.${version}${var:+.$var}.zip" -d phix; done
wget http://phix.x10.mx/p64; mv p64 phix/p
cd phix
chmod 777 p
./p -test
cd ..
mv phix ${HOME}/.local/phix
rm phix*.zip

set_path='[[ ":${PATH}:" == *":${HOME}/.local/phix:"* ]] \
  || export PATH="${HOME}/.local/phix${PATH:+:${PATH}}"'

config_strings="#begin phix init

${set_path}

#end phix init"

readarray -td '
' config_array <<< "$config_strings"

sed -i "/${config_array[0]}/,/${config_array[@]: -1:1}/c\\" "${HOME}/.bashrc"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo "$config_strings" >> "${HOME}/.bashrc"

eval $"$set_path"

p --version
