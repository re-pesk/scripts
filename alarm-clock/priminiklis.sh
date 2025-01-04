#!/usr/bin/env -S bash

if [[ "$@" == "" ]]; then
  text="Paleidžiant priminimą, turi būti nurodyti trukmė ir pranešimo tekstas.
  
Trukmė turi atitikti tokį formatą: 
vienas ar kelis skaitmenys, po kurių be tarpo gali būti prirašyta 

  \"s\" arba \"sek\", 
  \"m\" arba \"min\",
  \"h\" arba \"val\"

Pranešimo tekstas laisvas

Tarp trukmės ir pranešimo tkesto turi būti tarpas."
  
  echo "$text"
  zenity --info \
    --title "Programos paleidimas" \
    --width=400 \
    --height=300 \
    --text "$text"
  exit
fi

if [ "$1" = "" ]; then
  echo "Nenurodyta trukmė!"
  zenity --error --title "Klaida!" --text "Nenurodyta trukmė!"
  exit
fi

trukme="$1"
[[ "$trukme" =~ ^[0-9]+$ ]] && trukme="${1}sek"
[[ "$trukme" =~ ^[0-9]+m$ ]] && trukme="${1}in"
[[ "$trukme" =~ ^[0-9]+h$ ]] && trukme="${1//h/val}"
[[ "$trukme" =~ ^[0-9]+s$ ]] && trukme="${1}ek"

if [[  ! ( "$trukme" =~ ^[0-9]+(min|sek|val)$ ) ]]; then
# if [[  "$trukme" != +([0-9])@("min"|"sek"|"val"|) ]]; then
  echo "Klaida trukmės formate!"
  zenity --error --title "Klaida!" --text "Klaida trukmės formate: \"$trukme\"!"
  exit
fi

if [ "$2" == "" ]; then
  echo "Nenurodytas pranešimas!"
  zenity --error --title "Klaida!" --text "Nenurodytas pranešimas!"
  exit
fi

if [[ $(ps -o stat= -p $$) == *+* ]]; then
  echo Priminti po $trukme: $2
  ($0 $trukme $2 &)
  exit
fi

trukme="0"
case "$1" in
*min)
  trukme=$((${1%min} * 60)) #  minutė = 60s
  ;;
*sek)
  trukme=${1%sek}
  ;;
*val)
  trukme=$((${1%val} * 3600)) # valanda = 3600s
  ;;
*)
  trukme=$((${1%val} * 3600)) # valanda = 3600s
  echo "Klaidingas trukmės formatas!"
  zenity --error --title "Klaida!" --text "Klaidingas trukmės formatas!"
  exit
  ;;
esac

sleep $trukme # laukti nurodytą sekundžių skaičių

paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg

# Parodyti langą su antrašte ir tekstu
zenity --info --title "Priminimas" --text "$1 jau praėjo! $2"
