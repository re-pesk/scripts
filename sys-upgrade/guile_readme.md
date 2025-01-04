[Atgal](./readme.md)

# GNU Guile [&#x2B67;](https://www.gnu.org/software/guile/)

## Diegimas

```bash
sudo apt-get install guile-3.0
guile --version

sudo apt-get install guile-3.0-dev
guild --version
```

## Paleistis

```bash
guile --no-auto-compile guile_sys-upgrade.scm
```

Be automatinio kompiliavimo

```bash
guile --no-auto-compile guile_sys-upgrade.scm
```

## Kompiliavimas (į baitkodą)

Įtepti į guile_sys-upgrade.scm failą eilutes:

```scheme
(define-module (guile_sys-upgrade)
  #:export (main))

(define (main)
  <ankstesnis kodas>
)

(main)
```

Kompiliuoti failą

```bash
guild compile --output=guile_sys-upgrade.go guile_sys-upgrade.scm
```

Paleisti sukompiliuotą failą:

```bash
guile -C "$PWD" -c "(use-modules (guile_sys-upgrade))"
```