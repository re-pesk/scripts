#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl realpath unzip xargs xq; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/vlang/v/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
TAG="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/vlang/v/releases/latest" | xargs basename)"
COMMIT="$(curl -sSL "https://github.com/vlang/v/releases/tag/${TAG}" | xq -q "div:has(span:contains('${TAG}')) ~ div > a > code")"
LATEST="$(curl -sSL "https://raw.githubusercontent.com/vlang/v/refs/heads/master/v.mod" | 
awk -F"[' ]" '/version: / {print $3}') ${COMMIT}"
CURRENT="$(v -v 2> /dev/null | awk '{print $2, $NF}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "v" "${HOME}/.opt/v"; then
  exit 1
fi

# Išsaugoti esamą aplanką
# Sukurti diegimo aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t v.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1
# Atsisiųsti į diegimo aplanką programos failą.
curl -sSLo "v_${TAG}_linux.zip" "https://github.com/vlang/v/releases/download/${TAG}/v_linux.zip"
curl -sSL "https://github.com/vlang/v/releases/expanded_assets/${TAG}" |
  xq -q "li > div:has(a span:contains('v_linux.zip')) ~ div > div > span > span" \
  > "v_${TAG}_linux.zip.sha256"

# Patikrinti, ar failas atitinka patikros sumą
if ! check_sha256 "v_${TAG}_linux.zip" \
  "v_${TAG}_linux.zip.sha256" \
  "'{print \$1}'" "-F':' '{print \$NF}'"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo aplanką.
rm -r "${HOME}/.opt/v"
unzip "v_${TAG}_linux.zip" -d "${HOME}/.opt" > /dev/null 2>&1

# Sukurti simbolinę nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/v/v" -t "${HOME}/.local/bin"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! v -v > /dev/null 2>&1; then
  printf "Error! V is not working as expected!\n\n" 1>&2
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(v -v 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '\n%s\n\n' "${CURRENT} version is not up to date!" 1>&2
  exit 1
}
printf '\n%s\n\n' "${LATEST} version is succesfully installed" 1>&2

