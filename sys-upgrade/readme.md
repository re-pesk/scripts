[&uArr;](../readme.md)

# Skriptinimas skirtingomis programavimo kalbomis (57)

Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis ar jų dialektais.

Tikslas - patikrinti, kaip skirtingos kalbos tinka rašyti operacijų sistemos valdymo skriptus.

Naudota operacinė sistema – Ubuntu 24.04

## Tipinės apvalkalo scenarijų (Shell scripting) kalbos (6)

* [x] [Bash](bash_readme.md) (±)
  (-) asociatyvieji masyvai netinka medžio tipo struktūroms
  (+) labai paplitusi, daug informacijos
* [x] [Dash](dash_readme.md) (-)
  (+) greita
  (-) neturi asociatyviųjų masyvų
  (-) daug kitų apribojimų
* [x] [Yash](yash_readme.md) (-)
  (-) mažai informacijos
  (-) neturi asociatyviųjų masyvų
* [x] [ksh](ksh_readme.md) (±)
  (+) turi įterptinius asocijuotuosius masyvus
  (-) trūksta parametrų išplėtimo (Parameter Expansion) galimybių
* [x] [Osh (Oil)](oil-osh_readme.md) (-)
  (-) mažai informacijos
  (-) paini dokumentacija
* [x] [Zsh](zsh_readme.md) (±)
  (-) asociatyvieji masyvai netinka medžio tipo struktūroms
  (+) pakankamai paplitusi, daug informacijos
  
## Alternatyvios apvalkalo scenarijų (Shell scripting) kalbos (8)

* [x] [Elvish](elvish_readme.md) (?)
  (-) keista asocijuotųjų masyvų ir funkcijų sintaksė
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [Fish](fish_readme.md) (-)
  (-) neturi priemonių medžio tipo struktūroms
  (-) nepatogi sintaksė
* [x] [Ysh (Oil)](oil-ysh_readme.md) (-)
  (-) mažai informacijos
  (-) paini dokumentacija
* [x] [Koi](koi_readme.md) (-)
  (-) neužbaigta kalba
  (-) trūksta reikalingų apvalkalo kalboms ypatybių
* [x] [Murex](murex_readme.md) (-)
  (-) keista sintaksė
* [x] [Ngs](ngs_readme.md) (?)
  (-) keistai organizuotas darbas su klaidomis
* [x] [Nu](nu_readme.md) (?)
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [PowerShell](pwsh_readme.md) (-)
  (-) keista sintaksė
  (-) kilmė iš Microsoft'o

## Intepretuojamos kalbos ir JIT kompiliatoriai (30)

### JavaVM (8)

Lėtai pasileidžia arba reikalingas kompiliavimas. Reikalinga Java JRE arba JDK
  
* [x] [Clojure](clojure_readme.md) (-)
  ( ) Lispo sintaksė
* [x] [Ballerina](ballerina_readme.md) (-)
  (-) ribotos išorinių komandų iškvietimo funkcijos
  (-) sudėtingas klaidų apdrojimas
  (-) skurdi dokumentacija
  (-) mažai informacijos internete
* [X] [Groovy](groovy_readme.md) (-)
* [x] [Java](java_readme.md) (-)
* [x] [Kotlin](kotlin_readme.md) (-)
  3 kodo variantai:
  * [x] intepretuojamas,
  * [x] JVM,
  * [x] kompiliuojamas į mašininį kodą.
* [x] [Scala](scala_readme.md) (-)

### [JS](js_readme.md) (3)

Daug informacijos internete

* [x] Bun (+)
* [x] Deno truputį skiriasi nuo kitų variantų (±)
* [x] Node (+)

### Kitos (19)

* [x] [Abs](abs_readme.md) (-)
  (+) patogi kalba
  (?) nebevystoma? :frowning:, atnaujinta 2025-04
* [x] [Dart](dart_readme.md) (-)
  (-) nepatogus darbas su išorinėmis komandomis
* [x] [Euphoria](euph_readme.md) (-)
  (-) sudėtingas instaliavimas
  (-) seniai nebuvo leidimų
  * [x] [Phix](phix_readme.md) - stipriai modifikuota Euforijos versija (-)
    (-) nepavyko paleisti visų pavyzdžių
* [x] [Guile](guile_readme.md) (-)
  ( ) Lispo sintaksė
  (-) sudėtinga susigaudyti dokumentacijoje
  (-) mažai informacijos intenete
