[Atgal](./readme.md)

# Nushell [&#x2B67;](https://www.nushell.sh/)

* Paskiausias leidimas: 0.103.0
* Išleista: 2025-03-19

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/nushell/nushell/releases/latest")"
version="$(basename -- "${url}")"
[ -d "${HOME}/.opt/nu" ] && rm --recursive "${HOME}/.opt/nu"
curl -sSLo- "${url//tag/download}/nu-${version}-x86_64-unknown-linux-gnu.tar.gz" |\
  tar --transform 'flags=r;s/^(nu)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
unset url version
for filename in ${HOME}/.opt/nu/nu*; do ln -fs ${filename} ${filename//.opt\/nu\//.local/bin/}; done

nu -v # => 0.104.0
```

## Paleistis

```bash
nu kodo-failas.nu
```

### Vykdymo instrukcija (shebang)

```bash
#! /usr/bin/env nu
```
