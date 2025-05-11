[Atgal](./readme.md)

# Kotlin [&#x2B67;](https://kotlinlang.org/)

* Paskiausias leidimas: 2.1.20
* Išleista: 2025-03-20

## Diegimas

### Kotlin'o

```bash
sudo snap install --classic kotlin
kotlin -version
```

### Kotlin Native

```bash
url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/JetBrains/kotlin/releases/latest)"
curl -sSLo- "${url//tag/download}/kotlin-native-prebuilt-linux-x86_64-$(basename -- $url).tar.gz" \
| tar --transform 'flags=r;s/^(kotlin-native)[^\/]+/\1/x' --show-transformed-names -xzvC "${HOME}/.opt"

sed -i '/#begin kotlin init/,/#end kotlin init/c\' "${HOME}/.bashrc"
[[ "$( tail -n 1 "${HOME}/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.bashrc"

echo '#begin kotlin init

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

#end kotlin init' >> "${HOME}/.bashrc"

[[ ":${PATH}:" == *":${HOME}/opt/.kotlin-native/bin:"* ]] \
  || export PATH="${HOME}/opt/.kotlin-native/bin${PATH:+:${PATH}}"

kotlinc-native -version  
```

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
kotlinc kodo-failas.kt
kotlin Kodo_failasKt
```

### Binarinis failas

```bash
kotlinc-native -o vykdomasis-failas.bin.kexe kodo-failas.bin.kt
./vykdomasis-failas.bin.kexe
```
