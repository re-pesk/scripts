#! /usr/bin/env bash


url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/janet-lang/janet/releases/latest)"
file_name_part="janet-$(basename -- $url)-linux"
curl -sSLo - "${url//tag/download}/${file_name_part}-x64.tar.gz" | tar -xzvC "${HOME}/.local"
mv "${HOME}/.local/${file_name_part}" "${HOME}/.local/janet"
ln -s ${HOME}/.local/janet/bin/janet ${HOME}/.local/bin/janet
janet --version
