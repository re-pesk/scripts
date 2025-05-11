[Atgal](./readme.md)

# Carbon [&#x2B67;](https://docs.carbon-lang.dev/)

* Paskiausias leidimas: nightly.2025.04.01

## Diegimas

```bash
# Pasirinkti archyvą iš https://github.com/carbon-language/carbon-lang/releases
version="$(date -d yesterday +0.0.0-0.nightly.%Y.%m.%d)"
url="https://github.com/carbon-language/carbon-lang/releases/download/v${version}/carbon_toolchain-${version}.tar.gz"
[[ -d ${HOME}/.opt/carbon ]] && rm -r ${HOME}/.opt/carbon
curl -fsSLo - "${url}" | tar --transform 'flags=r;s/^(carbon)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
unset url version
ln -fs ${HOME}/.opt/carbon/lib/carbon/carbon-busybox ${HOME}/.local/bin/carbon
(( $(apt list --installed 2>/dev/null | grep -P '^libgcc-11-dev' | wc -l ) > 0 )) || sudo apt install libgcc-11-dev
carbon version
```

## Paleistis

### Vykdymo instrukcija (shebang)

Vykdymo instrukcijos formato, tinkamo carbono išeities kodo failams, išsiaiškinti nepavyko.

## Kompiliavimas

```bash
carbon compile --output=objektinis-failas.o kodo-failas.carbon
carbon link --output=vykdomasis-failas.bin objektinis-failas.o
./vykdomasis-failas.bin
```
