#!/usr/bin/env -S bash

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/purescript/purescript/releases/latest" | xargs basename)"
CURRENT="v$(purs --version 2> /dev/null)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "purs" "${HOME}/.opt/purescript"; then
  exit 1
fi

INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t purs.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1
curl -sSLO "https://github.com/purescript/purescript/releases/download/${LATEST}/linux64.tar.gz"
curl -sSLO "https://github.com/purescript/purescript/releases/download/${LATEST}/linux64.sha"

if ! check_sha1 "linux64.tar.gz" "linux64.sha"; then
  printf '%s\n\n' "Installation failed!"
  exit 1
fi

rm -rf "${HOME}/.opt/purescript"
tar -f "linux64.tar.gz" -xzvC "${HOME}/.opt"

ln -fs "${HOME}/.opt/purescript/purs" -t "${HOME}/.local/bin/"

# LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/purescript/purescript/releases/latest" | xargs basename)"

# curl -sSLo- "$(
#   curl -sLo /dev/null -w "%{url_effective}" \
#   "https://github.com/purescript/spago/releases/latest" \
#   | sed "s/tag/download/"
# )/Linux.tar.gz" | tar -xzv -C "${HOME}/.opt/purescript"

# ln -fs "${HOME}/.opt/purescript/spago" "${HOME}/.local/bin/spago"

# echo "spago v$(spago version) instaliuotas!"
