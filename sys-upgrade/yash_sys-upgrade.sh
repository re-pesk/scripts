#! /usr/bin/env yash

# Klaidų ir sėkmės pranešimų medis
messages="en.UTF-8.err:Error! Script execution was terminated!
en.UTF-8.succ:Successfully finished!
lt_LT.UTF-8.err:Klaida! Scenarijaus vykdymas sustabdytas!
lt_LT.UTF-8.succ:Komanda sėkmingai įvykdyta!"

# Funkcija pranešimui iš masyvo paimti pagal raktą
getMessage() {
  echo "$messages" | while read item; do
    case $item in
    ("$1:"*) 
      echo "${item#$1:}"
      return
      ;;
    esac
  done
}

# Pranešimai, atitinkantys aplinkos kalbą
errorMessage="$(getMessage "${LANG}.err")"
successMessage="$(getMessage "${LANG}.succ")"

# Išorinių komandų iškvietimo funkcija
runCmd() {

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  command="sudo $@"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  separator=${command//?/'-'}

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf "%s\n%s\n%s\n\n" "$separator" "$command" "$separator"

  # Vykdoma komanda
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
