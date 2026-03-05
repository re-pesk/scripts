#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Dart"

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command gpg tee wget; then
  exit 1
fi

if ! check_package apt-transport-https; then
  exit 1
fi

# Diegiamas raktas ir Darto šaltinis
[ -s "/usr/share/keyrings/dart.gpg" ] || \
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |\
  sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
[ -s "/etc/apt/sources.list.d/dart_stable.list" ] || \
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |\
  sudo tee /etc/apt/sources.list.d/dart_stable.list

# Instaliuojamas Dartas
sudo apt-get update && {
  dpkg -s dart &>/dev/null || sudo apt-get install dart
}

# Tikrinamas Darto veikimas
echo ""

if ! dart --version > /dev/null 2>&1; then
  printf 'Error! Dart is not working as expected!\n\n'
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
successMessage "${LANG_MESSAGES[installed]}"
