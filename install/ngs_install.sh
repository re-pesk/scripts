#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

# Jei curl neįdigta, išeiti iš skripto
if ! check_command curl xargs; then
  exit 1
fi

# Vėliausią versiją galima rasti https://github.com/ngs-lang/ngs/releases/latest
# Gauti naujausią versiją iš repozitorijos
# Gauti įdiegtos programos versijos numerį
# Pasirinkti, ar įdiegti naujausią versiją
LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/ngs-lang/ngs/releases/latest" | \
  xargs basename
)"
CURRENT="v$(ngs --version)"
if ! ask_to_install "${LATEST}" "${CURRENT}" "ngs" "${HOME}/.opt/ngs"; then
  exit 1
fi

# Įdiegti naujausią versiją
curl https://ngs-lang.org/install.sh | bash

# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! ngs --version > /dev/null 2>&1; then
  printf "Error! NGS is not working as expected!\n\n"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="v$(ngs --version)"
[[ "${CURRENT}" == "${LATEST}" ]] || { 
  printf '%s\n\n' "NGS ${CURRENT} is not up to date!"
  exit 1
}
printf '%s\n\n' "NGS ${LATEST} is succesfully installed"
