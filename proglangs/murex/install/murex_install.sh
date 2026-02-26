#! /usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/Murex-dev/murex/releases/latest
# Gauti programos paskutinės versijos numerį iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/lmorg/murex/releases/latest" | xargs basename)"
CURRENT="$(murex --version | head -n 1 | awk '{print $2}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "murex" "${HOME}/.opt/murex"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Sukurti diegimo aplanką.
# Parsiųsti į diegimo katalogą iš tinklalapio ir išskleisti į diegimo aplanką.
# Suteikti vykdomajam failui vykdymo privilegijas.
rm -r "${HOME}/.opt/murex"
mkdir -p "${HOME}/.opt/murex"
curl "https://nojs.murex.rocks/bin/latest/murex-linux-amd64.gz" | gunzip > "${HOME}/.opt/murex/murex"
chmod +x "${HOME}/.opt/murex/murex"

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -sf "${HOME}/.opt/murex/murex" -t "${HOME}/.local/bin"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! murex --version > /dev/null 2>&1; then
  printf "Error! Murex is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(murex --version | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '\n%s\n\n' "Murex v${CURRENT} is not up to date!"
  exit 1
}
printf '\n%s\n\n' "Murex v${LATEST} is succesfully installed"