* [x] [Haxe](haxe_readme.md) (-)
  (-) pagrindinės klasė nepatogiai susieta su kodo failo pavadinimu
  (-) reikalauja pagrindinės klasės
* [x] [Io](https://iolanguage.org/index.html) (±)
  (+) maža, paprasta kalba
  ( ) Smaltalk'o sintaksė
  (-) nebevystoma
* [x] [Janet](janet_readme.md) (?)
  ( ) Lispo sintaksė
  (+) pozicionuojama kaip skriptinė kalba
* [x] [Julia](julia_readme.md) (±)
  ( ) Pythono pakaitalas moksliniams skaičiavimams
* [x] [Lua](lua_readme.md) (+)
  (+) paprasta kalba
  * [x] [Hilbish](hilbish_readme.md) Apvalkalas (shell) Lua kalbos pagrindu (+)
  * [x] [Pluto](pluto_readme.md) Lua kalbos supersetas su klasėmis (+)
* [x] [Onyx](onyx_readme.md) - kalba, skirta kompiliuoti į Wasm (±)
  (+) turi JIT kompiliatorių
  (-) visiškai nauja kalba
  (-) nėra dokumentacijos
* [x] [Perl](perl_readme.md) bendros paskirties Unix'o scenarijų kalba (-)
  (-) nepatogi ir keista sintaksė
  (+) daug informacijos ir pavyzdžių
* [x] [PHP](php_readme.md) (±)
  (+) daug informacijos internete
  (+) kalba pakankamai universali, kad būtų taikoma ne tik web srityje
  (-) sintaksė vis dar orientuota į web skriptinimą („<?php“ failo pradžioje)
* [x] [Pike](pike_readme.md) (+)
  (+) C++ kalbos sintakse
  (-) mažai naudojama
* [x] [Python](py_readme.md) (±)
  (+) plačiai naudojamas
  (+) daug informacijos internete
  (-) teksto įtraukomis grįsta sintaksė
* [x] [Ruby](ruby_readme.md) (-)
  (-) keistoka sintaksė
  (-) lėtas, išnaudoja tik vieną branduolį
* [x] [Tcl](tcl_readme.md) (±)
  (+) sena, žinoma kalba
  (-) kartais keista sintaksė

## Kompiliuojamos kalbos (13, 2 neveikia)

* [x] [C](c_readme.md) (-)
  (+) greita
  (-) nėra reikiamų funkcijų ir struktūrų standartinėje bibliotekoje
* [x] [C++](c++_readme.md) (+)
  (+) kodą rašyti žymiai paprasčiau už C
  (+) turi reikalingas duomenų struktūras
* [x] [C3](c3_readme.md) (±)
  (+) sukurta kaip C kalbos pakaitalas
* [ ] [Carbon](carbon_readme.md) (-)
  (+) kuriama kaip C kalbos pakaitalas
  (-) nepakankamai iįvystyta, nepavyko sukompiliuoti dokumentacijos pavyzdžio
* [x] [Chapel](chapel_readme.md) (?)
  (+) kalba su C sintakse
  (+) paralelinė
  (-) pernelyg nauja, nedaug informacijos
  (-) nelabai patogi dokumentacija
* [x] [Crystal](crystal_readme.md) (+)
  (+) kalba su Ruby sintakse, tačiau kompiliuojama, tad daugiau prasmės mokytis nei Ruby
* [x] [D](d_readme.md) (+)
  (+) išvystyta kalba
  (-) sunkiai panaudojama be šiukšlių surinktuvo (Garbage Collector)
* [x] [Go](go_readme.md) (±)
* [x] [Haskell](haskell_readme.md) (-)
  (-) sintakse ir logika labai skiriasi nuo kitų kalbų
* [x] [Odin](odin_readme.md) (+)
  (+) dar vienas C kalbos pakaitalas
  (+) paprastesnė už Zig, verta pasimokyti
* [ ] [Purescript](purs_readme.md) (-)
  (-) transpileris, generuojantis JS kodą
  (-) netinka scenarijų kalbos vaidmeniui
* [x] [Rust](rust_readme.md) (-)
  (-) reikalauja projekto failo
  (-) neaiškūs klaidų pranešimai
* [x] [Swift](swift_readme.md) (-)
  (-) klaidos
  (-) dokumentacija orientuota į MacOS
* [x] [V](v_readme.md) (-)
  (-) mažai žinoma
  (-)daug kritikos dėl neprofesionalių sprendimų
* [x] [Zig](zig_readme.md) (-)
  (-) pernelyg sudėtinga paprastoms užduotims
