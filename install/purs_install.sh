#!/usr/bin/env bash

curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  https://github.com/purescript/purescript/releases/latest \
  | sed "s/tag/download/"
)/linux64.tar.gz" | tar -xzv -C "$HOME/.local"

ln -fs "$HOME/.local/purescript/purs" "$HOME/.local/bin/purs"

echo "purs v$(purs --version) instaliuotas!"

curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  https://github.com/purescript/spago/releases/latest \
  | sed "s/tag/download/"
)/Linux.tar.gz" | tar -xzv -C "$HOME/.local/purescript"

ln -fs "$HOME/.local/purescript/spago" "$HOME/.local/bin/spago"

echo "spago v$(spago version) instaliuotas!"
