///usr/bin/env io "$0" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
messages := Object clone do(
  setSlot("en.UTF-8", Object clone do(
    err := "Error! Script execution was terminated!"
    succ := "Successfully finished!"
  ))
  setSlot("lt_LT.UTF-8", Object clone do(
    err := "Klaida! Scenarijaus vykdymas sustabdytas!"
    succ := "Komanda sėkmingai įvykdyta!"
  ))
)

// Aplinkos kalbos nuostata
lang := System getEnvironmentVariable("LANG")

// Pranešimai pagal aplinkos kalbos nuostatą
errorMessage := messages getSlot(lang) err
successMessage := messages getSlot(lang) succ

// Išorinių komandų iškvietimo funkcija
runCmd := method(cmdArg, do(

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command := "sudo #{cmdArg}" interpolate

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  separator := ""
  for(a, 0, command size, 
    separator = "#{separator}-" interpolate 
  )

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  "#{separator}\n#{command}\n#{separator}\n" interpolate println

  // Įvykdoma komanda, išeities kodas išsaugomas į kintamąjį 
  exitCode := System system(command) 

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (exitCode > 0) ifTrue(
    "\n#{errorMessage asUTF8}\n" interpolate println
    System exit 99
  )

  // Kitu atveju išvedamas sėkmės pranešimas
  "\n#{successMessage asUTF8}\n" interpolate println
))

"" println

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
