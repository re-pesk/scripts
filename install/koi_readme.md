[Atgal](./readme.md)

# Köi [&#x2B67;](https://koi-lang.dev/)

* Paskiausias leidimas: 1.8.0
* Išleista: 2022-04-29 (nebevystoma)

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/eliaperantoni/Koi/releases/latest)"
mkdir -p "${HOME}/.opt/koi/bin"; curl -sSLo "${HOME}/.opt/koi/bin/koi" "${url//tag/download}/koi"
chmod +x ${HOME}/.opt/koi/bin/koi; ln -sf ${HOME}/.opt/koi/bin/koi ${HOME}/.local/bin/koi
unset url
koi --version
```

## Paleistis

```bash
koi kodo-failas.koi
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env koi
```
