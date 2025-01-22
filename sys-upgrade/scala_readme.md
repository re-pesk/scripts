[Atgal](./readme.md)

# Scala [&#x2B67;](https://scala-lang.org/)

## Diegimas

```bash
[[ $(apt list --installed jq 2> /dev/null | wc -l) == 1 ]] && sudo apt-get install jq 

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/scala/scala3/releases/latest)"
curl -sSLo- "${url//tag/download}/scala3-$(basename -- $url)-x86_64-pc-linux.tar.gz" \
| tar --transform 'flags=r;s/^scala3[^\/]+/scala3/x' --show-transformed-names -xzvC "${HOME}/.local"

[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo '#begin scala init

[[ ":${PATH}:" == *":${HOME}/.local/scala3/bin:"* ]] \
  || export PATH="${HOME}/.local/scala3/bin${PATH:+:${PATH}}"

#end scala init' >> "${HOME}/.bashrc"

eval export PATH="${HOME}/.local/scala3/bin${PATH:+:${PATH}}"

scala -version
```

## Paleistis

```bash
scala run scala_sys-upgrade.scala
```

### Shebang

```shebang
#!/usr/bin/env -S scala shebang
```
