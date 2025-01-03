#! /usr/bin/env nu

# Klaidų ir sėkmės pranešimų medis
let messages = {
  "en.UTF-8" : {
    'succ' : "Successfully finished!",
    'err' : "Error! Script execution was terminated!"
  },
  'lt_LT.UTF-8' : {
    'succ' : "Komanda sėkmingai įvykdyta!",
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!"
  },
}

# Pranešimai, atitinkantys aplinkos kalbą
let lang = $env.LANG
let errorMessage = $messages | get $lang | get "err"
let successMessage = $messages | get $lang | get "succ"

# Išorinių komandų iškvietimo funkcija 
def runCmd [...cmdArgs] {

  # Sukuria komandos tekstinę eilutę iš funkcijos argumentų
  let command = ["sudo" ...$cmdArgs] | str join " "

  # pakeičia visas eilutės raides "-" simboliu
  let separator = $command 
    | str replace --all --regex "." "-"

  # Išveda komandos eilutę, apsuptą skirtuko eilučių
  print $separator $command $separator ""

  # Įvykdo komandą
  run-external "sudo" ...$cmdArgs

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if $env.LAST_EXIT_CODE > 0 {
      print "" $errorMessage ""
      exit
  }

  # Kitu atveju išvedamas sėkmės pranešimas
  print "" $successMessage ""
}

print ""

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade "-y"
runCmd apt-get autoremove "-y"
runCmd snap refresh
