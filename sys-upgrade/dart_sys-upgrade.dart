#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

// Klaidų ir sėkmės pranešimų medis
const messages = {
  'en.UTF-8': {
    'err': "Error! Script execution was terminated!",
    'succ': "Successfully finished!",
  },
  'lt_LT.UTF-8': {
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ': "Komanda sėkmingai įvykdyta!",
  },
};

// Aplinkos kintamasis, nurodantis kalbą
Map<String, String> env = Platform.environment;
var lang = env["LANG"];

// Klaidų ir sėkmės pranešimų tekstai pagal pasirinktą kalbą
var errorMessage = messages[lang]!['err'];
var successMessage = messages[lang]!['succ'];

// Išorinių komandų iškvietimo funkcija
runCmd(String cmdArg) async {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  var command = "sudo $cmdArg";
  
  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * - simbolio kartojimas, command.length - komandos simbolių skaičius
  var separator = "-" * command.length;

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  print("$separator\n$command\n$separator\n");

  // Įvykdoma komandą, išvedimo srautai nukreipiami į pagrindinį procesą
  var process = await Process.start("sudo", cmdArg.split(' '));
  process.stdout
    .transform(utf8.decoder)
    .forEach(stdout.write);
  process.stderr
    .transform(utf8.decoder)
    .forEach(stderr.write);

  // išėjimo kodas išsaugomas į kintamąjį 
  var exitCode = await process.exitCode;

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if (exitCode > 0) {
    print("\n${errorMessage}\n");
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  print("\n${successMessage}\n");
}

// Pagrindinė funkcija - programos įeigos taškas
void main() async {

  print("");

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  await runCmd("apt-get update");
  await runCmd("apt-get upgrade -y");
  await runCmd("apt-get autoremove -y");
  await runCmd("snap refresh");
}
