[&#x2BA2;](./install_readme.md "Atgal")

# NGS [<sup>&#x2B67;</sup>](https://ngs-lang.org/)

* Paskiausias leidimas: 0.2.17
* Išleista: 2025-04-05 (atnaujinta)

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
if ! command -v curl &> /dev/null; then
  printf '\n%s\n\n' "Curl neįdiegta! Įdiekite prieš tęsdami!"
fi

LATEST="$(
  curl -sSLo /dev/null -w "%{url_effective}" "https://github.com/ngs-lang/ngs/releases/latest" | \
  xargs basename
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$( ngs --version )"

curl https://ngs-lang.org/install.sh | bash

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "v$( ngs --version)"

unset LATEST
```

## Paleistis

```bash
ngs kodo-failas.ngs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S ngs
```
