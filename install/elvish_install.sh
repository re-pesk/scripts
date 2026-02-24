#!/bin/env bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Gauti programos paskutinės versijos failo pavadinimą iš repozitorijos
# Vėliausią versiją galima rasti "https://dl.elv.sh/
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/elves/elvish/releases/latest" | xargs basename )"
CURRENT="v$(elvish --version | cut -c -6)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "elvish" "${HOME}/.opt/elvish"; then
  exit 1
fi

# Sukurti laikiną aplanką. 
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t elvish.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą.
# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz"
# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_sha256_str "elvish-${LATEST}.tar.gz" \
  "$(curl -sSLo - "https://dl.elv.sh/linux-amd64/elvish-${LATEST}.tar.gz.sha256sum")"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/elvish"
tar -f "elvish-${LATEST}.tar.gz" --transform 'flags=r;s/^/elvish\//x' -xzC "${HOME}/.opt"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/elvish/elvish" "${HOME}/.local/bin"

# Jeigu nepavyko įdiegti Elvish, išvesti pranešimą ir nutraukti skripto vykdymą
if ! elvish --version > /dev/null 2>&1; then
  printf "Error! Elvish is not working as expected!\n\n"
  exit 1 
fi
# Patikrinti, ar kompiuteryje įdiegta Elvish versija yra vėliausia
CURRENT="v$(elvish --version | cut -c -6)"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '\n%\n\n' "Elvish v${LATEST} is not up to date!"
  exit 1
}
printf '\n%\n\n' "Elvish v${LATEST} is succesfully installed."
