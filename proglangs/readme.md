[&#x2BA2;](../readme.md)

# Skriptinimas skirtingomis programavimo kalbomis (61)

Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis ar jų dialektais.

Tikslas - patikrinti, kaip skirtingos kalbos tinka rašyti operacijų sistemos valdymo skriptus.

Naudota operacinė sistema – Ubuntu 24.04

## Tipinės apvalkalo scenarijų (Shell scripting) kalbos (7)

* [x] [Bash](bash/sys-upgrade/bash_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) labai paplitusi, daug informacijos
  * [x] [Brush](brush/sys-upgrade/brush_readme.md) (–)\
    (+) greita ir saugi - parašyta su Rust\
    (+) suderinama su Bash
* [x] [Dash](dash/sys-upgrade/dash_readme.md) (–)\
  (+) greita\
  (–) neturi asociatyviųjų masyvų\
  (–) daug kitų apribojimų
* [x] [Yash](yash/sys-upgrade/yash_readme.md) (–)\
  (–) mažai informacijos\
  (–) neturi asociatyviųjų masyvų
* [x] [ksh](kash/sys-upgrade/ksh_readme.md) (±)\
  (+) turi įterptinius asocijuotuosius masyvus\
  (–) trūksta parametrų išplėtimo (Parameter Expansion) galimybių
* [x] [Osh (Oils)](oils/sys-upgrade/oils_readme.md) (–)\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Zsh](zsh/sys-upgrade/zsh_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) pakankamai paplitusi, daug informacijos

## Alternatyvios apvalkalo scenarijų (Shell scripting) kalbos (9)

* [x] [Abs](abs/sys-upgrade/abs_readme.md) (–)\
  (+) patogi kalba\
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-27
* [x] [Elvish](elvish/sys-upgrade/elvish_readme.md) (?)\
  (–) keista asocijuotųjų masyvų ir funkcijų sintaksė\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [Fish](fish/sys-upgrade/fish_readme.md) (–)\
  (–) neturi priemonių medžio tipo struktūroms\
  (–) nepatogi sintaksė
* [x] [Ysh (Oils)](oils/sys-upgrade/oils_readme.md) (–)\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Koi](koi/sys-upgrade/koi_readme.md) (–)\
  (–) neužbaigta kalba\
  (–) trūksta reikalingų apvalkalo kalboms ypatybių
* [x] [Murex](murex/sys-upgrade/murex_readme.md) (–)\
  (–) keista sintaksė
* [x] [Ngs](ngs/sys-upgrade/ngs_readme.md) (?)\
  (–) keistai organizuotas darbas su klaidomis
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-05
* [x] [Nushell](nushell/sys-upgrade/nu_readme.md) (?)\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [PowerShell](powershell/sys-upgrade/pwsh_readme.md) (–)\
  (–) keista sintaksė\
  (–) kilmė iš Microsoft'o

## Intepretuojamos kalbos ir JIT kompiliatoriai (32)

### JavaVM (8)

Lėtai pasileidžia arba reikalingas kompiliavimas. Reikalinga Java JRE arba JDK

* [x] [Clojure](clojure/sys-upgrade/clojure_readme.md) (–)\
  (&ensp;) Lispo sintaksė
* [x] [Ballerina](ballerina/sys-upgrade/ballerina_readme.md) (–)\
  (–) ribotos išorinių komandų iškvietimo funkcijos\
  (–) sudėtingas klaidų apdrojimas\
  (–) skurdi dokumentacija\
  (–) mažai informacijos internete
* [X] [Groovy](groovy/sys-upgrade/groovy_readme.md) (–)
* [x] [Java](java/sys-upgrade/java_readme.md) (–)
* [x] [Kotlin](kotlin/sys-upgrade/kotlin_readme.md) (–)
  3 kodo variantai:
  * [x] intepretuojamas,
  * [x] JVM,
  * [x] kompiliuojamas į mašininį kodą.
* [x] [Scala](scala/sys-upgrade/scala_readme.md) (–)

### [JS](js/sys-upgrade/js_readme.md) (3)

Daug informacijos internete

* [x] Bun (+)
* [x] Deno truputį skiriasi nuo kitų variantų (±)
* [x] Node (+)

### Kitos (21)

* [x] [Dart](dart/sys-upgrade/dart_readme.md) (–)\
  (–) nepatogus darbas su išorinėmis komandomis
* [x] [Euphoria](euphoria/sys-upgrade/euph_readme.md) (–)\
  (–) sudėtingas instaliavimas\
  (–) seniai nebuvo leidimų
  * [x] [Phix](phix/sys-upgrade/phix_readme.md) - stipriai modifikuota Euforijos versija (–)\
    (–) nepavyko paleisti visų pavyzdžių
* [x] [Guile](guile/sys-upgrade/guile_readme.md) (–)\
  (&ensp;) Lispo sintaksė\
  (–) sudėtinga susigaudyti dokumentacijoje\
  (–) mažai informacijos intenete
* [x] [Haxe](haxe/sys-upgrade/haxe_readme.md) (–)\
  (–) pagrindinės klasė nepatogiai susieta su kodo failo pavadinimu\
  (–) reikalauja pagrindinės klasės
* [x] [Io](io/sys-upgrade/io_readme.md) (±)\
  (+) maža, paprasta kalba\
  (&ensp;) Smaltalk'o sintaksė\
  (–) nebevystoma
* [x] [Janet](janet/sys-upgrade/janet_readme.md) (?)\
  (&ensp;) Lispo sintaksė\
  (+) pozicionuojama kaip skriptinė kalba
