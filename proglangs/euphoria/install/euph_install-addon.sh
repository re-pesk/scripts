#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Išsaugoti pradinį aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t euph.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

cd "${TMP_DIR}" || exit 1

echo ""

# shellcheck disable=SC2068
for addon in $@ ; do
  printf '%s\n\n' "Compiling ${addon^}\n"

  git clone "https://github.com/OpenEuphoria/${addon}"
  cd "${TMP_DIR}/${addon}" || exit 1
  ./configure
  make
  mv "${TMP_DIR}/${addon}/build/${addon}" "${HOME}/.opt/euphoria/bin"
  cd "${TMP_DIR}" || exit 1
  rm -rf "${TMP_DIR}/${addon:?}"

  printf '%s\n\n' "${addon^} is installed!"
done
