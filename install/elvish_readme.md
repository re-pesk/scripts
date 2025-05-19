[Atgal](./readme.md)

# Elvish shell [&#x2B67;](https://elv.sh/)

* Paskiausias leidimas: 0.21.0
* Išleista: 2024-08-14

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
mkdir -p ${HOME}/.opt/elvish/bin
curl -so - https://dl.elv.sh/linux-amd64/elvish-v0.21.0.tar.gz | tar -xzvC ${HOME}/.opt/elvish/bin
ln -fs ${HOME}/.opt/elvish/bin/elvish -t ${HOME}/.local/bin
elvish --version
```

## Paleistis

```bash
elvish kodo-failas.elv
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env elvish
```
