#!/usr/bin/env -S bash

DEBUG=

APP_NAME="Zig"

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl jq xargs; then
  exit 1
fi

# Vėliausią versijos numerį galima rasti https://ziglang.org/download/
# Gauti įdiegtos programos versijos numerį.
LATEST="$(curl -Lso - https://ziglang.org/download/index.json |\
  jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last')"
CURRENT="$(zig version 2> /dev/null)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "zig" "${HOME}/.opt/zig"; then
  exit 1
fi

# Parsiųsti instaliacinio archyvo duomenis iš tinklalapio į asociatyvų masyvą
# shellcheck disable=SC2155
declare -A DATA="($(
  curl -s "https://ziglang.org/download/index.json" |\
  jq -r '.[] | select(.version == "'"${LATEST}"'") | .["x86-linux"] | "[tarball]=" + .tarball + " [shasum]=" + .shasum'
))"
URL="${DATA["tarball"]}"

# Atsisiųsti failą iš tinklalapio
TMP_DIR="$( mktemp -p . -d -t zig_.XXXXXXXX | xargs realpath )"
trap cleanup EXIT


curl -sSLo "${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" "${URL}"

# Išvesti į terminalą SHA256 kontrolines sumas, kad būtų galima sulyginti
# Jeigu kontrolinės sumos nesutampa, diegimą nutraukti, atsisiųstus failus ištrinti.
if ! check_sha256_str "${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" "${DATA["shasum"]}"; then
  errorMessage "${LANG_MESSAGES[failed]}"
  exit 1
fi

# Ištrinti įdiegtą versiją.
# Išskleisti iš repozitorijos atsisiųstą archyvą į diegimo katalogą.
# Ištrinti laikiną aplanką.
rm -rf "${HOME}/.opt/zig"
tar --file="${TMP_DIR}/zig-x86_64-linux-${LATEST}.tar.xz" \
  --transform='flags=r;s/^zig[^\/]+/zig/x' \
  --show-transformed-names -xJC "${HOME}/.opt"

# Sukurti nuorodą į vykdomąjį failą.
ln -fs "${HOME}/.opt/zig/zig" "${HOME}/.local/bin"

echo ""

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! zig --version > /dev/null 2>&1; then
  errorMessage "${LANG_MESSAGES[not_working]}"
  exit 1
fi
# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(zig version 2> /dev/null)"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  errorMessage "${LANG_MESSAGES[not_updated]//'{CURRENT}'/"${CURRENT}"}"
  exit 1
}
successMessage "${LANG_MESSAGES[installed_latest]//'{LATEST}'/"${LATEST}"}"
