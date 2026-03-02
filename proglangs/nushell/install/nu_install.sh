#! /usr/bin/env -S bash

DEBUG=

APP_NAME="Nushell"

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį iš repozitorijos
# Vėliausią versiją galima rasti https://github.com/nushell/nushell/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/nushell/nushell/releases/latest" | xargs basename)"
CURRENT="$(nu -v 2> /dev/null)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "nu" "${HOME}/.opt/nu"; then
  exit 1
fi

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą.
# Sukurti failą su patikros suma iš tinklalapio.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t nushell_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1
curl -sSLO \
  "https://github.com/nushell/nushell/releases/download/${LATEST}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz"
curl -sSL "https://github.com/nushell/nushell/releases/expanded_assets/${LATEST}" \
  | xq -q "li > div:has(a span:contains('nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz')) ~ div > div > span > span" \
  | awk -F ':' '{print $NF}' \
  > "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 \
  "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  "nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/nu"
tar --file="${TMP_DIR}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzvC "${HOME}/.opt"

# Įtraukti įdiegtos programos kelią į sistemos kintamąjį
PATH_COMMAND=$'[[ -d "${HOME}/.opt/nu" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/nu:"* ]] \
    && export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! nu -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą.
CURRENT="$(nu -v 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" 'Nushell' '${HOME}/.opt/nu'
