#!/usr/bin/env -S bash

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Rosettea/Hilbish/releases/latest)"
curl -sSLo - "${url//tag/download}/hilbish-$(basename -- $url)-linux-amd64.tar.gz" |\
  sudo tar  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "$HOME/.opt"
unset url
sudo ln -s "$HOME/.opt/hilbish/hilbish" "$HOME/.local/bin/hilbish"
mkdir ${HOME}/.config/hilbish && cp -T $HOME/.opt/hilbish/.hilbishrc.lua ${HOME}/.config/hilbish/init.lua
echo "hilbish.opts.tips = false" >> ${HOME}/.config/hilbish/init.lua
hilbish --version
