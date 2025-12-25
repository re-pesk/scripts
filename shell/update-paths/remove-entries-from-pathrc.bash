#!/usr/bin/env bash

# Remove entry from ~/.parthrc

if [ -f "${HOME}/.pathrc" ]; then
  sed -i "/#begin include .pathrc/,/#end include .pathrc/c\\" "${HOME}/.pathrc"
  [[ "$( tail -n 1 "${HOME}/.pathrc" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/.pathrc"
fi
