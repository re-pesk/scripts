#!/usr/bin/env -S eui
include std/map.e
include std/os.e

-- Klaidų ir sėkmės pranešimų medis
map messages = new_from_kvpairs({
    {"en.UTF-8", new_from_kvpairs({
      {"err", "Error! Script execution was terminated!"},
      {"succ", "Successfully finished!"}
    })},
    {"lt_LT.UTF-8", new_from_kvpairs({
      {"err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
      {"succ", "Komanda sėkmingai įvykdyta!"}
    })}
})

-- Aplinkos kalbos nuostata
sequence lang = getenv("LANG")

-- Pranešimai pagal aplinkos kalbos nuostatą
sequence errorMessage = nested_get(messages, {lang, "err"})
sequence successMessage = nested_get(messages, {lang, "succ"})

-- Išorinių komandų iškvietimo funkcija
procedure runCmd(sequence cmdArg)

  -- Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  sequence command = sprintf("sudo %s", { cmdArg })

  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  -- repeat('-', n) - pakartoja n '-' simbolių
  -- length(command) - komandinės eilutės ilgis
  sequence separator = repeat('-', length(command))

  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  printf(1, "%s\n%s\n%s\n\n", { separator, command, separator })

  -- Įvykdoma komanda, išėjimo kodas išsaugomas į kintamąjį 
  integer exit_code = system_exec(command)

  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exit_code > 0 then
    printf(1, "\n%s\n\n", { errorMessage} )
    abort(exit_code)
  end if

  -- Kitu atveju išvedamas sėkmės pranešimas
  printf(1, "\n%s\n\n", { successMessage })
end procedure

puts(1, "\n")

-- Komandų vykdymo funkcijos iškvietimai su vykdytinų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
