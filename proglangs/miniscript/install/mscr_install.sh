#!/usr/bin/env -S bash

# DEBUG: production mode - null or unset, debug mode - any other value
DEBUG=

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

# shellcheck disable=SC2190
declare -A LOCAL_MESSAGES=(
  'en.UTF-8.not_working' 'Miniscript is not working as expected!'
  'en.UTF-8.not_updated' 'Miniscript {CURRENT} is not up to date!'
  'en.UTF-8.updated' 'Miniscript {LATEST} is installed!'
  'lt_LT.UTF-8.not_working' $'Miniscript\'as neveikia, kaip turėtų!'
  'lt_LT.UTF-8.not_updated' $'Miniscript\'as {CURRENT} neatnaujintas!'
  'lt_LT.UTF-8.updated' $'Miniscript\'as {LATEST} įdiegtas!'
)

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
  printf '%s\n\n' "${LOCAL_MESSAGES[${LANG}.not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(miniscript -? 2> /dev/null | tail -n +2 | head -n 1 | awk '{print $5}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  printf '\n%s\n\n' "${LOCAL_MESSAGES[${LANG}.not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
printf '\n%s\n\n' "${LOCAL_MESSAGES[${LANG}.updated]//'{LATEST}'/"${LATEST}"}"
