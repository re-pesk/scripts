#! /usr/bin/env -S bash

options="-2"
input=($(printf '%s\n' "$@" | sort))
case "$1" in
  (-i)
    options="-12"
    input=($(printf '%s\n' "${@:2}" | sort))
    ;;
  (-n)
    options="-3"
    input=($(printf '%s\n' "${@:2}" | sort))
    ;;
  (-*)
    if [[ ! "$1" =~ ^--help|-h ]]; then
      echo Error! The first arg is wrong! It must be --help, -h, -i, -n or name of package 
    fi
    echo "When the first arg is
    --help or -h             - show this message,
    -i                       - show only installed packages,
    -n                       - show only not installed packages,
    name                     - show both installed and not installed packages."
    exit 1
    ;;
esac

regex="($(printf '%s|' $(
  dpkg --status ${input[@]} 2> /dev/null \
  | grep -P '^Package' \
  | sed 's/Package: //') | sed 's/|$//'))"

echo "$regex"

inputNl="$(printf '%s\n' "${input[@]}")"

installed="$(grep -w -P "$regex" <<< $inputNl)"
notinstalled="$(grep -vw -P "$regex" <<< $inputNl)"

readarray -t istalledStr <<< "$installed"
readarray -t notistalledStr <<< "$notinstalled"

[[ "$1" == -i ]] && echo "${istalledStr[@]}" && exit
[[ "$1" == -n ]] && echo "${notistalledStr[@]}" && exit

echo "installed: ${istalledStr[@]}; notinstalled: ${notistalledStr[@]};"
