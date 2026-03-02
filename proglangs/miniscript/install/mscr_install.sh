#!/usr/bin/env -S bash

# DEBUG: production mode - null or unset, debug mode - any other value
DEBUG=

APP_NAME="Miniscript"

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

# Gauti naujausią versiją
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sSL https://github.com/JoeStrout/miniscript/tags | \
  xq -q "div[id^=header]:contains('Tags') ~ div a[href*='miniscript/releases']")"
CURRENT="$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "miniscript" "${HOME}/.opt/miniscript"; then
  exit 1
fi

# Pašalinti esamą versiją ir įkelti naujausią
rm -rf "${HOME}/.opt/miniscript"
curl -sSLo - https://miniscript.org/files/miniscript-linux.tar.gz | \
  tar --transform "flags=r;s//miniscript\//x" -xzC "${HOME}/.opt/" 2> /dev/null

# Sukurti simbolinę nuorodą į vykdomąjį failą
ln -sf "${HOME}/.opt/miniscript/miniscript" -t "${HOME}/.local/bin/"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! miniscript -? &> /dev/null; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"
