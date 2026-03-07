#! /usr/bin/env -S bash

# shellcheck disable=SC2034
APP_NAME="Vivaldi"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
HELPERS="$(cd -- "${SCRIPT_DIR}/../shell/install_helpers/" &> /dev/null && pwd )/_helpers.sh"
cmp -s "${SCRIPT_DIR}/_helpers.sh" "${HELPERS}" || cp -sfit "${SCRIPT_DIR}/" "${HELPERS}"

# Įkelti pagalbines funkcijas
. ./_helpers.sh

echo ""

if ! install_missing_packages gpg wget; then
  exit 1
fi

# Pagal https://askubuntu.com/questions/1532966/vivaldi-wont-load-on-xubuntu-noble-24-04

wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub \
| sudo gpg --dearmor -o /usr/share/keyrings/vivaldi-stable.gpg

sudo tee /etc/apt/sources.list.d/vivaldi.sources <<SOURCES
Types: deb
Architectures: amd64
URIs: https://repo.vivaldi.com/stable/deb/
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/vivaldi-stable.gpg
SOURCES

sudo apt update
sudo apt install vivaldi-stable
