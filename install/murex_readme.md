[&uArr;](./readme.md)

# NGS [&#x2B67;](https://nojs.murex.rocks/)

* Paskiausias leidimas: 6.4.2063
* Išleista: 2025-01-16

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
[ -d ${HOME}/.opt/murex/bin ] || mkdir -p ${HOME}/.opt/murex/bin
curl "https://nojs.murex.rocks/bin/latest/murex-linux-amd64.gz" | gunzip -cf - > ${HOME}/.opt/murex/bin/murex
chmod +x ${HOME}/.opt/murex/bin/murex
ln -sf ${HOME}/.opt/murex/bin/murex -t ${HOME}/.local/bin
murex --version
```

## Paleistis

```bash
murex kodo-failas.murex
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env murex
```
