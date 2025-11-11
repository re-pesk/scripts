#! /usr/bin/env bash

[ -d "${HOME}/.opt/murex" ] && rm -r "${HOME}/.opt/murex"
[ -f "${HOME}/.local/bin/murex" ] && rm "${HOME}/.local/bin/murex"
mkdir -p "${HOME}/.opt/murex/bin"
curl "https://nojs.murex.rocks/bin/latest/murex-linux-amd64.gz" | gunzip -cf - > "${HOME}/.opt/murex/bin/murex"
chmod +x "${HOME}/.opt/murex/bin/murex"
ln -sf "${HOME}/.opt/murex/bin/murex" -t "${HOME}/.local/bin"
murex --version
