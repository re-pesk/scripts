[Atgal](./readme.md)

# Carbon [&#x2B67;](https://docs.carbon-lang.dev/)

## Diegimas

```bash
# Pasirinkti archyvą iš https://github.com/carbon-language/carbon-lang/releases
version="$(date -d yesterday +0.0.0-0.nightly.%Y.%m.%d)"
url="https://github.com/carbon-language/carbon-lang/releases/download/v${version}/carbon_toolchain-${version}.tar.gz"
curl -fsSLo - $url | tar --transform 'flags=r;s/^(carbon)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.local"
unset version url
echo -e '#!/usr/bin/env bash'"\n\n"'${HOME}/.local/carbon/bin/carbon "$@"' > ${HOME}/.local/bin/carbon
chmod u+x ${HOME}/.local/bin/carbon
carbon version
```

## Paleistis ir kompiliavimas

Pagal instrukcijas suinstaliavus Carbon'o įrankius, dokumentacijoje nurodyta komanda nekompiliuoja ten pat pateikto pavyzdžio. Kitų kalbų projektai, startavę panašiu metu ar vėliau už Carboną, leidžia rašyti veikiantį kodą. Nepanašu, kad šis projektas gyvybingas.
