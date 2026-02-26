#! /usr/bin/env -S bash

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
TMP_DIR="$( mktemp -d )"
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
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/nu"
tar --file="${TMP_DIR}/nu-${LATEST}-x86_64-unknown-linux-gnu.tar.gz" \
  --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzvC "${HOME}/.opt"

# Įtraukti įdiegtos programos kelią į sistemos kintamąjį
[[ -d "${HOME}/.opt/nu" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/nu:"* ]] \
    && export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! nu -v > /dev/null 2>&1; then
  printf "Error! Nushell is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą.
CURRENT="$(nu -v 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '\n%s\n\n' "Nushell ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Nushell ${LATEST} is succesfully installed"

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
printf '%s\n\n' 'To use without relogging, execute the following command in the terminal:

[[ -d "${HOME}/.opt/nu" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/nu:"* ]] \
    && export PATH="${HOME}/.opt/nu${PATH:+:${PATH}}"'

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" 'Nushell' '${HOME}/.opt/nu'
