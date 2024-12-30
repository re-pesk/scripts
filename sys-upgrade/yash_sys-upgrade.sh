#! /usr/bin/env yash

# Klaidų ir sėkmės pranešimų raktai
keys=(
  'en.UTF-8.err'
  'en.UTF-8.succ'
  'lt_LT.UTF-8.err'
  'lt_LT.UTF-8.succ'
)

# PKlaidų ir sėkmės pranešimų tekstai
values=(
  'Error! Script execution was terminated!'
  'Successfully finished!'
  'Klaida! Scenarijaus vykdymas sustabdytas!'
  'Komanda sėkmingai įvykdyta!'
)

# Funkcija pranešimui iš masyvo paimti pagal raktą
getMessage() {

  index=0
  for key in $keys; do
    index=$((index + 1))
    if [[ "${key}" = "$1" ]]; then
      echo "${values[$index]}"
      return
    fi
  done
}

# Pranešimai, atitinkantys aplinkos kalbą
errorMessage="$(getMessage "${LANG}.err")"
successMessage="$(getMessage "${LANG}.succ")"

# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command="sudo $@"

  # Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  separator=${command//?/'-'}

  # Išveda komandos eilutę, apsuptą skirtuko eilučių
  printf "%s\n%s\n%s\n\n" "$separator" "$command" "$separator"

  # Įvykdo komandą
  (sudo $@)

  # Išsaugo įvykdytos komandos išėjimo kodą
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if [[ $exitCode > 0 ]]; then
    printf "\n%s\n\n" "$errorMessage"
    exit $exitCode
  fi

  # Kitu atveju išvedamas sėkmės pranešimas
  printf "\n%s\n\n" "$successMessage"
}

echo

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh
