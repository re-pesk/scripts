[Atgal](./readme.md)

# PHP [&#x2B67;](https://www.php.net/)

## Diegimas

```bash
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.4 php8.4-mbstring php8.4-curl php8.4-phpdbg php8.4-xdebug -y
php -v
```

arba

```bash
bash php_install.sh
```

## Paleistis

```bash
php kodo-failas.php
```

### Vykdymo instrukcija (shebang)

Norint *kodo-failas.php* paversti vykdomuoju failu, reikia suteikti jam vykdymo teises ir failo pradžioje įrašyti vykdymo instrukciją (shebangą):

```bash
#!/usr/bin/env php
```

arba

```bash
///usr/bin/env php -r "$(tail -n +1 "$0")" "$@"; exit "$?"
//<?php
```

arba

```bash
///usr/bin/env php "$0" -- "$@"; exit "$?"
<?php
```
