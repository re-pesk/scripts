[&#x2BA2;](./readme.md)

# Chapel [<sup>&#x2B67;</sup>](https://chapel-lang.org/)

## Parengimas

Operacinė sistema – Ubuntu 24.04

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
TO_INSTALL="y"

INSTALLED="$(chpl --version 2>/dev/null | head -n 1)"
INSTALLED="${INSTALLED//chpl version }"

[[ "${INSTALLED}" != "" ]] && \
  read -e -p "Chapel v${INSTALLED} is installed. Do you want overwrite it? Print 'y' to overwrite. Print 'n' or [Enter] to exit: " TO_INSTALL
[[ "${TO_INSTALL}" == "y" ]] || { unset TO_INSTALL INSTALLED; exit 0; }
unset TO_INSTALL

VERSION="$(basename -- "$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/chapel-lang/chapel/releases/latest")")"
TMP_DIR="$(mktemp -d)"
curl -sSLo "${TMP_DIR}/chapel-${VERSION}-1.ubuntu24.amd64.deb" \
  "https://github.com/chapel-lang/chapel/releases/download/${VERSION}/chapel-${VERSION}-1.ubuntu24.amd64.deb"
sudo apt install "${TMP_DIR}/chapel-${VERSION}-1.ubuntu24.amd64.deb"
rm -r "${TMP_DIR}"
unset TMP_DIR

sudo chown root:root /usr/bin/chpl*
sudo chown -R root:root /usr/share/chapel

chpl --version 2> /dev/null
[[ "$?" > 0 ]] && echo "Error! Chapel is not working as expected!"
INSTALLED="$(chpl --version 2>/dev/null | head -n 1)"
INSTALLED="${INSTALLED//chpl version }"
[[ "${INSTALLED}" != "${VERSION}" ]] && echo "Chapel v${VERSION} is not installed!" || echo "Chapel v${VERSION} is succesfully installed"
unset INSTALLED VERSION
```

## Paleistis

```bash
chpl --output="kodo-failas.bin" kodo-failas.chpl
./kodo-failas.bin
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?
```
