#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl make xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį iš repozitorijos
# Vėliausią versiją galima rasti https://github.com/magicant/yash/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/magicant/yash/releases/latest" | xargs basename)"
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "yash" "${HOME}/.opt/yash"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -d )"
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
  printf '%s\n\n' "Installation failed!"
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
  printf "Error! Yash is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(yash --version 2> /dev/null | head -n 1 | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '\n%s\n\n' "Yash v${CURRENT} is not up to date!"
  exit 1
}
printf '\n%s\n\n' "Yash v${LATEST} is succesfully installed"

# Išvesti komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
printf '%s\n\n' 'To use without relogging, execute the following command in the terminal:

[[ -d "${HOME}/.opt/yash/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/yash/bin:"* ]] \
  && export PATH="${HOME}/.opt/yash/bin${PATH:+:${PATH}}"'

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" 'Yash' '${HOME}/.opt/yash/bin'
