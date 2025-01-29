[Atgal](./readme.md)

# Zig [&#x2B67;](https://ziglang.org/)

## Diegimas Linuxe (Ubuntu 24.04)

```bash
# Pakeiskite ${version} versijos numeriu, tarkim, 0.13.0
# Vėliausią versijos numerį galima rasti https://ziglang.org/download/
curl -sSLo- https://ziglang.org/download/${version}/zig-linux-x86_64-${version}.tar.xz \
| tar --transform 'flags=r;s/^zig[^\/]+/zig/x' --show-transformed-names -xJC "${HOME}/.local"
ln -fs ${HOME}/.local/zig/zig ${HOME}/.local/bin/zig
zig version
```

arba pakeiskite reikalingą versijos numerį `zig_instal.sh` faile ir pleiskite isntaliaciją

```bash
bash zig_instal.sh
```

## Paleistis

```bash
zig run --name vykdomasis-failas.bin kodo-failas.zig
```

### Vykdomoji eilutė

```bash
///usr/bin/env -S zig run "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name vykdomasis-failas.bin kodo-failas.zig
rm vykdomasis-failas.bin.o
```
