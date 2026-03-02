#! /usr/bin/env -S bash

DEBUG=

APP_NAME="Chapel"

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/chapel-lang/chapel/releases/latest
# Gauti paskutinės programos versijos numerį iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(basename -- "$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/chapel-lang/chapel/releases/latest")")"
CURRENT="$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "chpl" "/usr/share/chapel"; then
  exit 1
fi

# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t chapel_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos instaliacinį failą.
# Atsisųsti failo patikros sumą iš programos tinklalapio ir išsaugoti į kintamąjį.
# Sulyginti failo patikros sumą su tinklalapio patikros suma.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/chapel-lang/chapel/releases/download/${LATEST}/chapel-${LATEST}-1.ubuntu24.amd64.deb"
curl -sL "https://github.com/chapel-lang/chapel/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('chapel-${LATEST}-1.ubuntu24.amd64.deb')) ~ div > div > span > span" \
| cut -c 8- > "chapel-${LATEST}-1.ubuntu24.amd64.deb.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "chapel-${LATEST}-1.ubuntu24.amd64.deb" "chapel-${LATEST}-1.ubuntu24.amd64.deb.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]//'{LATEST}'/"${LATEST}"}"
  exit 1
fi

# Įdiegti programą. Ištrinti laikiną aplanką.
sudo dkpg -i "chapel-${LATEST}-1.ubuntu24.amd64.deb"
sudo apt-get install -f

# Pataisyti failų nuosavybę
sudo chown root:root /usr/bin/chpl*
sudo chown -R root:root /usr/share/chapel

# Jeigu nepavyko įdiegti Chapel, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! chpl --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
# Patikrinti, ar kompiuteryje įdiegta Chapel versija yra vėliausia
CURRENT="$(chpl --version 2>/dev/null | head -n 1 | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{Latest}'/"${LATEST}"}"
