#!/usr/bin/env -S bash

# DEBUG: darbinis režimas - null arba nunustatytas (unset), klaidų paieškos režimas - bet kokia kita reikšmė
DEBUG=

APP_NAME="Go"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../../utils/install_helpers/_set_helpers.sh ../../
. ../../_helpers_.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs xq; then
  exit 1
fi

# Vėliausią versiją galima rasti https://go.dev/dl/
# Gauti vėliausios programos versijos numerį.
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sSL https://go.dev/dl/ \
| xq -q "a.downloadBox[href$='.linux-amd64.tar.gz']" --attr href \
| xargs basename | sed -E 's/^(go[0-9\.]+)\..+$/\1/')"
CURRENT="$(go version 2> /dev/null | awk '{print $3}')"

# Atnaujinti pranešimų masyvą
# shellcheck disable=SC2155
declare -A LANG_MESSAGES="($(update_lang_messages LANG_MESSAGES))"

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "go" "${HOME}/.opt/go"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t go.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą.
# Atsisųsti failo patikros sumą iš programos tinklalapio.
# Sulyginti failo patikros sumą su tinklalapio patikros suma.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://go.dev/dl/${LATEST}.linux-amd64.tar.gz"
curl -sSL https://go.dev/dl/ \
| xq -q "td:has(a:contains('${LATEST}.linux-amd64.tar.gz')) ~ td:last-of-type tt" \
| xargs printf "%s  ${LATEST}.linux-amd64.tar.gz\n" > "${LATEST}.linux-amd64.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256 "${LATEST}.linux-amd64.tar.gz" "${LATEST}.linux-amd64.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed_latest]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/go"
tar -f "${LATEST}.linux-amd64.tar.gz" -xzC "${HOME}/.opt"

[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] \
  || export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"

[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  || export PATH="${HOME}/go/bin${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! go version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(go version 2> /dev/null | awk '{print $3}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
printf '\n%s\n\n' "Golang v${LATEST} is succesfully installed"

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
PATH_COMMAND=$'[[ ":${PATH}:" == *":${HOME}/.opt/go/bin:"* ]] || \
  export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"\n
[[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] || \
  export PATH="${HOME}/go/bin${PATH:+:${PATH}}"'
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" '${HOME}/.opt/go/bin' '${HOME}/go/bin'
