#!/bin/env -S bash

clear

# VERSION="$(curl -s https://oils.pub/release/latest/ | grep -o '<title>.*</title>' | sed 's/<\/\?title>//g;s/^Oils //g')"
VERSION="$(curl -sSLo - https://raw.githubusercontent.com/oils-for-unix/oils/refs/heads/master/oils-version.txt | head -n 1)"
URL="https://oils.pub/download/oils-for-unix-${VERSION}.tar.gz"
echo "Downloading ${URL}"
TMP_DIR="$(mktemp -p . -d)"
curl -fsSLo - "${URL}" | tar  -xzC "${TMP_DIR}"
INIT_DIR="$(pwd)"

cleanup() {
  cd "$INIT_DIR"
  echo "Removing temporary directory ${TMP_DIR}"
  rm -rf "${TMP_DIR}"
  unset INIT_DIR URL TMP_DIR VERSION
  exit
}

trap cleanup 1 2 3 6

echo "Extracted to ${TMP_DIR}/oils-for-unix-${VERSION}"
cd "${TMP_DIR}/oils-for-unix-${VERSION}"

./configure --prefix ~/.opt/oils --datarootdir ~/.opt/oils/share
_build/oils.sh
[ -d "~/.opt/oils" ] && rm -rf ~/.opt/oils
./install
ln -sf ~/.opt/oils/bin/oils-for-unix ~/.local/bin/osh
ln -sf ~/.opt/oils/bin/oils-for-unix ~/.local/bin/ysh

osh --version | head -n 1 # => Oils ${VERSION}             https://oils.pub/
ysh --version | head -n 1 # => Oils ${VERSION}             https://oils.pub/

cleanup
