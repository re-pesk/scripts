#!/usr/bin/env bash

base_name="$(basename "$@")"

declare -A messages=(
  [en.UTF-8.not-an-appimage]="The selected file <b><i>$base_name</i></b> is not an AppImage!"
  [en.UTF-8.exists]="Directory <b><i>$base_name.config</i></b> already exists!"
  [en.UTF-8.create-dir]="Create <b><i>$base_name.config</i></b> directory?"
  [lt_LT.UTF-8.not-an-appimage]="Pasirinktas failas $base_name</i></b> nėra AppImage tipo!"
  [lt_LT.UTF-8.exists]="Katalogas <b><i>$base_name.config</i></b> jau yra!"
  [lt_LT.UTF-8.create-dir]="Ar sukurti <b><i>$base_name.config</i></b> katalogą?"
)

if [[ ! "$@" =~ \.AppImage$ ]]; then
  zenity --error --text="${messages[${LANG}.not-an-appimage]}"
  exit 1
fi

dir_name="$@.config"
if [[ -d "$dir_name" ]]; then
  zenity --error --text="${messages[${LANG}.exists]}"
  exit 1
fi

if ! zenity --question --text="${messages[${LANG}.create-dir]}" --default-cancel; then
  exit 1
fi

mkdir "$dir_name"
exit 0
