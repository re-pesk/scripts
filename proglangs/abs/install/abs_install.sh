#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Abs"

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

# Vėliausią versiją galima rasti https://github.com/abs-lang/abs/releases/latest
# Gauti programos paskutinės versijos numerį iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/abs-lang/abs/releases/latest" | xargs basename)"
CURRENT="$(abs --version 2> /dev/null)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "abs" "${HOME}/.opt/abs"; then
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Parsiųsti naujausią programos failą.
# Sukurti diegimo aplanką ir perkelti į jį programos failą.
rm -rf "${HOME}/.opt/abs"
mkdir -p "${HOME}/.opt/abs"
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv -T abs "${HOME}/.opt/abs/abs"
ln -fs "${HOME}/.opt/abs/abs" "${HOME}/.local/bin"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! abs --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(abs --version 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"
