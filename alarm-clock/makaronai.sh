#!/usr/bin/env bash

trukme="7m"

if [ "$1" != "" ]; then
  trukme="$1"
fi

./priminiklis.sh "$trukme" "Makaronai!" &
