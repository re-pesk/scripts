# Go [&#x2B67;](https://go.dev/)

## Diegimas

```bash
curl -fsSo - https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz | tar -xz -C $HOME/.local
ln -s $HOME/.local/go/bin/go $HOME/.local/bin/go
ln -s $HOME/.local/go/bin/gofmt $HOME/.local/bin/gofmt
go version
```

## Paleistis

```bash
go run go_sys-upgrade.go
```

## Kompilavimas

```bash
go build -o go_sys-upgrade.bin go_sys-upgrade.go
```
