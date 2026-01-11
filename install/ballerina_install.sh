#! /usr/bin/env bash

. ./helpers.sh

CURRENT_VERSION="$(bal --version 2>/dev/null | head -n 1 | sed -E 's/^\w+ ([0-9\.]+) .+$/\1/')"
VERSION="$(basename "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  "https://github.com/ballerina-platform/ballerina-distribution/releases/latest"
)")"
VERSION="${VERSION#v}"
ask_to_install "${CURRENT_VERSION}" "${VERSION}" "Ballerina" "${HOME}/.opt/ballerina"

TMP_DIR="$(mktemp -d)"
FILE_NAME="ballerina-${VERSION}-swan-lake.zip"
URL="https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${VERSION}/${FILE_NAME}"

echo "Downloading Ballerina v${VERSION} from ${URL}"
curl -sSLo "${TMP_DIR}/${FILE_NAME}" "${URL}"
curl -sSLo "${TMP_DIR}/${FILE_NAME}.sha256" "${URL}.sha256"
compare_sha256 "${TMP_DIR}/${FILE_NAME}" "${TMP_DIR}/${FILE_NAME}.sha256" '{print $1}' '{print $2}'

unzip -q "${TMP_DIR}/ballerina-${VERSION}-swan-lake.zip" -d "${TMP_DIR}"
rm -rf "${HOME}/.opt/ballerina"
mv -T "${TMP_DIR}/ballerina-${VERSION}-swan-lake" "${HOME}/.opt/ballerina"
rm -rf "${TMP_DIR}"

insert_path '${HOME}/.opt/ballerina/bin' 'ballerina' "${HOME}/.pathrc"

[[ ":${PATH}:" == *":${HOME}/.opt/ballerina/bin:"* ]] || \
  export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"

CURRENT_VERSION="$(bal --version 2>/dev/null | head -n 1 | sed -E 's/^\w+ ([0-9\.]+) .+$/\1/')"
[[ "${CURRENT_VERSION}" == "${VERSION}" ]] || { 
  echo "Ballerina is not up to date!"
  exit 1
}
printf "\nBallerina v${VERSION} is succesfully installed\n\n"
printf 'To use without relogging, execute the following command in the terminal:

[[ ":${PATH}:" == *":${HOME}/.opt/ballerina/bin:"* ]] || \
  export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"\n\n'
