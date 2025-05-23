#!/usr/bin/env bash

filepath="$@"
stat -c %a "$filepath"

if [[ -x "$filepath" ]]; then
  chmod -x "$filepath"
else 
  chmod +x "$filepath"
fi

stat -c %a "$filepath"

exit 0

