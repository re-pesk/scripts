#!/usr/bin/env bash

curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  https://github.com/purescript/purescript/releases/latest \
  | sed "s/tag/download/"
)/linux64.tar.gz" | tar -xzv -C "$HOME/.opt"

ln -fs "$HOME/.opt/purescript/purs" "$HOME/.local/bin/purs"

echo "purs v$(purs --version) instaliuotas!"

curl -sSLo- "$(
  curl -Ls -o /dev/null -w %{url_effective} \
  https://github.com/purescript/spago/releases/latest \
  | sed "s/tag/download/"
)/Linux.tar.gz" | tar -xzv -C "$HOME/.opt/purescript"

ln -fs "$HOME/.opt/purescript/spago" "$HOME/.local/bin/spago"

echo "spago v$(spago version) instaliuotas!"
