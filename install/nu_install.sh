#! /usr/bin/env bash

# Failų pavadinimų ieškokite https://github.com/nushell/nushell/releases/latest

CURRENT_VERSION="$(nu -v 2> /dev/null)"
VERSION="$(basename "$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/nushell/nushell/releases/latest")")"
[[ "${VERSION}" == "${CURRENT_VERSION}" ]] && {
  printf "\n%s\n\n" "Nushell version is up to date!"
  exit 0
}

TO_INSTALL="y"
[[ "${CURRENT_VERSION}" != "" ]] && [[ -d "${HOME}/.opt/nu" ]] && {
  echo
  printf "Nushell v${CURRENT_VERSION} is installed. Do you want overwrite it?
Print 'y' to overwrite. Print 'n' or <Enter> to exit: \e[s"
  read -r TO_INSTALL
  [[ "${TO_INSTALL}" == "" ]] && printf "\e[u<Enter>\n"
  [[ "${TO_INSTALL}" != "y" ]] && { printf "\nNushell version is not up to date!\n\n"; exit 0; }

}

rm -rf "${HOME}/.opt/nu"
URL="https://github.com/nushell/nushell/releases/download/${VERSION}/nu-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
curl -sSLo- "${URL}" | tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "${HOME}/.opt"

[[ "$(grep 'export PATH="\${HOME}/.opt/nu\$' < ${HOME}/.pathrc | wc -l)" > 0 ]] || {
  sed --in-place=".$(date +"%Y%m%d-%H%M%S-%3N")" '/#begin nushell init/,/#end nushell init/d'  "${HOME}/.pathrc"
  sed --in-place '/^[[:space:]]*$/N; /^\n$/D' "${HOME}/.pathrc"
  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"

  printf '#begin nushell init

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] \
  || export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

#end nushell init\n\n' >> "${HOME}/.pathrc"
}

[[ ":${PATH}:" == *":${HOME}/.opt/nu:"* ]] || \
  export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

[[ "$(nu -v 2> /dev/null )" == "${VERSION}" ]] || { echo "Nushell version is not up to date!"; exit 1; }
printf "\nNushell v${VERSION} is succesfully installed\n\n"
