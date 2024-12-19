#!/usr/bin/env php
<?php

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

$LANG = getenv("LANG");
$errorMessage = $messages[$LANG]["err"];
$successMessage = $messages[$LANG]["succ"];

function runCmd($cmdArg) {
  global $errorMessage, $successMessage;
  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  $command = "sudo {$cmdArg}";

  // "-".repeat() - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // command.length paima komandinės eilutės ilgį
  $separator = str_repeat("-", strlen($command));

  // spausdina separatorių ir komandos eilutę
  echo "{$separator}\n{$command}\n{$separator}\n\n";

  // vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį
  $code = null;
  system($command, $code);

  // jeigu įvyko klaida,išeinama iš programos
  if ($code > 0) {
      echo "\n{$errorMessage}\n\n";
      exit(99);
  }

  // sėkmingai įvykdžius programą, apie tai pranešama
  echo "\n{$successMessage}\n\n";
};

echo "\n";

runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");
