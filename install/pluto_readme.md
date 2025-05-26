[Atgal](./readme.md)

# Pluto [&#x2B67;](https://pluto-lang.org/)

## Diegimas

```bash
wget -qO- https://calamity-inc.github.io/deb-repo/key.gpg | sudo tee /usr/share/keyrings/calamity-inc.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/calamity-inc.gpg] https://calamity-inc.github.io/deb-repo/ buster main" \
| sudo tee /etc/apt/sources.list.d/calamity-inc.list > /dev/null
sudo apt update
sudo apt install pluto
pluto -v
```

## Paleistis

```bash
pluto kodo-failas.pluto
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env pluto
```

## Kompiliavimas

Kompiliavimas į baitkodą ir vykdymas:

```bash
plutoc -o baitkodo-failas.bin kodo-failas.pluto
pluto baitkodo-failas.bin
```
