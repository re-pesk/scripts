[Atgal](./readme.md)

# Kotlin [&#x2B67;](https://kotlinlang.org/)

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
  | tar --transform 'flags=r;s/^kotlin-native[^\/]+/kotlin-native/x' --show-transformed-names -xzvC "$HOME/.local"

[[ "$( tail -n 1 "$HOME/.bashrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "$HOME/.bashrc"

echo '#begin kotlin init

[[ ":$PATH:" == *":$HOME/.local/kotlin-native/bin:"* ]] \
  || export PATH="$HOME/.local/kotlin-native/bin${PATH:+:${PATH}}"

#end kotlin init' >> "$HOME/.bashrc"

export PATH="$HOME/.local/kotlin-native/bin${PATH:+:${PATH}}"

kotlinc-native -version  
```

## Paleistis

Failo pavadinimo plėtinys būtinai turi būti „.kts“!

```bash
kotlinc -script kotlin_sys-upgrade.kts
```

### Shebang

```shebang
#!/usr/bin/env -S kotlinc -script
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
