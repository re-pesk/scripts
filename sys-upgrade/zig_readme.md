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
zig run --name zig_sys-upgrade.bin zig_sys-upgrade.zig
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name zig_sys-upgrade.bin zig_sys-upgrade.zig && rm zig_sys-upgrade.bin.o
```
