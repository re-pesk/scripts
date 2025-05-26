[Atgal](./readme.md)

# V [&#x2B67;](https://vlang.io/)

* Paskiausias leidimas: 0.4.10
* Išleista: 2025-03-20

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
curl -sSL https://github.com/vlang/v/releases/latest/download/v_linux.zip -o /tmp/v_linux.zip
[ -d ${HOME}/.opt/v ] && rm -r ${HOME}/.opt/v
unzip /tmp/v_linux.zip -d ${HOME}/.opt
[ -f /tmp/v_linux.zip ] && rm /tmp/v_linux.zip
ln -fs ${HOME}/.opt/v/v ${HOME}/.local/bin/v
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
