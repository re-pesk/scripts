[Atgal](./readme.md)

# Carbon [&#x2B67;](https://docs.carbon-lang.dev/)

* Paskiausias leidimas: nightly.2025.04.01

## Diegimas

```bash
# Pasirinkti archyvą iš https://github.com/carbon-language/carbon-lang/releases
version="$(date -d yesterday +0.0.0-0.nightly.%Y.%m.%d)"
url="https://github.com/carbon-language/carbon-lang/releases/download/v${version}/carbon_toolchain-${version}.tar.gz"
curl -fsSLo - "${url}" | tar --transform 'flags=r;s/^carbon[^\/]+\///x' --show-transformed-names -xzvC "${HOME}/.local"
unset url version
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
