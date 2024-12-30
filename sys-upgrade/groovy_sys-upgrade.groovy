#!/usr/bin/env groovy

// Klaidų ir sėkmės pranešimų medis
def messages = [
  'en.UTF-8' : [
    'succ' : "Successfully finished!",
    'err' : "Error! Script execution was terminated!"
  ],
  'lt_LT.UTF-8' : [
    'succ' : "Komanda sėkmingai įvykdyta!",
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!"
  ],
]

// Aplinkos kintamasis su aplinkos kalbos nuostata
def lang = System.getenv('LANG')

// Globalūs kintamieji su ranešimais, atitinkančiais aplinkos kalbą, 
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
  // Sulaukiama, kol procesas baigs išvedimą į kviečiančio proceso išvedimo srautus.  
  // Komandos išėjimo kodas išsaugomas į kintamąjį 
  Process proc = command.execute()
  proc.waitForProcessOutput(System.out, System.err)
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
