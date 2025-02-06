[Atgal](./readme.md)

# JavaScript [&#x2B67;](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

## Vadovai
  
* [Learn web development](https://developer.mozilla.org/en-US/docs/Learn)
* [The Modern JavaScript Tutorial](https://javascript.info/)

## [Diegimas](../install/js_readme.md)

## Paleistis

### Bun

```bash
bun run js_sys-upgrade-bun.mjs
```

### Deno

```bash
deno js_sys-upgrade-deno.mjs
```

### Node

```bash
node js_sys-upgrade-node.mjs
```

## Vykdymo instrukcija (shebang)

### Bun

```bash
#!/usr/bin/env -S bun run
```

arba

```bash
///usr/bin/env -S bun run "$0" "$@"; exit $?
```

### Deno

```bash
#!/usr/bin/env -S deno run --allow-run --allow-env
```

arba

```bash
///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
```

### Node

```bash
#!/usr/bin/env -S node
```

arba

```bash
///usr/bin/env -S node "$0" "$@"; exit $?
```
