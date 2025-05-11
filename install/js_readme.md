[Atgal](./readme.md)

# JavaScript [&#x2B67;](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

* Paskiausias leidimas: ES2024
* Išleista: 2024-06

## Vadovai
  
* [Learn web development](https://developer.mozilla.org/en-US/docs/Learn)
* [The Modern JavaScript Tutorial](https://javascript.info/)

## Bun

### Diegimas

```bash
curl -fsSL https://bun.sh/install | bash
bun --version
```

### Paleistis

```bash
bun run js_sys-upgrade-bun.mjs
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
curl -fsSL https://deno.land/install.sh | sh
deno --version
```

### Paleistis

```bash
deno js_sys-upgrade-deno.mjs
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
node js_sys-upgrade-node.mjs
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S node
```

arba

```bash
///usr/bin/env -S node "$0" "$@"; exit $?
```
