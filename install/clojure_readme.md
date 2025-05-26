[Atgal](./readme.md)

# Clojure [&#x2B67;](https://clojure.org/index)

* Paskiausias leidimas: 1.12.0.1530
* Išleista: 2025-03-06

## Diegimas

```bash
[ -d ${HOME}/.clojure ] && rm -r ${HOME}/.clojure
curl -Lo- https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh \
| bash -s -- --prefix ${HOME}/.local
clojure -version
```

## Paleistis

```bash
clojure -M kodo-failas.clj
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S clojure -M
```
