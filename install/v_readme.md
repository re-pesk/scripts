[Atgal](./readme.md)

# V [&#x2B67;](https://vlang.io/)

## Diegimas

```bash
curl -sSL https://github.com/vlang/v/releases/latest/download/v_linux.zip -o /tmp/v_linux.zip
unzip /tmp/v_linux.zip -d ${HOME}/.local
rm /tmp/v_linux.zip
ln -fs ${HOME}/.local/v/v ${HOME}/.local/bin/v
echo "v -v => $(v -v)"
```

arba

```bash
bash v_install.sh
```

## Paleistis

```bash
v run v_sys-upgrade.v
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S v run
```

arba

```bash
///usr/bin/env -S v run "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
v kodo-failas.v
mv v_sys-upgrade v_sys-upgrade.bin
./vykdomasis-failas.bin
```
