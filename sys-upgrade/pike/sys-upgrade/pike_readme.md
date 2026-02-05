[&uArr;](./readme.md)

# Pike [&#x2B67;](https://pike.lysator.liu.se/)

## [Diegimas](../install/pike_readme.md)

## Paleistis

```bash
pike pike_sys-upgrade.pike
```

### Vykdymo instrukcija (shebang)

Norint *pike_sys-upgrade.pike* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vydymo eilutę.

Įprastinė eilutė:

```bash
#!/usr/bin/env -S pike
```

Bash'o* kodo eilutė:

```bash
///usr/bin/env -S pike "$0" "$@"; exit "$?"
```
