#! /usr/bin/env -S bash

# shellcheck disable=SC2034
APP_NAME="VSCode"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
HELPERS="$(cd -- "${SCRIPT_DIR}/../shell/install_helpers/" &> /dev/null && pwd )/_helpers.sh"
cmp -s "${SCRIPT_DIR}/_helpers.sh" "${HELPERS}" || cp -sfit "${SCRIPT_DIR}/" "${HELPERS}"

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

if ! install_missing_packages apt-transport-https gpg wget; then
  exit 1
fi

# Pagal https://code.visualstudio.com/docs/setup/linux
wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

sudo tee /etc/apt/sources.list.d/vivaldi.sources <<SOURCES
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
SOURCES

sudo apt update
sudo apt install sudo apt install code
