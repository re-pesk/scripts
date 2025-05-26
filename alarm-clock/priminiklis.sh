#!/usr/bin/env -S bash

declare -A messages=(
  [en.UTF-8.infoTitle]="Starting reminder"
  [en.UTF-8.error]="Error!"
  [en.UTF-8.errorDurationNotExists]="Duration is absent!"
  [en.UTF-8.errorDurationFormat]="Wrong duration format!"
  [en.UTF-8.errorMessageIsAbsent]="No message specified!"
  [en.UTF-8.startInfo]="Remind after"
  [en.UTF-8.finalInfoTitle]="Reminder"
  [en.UTF-8.finalInfo]="has already expired!"
  [en.UTF-8.h]="hrs"
  [en.UTF-8.m]="min"
  [en.UTF-8.s]="sec"
  [lt_LT.UTF-8.infoTitle]="Programos paleidimas"
  [lt_LT.UTF-8.error]="Klaida!"
  [lt_LT.UTF-8.errorDurationNotExists]="Nenurodyta trukmė!"
  [lt_LT.UTF-8.errorDurationFormat]="Klaidingas trukmės formatas!"
  [lt_LT.UTF-8.errorMessageIsAbsent]="Nenurodytas pranešimas!"
  [lt_LT.UTF-8.startInfo]="Priminti po"
  [lt_LT.UTF-8.finalInfoTitle]="Priminimas"
  [lt_LT.UTF-8.finalInfo]="jau praėjo!"
  [lt_LT.UTF-8.h]="val"
  [lt_LT.UTF-8.m]="min"
  [lt_LT.UTF-8.s]="sek"
) 

messages["en.UTF-8.info"]="When a reminder is starting, the duration and the text of the message must be specified. \
There must be a space between the duration and the message text.
  
The duration shall follow the following format: 
one or more digits, which may be followed by the following without a space 

  \"h\" or \"${messages[en.UTF-8.h]}\",
  \"m\" or \"${messages[en.UTF-8.m]}\",
  \"s\" or \"${messages[en.UTF-8.s]}\", 

Message text is in free form, it is not to be surrounded by quotes.

Usage:

>  priminiklis.sh 1m \"Pranešimo tekstas\"

>  priminiklis.sh 1m Pranešimo tekstas"

messages["lt_LT.UTF-8.info"]="Paleidžiant priminimą, turi būti nurodyti trukmė ir pranešimo tekstas. \
Tarp trukmės ir pranešimo teksto turi būti tarpas.
  
Trukmė turi atitikti tokį formatą: 
vienas ar keli skaitmenys, po kurių be tarpo gali būti prirašyta 

  \"h\" arba \"${messages[lt_LT.UTF-8.h]}\",
  \"m\" arba \"${messages[lt_LT.UTF-8.m]}\",
  \"s\" arba \"${messages[lt_LT.UTF-8.s]}\", 

Pranešimo tekstas laisvas, jis neturi būti įrėmintas kabutėmis.

Naudojimas:

>  priminiklis.sh 1m \"Pranešimo tekstas\"

>  priminiklis.sh 1m Pranešimo tekstas"

if [[ "$@" == "" ]]; then
  text="${messages[$LANG.info]}"
  
  echo "$text"
  zenity --info \
    --title "${messages[$LANG.infoTitle]}" \
    --width=400 \
    --height=300 \
    --text "$text"
  exit
fi

if [ "$1" = "" ]; then
  echo "${messages[$LANG.errorDurationNotExists]}"
  zenity --error \
    --width=400 \
    --height=300 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorDurationNotExists]}"
  exit
fi

trukme="$1"
[[ "$trukme" =~ ^[0-9]+$ ]] && trukme="${1}s"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.m]}$ ]] && trukme="${1%in}"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.s]}$ ]] && trukme="${1%ek}"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.h]}$ ]] && trukme="${1//val/h}"

if [[ ! ( "$trukme" =~ ^[0-9]+(h|m|s)$ ) ]]; then
  echo "${messages[$LANG.errorDurationFormat]}"
  zenity \
    --error \
    --width=400 \
    --height=300 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorDurationFormat]}: \"$trukme\"!"
  exit
fi

text="${@:2}"

if [ "$text" == "" ]; then
  echo "${messages[$LANG.errorMessageIsAbsent]}"
  zenity \
    --error \
    --width=400 \
    --height=300 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorMessageIsAbsent]}"
  exit
fi

if [[ $(ps -o stat= -p $$) == *+* ]]; then
  echo "${messages[$LANG.startInfo]} $trukme: $text"
  ($0 "$trukme" "$text" &)
  exit
fi

secs="0"
case "$trukme" in
*h)
  secs=$((${1%h} * 3600)) # valanda = 3600s
  ;;
*m)
  secs=$((${1%m} * 60)) #  minutė = 60s
  ;;
*s)
  secs=${1%s}
  ;;
*)
  echo "${messages[$LANG.errorDurationFormat]}"
  zenity \
    --error \
    --width=400 \
    --height=300 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorDurationFormat]}: $trukme"
  exit
  ;;
esac

sleep $secs # laukti nurodytą sekundžių skaičių

paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg

# Parodyti langą su antrašte ir tekstu
zenity \
  --info \
  --width=400 \
  --height=300 \
  --title "${messages[$LANG.finalInfoTitle]}" \
  --text "${trukme} ${messages[$LANG.finalInfo]} $text"