* [x] [Julia](julia/sys-upgrade/julia_readme.md) (±)\
  (&ensp;) Pythono pakaitalas moksliniams skaičiavimams
* [x] [Lua](lua/sys-upgrade/lua_readme.md) (+)\
  (+) paprasta kalba
  * [x] [Hilbish](hilbish/sys-upgrade/hilbish_readme.md) Apvalkalas (shell) Lua kalbos pagrindu (+)
  * [x] [Pluto](pluto/sys-upgrade/pluto_readme.md) Lua kalbos supersetas su klasėmis (+)
* [x] [Miniscript](miniscript/sys-upgrade/mscr_readme.md) (–)\
  (+) paprasta kalba\
  (–) menkos galimybės dirbti su išorinėmis komandomis\
  (–) mažai informacijos internete\
  (–) seniai nebuvo leidimų\
  (+) ruošiama nauja versija
* [x] [Onyx](onyx/sys-upgrade/onyx_readme.md) - kalba, skirta kompiliuoti į Wasm (±)\
  (+) turi JIT kompiliatorių\
  (–) visiškai nauja kalba\
  (–) nėra dokumentacijos
* [x] [Perl](perl/sys-upgrade/perl_readme.md) bendros paskirties Unix'o scenarijų kalba (–)\
  (–) nepatogi ir keista sintaksė\
  (+) daug informacijos ir pavyzdžių
* [x] [PHP](php/sys-upgrade/php_readme.md) (±)\
  (+) daug informacijos internete\
  (+) kalba pakankamai universali, kad būtų taikoma ne tik web srityje\
  (–) sintaksė vis dar orientuota į web skriptinimą („<?php“ failo pradžioje)
* [x] [Pike](pike/sys-upgrade/pike_readme.md) (+)\
  (+) C++ kalbos sintakse\
  (–) mažai naudojama
* [x] [Python](python/sys-upgrade/python_readme.md) (±)\
  (+) plačiai naudojamas\
  (+) daug informacijos internete\
  (–) teksto įtraukomis grįsta sintaksė
  * [x] [Bython](bython/sys_upgrade/bython_readme.md) (±)\
    (+) skliaustais įrėminti blokai
  * [x] [CurlyPy](curlypy/sys_upgrade/curlypy_readme.md) (±)\
    (+) skliaustais įrėminti blokai
* [x] [Ruby](ruby/sys-upgrade/ruby_readme.md) (–)\
  (–) keistoka sintaksė\
  (–) lėtas, išnaudoja tik vieną branduolį
* [x] [Tcl](tcl/sys-upgrade/tcl_readme.md) (±)\
  (+) sena, žinoma kalba\
  (–) kartais keista sintaksė

## Kompiliuojamos kalbos (13, dar 2 neveikia)

* [x] [C](c/sys-upgrade/c_readme.md) (–)\
  (+) greita\
  (–) nėra reikiamų funkcijų ir struktūrų standartinėje bibliotekoje
* [x] [C++](c++/sys-upgrade/c++_readme.md) (+)\
  (+) kodą rašyti žymiai paprasčiau už C\
  (+) turi reikalingas duomenų struktūras
* [x] [C3](c3/sys-upgrade/c3_readme.md) (±)\
  (+) sukurta kaip C kalbos pakaitalas
* [ ] [Carbon](carbon/sys-upgrade/carbon_readme.md) (–)\
  (+) kuriama kaip C kalbos pakaitalas\
  (–) nepakankamai iįvystyta, nepavyko sukompiliuoti dokumentacijos pavyzdžio
* [x] [Chapel](chapel/sys-upgrade/chapel_readme.md) (?)\
  (+) kalba su C sintakse\
  (+) paralelinė\
  (–) pernelyg nauja, nedaug informacijos\
  (–) nelabai patogi dokumentacija
* [x] [Crystal](crystal/sys-upgrade/crystal_readme.md) (+)\
  (+) kalba su Ruby sintakse, tačiau kompiliuojama, tad daugiau prasmės mokytis nei Ruby
* [x] [D](d/sys-upgrade/d_readme.md) (+)\
  (+) išvystyta kalba\
  (–) sunkiai panaudojama be šiukšlių surinktuvo (Garbage Collector)
* [x] [Go](go/sys-upgrade/go_readme.md) (±)
* [x] [Haskell](haskell/sys-upgrade/haskell_readme.md) (–)\
  (–) sintakse ir logika labai skiriasi nuo kitų kalbų
* [x] [Odin](odin/sys-upgrade/odin_readme.md) (+)\
  (+) dar vienas C kalbos pakaitalas\
  (+) paprastesnė už Zig, verta pasimokyti
* [ ] [Purescript](purescript/sys-upgrade/purs_readme.md) (–)\
  (–) transpileris, generuojantis JS kodą\
  (–) netinka scenarijų kalbos vaidmeniui
* [x] [Rust](rust/sys-upgrade/rust_readme.md) (–)\
  (–) reikalauja projekto failo\
  (–) neaiškūs klaidų pranešimai
* [x] [Swift](swift/sys-upgrade/swift_readme.md) (–)\
  (–) klaidos\
  (–) dokumentacija orientuota į MacOS
* [x] [V](v/sys-upgrade/v_readme.md) (–)\
  (–) mažai žinoma\
  (–) daug kritikos dėl neprofesionalių sprendimų
* [x] [Zig](zig/sys-upgrade/zig_readme.md) (–)\
  (–) pernelyg sudėtinga paprastoms užduotims
