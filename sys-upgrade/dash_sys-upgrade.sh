#! /usr/bin/env dash

# Klaidų ir sėkmės pranešimų masyvas - kiekvienas pranešimas naujoje eilutėje
messages="en.UTF-8.err:Error! Script execution was terminated!
en.UTF-8.succ:Successfully finished!
lt_LT.UTF-8.err:Klaida! Scenarijaus vykdymas sustabdytas!
lt_LT.UTF-8.succ:Komanda sėkmingai įvykdyta!"

# Funkcija pranešimui iš masyvo paimti pagal raktą
getMessage() {
  echo "$messages" | while read item; do
    case $item in
    "$1:"*) 
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

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command="sudo $@"

  # Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  # printf "%ns", kur n - tai tarpų skaičius, o ${#command} - komandos eilutės ilgis, generuoja komandos ilgio tarpo simbolių eilutę
  # tr " " "-" tarpus pakeičia brūkšniais
  separator=$(printf "%${#command}s" | tr " " "-")

  # Išveda komandos eilutę, apsuptą skirtuko eilučių
  printf "%s\n%s\n%s\n\n" "$separator" "$command" "$separator"

  # Įvykdo komandą
  (sudo $@)

  # Išsaugo įvykdytos komandos išėjimo kodą
  exitCode="$?"

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
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