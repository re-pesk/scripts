#!/bin/env sh

[ -d "${HOME}/.opt/elvish/bin" ] && rm -r "${HOME}/.opt/elvish/bin"
[ -f "${HOME}/.local/bin/elvish" ] && rm "${HOME}/.local/bin/elvish"
mkdir -p "${HOME}/.opt/elvish/bin"
curl -so - "https://dl.elv.sh/linux-amd64/elvish-v0.21.0.tar.gz" | tar -xzvC "${HOME}/.opt/elvish/bin"
ln -fs "${HOME}/.opt/elvish/bin/elvish" -t "${HOME}/.local/bin"
elvish --version
