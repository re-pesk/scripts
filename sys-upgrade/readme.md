[Atgal](../readme.md)

# Skriptinimas skirtingomis programavimo kalbomis (46)

Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis ar jų dialektais

Naudota operacinė sistema – Ubuntu 24.04

## Tipinės apvalkalo scenarijų (Shell scripting) kalbos (6)

* [x] [Bash](bash_readme.md) (+-): asociatyvieji masyvai netinka medžio tipo struktūroms, bet labai papiltusi, daug informacijos
* [x] [Dash](dash_readme.md) (-): neturi asociatyviųjų masyvų, daug kitų apribojimų
* [x] [Yash](yash_readme.md) (-): mažai informacijos, neturi asociatyviųjų masyvų
* [x] [ksh](ksh_readme.md) (+-): turi įterptinius asocijuotuosius masyvus, tačiau trūksta parametrų išplėtimo (Parameter Expansion) galimybių
* [x] [Osh (Oil)](oil-osh_readme.md) (-) mažai informacijos, paini dokumentacija
* [x] [Zsh](zsh_readme.md) (+-): tas pats kaip Bash
  
## Alternatyvios apvalkalo scenarijų (Shell scripting) kalbos (8)

* [x] [Elvish](elvish_readme.md) (?): keista asocijuotųjų masyvų ir funkcijų sintaksė, dažniau minima, mei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [Fish](fish_readme.md) (-): neturi priemonių medžio tipo struktūroms, nepatogi sintaksė  
* [x] [Ysh (Oil)](oil-ysh_readme.md) (-): mažai informacijos, paini dokumentacija
* [x] [Koi](koi_readme.md) (-): neužbaigta kalba, trūksta reikalingų apvalkalo kalboms ypatybių
* [x] [Murex](murex_readme.md) (-): keista sintaksė
* [x] [Ngs](ngs_readme.md) (?): keistai organizuotas darbas su klaidomis
* [x] [Nu](nu_readme.md) (?): dažniau minima, mei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [PowerShell](pwsh_readme.md) (-): keista sintaksė, kilmė iš Microsoft'o

## Intepretuojamos kalbos ir JIT kompiliatoriai (20)

### JavaVM (7)

Lėtai pasileidžia arba reikalingas kompiliavimas. Reikalinga Java JRE arba JDK
  
* [x] [Clojure](https://clojure.org/) (-) Lispo sintaksė
* [X] [Groovy](groovy_readme.md) (-)
* [x] [Java](java_readme.md) (-)
* [x] [Kotlin](kotlin_readme.md) (-)
      3 kodo variantai: intepretuojamas, JVM, ir native
* [x] [Scala](scala_readme.md) (-)

### [JS](js_readme.md) (3)

Daug informacijos internete

* [x] Bun (+)
* [x] Deno (+-) truputį skiriasi nuo kitų variantų
* [x] Node (+)

### Kitos (10)

* [x] [Abs](abs_readme.md) (-) patogi kalba, bet nebevystoma :(
* [x] [Dart](dart_readme.md) (-) nepatogus darbas su išorinėmis komandomis
* [x] [Guile](guile_readme.md) (-) Lispo sintaksė. Sudėtinga susigaudyti dokumentacijoje, mažai informacijos intenete
* [x] [Io](https://iolanguage.org/index.html) (+-) Maža, paprasta kalba su Smaltalk'o sintakse, bet, deja, nevystoma
* [x] [Janet](janet_readme.md) (?) Lispo sintaksė, pozicionuojama kaip skriptinė kalba
* [x] [Julia](julia_readme.md) (+-) Pythono pakaitalas moksliniams skaičiavimams
* [x] [Lua](lua_readme.md) (+) Paprasta kalba
* [x] [PHP](php_readme.md) (+-) daug informacijos internete, kalba pakankamai universali, kad būtų taikoma ne tik web srityje, tačiau sintaksė vis dar orientuota į web skriptinimą
* [x] [Python](py_readme.md) (+-) pagrindinis trūkumas - tarpais grįsta sintaksė
* [x] [Ruby](ruby_readme.md) (+-) keistoka sintaksė

## Kompiliuojamos kalbos (12)

* [x] [C](c_readme.md) (-): nėra reikiamų funkcijų ir struktūrų standartinėje bibliotekoje
* [x] [C++](c++_readme.md) (+): kodą rašyti žymiai paprasčiau už C, turi reikalingas duomenų struktūras
* [x] [C3](c3_readme.md) (+-): C kalbos pakaitalas
* [ ] [Carbon](carbon_readme.md) (-): nepavyko sukompiliuoti dokumentacijos pavyzdžio
* [x] [Crystal](crystal_readme.md) (+): kompiliuojama kalba su Ruby sintakse, daugiau prasmės mokytis nei Ruby
* [x] [D](d_readme.md) (+): išvystyta kalba, bet mažai naudinga be šiukšlių surinktuvo (Garbage Collector)
* [x] [Go](go_readme.md) (+-)
* [x] [Haskell](haskell_readme.md) (-): sintakse ir logika labai skiriasi nuo kitų kalbų
* [x] [Odin](odin_readme.md) (+): dar vienas C kalbos pakaitalas, verta pasimokyti
* [ ] [Purescript](purs_readme.md) (-): transpileris, generuojantis JS kodą, reikalingas papildomų instrumentų.
* [x] [Rust](rust_readme.md) (-): reikalauja projekto failo, neaiškūs klaidų pranešimai
* [x] [Swift](swift_readme.md) (-) klaidos, dokumentacija orientuota į MacOS
* [x] [V](v_readme.md) (-): mažai žinoma, daug kritikos dėl neprofesionalių sprendimų
* [x] [Zig](zig_readme.md) (-): pernelyg sudėtinga paprastoms užduotims
