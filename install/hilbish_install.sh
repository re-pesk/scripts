#!/usr/bin/env -S bash

app_name="hilbish"
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Rosettea/Hilbish/releases/latest)"
version="$(basename -- $url)"
file_name="${app_name}-${version}-linux-amd64.tar.gz"
curl -sSLo - "${url//tag/download}/${file_name}" \
  | sudo tar  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "/usr/local/share"
sudo ln -s "/usr/local/share/${app_name}/${app_name}" "/usr/local/bin/${app_name}"
mkdir ${HOME}/.config/${app_name} && cp -T /usr/local/share/${app_name}/.hilbishrc.lua ${HOME}/.config/${app_name}/init.lua
${app_name} --version
echo "hilbish.opts.tips = false" >> ${HOME}/.config/${app_name}/init.lua
unset app_name file_name url
