#!/usr/bin/env bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Groovy"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command awk curl unzip xargs xq; then
  exit 1
fi

if ! java --version > /dev/null 2>&1; then
  printf '%s\n\n' "Pirmiau įdiekite Javą!"
  exit 1
fi

# Vėliausią versiją galima rasti "https://groovy.apache.org/download.html#distro"
# Gauti programos paskutinės versijos numerį
# Gauti įdiegtos programos versijos numerį
LATEST="$( curl -s https://groovy.apache.org/download.html#distro \
  | xq -q "button[id='big-download-button']" --attr "onclick" \
  | awk -F'["-]' '{print $(NF-1)}' | sed 's/\.zip$//' )"
CURRENT="$(groovy --version 2> /dev/null | awk '{print $3}')"

# Atnaujinti pranešimų masyvą
# shellcheck disable=SC2155
declare -A LANG_MESSAGES="($(update_lang_messages LANG_MESSAGES))"

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "groovy" "${HOME}/.opt/groovy"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t groovy.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą.
# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip"
curl -sSLo - "https://downloads.apache.org/groovy/${LATEST}/distribution/apache-groovy-sdk-${LATEST}.zip.sha256" \
  | tr -d '\r' > "groovy-sdk-${LATEST}.zip.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "groovy-sdk-${LATEST}.zip" "groovy-sdk-${LATEST}.zip.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Išskelti iš repozitorijos atsisiųstą archyvą į laikiną katalogą.
# Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotus failus į diegimo katalogą.
# Ištrinti laikiną aplanką.
unzip -q "groovy-sdk-${LATEST}.zip"
rm -rf "${HOME}/.opt/groovy"
mv -T "groovy-${LATEST}" "${HOME}/.opt/groovy"

# shellcheck disable=SC2155
[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(
    which java | xargs readlink -f | xargs dirname | xargs dirname
  )"

[[ -d "${HOME}/.opt/groovy/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/groovy/bin:"* ]] \
  && export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! groovy --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą.
CURRENT="$(groovy --version 2> /dev/null | awk '{print $3}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
printf '%s\n\n' "Groovy v${LATEST} is succesfully installed."

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
PATH_COMMAND=$'[ -z "$JAVA_HOME" ] && {
  JAVA_HOME="$(which java | xargs readlink -f | xargs dirname | xargs dirname)"
	export JAVA_HOME
}\n
[[ -d "${HOME}/.opt/groovy/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/groovy/bin:"* ]] && \
    export PATH="${HOME}/.opt/groovy/bin${PATH:+:${PATH}}"'
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įtraukti įdiegtos programos kelią į sistemos kintamąjį
# shellcheck disable=SC2016
insert_path_str "${HOME}/.pathrc" "${PATH_COMMAND}"
