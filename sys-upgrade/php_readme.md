[Atgal](./readme.md)

# PHP [&#x2B67;](https://www.php.net/)

## [Diegimas](../install/php_readme.md)

## Paleistis

```bash
php php_sys-upgrade.php
```

### Shebang

Norint *php_sys-upgrade.php* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti shebangą:

```shebang
#!/usr/bin/env php
```

arba prieš *<?php* tagą įterpti *bash'o* kodo eilutę:

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" "$@"; exit "$?"
//<?php
```
