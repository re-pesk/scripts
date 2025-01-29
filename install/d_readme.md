[Atgal](./readme.md)

# D [&#x2B67;](https://dlang.org/)

## Diegimas

```bash
curl -fsSL https://dlang.org/install.sh | bash -s dmd -p ~/.dlang
source ~/.dlang/dmd-2.109.1/activate
dmd --version
deactivate # kai nebereikia
```

arba atsisiųsti vėliausią `.deb` failą iš D kalbos leidimų [puslapio](https://downloads.dlang.org/releases/) ir

```bash
sudo apt install atsisiųstas_failas.deb
```

## Paleistis

```bash
rdmd kodo_failas.d
```

### Shebang

```shebang
#!/usr/bin/env rdmd
```

## Kompiliavimas

```bash
rdmd --build-only -release -of=vykdomasis_failas.bin kodo_failas.d
```
