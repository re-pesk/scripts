#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs xq; then
  exit 1
fi

# Vėliausią versiją galima rasti puslapyje https://github.com/odin-lang/Odin/releases/latest
# Gauti vėliausios programos versijos numerį iš repozitorijos.
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/odin-lang/Odin/releases/latest" | xargs basename)"
CURRENT="$(odin version 2> /dev/null | cut -c 14-24)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "odin" "${HOME}/.opt/odin"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nutatyti automainį laikino aplanko trynimą išeinant iš skripto.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t odin.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/odin-lang/Odin/releases/download/${LATEST}/odin-linux-amd64-${LATEST}.tar.gz"
curl -sSLo - "https://github.com/odin-lang/Odin/releases/expanded_assets/${LATEST}" \
  | xq -q "li > div:has(a span:contains('odin-linux-amd64-${LATEST}.tar.gz')) ~ div > div > span > span" \
  | awk -F':' '{print $NF}' > "odin-linux-amd64-${LATEST}.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 "odin-linux-amd64-${LATEST}.tar.gz" \
  "odin-linux-amd64-${LATEST}.tar.gz.sha256"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Jeigu nesėkmė, nutraukti diegimą.
rm -rf "${HOME}/.opt/odin"
if ! tar --file "odin-linux-amd64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(odin)[^\/]+/\1/x' \
  --show-transformed-names -xzC "${HOME}/.opt"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/odin/odin" "${HOME}/.local/bin/"

# Jeigu programa neveikia, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! odin version > /dev/null 2>&1; then
  printf "Error! Odin compiler is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(odin version 2> /dev/null | awk -F'[ -]' '{print $3"-"$4"-"$5}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '%s\n\n' "Odin ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Odin ${LATEST} is succesfully installed"

