[&uArr;](./readme.md)

# Kotlin [&#x2B67;](https://kotlinlang.org/)

## Diegimas

### [Kotlin'o](../install/kotlin_readme.md)

## Paleistis

Failo pavadinimo plėtinys būtinai turi būti „.kts“!

```bash
kotlinc -script kotlin_sys-upgrade.kts
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S kotlinc -script
```

arba

```bash
///usr/bin/env -S kotlinc -script "$0" "$@"; exit $?
```

## Kompiliavimas

Kompiliuojant kodas turi būti pagrindinėje „main“ funkcijoje. Failo pavadinimo plėtinys būtinai turi būti „.kt“!

### Klasės failas

```bash
kotlinc kotlin_sys-upgrade.kt
kotlin Kotlin_sys_upgradeKt
```

### Binarinis failas

```bash
kotlinc-native -o kotlin_sys-upgrade.bin kotlin_sys-upgrade.bin.kt
./kotlin_sys-upgrade.bin.kexe
```
