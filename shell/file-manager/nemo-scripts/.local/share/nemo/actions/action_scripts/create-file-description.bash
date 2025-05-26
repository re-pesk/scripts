#!/usr/bin/env bash

base_name="$(basename "$@")"

declare -A messages=(
  [en.UTF-8.selected-md]="The selected file <b><i>$base_name.md</i></b> is an .md already!"
  [lt_LT.UTF-8.selected-md]="Pasirinktas failas <b><i>$base_name.md</i></b> jau yra .md tipo!"
  [en.UTF-8.exists]="Descripion file <b><i>$base_name.md</i></b> already exists!"
  [lt_LT.UTF-8.exists]="Failas <b><i>$base_name.md</i></b> jau yra!"
)

if [[ "$@" =~ \.md$ ]]; then
  zenity --error --no-wrap --text="${messages[${LANG}.selected-md]}"
  exit 1
fi

if [[ -f "$@.md" ]]; then
  zenity --error --text="${messages[${LANG}.exists]}"
  exit 1
fi

filename="$@.md"
echo -e '# '"$base_name\n\n[$base_name" '&#x1F875;](https://www.google.com/search?q='"$base_name"'&ie=UTF-8)' > "$filename"
exit 0
