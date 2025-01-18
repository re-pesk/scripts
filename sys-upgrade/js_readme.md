[Atgal](./readme.md)

# JavaScript [&#x2B67;](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

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

### Shebang

```shebang
#!/usr/bin/env -S bun run
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

### Shebang

```shebang
#!/usr/bin/env -S deno run --allow-run --allow-env
```

## Node

### Diegimas

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
node --version
```

### Paleistis

```bash
node js_sys-upgrade-node.mjs
```

### Shebang

```shebang
#!/usr/bin/env -S node
```
