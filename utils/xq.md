# xq

Command-line XML and HTML beautifier and content extractor.

## Diegimas

* Naujausios versijos

  ```bash
  (( $(which xq | wc -l ) > 0 )) || {
    url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/sibprogrammer/xq/releases/latest)"
    version="$(basename -- $url)"
    curl -fsSLo - "${url//tag/download}/xq_${version#v}_linux_amd64.tar.gz" |\
      tar  --transform 'flags=r;s/^(.+)/xq\/\1/x' --show-transformed-names -xzvC ${HOME}/.opt
    ln -sf "${HOME}/.opt/xq/xq" ${HOME}/.local/bin/xq
    unset url version
    xq --version
  }
  ```

* Versijos iš oficialios Ubuntu repozitorijos

  ```bash
  (( $(apt list --installed 2>/dev/null | grep -P 'xq' | wc -l ) > 0 )) || \
  sudo apt install xq
  ```
