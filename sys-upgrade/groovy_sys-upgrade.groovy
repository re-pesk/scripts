#!/usr/bin/env groovy

// Klaidų ir sėkmės pranešimų medis
def messages = [
  'en.UTF-8' : [
    'err' : "Error! Script execution was terminated!",
    'succ' : "Successfully finished!"
  ],
  'lt_LT.UTF-8' : [
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' : "Komanda sėkmingai įvykdyta!"
  ],
]

// Aplinkos kintamasis su aplinkos kalbos nuostata
def lang = System.getenv('LANG')

// Globalūs kintamieji su pranešimais, atitinkančiais aplinkos kalbą, 
errorMessage = messages[lang]['err']
successMessage = messages[lang]['succ']

// Išorinių komandų iškvietimo funkcija
def runCmd(String cmdArg) {
  // Komanda iš funkcijos argumento
  def command = "sudo $cmdArg"

  // Komandos ilgio skirtukas iš "-" simbolių
  // '-'* - kartoja '-' simbolį
  // command.length() - komandos ilgis
  def separator = '-'*command.length()
  
  // Komanda išvedama, apsupta skirtuko eilučių
  println "${separator}\n${command}\n${separator}\n"

  // Įvykdoma komanda, procesas išsaugomas į kintamąjį
  Process proc = command.execute()

  // Sulaukiama, kol procesas baigs išvedimą į kviečiančio proceso išvedimo srautus.  
  proc.waitForProcessOutput(System.out, System.err)

  // Komandos išėjimo kodas išsaugomas į kintamąjį 
  def exitCode = proc.exitValue()

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    println "\n${errorMessage}\n"
    System.exit(99)
  }
  
  // Kitu atveju išvedamas sėkmės pranešimas
  println "\n${successMessage}\n"
}

println ""

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
