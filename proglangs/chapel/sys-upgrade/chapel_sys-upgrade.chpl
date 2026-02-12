///usr/bin/env -S rm -f "./${0%.*}.bin"; chpl --output="${0%.*}.bin" "$0"; [[ $? == 0 ]] && "./${0%.*}.bin" "$@"; exit $?

use CTypes;
use OS.POSIX;
use Subprocess;

// Klaidų ir sėkmės pranešimų medis
var messages = [
  "en.UTF-8" => [
    "err" => "Error! Script execution was terminated!",
    "succ" => "Successfully finished!"
  ],
  "lt_LT.UTF-8" => [
    "err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" => "Komanda sėkmingai įvykdyta!"
  ]
];

// Aplinkos kalbos nuostata
const lang = string.createBorrowingBuffer(getenv("LANG"));

// Pranešimai pagal aplinkos kalbos nuostatą
const errorMessage = messages[lang]["err"];
const successMessage = messages[lang]["succ"];

// Išorinių komandų iškvietimo funkcija
proc runCmd(cmdArg: string) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  const command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * - kartoja '-' simbolį
  // command.size - paimamas komandinės eilutės ilgis
  const separator = "-" * command.size;

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  writef("%s\n%s\n%s\n\n", separator, command, separator);

  // Įvykdoma komanda, sulaukiama kol pasibaigs 
  var sub = spawnshell(command);
  sub.wait();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if !sub.running && sub.exitCode != 0 {
    writef("\n%s\n\n", errorMessage);
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  writef("\n%s\n\n", successMessage);
}

writeln();

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");
