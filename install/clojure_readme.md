[&uArr;](./readme.md)

# Clojure [&#x2B67;](https://clojure.org/index)

* Paskiausias leidimas: 1.12.0.1530
* Išleista: 2025-03-06

## Parengimas

Jeigu nėra įdiegta, įdiegiama [curl](../utils/curl.md)

## Diegimas

```bash
[ -d ${HOME}/.opt/clojure ] && rm -r ${HOME}/.opt/clojure
curl -Lo- https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh \
| bash -s -- --prefix ${HOME}/.opt/clojure
ln -fs ${HOME}/.opt/clojure/bin/clj -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/bin/clojure -t ${HOME}/.local/bin
ln -fs ${HOME}/.opt/clojure/share/man/man1/clj.1 -t ${HOME}/.local/man/man1
ln -fs ${HOME}/.opt/clojure/share/man/man1/clojure.1 -t ${HOME}/.local/man/man1
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
