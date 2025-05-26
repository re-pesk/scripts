# Odin [&#x2B67;](ttps://odin-lang.org/)

## Diegimas

```bash
sudo apt install clang
url=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/odin-lang/Odin/releases/latest)
url="${url//tag/download}/odin-linux-amd64-$(basename -- $url).tar.gz"
curl -sSLo- $url | tar --transform 'flags=r;s/^odin[^\/]+/odin/x' --show-transformed-names -xzvC "$HOME/.local"
ln -s $HOME/.local/odin/odin $HOME/.local/bin/odin
unset url
odin version
```

arba

```bash
bash odin-install.sh
```


## Paleistis

```bash
odin run odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```

## Kompilavimas

```bash
odin build odin_sys-upgrade.odin -file -out:odin_sys-upgrade.bin
```
