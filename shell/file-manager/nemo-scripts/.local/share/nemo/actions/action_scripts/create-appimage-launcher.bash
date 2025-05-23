#!/usr/bin/env bash

base_name="$(basename "$@")"

declare -A messages=(
  [en.UTF-8.not-an-appimage]="The selected file <b><i>$base_name</i></b> is not an AppImage!"
  [lt_LT.UTF-8.not-an-appimage]="Pasirinktas failas $base_name</i></b> nėra AppImage tipo!"
)

if [[ ! "$@" =~ \.AppImage$ ]]; then
  zenity --error --text="${messages[${LANG}.not-an-appimage]}"
  exit 1
fi

file_name="$@.sh"
echo -e "#!/usr/bin/env bash\n\n$@ --no-sandbox" > "$file_name"

chmod +x "$@"
chmod +x "$file_name"

exit 0
