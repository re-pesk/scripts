# yq

`yq` is a lightweight and portable command-line YAML, JSON, INI and XML processor.

## Diegimas

```bash
(( $(which yq | wc -l ) > 0 )) || {
  url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/mikefarah/yq/releases/latest)"
  curl -fsSLo - "${url//tag/download}/yq_linux_amd64.tar.gz" |\
    tar --transform 'flags=r;s/^(.+)/yq\/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
  unset url
  mv -T "${HOME}/.opt/yq/yq_linux_amd64" "${HOME}/.opt/yq/yq"
  ln -sf "${HOME}/.opt/yq/yq" ${HOME}/.local/bin/yq
  sed -r 's/^cp (yq.1) (.+)$/ln -sf "${HOME}\/.opt\/yq\/\1" \2/' -i "${HOME}/.opt/yq/install-man-page.sh"
  ("${HOME}/.opt/yq/install-man-page.sh")
  yq --version
}
```
