[Grįžti &#x2BA2;](../../readme.md "Grįžti")

# TypeScript [<sup>&#x2B67;</sup>](https://www.typescriptlang.org/) (Deno [<sup>&#x2B67;</sup>](https://deno.com/))

## [Diegimas](../install/deno_readme.md)

## Paleistis

```bash
deno run --allow-run --allow-env ts_sys-upgrade-deno.mts
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
```

# Kompiliavimas

```bash
deno compile --allow-run --allow-env --output ts_sys-upgrade-deno.bin ts_sys-upgrade-deno.mts
./ts_sys-upgrade-deno.bin
```
