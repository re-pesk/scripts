#!/usr/bin/env -S julia

# Klaidų ir sėkmės pranešimų medis
messages = Dict(
  "en.UTF-8" => Dict(
    "err" => "Error! Script execution was terminated!",
    "succ" => "Successfully finished!",
  ),
  "lt_LT.UTF-8" => Dict(
    "err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" => "Komanda sėkmingai įvykdyta!",
  ),
)

# Pranešimai, atitinkantys aplinkos kalbą
lang = ENV["LANG"]
errorMessage = messages[lang]["err"]
successMessage = messages[lang]["succ"]

import Printf: @printf

# Išorinių komandų iškvietimo funkcija
function runCmd(cmdArg)

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  command = "sudo $cmdArg"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # repeat("-", n) - kartoja '-' simbolį, length(command) - paima komandinės eilutės ilgį
  separator = repeat("-", length(command))

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  @printf("%s\n%s\n%s\n\n", separator, command, separator)

  # Paverčia komandos argumentą masyvu
  args = split(cmdArg, " ")

  # Sukuria komandos objektą
  objCmd = Cmd(`sudo $args`, ignorestatus = true)

  # Vykdoma komanda ir išaugo išėjimo kodą
  exitCode = run(objCmd).exitcode

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0
    @printf("\n%s\n\n", errorMessage)
    exit(exitCode)
  end

  # Kitu atveju išvedamas sėkmės pranešimas
  @printf("\n%s\n\n", successMessage)
end

println()

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
