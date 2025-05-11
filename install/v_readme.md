[Atgal](./readme.md)

# V [&#x2B67;](https://vlang.io/)

* Paskiausias leidimas: 0.4.10
* Išleista: 2025-03-20

## Diegimas

```bash
curl -sSL https://github.com/vlang/v/releases/latest/download/v_linux.zip -o /tmp/v_linux.zip
[ -d ${HOME}/.local/v ] && rm -r ${HOME}/.local/v
unzip /tmp/v_linux.zip -d ${HOME}/.local
[ -f /tmp/v_linux.zip ] && rm /tmp/v_linux.zip
ln -fs ${HOME}/.local/v/v ${HOME}/.local/bin/v
v -v
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
v -o vykdomasis-failas.bin kodo-failas.v
./vykdomasis-failas.bin
```
