#!/usr/bin/env -S bash

install_euphoria_4.2() {

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  printf '%s' "${FUNC_NAME:+"${FUNC_NAME}"$'\n\n'}"

  # Įrašyti į kintamąjį diegiamos versijos numerį
  # shellcheck disable=SC1003
  LATEST="$(
    curl -sSLo - "https://raw.githubusercontent.com/OpenEuphoria/euphoria/refs/heads/master/source/version_info.rc" |
    grep -P 'VALUE "ProductVersion"' | awk -F'"|\' '{print $4}'
  )"
  CURRENT="$(euc --version &> /dev/null && euc --version | head -n 1 | awk '{print $5}' | sed 's/v//')"
  if ! ask_to_install "${LATEST}" "${CURRENT}" "euc" "${HOME}/.opt/euphoria"; then
    return 1
  fi

  # Pereiti į laikiną aplanką
  # Klonuoti git repozitoriją iš OpenEuphoria
  # Pereiti į aplanką euphoria/source
  cd "${TMP_DIR}" || exit 1
  git clone https://github.com/OpenEuphoria/euphoria "${TMP_DIR}/euphoria"
  cd "${TMP_DIR}/euphoria/source" || exit 1

  # Sukompiliuoti Euphoria 4.2
  ./configure
  make
  find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
  cp ./build/eu.cfg -t "${TMP_DIR}/euphoria/bin/"

  cd "${TMP_DIR}/euphoria/bin" || exit 1
  for file in *.{ex,exw} ;do
    [ -f "${file%.*}" ] && continue
    if ! euc "$file"; then
      exit "$?"
    fi
  done

  # printf '%s' "${FUNC_NAME:+"${FUNC_NAME}-1"$'\n\n'}"
  echo "CURRENT => ${CURRENT}"
  echo "LATEST => ${LATEST}"

  cd "${TMP_DIR}" || exit 1
  rm -rf "${HOME}/.opt/euphoria-${CURRENT}"
  mv "${HOME}/.opt/euphoria" "${HOME}/.opt/euphoria-${CURRENT}"
  mv "${TMP_DIR}/euphoria" -t "${HOME}/.opt/"

  echo ""

  # Jeigu nėra pakeisti kelią PATH kintamajame
  [[ -d "${HOME}/.opt/euphoria/bin" ]] &&
    [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] &&
      export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"

  # Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
  if ! euc --version &> /dev/null || ! eui --version &> /dev/null ; then
    printf '%s\n\n' "Euphoria is not working as expected!"
    return 1
  fi

  cd "${HOME}/.opt/euphoria/source" || exit 1
  ./configure
  find build -maxdepth 1 -type f -exec mv -t "${HOME}/.opt/euphoria/bin/" {} \+
  rm -rf build
  sed -i 's/source\/build/bin/g' "${HOME}/.opt/euphoria/bin/eu.cfg"

  # Patikrinti, ar įdiegta versija yra naujausia.
  # Išvesti atitinkamą pranešimą
  CURRENT="$(euc --version &> /dev/null && euc --version | head -n 1 | awk '{print $5}' | sed 's/v//')"
  [[ "${CURRENT}" == "${LATEST}" ]] || {
    printf '\n%s\n\n' "Euphoria v${CURRENT} is not v${LATEST}!"
    return 1
  }
  printf '%s\n\n' "Euphoria v${LATEST} is installed!"

  # Išvesti komandą, kurią reikia įvykdyti terminale,
  # kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
  # shellcheck disable=SC2016
  COMMAND=$'[[ -d "${HOME}/.opt/euphoria/bin" ]] &&
  [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] &&
    export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"'
  printf '%s\n\n' "${EUPH_MESSAGES[${LANG}.wo_relogin]//'{COMMAND}'/"${COMMAND}"}"

  # Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
  create_file_if_not_exists "${HOME}/.pathrc" '# shellcheck shell=bash'
  insert_path "${HOME}/.pathrc" 'Euphoria' "${HOME}/.opt/euphoria/bin"
}
