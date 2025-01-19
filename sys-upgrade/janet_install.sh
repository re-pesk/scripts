#! /usr/bin/env bash

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/janet-lang/janet/releases/latest)"
filenamepart="janet-$(basename -- $url)-linux"
curl -sSLo - "${url//tag/download}/$filenamepart-x64.tar.gz" | tar -xzvC "$HOME/.local"
mv "$HOME/.local/$filenamepart" "$HOME/.local/janet"
ln -s $HOME/.local/janet/bin/janet $HOME/.local/bin/janet
janet --version
