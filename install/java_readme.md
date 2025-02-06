[Atgal](./readme.md)

# Java [&#x2B67;](https://www.java.com/en/download/help/index.html)

## Diegimas

```bash
sudo apt install openjdk-21-jdk
java -version
```

## Paleistis

```bash
java --source 21 --enable-preview java_sys-upgrade.java
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env java --source 21 --enable-preview "$0" "$@"; exit $?
```
