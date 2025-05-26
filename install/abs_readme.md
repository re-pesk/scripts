[Atgal](./readme.md)

# Abs [&#x2B67;](https://www.abs-lang.org/)

* Vėliausias leidimas: 2.6.0
* Išleista: 2022-04-15 (nebevystoma)

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv abs ${HOME}/.opt/abs/bin
ln -fs ${HOME}/.opt/abs/bin/abs ${HOME}/.local/bin/abs
abs --version
```

## Paleistis

```bash
abs kodo-failas.abs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env abs
```
