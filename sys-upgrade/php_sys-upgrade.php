#!/usr/bin/env php
<?php

// Klaidų ir sėkmės pranešimų medis
$messages = [
  'en.UTF-8' => [
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!"
  ],
  'lt_LT.UTF-8' => [
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!"
  ],
];

// Pranešimai, atitinkantys aplinkos kalbą
$LANG = getenv("LANG");
$errorMessage = $messages[$LANG]["err"];
$successMessage = $messages[$LANG]["succ"];

// Išorinių komandų iškvietimo funkcija
function runCmd($cmdArg) {
  global $errorMessage, $successMessage;

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  $command = "sudo {$cmdArg}";

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // str_repeat("-", n) - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // strlen($command) - paima komandinės eilutės ilgį
  $separator = str_repeat("-", strlen($command));

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  echo "{$separator}\n{$command}\n{$separator}\n\n";

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  $exitCode = null;
  system($command, $exitCode);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if ($exitCode > 0) {
      echo "\n{$errorMessage}\n\n";
      exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  echo "\n{$successMessage}\n\n";
};

echo "\n";

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");
