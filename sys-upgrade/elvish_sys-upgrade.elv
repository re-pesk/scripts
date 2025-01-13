#! /usr/bin/env elvish

# Klaidų ir sėkmės pranešimų medis
var messages = [
  &en.UTF-8= [
    &succ= "Successfully finished!"
    &err= "Error! Script execution was terminated!"
  ]
  &lt_LT.UTF-8= [
    &succ= "Komanda sėkmingai įvykdyta!"
    &err= "Klaida! Scenarijaus vykdymas sustabdytas!"
  ]
]

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
var lang = (get-env LANG)
var errorMessage = $messages[$lang][err]
var successMessage = $messages[$lang][succ]

use str

# Išorinių komandų iškvietimo funkcija
var runCmd = {| @cmdArgs |
  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  var command = "sudo "(str:join ' ' $cmdArgs)

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # (count $command) grąžina eilutės ilgį
  # str:repeat  - generuoja seką iš "-" simbolių
  var separator = (str:repeat "-" (count $command) )
  
  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  echo $separator"\n"$command"\n"$separator"\n"
  
  # Vykdoma komanda
  try {
    sudo $@cmdArgs
  } catch err {
      # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
      # echo $err[reason][exit-status] - spausdina klaidos priežastį
      echo "\n"$errorMessage"\n"
      exit 99
  }
  
  # Kitu atveju išvedamas sėkmės pranešimas
  echo "\n"$successMessage"\n"
}

echo

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
$runCmd apt-get update
$runCmd apt-get upgrade -y
$runCmd apt-get autoremove -y
$runCmd snap refresh
