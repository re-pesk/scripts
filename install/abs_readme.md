[&#x2BA2;](./readme.md)

# Abs [<sup>&#x2B67;</sup>](https://www.abs-lang.org/)

* Vėliausias leidimas: 2.7.2
* Išleista: 2025-04-25

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
LATEST="$(curl -Ls -o /dev/null -w "%{url_effective}" "https://github.com/abs-lang/abs/releases/latest" | xargs basename)"

printf '\nVersijos:\n  Vėliausia: v%s\n  Instaliuota: v%s\n\n' \
  "${LATEST}" "$(abs --version 2> /dev/null)"

[[ -d "${HOME}/.opt/abs" ]] && rm -rf "${HOME}/.opt/abs"
mkdir -p "${HOME}/.opt/abs"
bash <(curl -fsSL https://www.abs-lang.org/installer.sh)
mv -T abs "${HOME}/.opt/abs/abs"
ln -fs "${HOME}/.opt/abs/abs" "${HOME}/.local/bin"

printf '\nVersijos:\n  Vėliausia: v%s\n  Instaliuota: v%s\n\n' \
  "${LATEST}" "$(abs --version 2> /dev/null)"

unset LATEST
```

## Paleistis

```bash
abs kodo-failas.abs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env abs
```
