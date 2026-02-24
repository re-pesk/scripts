#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/Rosettea/Hilbish/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" https://github.com/Rosettea/Hilbish/releases/latest | xargs basename)"
CURRENT="$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "hilbish" "${HOME}/.opt/hilbish"; then
  exit 1
fi

# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -d )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz"
curl -sSLO "https://github.com/sammy-ette/Hilbish/releases/download/${LATEST}/hilbish-${LATEST}-linux-amd64.tar.gz.md5"

# Jeigu patikros sumos nesutampa, ištrinti laikinąjį katalogą ir nutraukti diegimą
if ! check_md5 "hilbish-${LATEST}-linux-amd64.tar.gz" "hilbish-${LATEST}-linux-amd64.tar.gz.md5"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/hilbish"
tar --file="hilbish-${LATEST}-linux-amd64.tar.gz" \
  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "${HOME}/.opt"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -si "${HOME}/.opt/hilbish/hilbish" "${HOME}/.local/bin/"

# Nukopijuoti konfigūracius failus į naują katalogą
[[ ! -d "${HOME}/.config/hilbish" ]] && mkdir "${HOME}/.config/hilbish"
cp -iT "${HOME}/.opt/hilbish/.hilbishrc.lua" "${HOME}/.config/hilbish/init.lua"
printf "hilbish.opts.tips = false\n" >> "${HOME}/.config/hilbish/init.lua"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! hilbish --version > /dev/null 2>&1; then
  printf "Error! Hilbish is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
CURRENT="$(hilbish --version 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '%s\n\n' "Hilbish ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Hilbish ${LATEST} is succesfully installed."
