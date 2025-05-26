# Nushell [&#x2B67;](https://www.nushell.sh/)

## Diegimas

```bash
# Pakeiskite $version versijos numeriu, tarkim, 0.13.0
# Vėliausią versijos numerį galima rasti https://github.com/nushell/nushell/releases/latest

curl -sSLo- https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz \
| tar --transform 'flags=r;s/nu.+gnu/nu/x' --show-transformed-names -xzv -C "$HOME/.local"

for filename in $HOME/.local/nu/nu*; do ln -fs $filename ${filename//nu\//bin/}; done

nu -v # => 0.100.0
```

arba paleiskite failą

```bash
bash nu_install.sh
```

## Paleistis

```bash
nu nu_sys-upgrade.nu
```
