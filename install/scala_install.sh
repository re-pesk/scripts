#!/usr/bin/env bash

. ./helpers.sh

CURRENT_VERSION="$(scala version 2> /dev/null | tail -n 1 | sed 's/.*: //')"
VERSION="$(basename -- "$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)")"
ask_to_install "${CURRENT_VERSION}" "${VERSION}" "Scala" "${HOME}/.opt/scala3"

TMP_DIR="$(mktemp -d)"
FILE_NAME="scala3-${VERSION}-x86_64-pc-linux.tar.gz"
URL="https://github.com/scala/scala3/releases/download/${VERSION}/${FILE_NAME}"
curl -sSLo "${TMP_DIR}/${FILE_NAME}" "${URL}"
curl -sSLo "${TMP_DIR}/${FILE_NAME}.sha256" "${URL}.sha256"
compare_sha256 "${TMP_DIR}/${FILE_NAME}" "${TMP_DIR}/${FILE_NAME}.sha256"

rm -rf "${HOME}/.opt/scala3"
tar --file="${TMP_DIR}/${FILE_NAME}" --transform='flags=r;s/^(scala3)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -rf "${TMP_DIR}"

insert_path '${HOME}/.opt/scala3/bin' 'scala' "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] || \
  export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"

CURRENT_VERSION="$(scala version 2> /dev/null | tail -n 1 | sed 's/.*: //')"
[[ "${CURRENT_VERSION}" == "${VERSION}" ]] || { 
  echo "Scala were not updated!"
  exit 1
}
printf "\nScala v${VERSION} is succesfully installed.\n\n"
printf 'To use without relogging, execute the following command in the terminal:

[[ ":${PATH}:" == *":${HOME}/.opt/scala3/bin:"* ]] || \
  export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"\n\n'
