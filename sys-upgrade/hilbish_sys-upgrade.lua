#!/usr/bin/env -S hilbish

-- Klaidų ir sėkmės pranešimų medis
local messages = {
  ["en.UTF-8"] = {
    err = "Error! Script execution was terminated!",
    succ = "Successfully finished!",
  },
  ["lt_LT.UTF-8"] = {
    err = "Klaida! Scenarijaus vykdymas sustabdytas!",
    succ = "Komanda sėkmingai įvykdyta!",
  }
}

-- Aplinkos kalbos nuostata
local lang = os.getenv("LANG")

-- Pranešimai pagal aplinkos kalbos nuostatą
errorMessage = messages[lang].err
successMessage = messages[lang].succ

-- Išorinių komandų iškvietimo funkcija
function runCmd (cmdArg)

  -- Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  local command = "sudo " .. cmdArg

  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  -- #command - komandinės eilutės ilgis
  -- string.rep("-",  n) - kartojamas '-' simbolis
  local separator = string.rep("-",  #command)

  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  print (separator .. "\n" .. command .. "\n" .. separator .. "\n") 

  -- vykdoma komanda, statusas ir išėjimo kodas išsaugomi
  local status, _, exitCode = os.execute (command)

  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (not status) and exitCode > 0 then
    print ("\n" .. errorMessage .. "\n")
    os.exit (exitCode)
  end

  -- Kitu atveju išvedamas sėkmės pranešimas
  print ("\n" .. successMessage .. "\n")
end

print ""

-- Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
