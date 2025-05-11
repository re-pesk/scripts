[Atgal](./readme.md)

# Janet [&#x2B67;](https://janet-lang.org/)

* Paskiausias leidimas: 1.38.0
* Išleista: 2025-03-19

## Diegimas

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/janet-lang/janet/releases/latest)"
version="$(basename -- $url)"
[ -d ${HOME}/.opt/janet ] && rm -r ${HOME}/.opt/janet
curl -sSLo - "${url//tag/download}/janet-${version}-linux-x64.tar.gz" \
| tar --transform 'flags=r;s/^\.\/(janet)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"
ln -s ${HOME}/.opt/janet/bin/janet ${HOME}/.local/bin/janet
ln -s ${HOME}/.opt/janet/man/man1/janet.1 ${HOME}/.local/man/man1/janet.1
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
