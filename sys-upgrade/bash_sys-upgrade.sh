#! /usr/bin/env bash

# Klaidų ir sėkmės pranešimų medis - asociatyvusis masyvas
declare -A messages=(
  [en.UTF-8.err]="Error! Script execution was terminated!"
  [en.UTF-8.succ]="Successfully finished!"
  [lt_LT.UTF-8.err]="Klaida! Scenarijaus vykdymas sustabdytas!"
  [lt_LT.UTF-8.succ]="Komanda sėkmingai įvykdyta!"
)

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
errorMessage="${messages[$LANG.err]}"
successMessage="${messages[$LANG.succ]}"

# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command="sudo $@"

  # Generuoja skirtuką, visus komandos simbolius pakeisdamas "-" simboliu
  separator=${command//?/'-'}

  # Išveda komandos eilutę, apsuptą skirtuko eilučių
  printf "%s\n%s\n%s\n\n" "$separator" "$command" "$separator"

  # Įvykdo komandą
  (sudo $@)

  # Išsaugo įvykdytos komandos išėjimo kodą
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas 
  if [ $exitCode -gt 0 ]; then
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
