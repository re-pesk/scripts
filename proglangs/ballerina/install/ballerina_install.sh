#! /usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl unzip xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/ballerina-platform/ballerina-distribution/releases/latest
# Gauti paskutinės programos versijos numerį iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/ballerina-platform/ballerina-distribution/releases/latest" \
  | xargs basename | cut -c 2-
)"
CURRENT="$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "bal" "${HOME}/.opt/ballerina"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t ballerina.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Gauti programos failo nuorodą
URL="https://github.com/ballerina-platform/ballerina-distribution/releases/download/v${LATEST}/ballerina-${LATEST}-swan-lake.zip"

# Sukurti laikiną aplanką ir atsisųsti programos ir sha256sum failus. 
# Patikrinti, ar failas atitinka patikros sumą
# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
cd "${TMP_DIR}" || exit 1
curl -sSLO "${URL}"
curl -sSLO "${URL}.sha256"
# shellcheck disable=SC2016
if ! check_sha256 "ballerina-${LATEST}-swan-lake.zip" "ballerina-${LATEST}-swan-lake.zip.sha256" \
  "'{print $1}'" "'{print $NF}'"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Išskleisti programos failą į laikiną aplanką. Ištrinti įdiegtą versiją.
# Perkelti išarchyvuotus failus į diegimo katalogą. Ištrinti laikiną aplanką su turiniu
unzip -q "ballerina-${LATEST}-swan-lake.zip"
rm -rf "${HOME}/.opt/ballerina"
mv -T "ballerina-${LATEST}-swan-lake" "${HOME}/.opt/ballerina"

# Įtraukti programos kelią į sistemos kintamąjį
[[ -d "${HOME}/.opt/ballerina/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] \
  && export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! bal --version > /dev/null 2>&1; then
  printf "Ballerina is not installed!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(bal --version 2>/dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  echo "Ballerina is not up to date!"
  exit 1
}
printf '\n%s\n\n' "Ballerina v${LATEST} is succesfully installed"

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
printf '%s\n\n' 'To use without relogging, execute the following command in the terminal:

[[ -d "${HOME}/.opt/ballerina/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/ballerina/bin:"* ]] \
  && export PATH="${HOME}/.opt/ballerina/bin${PATH:+:${PATH}}"'

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" 'Ballerina' '${HOME}/.opt/ballerina/bin'
