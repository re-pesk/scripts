#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Lua"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl make xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį
# Vėliausią versiją galima rasti https://github.com/lua/lua/releases/latest
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lua/lua/releases/latest" | \
  xargs basename | sed 's/^v//')"
CURRENT="$(lua -v 2> /dev/null | awk '{print $2}')"

# Atnaujinti pranešimų masyvą
# shellcheck disable=SC2155
declare -A LANG_MESSAGES="($(update_lang_messages LANG_MESSAGES))"

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "lua" "${HOME}/.opt/lua"; then
  exit 1
fi

# Sukurti laikiną aplanką ir atsisųsti į jį programos failą ir patikros sumą.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t lua_.XXXXXXXXXX | xargs realpath )"
trap cleanup EXIT

curl -sLo "${TMP_DIR}/lua-${LATEST}.tar.gz" "https://www.lua.org/ftp/lua-${LATEST}.tar.gz"
curl -sL https://lua.org/ftp/ \
  | xq -q "body > table:first-of-type td.name:has(a:contains('lua-${LATEST}.tar.gz')) ~ td.sum" \
  > "${TMP_DIR}/lua-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "${TMP_DIR}/lua-${LATEST}.tar.gz" \
  "${TMP_DIR}/lua-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskleisti iš repozitorijos atsisiųstą archyvą į laikiną katalogą.
# Ištrinti įdiegtą versiją.
# Sukompiliuoti programą ir instaliuoti į diegimo katalogą.
# Ištrinti laikiną aplanką.
tar --file="${TMP_DIR}/lua-${LATEST}.tar.gz" -xzC "${TMP_DIR}"
cd "${TMP_DIR}/lua-${LATEST}" || exit 1
make all test
rm -rf "${HOME}/.opt/lua"
make install INSTALL_TOP="${HOME}/.opt/lua"
cd "${INIT_DIR}" || exit 1

# Įtraukti įdiegtos programos kelią į sistemos kintamąjį
PATH_COMMAND=$'[[ -d "${HOME}/.opt/lua/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/lua/bin:"* ]] && \
    export PATH="${HOME}/.opt/lua/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

echo ""

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! lua -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(lua -v 2> /dev/null | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
printf '%s\n\n' "Lua ${LATEST} is succesfully installed."

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path_str "${HOME}/.pathrc" '${HOME}/.opt/lua/bin'
