[Atgal](./readme.md)

# PureScript [&#x2B67;](https://www.purescript.org/)

## Diegimas

```bash
curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  https://github.com/purescript/purescript/releases/latest \
  | sed "s/tag/download/"
)/linux64.tar.gz" | tar -xzv -C "$HOME/.local"

ln -fs "$HOME/.local/purescript/purs" "$HOME/.local/bin/purs"

purs --version

echo "purs v$(purs --version) instaliuotas!"

curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} https://github.com/purescript/spago/releases/latest \
  | sed "s/tag/download/"
)/Linux.tar.gz" | tar -xzv -C "$HOME/.local/purescript"

ln -fs "$HOME/.local/purescript/spago" "$HOME/.local/bin/spago"

echo "spago v$(spago version) instaliuotas!"

spago --version
```

## Paleistis ir kompiliavimas

Purescripto programos pirmiau yra kompiliuojamos į Javascriptą, o ne tiesiogiai vykdomos, todėl Purescriptas netinka scenarijų kalbos vaidmeniui.
