[Atgal](../readme.md)

# Pandoc koverterio naudojimas

## Paleidimas

Pavyzdys:

```bash
pandoc-bun.mjs --opt=markdown/asciidoc readme
```

Parametrai

```bash
pandoc-bun.mjs \
--opt=<įvedimo formatas>/<išvedimo formatas> \
<failo pavadinimas be plėtinio>
```

Įvedimo išvedimo formatai

| Pavadinimas | Failo plėtinys | Numatytieji plėtiniai |
| -- | -- | :--: |
| asciidoc | adoc | - |
| context | ctex  | - |
| djot | dj  | - |
| docx | docx  | - |
| haddock | hie  | - |
| html | html  | - |
| ipynb | ipynb  | - |
| jats | jats  | - |
| json | json  | - |
| latex | tex  | - |
| markdown | md | +abbreviations+emoji+mark |
| muse | muse  | - |
| native | hs  | - |
| pdf | pdf  | - |
| odt | odt  | - |
| rst | rst  | - |
| texinfo | txi  | - |
| textile | textile  | - |
| typst | typ  | - |
