///usr/bin/env java --source 21 --enable-preview "$0" "$@"; exit $?

import java.util.Map;

// Privaloma klasė vienišuose skritpuose
class Main {

  // Klaidų ir sėkmės pranešimų medis
  Map<String, Map<String, String>> messages = Map.of(
      "en.UTF-8",
      Map.of(
          "err", "Error! Script execution was terminated!",
          "succ", "Successfully finished!"),

      "lt_LT.UTF-8",
      Map.of("err", "Klaida! Scenarijaus vykdymas sustabdytas!",
          "succ", "Komanda sėkmingai įvykdyta!"));

  // Pranešimai pagal aplinkos kalbos nuostatą
  String lang = System.getenv("LANG");
  String errorMessage = messages.get(lang).get("err");
  String successMessage = messages.get(lang).get("succ");

  // Išorinių komandų iškvietimo funkcija
  void runCmd(String cmdArg) {

    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    String command = String.join(" ", "sudo", cmdArg);

    // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    String separator = "-".repeat(command.length());
  
    // Išvedama komandos eilutė, apsupta skirtuko eilučių
    System.out.print(String.join("\n", separator, command, separator, "\n"));

    // Sukuriamas procesas ir išsaugomas į kintamąjį
    ProcessBuilder processBuilder = new ProcessBuilder(command.split(" "));
    
    // Išvedimas mukreipiamas į esamą procesą
    processBuilder.inheritIO();
    int exitCode = 0;

    // Įvykdoma komanda, išėjimo kodas išasugomas kintamajame 
    try {
      exitCode = processBuilder.start().waitFor();
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if (exitCode != 0) {
      System.out.println(String.join(errorMessage, "\n", "\n"));
      System.exit(99);
    }

    // Kitu atveju išvedamas sėkmės pranešimas
    System.out.println(String.join(successMessage, "\n", "\n"));
  }

  // Pagrindinis klasės metodas - programos įeigos taškas
  void main(String[] args) {
    System.out.println();

    // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
    this.runCmd("apt-get update");
    this.runCmd("apt-get upgrade -y");
    this.runCmd("apt-get autoremove -y");
    this.runCmd("snap refresh");
  }

}
