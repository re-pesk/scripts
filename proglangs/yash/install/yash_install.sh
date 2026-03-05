#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Yash"

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl make xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Vėliausią versiją galima rasti https://github.com/magicant/yash/releases/latest
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/magicant/yash/releases/latest" | xargs basename)"
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
# shellcheck disable=SC2155
declare -A LANG_MESSAGES="($(update_lang_messages LANG_MESSAGES))"

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "yash" "${HOME}/.opt/yash"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t yash_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/magicant/yash/releases/download/${LATEST}/yash-${LATEST}.tar.gz"
curl -sSL "https://github.com/magicant/yash/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('yash-${LATEST}.tar.gz')) ~ div > div > span > span" \
| awk -F':' '{print $NF}' > "yash-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "yash-${LATEST}.tar.gz" \
  "yash-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskleisti iš repozitorijos atsisiųstą archyvą į laikiną aplanką.
# Pereiti į išskleisto archyvo aplanką.
# Sukonfiguruoti diegimo programą, nurodant diegimo aplanką.
# Sukompiliuoti programą.
tar --file="yash-${LATEST}.tar.gz" -xzv
cd "yash-${LATEST}" || exit 1
./configure --prefix="${HOME}/.opt/yash"
make

# Ištrinti įdiegtą versiją.
# Įdiegti programą.
# Grįžti į pradinį aplanką.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/yash"
make install

# Įtraukti įdiegtos programos kelius į sistemos kintamąjį
[[ -d "${HOME}/.opt/yash/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/yash/bin:"* ]] \
  && export PATH="${HOME}/.opt/yash/bin${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! yash --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
PATH_COMMAND=$'[[ -d "${HOME}/.opt/yash/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/yash/bin:"* ]] &&
    export PATH="${HOME}/.opt/yash/bin${PATH:+:${PATH}}"'
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" '${HOME}/.opt/yash/bin'
