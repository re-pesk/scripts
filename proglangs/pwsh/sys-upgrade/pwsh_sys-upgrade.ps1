#! /usr/bin/env -S pwsh

# Klaidų ir sėkmės pranešimų medis
$messages = @{
  "en.UTF-8" = @{
    "err" = "Error! Script execution was terminated!"
    "succ" = "Successfully finished!"
  }
  "lt_LT.UTF-8" = @{
    "err" = "Klaida! Scenarijaus vykdymas sustabdytas!"
    "succ" = "Komanda sėkmingai įvykdyta!"
  }
}

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
$errorMessage = $messages["lt_LT.UTF-8"]["err"]
$successMessage = $messages["lt_LT.UTF-8"]["succ"]

# Išorinių komandų iškvietimo funkcija
function runCmd {
  param(
    [string]$cmdArg
  )

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  $command = "sudo $cmdArg"

  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # "-" * - simbolio kartojimas
  # $command.length - komandos eilutės ilgis
  $separator = $("-" * $command.length)

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  Write-Host "$separator`n$command`n$separator`n"

  # Įvykdoma komanda
  &"sudo" $cmdArg.Split(" ")

  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas 
  if ($LASTEXITCODE -ne 0) {
    Write-Host "`n$errorMessage`n"
    Exit 99
  }
  
  # Kitu atveju išvedamas sėkmės pranešimas
  Write-Host "`n$successMessage`n"
}

Write-Host

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd "snap refresh"
