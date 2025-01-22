[Atgal](./readme.md)

# Köi [&#x2B67;](https://koi-lang.dev/)

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/eliaperantoni/Koi/releases/latest)"
curl -sSLo "${HOME}/.local/bin/koi"  "${url//tag/download}/koi"
chmod +x ${HOME}/.local/bin/koi
koi --version
```

## Paleistis

```bash
koi koi_sys-upgrade.koi
```

### Shebang

```shebang
#!/usr/bin/env koi
```
