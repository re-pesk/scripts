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

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # Visi komandos eilutės simboliai pakeičiami "-" simboliu
  let separator = $command | str replace --all --regex "." "-"

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  print $separator $command $separator ""

  # Vykdoma komanda. Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  try { run-external "sudo" ...$cmdArgs } catch { 
    print "" $errorMessage ""
    exit 1
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
