#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Kotlin"

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

# Jeigu nėra įdiegtas, įdiegiamas Kotlinas
[[ "$(snap list kotlin | tail -n +2 | wc -l)" -gt 0 ]] || {
  sudo snap install --classic kotlin
  kotlin -version
}

# Gauti programos paskutinės versijos numerį iš repozitorijos
# Vėliausią versiją galima rasti https://github.com/JetBrains/kotlin/releases/latest
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/JetBrains/kotlin/releases/latest" \
  | xargs basename | sed 's/v//')"
CURRENT="$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "kotlin" "${HOME}/.opt/kotlin-native"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t kotlin_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisiųsti į laikiną katalogą programos ir patikros sumos failus.
# Sutikrinti failo patikros sumą su tinklalapio patikros suma, jei patikros sumos nesutampa, nutraukti diegimą.
cd "${TMP_DIR}" || exit 1
curl -sSLO \
  "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz"
curl -sSLO \
  "https://github.com/JetBrains/kotlin/releases/download/v${LATEST}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256"
if ! check_sha256 "${TMP_DIR}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" \
  "${TMP_DIR}/kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
rm -rf "${HOME}/.opt/kotlin-native"
tar --file="kotlin-native-prebuilt-linux-x86_64-${LATEST}.tar.gz" \
  --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

[[ -d "${HOME}/.opt/kotlin-native/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/kotlin-native/bin:"* ]] && \
    export PATH="${HOME}/.opt/kotlin-native/bin${PATH:+:${PATH}}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! kotlinc-native -version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(kotlinc-native -version 2> /dev/null | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  printf '%s\n\n' "Kotlin v${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "Kotlin v${LATEST} is succesfully installed."

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
PATH_COMMAND=$'[[ -d "${HOME}/.opt/kotlin-native/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/kotlin-native/bin:"* ]] && \
    export PATH="${HOME}/.opt/kotlin-native/bin${PATH:+:${PATH}}"'
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įtraukti įdiegtos programos kelią į sistemos kintamąjį
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" 'Kotlin' '${HOME}/.opt/kotlin-native/bin'
