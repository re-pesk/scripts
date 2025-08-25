[&uArr;](./readme.md)

# Pike [&#x2B67;](https://pike.lysator.liu.se/)

* Paskiausia stabili versija: v8.0.1956

## Diegimas

```bash
sudo apt install pike8.0
pike --version
```

## Paleistis

```bash
pike kodo-failas.pike
```

### Vykdymo instrukcija (shebang)

Norint *kodo-failas.pike* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vykdymo instrukciją (shebangą):

```bash
#!/usr/bin/env -S pike
```

arba

```bash
///usr/bin/env -S pike "$0" "$@"; exit "$?"
```
