[Atgal](./readme.md)

# Dart [&#x2B67;](https://dart.dev/)

* Paskiausias leidimas: 3.7.2

## Diegimas

```bash
sudo apt-get update

# Jeigu nėra instaliuotas, instaliuojamas paketas 'apt-transport-https'
(( $(apt list --installed 2>/dev/null | grep -P '^apt-transport-https' | wc -l ) > 0 )) || sudo apt install apt-transport-https

# Diegiamas raktas ir Darto šaltinis
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |\
  sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |\
  sudo tee /etc/apt/sources.list.d/dart_stable.list

# Jeigu nėra instaliuota, instaliuojamas Dartas 
sudo apt-get update && sudo apt-get install dart

# Tikrinamas Darto veikimas
echo ; dart --version
```

arba

```bash
bash dart-install.sh
```

## Paleistis

```bash
dart kodo-failas.dart
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env dart
```

arba

```bash
///usr/bin/env dart "$0" "$@"; exit $? 
```

## Kompiliavimas

```bash
dart compile exe -o vykdomasis-failas.bin kodo-failas.dart
./vykdomasis-failas.bin
```
