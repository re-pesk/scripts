#!/usr/bin/env -S bash

INIT_DIR="$PWD"

TMP_DIR="$(mktemp -p . -d)"
cd "${TMP_DIR}"

for addon in $@ ;do
  echo -e "\nCompiling ${addon^}\n"
  echo -e "Current directory => $PWD\n"

  [ -d "${TMP_DIR}/${addon}" ] && rm -rf "${TMP_DIR}/${addon}"

  git clone "https://github.com/OpenEuphoria/${addon}"
  cd "${TMP_DIR}/${addon}"
  echo -e "\nCurrent directory: $PWD\n"
  ./configure
  make
  mv "${TMP_DIR}/${addon}/build/${addon}" "${HOME}/.opt/euphoria/bin"
  cd "${TMP_DIR}"
  rm -rf "${TMP_DIR}/${addon}"

  echo -e "\nCurrent directory: $PWD\n"
  echo -e "${addon^} is installed!"
done

cd "${INIT_DIR}"
rm -rf "${TMP_DIR}"
unset INIT_DIR TMP_DIR
