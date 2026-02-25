#!/usr/bin/env -S bash

# Įkelti pagalbines funkcijas
. ../../_helpers.sh

echo ""

# Gauti įdiegtos programos versijos numerį
# Gauti programos paskutinės versijos numerį iš repozitorijos
# Vėliausią versiją galima rasti https://github.com/OpenEuphoria/euphoria/releases/latest
# Pasirinkti, ar įdiegti kitą versiją
LATEST="$(curl -sL -o /dev/null -w "%{url_effective}" https://github.com/OpenEuphoria/euphoria/releases/latest | xargs basename)"
CURRENT="$(euc --version 2> /dev/null | head -n 1 | awk '{print $5}')"
if ! ask_to_install "v${LATEST}" "${CURRENT}" "eui" "${HOME}/.opt/euphoria-${LATEST}"; then
  exit 1
fi

echo ""

# Gauti atsiuntimo nuorodą
# Ištrinti esamą versiją.
# Atsisiųsti archyvo failą iš repozitorijos išskleisti jį į diegimo aplanką.
# Sukurti tekstinį failą su versijos numeriu.
URL="$(curl -sL https://api.github.com/repos/OpenEuphoria/euphoria/releases/latest | grep -o 'https.*Linux-x64.*tar.gz')"
rm -rf "${HOME}/.opt/euphoria-${LATEST}"
curl -sSLo - "${URL}" \
| tar --transform "flags=r;s/^(euphoria-${LATEST})[^\/]+/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

# Įkelti kelią į PATH
[[ -d "${HOME}/.opt/euphoria-${LATEST}/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/euphoria-${LATEST}/bin:"* ]] \
  && export PATH="${HOME}/.opt/euphoria-${LATEST}/bin${PATH:+:${PATH}}"
  
# Jeigu nepavyko įdiegti, išvesti pranešimą ir nutraukti scenarijaus vykdymą
if ! euc --version 2> /dev/null || ! eui --version 2> /dev/null ; then
  printf '%s\n\n' "Euphoria is not working as expected!"
  exit 1
fi

# Patikrinti, ar įdiegta versija yra naujausia. Išvesti atitinkamą pranešimą
CURRENT="$(euc --version | head -n 1 | awk '{print $5}')"
[[ "${CURRENT}" == "v${LATEST}" ]] || { 
  printf '\n%\n\n' "Euphoria v${CURRENT} is not v${LATEST}!"
  exit 1
}
printf '%s\n\n' "Euphoria v${LATEST} is installed!"
