[Atgal](./readme.md)

# Hilbish [&#x2B67;](https://rosettea.github.io/Hilbish/)

## Diegimas

```bash
app_name="hilbish"
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Rosettea/Hilbish/releases/latest)"
file_name="${app_name}-$(basename -- $url)-linux-amd64.tar.gz"
curl -sSLo - "${url//tag/download}/${file_name}" \
  | sudo tar  --transform 'flags=r;s/^/hilbish\//x' --show-transformed-names -xzvC "/usr/local/share"
sudo ln -s "/usr/local/share/${app_name}/${app_name}" "/usr/local/bin/${app_name}"
mkdir ${HOME}/.config/${app_name} && cp -T /usr/local/share/${app_name}/.hilbishrc.lua ${HOME}/.config/${app_name}/init.lua
${app_name} --version
echo "hilbish.opts.tips = false" >> ${HOME}/.config/${app_name}/init.lua
unset app_name file_name url
```

## Paleistis

```bash
hilbish kodo-failas.lua
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S hilbish
```
