#! /usr/bin/env -S ruby

# Klaidų ir sėkmės pranešimų medis
messages = {
  :"en.UTF-8" => {
    :"err" => "Error! Script execution was terminated!",
    :"succ" => "Successfully finished!",
  },
  :"lt_LT.UTF-8" => {
    :"err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    :"succ" => "Komanda sėkmingai įvykdyta!",
  },
}

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
errorMessage="${messages[$LANG.err]}"
lang = ENV['LANG']
@errorMessage = messages[:"#{lang}"][:err]
@successMessage = messages[:"#{lang}"][:succ]

# Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg)

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo #{cmdArg}"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # '-' * simbolio kartojimas
  # comand.lengh - komandos eilutės ilgis
  separator = '-' * command.length

   # Išvedama komandos eilutė, apsupta skirtuko eilučių
  puts separator, command, separator, ""

  # Įvykdoma komanda, statusas išsaugomas į kintamąjį
  status = system( command )
  
  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas 
  if !status
    puts "", @errorMessage, ""
    exit(99)
  end

  # Kitu atveju išvedamas sėkmės pranešimas
  puts "", @successMessage, ""
end

puts

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
