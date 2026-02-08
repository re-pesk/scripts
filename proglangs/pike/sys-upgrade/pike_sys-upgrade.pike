///usr/bin/env -S pike "$0" "$@"; exit "$?"

// Klaidų ir sėkmės pranešimų medis
mapping messages = ([ 
  "en.UTF-8":([
    "err" : "Error! Script execution was terminated!",
    "succ" : "Successfully finished!"
  ]),
  "lt_LT.UTF-8":([
    "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" : "Komanda sėkmingai įvykdyta!"
  ]) 
]);

// Išrenkami pranešimai, atitinkantys aplinkos kalbą
string LANG = getenv("LANG");
string errorMessage = messages[LANG]["err"];
string successMessage = messages[LANG]["succ"];

// Išorinių komandų iškvietimo funkcija
void runCmd(string cmdArg) {
  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  string command = sprintf("sudo %s", cmdArg);

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * n => generuoja n ilgio separatorių iš '-' simbolių
  // sizeoff(command) => paima komandinės eilutės ilgį
  string separator = "-" * sizeof(command); 

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  write("%s\n%s\n%s\n\n", separator, command, separator);

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį
  int exitCode = Process.system(command);

// Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    write("\n%s\n\n", errorMessage);
    exit(99);
  }

// Kitu atveju išvedamas sėkmės pranešimas
  write("\n%s\n\n", successMessage);
};

int main() {
  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");
  return 0;
}

