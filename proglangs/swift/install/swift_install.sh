#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://www.swift.org/install/linux/

# Sukurti laikiną aplanką.
# Sukurti funkciją, ištrinančią jį iš disko.
# Nustatyti, jog ji bus paleista, kai bus nutrauktas šio skripto vykdymas.
TMP_DIR="$( mktemp -p . -d -t swiftly.XXXXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną aplanką diegimo programą.
curl -o - "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz" \
| tar xzxC "${TMP_DIR}"

# Exportuoti Swiftly sistemos kintamuosius
export SWIFTLY_HOME_DIR="${HOME}/.opt/swiftly"
export SWIFTLY_BIN_DIR="${HOME}/.opt/swiftly/bin"
export SWIFTLY_TOOLCHAINS_DIR="${HOME}/.opt/swiftly/toolchains"

# Įdiegti programą
# Įkelti kelią į sistemos kintamąjį
# Ištrinti laikiną aplanką.
"${TMP_DIR}"/swiftly init
# shellcheck disable=SC1091
. "${HOME}/.opt/swiftly/env.sh"
hash -r
rm -rf "${TMP_DIR}"

if ! swiftly --version > /dev/null 2>&1; then
  printf "Error! Swiftly is not working as expected!\n\n"
  exit 1
fi

if ! swift --version > /dev/null 2>&1; then
  printf "Error! Swift is not working as expected!\n\n"
  exit 1
fi
