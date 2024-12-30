module sys_upgrade;

import core.stdc.stdlib;
import std.array;
import std.process;
import std.stdio;

// Pagrindinė funkcija - programos įeigos taškas
void main()
{

  // Klaidų ir sėkmės pranešimų medis
  const auto messages = [
    "en.UTF-8": [
      "err": "Error! Script execution was terminated!",
      "succ": "Successfully finished!"
    ],
    "lt_LT.UTF-8": [
      "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ": "Komanda sėkmingai įvykdyta!"
    ]
  ];

  // Aplinkos kalbos nustatymas
  const auto lang = environment.get("LANG");

  // Pranešimai, atitinkantys aplinkos kalbą
  const auto errorMessage = messages[lang]["err"];
  const auto successMessage = messages[lang]["succ"];

  // Išorinių komandų iškvietimo funkcija
  void runCmd(string cmdStr)
  {
    // Sukuria komandos tekstinę eilutę iš funkcijos argumento
    const auto command = "sudo " ~ cmdStr;

    // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
    // replicate("-", ...) - simbolio kartojimas, command.length - komandos ilgis
    const auto separator = replicate("-", command.length);

    // Išveda komandos eilutę, apsuptą skirtuko eilučių
    writefln("%s\n%s\n%s\n", separator, command, separator);

    // Vykdo komandą
    auto pipesPid = spawnShell(command);

    // Lauikia proceso pabaigos, išsaugo įvykdytos komandos išėjimo kodą
    const auto exitCode = wait(pipesPid);

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
    if (exitCode != 0)
    {
      writefln("\n%s\n", errorMessage);
      exit(99);
    }

    // Kitu atveju išvedamas sėkmės pranešimas
    writefln("\n%s\n", successMessage);
  }

  writeln();

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");

}
