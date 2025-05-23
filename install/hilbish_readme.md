[&uArr;](./readme.md)

# Hilbish [&#x2B67;](https://rosettea.github.io/Hilbish/)

* Vėliausias leidimas: 2.3.4
* Išleista: 2024-12-29

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Rosettea/Hilbish/releases/latest)"
curl -sSLo - "${url//tag/download}/hilbish-$(basename -- $url)-linux-amd64.tar.gz" |\
  sudo tar  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "$HOME/.opt"
unset url
ln -sf "$HOME/.opt/hilbish/hilbish" "$HOME/.local/bin/hilbish"
mkdir ${HOME}/.config/hilbish && cp -T $HOME/.opt/hilbish/.hilbishrc.lua ${HOME}/.config/hilbish/init.lua
echo "hilbish.opts.tips = false" >> ${HOME}/.config/hilbish/init.lua
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
