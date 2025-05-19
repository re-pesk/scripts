#! /usr/bin/env bash


url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/janet-lang/janet/releases/latest)"
[ -d ${HOME}/.opt/janet ] && rm -r ${HOME}/.opt/janet
curl -sSLo - "${url//tag/download}/janet-$(basename -- $url)-linux-x64.tar.gz" \
| tar --transform 'flags=r;s/^\.\/(janet)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
ln -s ${HOME}/.local/janet/bin/janet ${HOME}/.local/bin/janet
ln -s ${HOME}/.opt/janet/man/man1/janet.1 ${HOME}/.local/man/man1/janet.1
unset url
janet --version
