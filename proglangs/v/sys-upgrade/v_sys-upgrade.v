///usr/bin/env -S v run "$0" "$@"; exit $?

import os
import strings

// Klaidų ir sėkmės pranešimų medis
const messages := {
  "en.UTF-8" : {
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!",
  },
  "lt_LT.UTF-8" : {
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!",
  },
}

// Pranešimai, atitinkantys aplinkos kalbą
const lang := os.getenv("LANG")
const lang_messages := messages[lang].clone()

// Išorinių komandų iškvietimo funkcij
fn run_cmd(cmdArg string) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  command := "sudo ${cmdArg}"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // strings.repeat(`-`, n) - simbolio kartojimas, command.len - komandos simbolių skaičius 
  separator := strings.repeat(`-`, command.len)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  println("${separator}\n${command}\n${separator}\n")

  // Vykdoma komanda, išsaugo išėjimo kodą į kintamąjį
  exit_code := os.system(command)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exit_code != 0 {
    println("\n${lang_messages['err']}\n")
    exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  println("\n${lang_messages['succ']}\n")
}

println("")

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
run_cmd("apt-get update")
run_cmd("apt-get upgrade -y")
run_cmd("apt-get autoremove -y")
run_cmd("snap refresh")
