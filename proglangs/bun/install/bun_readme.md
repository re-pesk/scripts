[Grįžti &#x2BA2;](../../install_readme.md "Grįžti")

# Bun [<sup>&#x2B67;</sup>](https://bun.sh/)

## Diegimas

```bash
LATEST="$( \
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/oven-sh/bun/releases/latest" | \
  xargs basename | sed 's/bun-v//' \
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(bun --version 2> /dev/null)"

# Įvykdyti uname -ms
# Jeigu išvestas "Linux x86_64", palikit kaip yra.
# Jeigu išvestas "Linux aarch64" arba "Linux arm64", pakeisti "linux-x64" į "linux-aarch64".
uname -ms
TARGET="linux-x64"
[ -f /etc/alpine-release ] && TARGET="$TARGET-musl"
[[ $(cat /proc/cpuinfo | grep avx2) = '' ]] && TARGET="$TARGET-baseline"

curl -fsSLo "tmp.bun-${TARGET}.zip" "https://github.com/oven-sh/bun/releases/latest/download/bun-${TARGET}.zip"

printf 'sha256 kontrolinės sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "tmp.bun-${TARGET}.zip" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/oven-sh/bun/releases/expanded_assets/bun-v${LATEST}" \
    | xq -q "li > div:has(a[href$='/bun-${TARGET}.zip']) ~ div > div > span > span:contains('sha256:')" \
    | awk -F':' '{print $NF}')"

rm -rf "$HOME/.opt/bun"
mkdir -p "$HOME/.opt/bun/bin"
unzip -jqd "$HOME/.opt/bun/bin" "tmp.bun-${TARGET}.zip" 2> /dev/null \
  || errorMessage 'Failed to extract bun'

export BUN_INSTALL="${HOME}/.opt/bun"
[[ -d "${BUN_INSTALL}/bin" ]] && \
  [[ ":${PATH}:" != *":${BUN_INSTALL}/bin:"* ]] && \
  export PATH="${BUN_INSTALL}/bin${PATH:+:${PATH}}"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(bun --version 2> /dev/null)"

unset LATEST TARGET
```

Baigę diegti, pakeiskite konfigūracinius failus, kad kelias `${HOME}/.opt/bun/bin` būtų automatiškai įtraukiamas į sistemos `PATH` kintamąjį.

Baigę diegti, pakeiskite konfigūracinius failus, kad bun diegimo katalogas būtų įkeliamas į `BUN_INSTALL` kintamąjį, o kelias `${BUN_INSTALL}/bin` būtų įtraukiamas į sistemos `PATH` kintamąjį.

## Paleistis

```bash
bun run kodo-failas.mjs
```

## Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S bun run
```

arba

```bash
///usr/bin/env -S bun run "$0" "$@"; exit $?
