#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Scala"

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

# Vėliausią versiją galima rasti https://github.com/scala/scala3/releases/latest
# Gauti įdiegtos programos versijos numerį
LATEST="$(curl -sLo /dev/null -w "%{url_effective}" "https://github.com/scala/scala3/releases/latest" | xargs basename)"
CURRENT="$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"

# Atnaujinti pranešimų masyvą
# shellcheck disable=SC2155
declare -A LANG_MESSAGES="($(update_lang_messages LANG_MESSAGES))"

# Pasirinkti, ar įdiegti naujausią versiją
if ! ask_to_install "scala" "${HOME}/.opt/scala3"; then
  exit 1
fi

# Sukurti laikiną aplanką.
# Sukurti funkciją, ištrinančią jį iš disko.
# Nustatyti, jog ji bus paleista, kai bus nutrauktas šio skripto vykdymas.
TMP_DIR="$( mktemp -p . -d -t scala_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Atsisųsti į laikiną aplanką programos ir patikros sumos failus.
curl -sSLo "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz"
curl -sSLo "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256" \
  "https://github.com/scala/scala3/releases/download/${LATEST}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256"

# Sulyginti failo patikros sumą su patikros suma iš tinklalapio.
# Jeigu patikros sumos nesutampa, nutraukti diegimą
if ! check_sha256 \
  "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  "${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz.sha256"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/scala3"
tar --file="${TMP_DIR}/scala3-${LATEST}-x86_64-pc-linux.tar.gz" \
  --transform='flags=r;s/^(scala3)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
rm -rf "${TMP_DIR}"

# Įtraukti įdiegtos programos kelius į sistemos kintamąjį
PATH_COMMAND=$'[[ -d "${HOME}/.opt/scala3/bin" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/scala3/bin:"* ]] && \
    export PATH="${HOME}/.opt/scala3/bin${PATH:+:${PATH}}"'
eval "${PATH_COMMAND}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! scala --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(scala version 2> /dev/null | tail -n +2 | awk '{print $NF}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]}"

# Išvesti į terminalą komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
infoMessage "${LANG_MESSAGES[wo_relogin]//'{PATH_COMMAND}'/"${PATH_COMMAND}"}"

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
# shellcheck disable=SC2016
insert_path "${HOME}/.pathrc" '${HOME}/.opt/scala3/bin'
