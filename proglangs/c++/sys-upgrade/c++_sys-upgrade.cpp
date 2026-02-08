///usr/bin/env -S g++ -Wno-sizeof-array-argument -std=c++2b -o "${0%.*}.bin" "$0"; "./${0%.*}.bin" "$@"; exit $?
#include <format> 
#include <iostream>
#include <map>

using namespace std;

map<string, string> messages = {
  {"en.UTF-8.err", "Error! Script execution was terminated!"},
  {"en.UTF-8.succ", "Successfully finished!"},
  {"lt_LT.UTF-8.err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
  {"lt_LT.UTF-8.succ", "Komanda sėkmingai įvykdyta!"}
};

// Paimama aplinkos kalbos nuostata
string lang = getenv("LANG");

// Parenkami pranešimai pagal aplinkos kalbos nuostatą
string errorMessage = ::messages[lang + ".err"];
string successMessage = ::messages[lang + ".succ"];

// Išorinių komandų iškvietimo funkcija
void runCmd(string cmdArg) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  string command = "sudo " + cmdArg;

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // string(n, char) - pakartoja simbolį '-' n kartų
  string separator = string(command.length(), '-'); 

  cout << format("{}\n{}\n{}\n\n", separator, command, separator); 

  // Įvykdoma komanda, iėjimo kodas išsaugomas į kintamąjį 
  int exitCode = system(command.c_str());

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0 ) {
    cout << format("\n{}\n\n", ::errorMessage);
    exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  cout << format("\n{}\n\n", ::successMessage);
}

// Pagrindinė funkcija - programos įeigos taškas
int main() {

  puts("");

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");
  
  return 0;
}
