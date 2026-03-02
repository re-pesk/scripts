#!/usr/bin/env -S bash

# Sukurti nuorodą į pagalbinių funkcijų failą
HELPERS="$(realpath ../../../shell/install_helpers/_helpers.sh)"
cmp -s ../../_helpers.sh "${HELPERS}" || cp -sfit ../../ "${HELPERS}"

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Įrašyti į kintamąjį diegiamos versijos numerį
LATEST="4.2.0"
CURRENT="$(euc --version | head -n 1 | awk '{print $5}')"
if ! ask_to_install "${CURRENT}" "v${LATEST}" "Euphoria" "${HOME}/.opt/euphoria"; then
  exit 1
fi

# Išsaugoti pradinį aplanką
# Sukurti laikiną aplanką
# Nustatyti funkciją, ištrinančią jį iš disko išeinant iš programos.
INIT_DIR="$PWD"
TMP_DIR="$( mktemp -p . -d -t euph.XXXXXXXX | xargs realpath )"
trap cleanup EXIT

# Pereiti į laikiną aplanką
# Klonuoti git repozitoriją iš OpenEuphoria
# Pereiti į aplanką euphoria/source
cd "${TMP_DIR}" || exit 1
git clone https://github.com/OpenEuphoria/euphoria "euphoria"
cd "./euphoria/source" || exit 1

# Sukompiliuoti Euphoria 4.2
./configure --prefix "${HOME}/.opt/euphoria"
make
make install

# Pakeisti kelią PATH kintamajame
[[ ":${PATH}:" == *":${HOME}/.opt/euphoria-${CURRENT}/bin:"* ]] \
  && export PATH="${PATH/"euphoria-${CURRENT}"/euphoria}"

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! euc --version 2> /dev/null || ! eui --version 2> /dev/null ; then
  printf '%s\n\n' "Euphoria is not working as expected!"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia.
# Išvesti atitinkamą pranešimą
CURRENT="$(euc --version | head -n 1 | awk '{print $5}')"
[[ "${CURRENT}" == "v${LATEST}" ]] || { 
  printf '\n%\n\n' "Euphoria v${CURRENT} is not v${LATEST}!"
  exit 1
}
printf '%s\n\n' "Euphoria v${LATEST} is installed!"

# Išvesti komandą, kurią reikia įvykdyti terminale,
# kad nereikėtų iš naujo prisijungti prie vartotojo paskyros.
# shellcheck disable=SC2016
printf '%s\n\n' 'To use without relogin, execute the following command in the terminal:

[[ -d "${HOME}/.opt/euphoria/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/euphoria/bin:"* ]] \
  && export PATH="${HOME}/.opt/euphoria/bin${PATH:+:${PATH}}"'

# Įrašyti programos kelio įtraukimo komandą į konfigūracinį failą
create_file_if_not_exists "${HOME}/.pathrc" '# shellcheck shell=bash'
insert_path "${HOME}/.pathrc" 'Euphoria' "${HOME}/.opt/euphoria/bin"
