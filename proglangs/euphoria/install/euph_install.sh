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

printf '%s\n' "Checking required packages\n"

[ "$(apt list --installed 2> /dev/null | grep -cP '^build-essential\/')" -gt 1 ] || sudo apt install build-essential
[ "$(apt list --installed 2> /dev/null | grep -cP '^git\/')" -gt 1 ] || sudo apt install git

printf '%s\n' "\nInstalling Euphoria\n"

INIT_DIR="$PWD"

"${INIT_DIR}/euph_install-4.1.sh"
"${INIT_DIR}/euph_install-4.2.sh"
"${INIT_DIR}/euph_install-addon.sh" eudoc creole

printf '%s\n' "Installation is completed!\n"
