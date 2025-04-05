[Atgal](./readme.md)

# Hilbish [&#x2B67;](https://rosettea.github.io/Hilbish/)

* Vėliausias leidimas: 2.3.4
* Išleista: 2024-12-29

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Rosettea/Hilbish/releases/latest)"
version="$(basename -- $url)"
curl -sSLo - "${url//tag/download}/hilbish-${version}-linux-amd64.tar.gz" |\
  sudo tar  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "/usr/local/share"
sudo ln -s "/usr/local/share/hilbish/hilbish" "/usr/local/bin/hilbish"
mkdir ${HOME}/.config/hilbish && cp -T /usr/local/share/hilbish/.hilbishrc.lua ${HOME}/.config/hilbish/init.lua
echo "hilbish.opts.tips = false" >> ${HOME}/.config/hilbish/init.lua
unset url version
hilbish --version
```

## Paleistis

```bash
hilbish kodo-failas.lua
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S hilbish
```
