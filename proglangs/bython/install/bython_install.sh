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
  'en.UTF-8.not_working' $'{APP_NAME} is not working as expected!'
  'en.UTF-8.installed' $'{APP_NAME} is installed!'
  'lt_LT.UTF-8.not_working' $'{APP_NAME} neveikia, kaip turėtų!'
  'lt_LT.UTF-8.installed' $'{APP_NAME} įdiegtas!'
)

echo ""

# Jei komandos neįdiegtos, išeiti iš skripto
if ! check_command python3 xargs xq; then
  exit 1
fi

# Įdiegti trūkstamus paketus
(
  readarray -t NOT_INSTALLED < <(packages_to_install python3-venv)
  (( ${#NOT_INSTALLED[@]} > 0 )) && sudo apt-get install -y "${NOT_INSTALLED[@]}"
)

if [ -d "${HOME}/.pyvenvs/tests" ]; then
  # shellcheck disable=SC1091
  source "${HOME}/.pyvenvs/tests/bin/activate"
  if bython --help &> /dev/null; then
    printf '%s\n\n' "${LOCAL_MESSAGES[${LANG}.installed]//'{APP_NAME}'/"Bython"}"
    deactivate
    exit 0
  fi
fi

# Nustatyti laukiamą atsakymą
# Gauti reikalingą eilutę iš komandos išvedimo
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="bython"
CURRENT="$(bython --help 2> /dev/null | head -n 1 | awk '{print $2}')"
if ! ask_to_install "${LATEST}" "${CURRENT}" "Bython" "${HOME}/.pyvenvs/tests/bin"; then
  exit 1
fi

# Sukurti virtualių aplankų aplanką
# Sukurti pythono virtualią aplinką
# Įdiegti bython
# Aktyvuoti virtualią aplinką
mkdir -p "${HOME}/.pyvenvs"
python3 -m venv ~/.pyvenvs/tests
# shellcheck disable=SC1091
source "${HOME}/.pyvenvs/tests/bin/activate"
python -m pip install bython-prushton
printf '%s\n' $'#!/usr/bin/env -S bash\n\npython -m bython-prushton "$@"' > "${HOME}/.pyvenvs/tests/bin/bython"


# Patikrinti, ar įdiegta versija veikia. Išvesti atitinkamą pranešimą
CURRENT="$(bython --help 2> /dev/null | head -n 1 | awk '{print $2}')"
[[ "${CURRENT}" == "${LATEST}" ]] || {
  printf '\n%s\n\n' "${LOCAL_MESSAGES[${LANG}.not_working]//'{APP_NAME}'/"Bython"}"
  exit 1
}
printf '\n%s\n\n' "${LOCAL_MESSAGES[${LANG}.installed]//'{APP_NAME}'/"Bython"}"
