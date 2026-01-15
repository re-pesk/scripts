#!/usr/bin/env bash

# Remove entry from ~/.parthrc
if [ -f "${HOME}/.pathrc" ]; then
  sed -i "/#begin include .pathrc/,/#end include .pathrc/c\\" "${HOME}/.pathrc"
  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"
fi

[[ "$(grep 'export PATH="\${HOME}/.opt/nu\$' < ${HOME}/.pathrc | wc -l)" > 0 ]] || {
  sed --in-place=".$(date +"%Y%m%d-%H%M%S-%3N")" '/#begin nushell init/,/#end nushell init/d'  "${HOME}/.pathrc"
  sed --in-place '/^[[:space:]]*$/N; /^\n$/D' "${HOME}/.pathrc"
  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

  echo '#begin abcd init

  [[ ":${PATH}:" == *":${HOME}/.opt/abcd:"* ]] \
    || export PATH="${HOME}/.opt/abcd${PATH:+:${PATH}}"

  #end abcd init' >> "${HOME}/.pathrc"

  [[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] || \
    export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

}
