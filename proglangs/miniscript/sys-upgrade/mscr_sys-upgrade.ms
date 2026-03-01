///usr/bin/env -S miniscript "$0" "$@"; exit "$?"
// #!/usr/bin/env -S miniscript

// Klaidų ir sėkmės pranešimų medis
messages = {
  "en.UTF-8" : {
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!",
  },
  "lt_LT.UTF-8" : {
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!",
  },
}

// Išorinių komandų iškvietimo funkcija
runCmd = function (cmdArg)
  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  command = "sudo " + cmdArg

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // command.len - komandinės eilutės ilgis
  // "-" * n - kartojamas '-' simbolis
  separator = "-" * command.len

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  print(separator + char(10) + command + char(10) + separator)

  // vykdoma komanda, statusas ir išėjimo kodas išsaugomi
  result = exec(command, 300)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if result.status > 0 then
    print(result.errors)
    print(char(10) + messages[env.LANG]["err"] + char(10))
    exit(result.status)
  end if

  // Kitu atveju išvedama komandos išvestis ir sėkmės pranešimas
  if result.output.len > 0 then
    print(char(10) + result.output)
  end if
  print(char(10) + messages[env.LANG]["succ"] + char(10))
end function

print ""

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
