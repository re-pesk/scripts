///usr/bin/env -S bal run "$0" "$@"; exit $?

import ballerina/io;
import ballerina/os;

// Klaidų ir sėkmės pranešimų medis
map<map<string>> messages = {
  "en.UTF-8" : {
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!"
  },
  "lt_LT.UTF-8" : {
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!"
  }
};

// Aplinkos kalbos nuostata
string lang = os:getEnv("LANG");

// Pranešimai pagal aplinkos kalbos nuostatą
string? errorMessage = messages[lang]["err"];
string? successMessage = messages[lang]["succ"];

// Išorinių komandų iškvietimo funkcija
function runCmd(string cmdArg) returns int {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  string command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // command.length() - paimamas komandinės eilutės ilgis
  // string:padStart - pildo eilutę "" iki komandinės eilutės ilgio '-' simboliais
  string separator = string:padStart("", command.length(), "-");

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  io:println(separator, "\n", command, "\n", separator);

  // Įvykdoma komanda, sukuriamas procesas ir išsaugomas į kintamąjį
  os:Process|os:Error process = os:exec({
    value: "sudo", 
    arguments: re ` `.split(cmdArg)
  });

  // Jeigu procesas yra klaidos tipo (proceso sukūrimas nepavyko), 
  // išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if process is os:Error {
    io:println(process.message());
    // Gražinamas išėjimo kodas 1 (klaida)
    return 1;
  }

  // Sulaukiama, kol procesas pasibaigs, išėjimo kodas išasugomas kintamajame
  int|os:Error exitCode = process.waitForExit();
  
  // Jeigu išėjimo kodas yra klaidos tipo (proceso vykdymas nepavyko),
  // išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode is error {
    io:println(exitCode.message());
    io:println("\n", errorMessage);
    // Gražinamas išėjimo kodas 1 (klaida)
    return 1;
  }

  // Klaidų ir pranešimų srautų turinys išsaugomas kintamuosiuose
  byte[]|os:Error err = process.output(io:stderr);
  byte[]|os:Error out = process.output(io:stdout);

  // Jeigu klaidų srautas yra netuščias bytų masyvas, išvedamas pranešimas
  if err is byte[] && err.length() > 0 {
    io:println("\n", string:fromBytes(err));
  }

  // Jeigu pranešimų srautas yra netuščias bytų masyvas, išvedamas pranešimas
  if out is byte[] && out.length() > 0 {
    io:println("\n", string:fromBytes(out));  
  }

  // Jeigu išėjimo kodas nelygus 0 (komanda užsibaigė klaida),
  // išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    io:println(errorMessage, "\n");
    // Gražinamas išėjimo kodas 1 (klaida)
    return exitCode;
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  io:println(successMessage, "\n");

  // Gražinamas išėjimo kodas 0 (sėkmė)
  return 0;
}

public function main() {
  io:println();

  // Komandų iškvietimo eilučių masyvas
  string[] commandArr = [
    "apt-get update",
    "apt-get upgrade -y",
    "apt-get autoremove -y",
    "snap refresh"
  ];

  foreach string command in commandArr {
    // Komandos vykdymo funkcijos iškvietimas su vykdomos komandos duomenimis
    int exitCode = runCmd(command);

    // Jeigu vykdant komandą įvyko klaida, programos vykdymas nutraukiamas
    if exitCode > 0 {
      return;
    }
  }
}
