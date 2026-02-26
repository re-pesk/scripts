#! /usr/bin/env -S bash

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs xq; then
  exit 1
fi

# Gauti programos paskutinės versijos numerį iš repozitorijos
# Vėliausią versiją galima rasti https://github.com/janet-lang/janet/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/janet-lang/janet/releases/latest" | xargs basename)"
CURRENT="v$(janet --version 2> /dev/null | awk -F '-' '{print $1}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "janet" "${HOME}/.opt/janet"; then
  exit 1
fi

# Sukurti laikiną aplanką. 
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -d )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos failą ir patikros sumą.
cd "${TMP_DIR}" || exit 1
curl -sSLo "janet-${LATEST}-linux-x64.tar.gz" \
  "https://github.com/janet-lang/janet/releases/download/${LATEST}/janet-${LATEST}-linux-x64.tar.gz"
curl -sL "https://github.com/janet-lang/janet/releases/expanded_assets/${LATEST}" \
| xq -q "li > div:has(a span:contains('janet-${LATEST}-linux-x64.tar.gz')) ~ div > div > span > span" \
| awk -F ':' '{print $NF}' > "janet-${LATEST}-linux-x64.tar.gz.sha256"

# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 "janet-${LATEST}-linux-x64.tar.gz" \
  "janet-${LATEST}-linux-x64.tar.gz.sha256"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

# Įdiegti programą.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
rm -rf "${HOME}/.opt/janet"
tar --file="janet-${LATEST}-linux-x64.tar.gz" \
  --transform 'flags=r;s/^\.\/(janet)[^\/]+/\1/x' --show-transformed-names -xzC "${HOME}/.opt"

# Sukurti simbolines nuorodas į vykdomąjį failą ir dokumentacijos failą.
ln -sf "${HOME}/.opt/janet/bin/janet" "${HOME}/.local/bin/"
ln -sf "${HOME}/.opt/janet/man/man1/janet.1" "${HOME}/.local/man/man1/"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! janet --version > /dev/null 2>&1; then
  printf '%s\n\n' "Error! Janet is not working as expected!"
  exit 1
fi

# Patikrinti, ar kompiuteryje įdiegta vėliausia programos versija.
# Išvesti pranešimą apie reultatą.
CURRENT="v$(janet --version 2> /dev/null | awk -F '-' '{print $1}')"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '%s\n\n' "Janet ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Janet ${LATEST} is succesfully installed."
