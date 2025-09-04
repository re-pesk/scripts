#!/bin/sh

ansi_getShellName() {
  echo "$(basename "$(ps -hp "$$" | { read _ _ _ _ cmd _; echo "$cmd"; })" )"
}

ansi_getShellName

if [ "$1" > 0 ]; then
  exit 0
fi

dash "$0" 1
yash "$0" 1
bash "$0" 1
ksh "$0" 1
zsh "$0" 1
osh "$0" 1
