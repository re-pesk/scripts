#!/usr/bin/env -S bash

DEBUG=

APP_NAME="PHP"

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

if (( $(add-apt-repository -L ondrej/php | grep -c "ondrej/php") < 1 )); then
  sudo add-apt-repository ppa:ondrej/php
  sudo apt update
fi

LATEST="$(curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/php/php-src/releases/latest" \
  | xargs basename | sed 's/^php-//')"
CURRENT="$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "php" "$(which php | xargs realpath)"; then
  exit 1
fi

MINOR="${LATEST%.*}"

sudo apt install "php${MINOR} php${MINOR}-mbstring php${MINOR}-curl php${MINOR}-phpdbg php${MINOR}-xdebug" -y

echo

if ! php -v > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(php -v 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"
