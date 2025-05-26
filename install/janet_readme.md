[Atgal](./readme.md)

# Janet [&#x2B67;](https://janet-lang.org/)

* Paskiausias leidimas: 1.38.0
* Išleista: 2025-03-19

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/janet-lang/janet/releases/latest)"
version="$(basename -- $url)"
[ -d ${HOME}/.local/janet ] && rm -r ${HOME}/.local/janet
curl -sSLo - "${url//tag/download}/janet-${version}-linux-x64.tar.gz" \
  | tar --transform 'flags=r;s/^(\.\/janet)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.local"
ln -s ${HOME}/.local/janet/bin/janet ${HOME}/.local/bin/janet
unset url version
janet --version
```

## Paleistis

```bash
janet kodo-failas.janet
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env janet
```
