[Atgal](./readme.md)

# Köi [&#x2B67;](https://koi-lang.dev/)

* Paskiausias leidimas: 1.8.0
* Išleista: 2022-04-29 (nebevystoma)

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/eliaperantoni/Koi/releases/latest)"
curl -sSLo "${HOME}/.local/bin/koi" "${url//tag/download}/koi"
chmod u+x ${HOME}/.local/bin/koi
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
