#!/usr/bin/env bash

filepath="$@"
dir="$(dirname -- "$filepath")"
file=$(basename -- "$filepath")
# zenity --info --text="$(tr ' ' '_' <<< "$dir/$file")"
echo "$dir/$file" | tr ' ' '_' | xargs -I '{}' mv "$filepath" {} "
exit 0

