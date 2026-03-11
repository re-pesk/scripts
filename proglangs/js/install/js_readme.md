[Grįžti &#x2BA2;](../../install_readme.md "Grįžti")

# JavaScript [<sup>&#x2B67;</sup>](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

* Paskiausias leidimas: ES2024
* Išleista: 2024-06

## Vadovai

* [Learn web development](https://developer.mozilla.org/en-US/docs/Learn)
* [The Modern JavaScript Tutorial](https://javascript.info/)

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Bun

### Diegimas

```bash
curl -fsSL https://bun.sh/install | bash
bun --version
```

### Paleistis

```bash
bun run kodo-failas.mjs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S bun run
```

arba

```bash
///usr/bin/env -S bun run "$0" "$@"; exit $?
```

## Deno

### Diegimas

```bash
DENO_INSTALL="${HOME}/.opt/deno" curl -fsSL https://deno.land/install.sh | sh
deno --version
```

### Paleistis

```bash
deno kodo-failas.mjs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S deno run --allow-run --allow-env
```

arba

```bash
///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
```

## Node

### Diegimas

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
node --version
```

arba (jeigu patenkina sistemos (Ubuntu 24.04) versija `nodejs v18.19`)

```bash
sudo apt update
sudo apt install nodejs
node --version
```

### Paleistis

```bash
node kodo-failas.mjs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S node
```

arba

```bash
///usr/bin/env -S node "$0" "$@"; exit $?
```
