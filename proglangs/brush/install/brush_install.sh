#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Brush"

# # Sukurti simbolinę nuorodą į pranešimų failą
# MESSAGES_FILE="$(realpath ../../../shell/install_helpers/_messages.sh)"
# cmp -s ../../_messages.sh "${MESSAGES_FILE}" || cp -sfit ../../ "${MESSAGES_FILE}"

# source ../../_messages.sh

# Sukurti simbolinę nuorodą į pagalbinių funkcijų failą
HELPERS_FILE="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS_FILE}" || cp -sfit ../../ "${HELPERS_FILE}"

# Įkelti pagalbines funkcijas
source ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/reubeno/brush/releases/latest
# Gauti programos paskutinės versijos numerį iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/reubeno/brush/releases/latest" | \
  xargs basename | awk -F'-' '{print $NF}')"
CURRENT="$(brush --version 2> /dev/null | awk '{print $2}')"
if ! ask_to_install "${LATEST#v}" "${CURRENT}" "brush" "${HOME}/.opt/brush"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti automatinį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t brush_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
URL="https://github.com/reubeno/brush/releases/download/brush-shell-${LATEST}/brush-x86_64-unknown-linux-musl"
curl -sSLO "${URL}.tar.gz"
curl -sSLO "${URL}.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 "brush-x86_64-unknown-linux-musl.tar.gz" "brush-x86_64-unknown-linux-musl.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]//'{LATEST}'/"${LATEST}"}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Jeigu nesėkmė, nutraukti diegimą.
rm -rf "${HOME}/.opt/brush"
if ! tar --file "${TMP_DIR}/brush-x86_64-unknown-linux-musl.tar.gz" \
  --transform 'flags=r;s//brush\//x' \
  --show-transformed-names -xzC "${HOME}/.opt" 2> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_extracted]}"
  exit 1
fi

ln -fs "${HOME}/.opt/brush/brush" -t "${HOME}/.local/bin/"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! brush --version &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(brush --version 2> /dev/null | awk '{print $2}')"
if [[ "${CURRENT}" != "${LATEST#v}" ]]; then
  errorMessage "${LANG_MESSAGES[not_installed]//'{LATEST}'/"${LATEST}"}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"
