# zed

Command-line JSON editor.

* Pagrindinis puslapis [&#x2B67;](https://zed.dev/)
* Pradinis kodas [&#x2B67;](https://github.com/zed-industries/zed)

## Diegimas

### Naujausios versijos diegimas iš repozitorijos

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/zed-industries/zed/releases/latest" | \
  xargs basename
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$( zed --version  | awk '{print $2}')"

curl -fo zed_install_.sh https://zed.dev/install.sh
sed -i '/ZED_VERSION="\${ZED_VERSION:-latest}"/a\
    TARGET_DIR="${TARGET_DIR:-\"$HOME\/.local\"}"
s|\$HOME/\.local/zed|${TARGET_DIR}/zed|g
/tar -xzf "\$temp\/zed-linux-\$arch\.tar\.gz" -C / s|"\$HOME/\.local/"|"${TARGET_DIR}/"|' zed_install_.sh
TARGET_DIR="${HOME}/.opt" sh zed_install_.sh
rm -f zed_install_.sh

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$( zed --version  | awk '{print $2}')"
