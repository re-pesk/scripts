#! /usr/bin/env ksh

# Klaidų ir sėkmės pranešimų medis
messages=(
  [en.UTF-8]=(
    err="Error! Script execution was terminated!"
    succ="Successfully finished!"
  )
  [lt_LT.UTF-8]=(
    err="Klaida! Scenarijaus vykdymas sustabdytas!"
    succ="Komanda sėkmingai įvykdyta!"
  )
)

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
errorMessage="${messages[${LANG}].err}"
successMessage="${messages[${LANG}].succ}"

# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command="sudo $*"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  separator=${command//?/'-'}

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf "%s\n%s\n%s\n\n" "${separator}" "${command}" "${separator}"

  # Įvykdoma komanda
  sudo "$@"

  # Išsaugomas įvykdytos komandos išėjimo kodas
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas 
  if (( exitCode > 0 )); then
    printf "\n%s\n\n" "${errorMessage}"
    exit "${exitCode}"
  fi

  # Kitu atveju išvedamas sėkmės pranešimas
  printf "\n%s\n\n" "${successMessage}"
}

echo

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh
