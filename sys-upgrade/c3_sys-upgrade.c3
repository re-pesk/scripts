import std::collections::elastic_array;
import std::collections::map;

def LangMessages = HashMap(<String, String>); // Atskiros kalbos pranešimų tipas
def Messages = HashMap(<String, LangMessages>); // Bendras pranešimų medis
def Separator = ElasticArray(<char, 255>); // Dinaminis masyvas, naudojamas separatoriui paruošti

// Separatoriaus užpildymo metodas
fn void Separator.fill(&self, char x, String* str) @dynamic {
  for (int i = 0; i < str.len; i++) {
    self.push(x);
  }
}

// Separatoriaus konvertavimo į tekstinę eilutę metodas
fn String Separator.toString(&self) @dynamic {
  return (String)(self.entries[0:self.size]);
}

import libc;
import std::core::string;
import std::io;

// Išorinių komandų iškvietimo funkcija
fn void runCmd(String cmdArg, LangMessages langMessages) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  String command = string::join_new({"sudo", cmdArg}, " ");

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  Separator sepArray = {};
  sepArray.fill('-', &command);
  String separator = sepArray.toString();

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  io::printfn("%s\n%s\n%s\n", separator, command, separator);

  // Komanda paverčiama į C eilutę
  ZString zCommand = (ZString)command;

  // Vykdoma komanda, komandos išėjimo kodas išsaugomas į kintamąjį 
  CInt exitCode = (uint)libc::system(zCommand);


  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  if (exitCode != 0) {
    io::printfn("\n%s\n", langMessages["err"] ?? "");
    libc::exit(99);
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  io::printfn("\n%s\n", langMessages["succ"] ?? "");
}

import std::os::env;

// Pagrindinė funkcija - programos įeigos taškas
fn void main() {

  // Kalbos pranešimų medis
  Messages messages = *Messages{}.new_init_with_key_values(
    "en.UTF-8", *LangMessages{}.new_init_with_key_values(
      "err", "Error! Script execution was terminated!",
      "succ" , "Successfully finished!",
    ),
    "lt_LT.UTF-8", *LangMessages{}.new_init_with_key_values(
      "err" , "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" , "Komanda sėkmingai įvykdyta!"
    ),
  );

  // Gaunamas sistemos kalbos nustatymas
  String lang = env::get_var("LANG") ?? "";
  
  // Išsaugomi pranešimai, atitinkantys aplinkos kalbą
  LangMessages langMessages = messages[lang] ?? LangMessages{};

  io::printn("");

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis ir pranešimais
  runCmd("apt-get update", langMessages);
  runCmd("apt-get upgrade -y", langMessages);
  runCmd("apt-get autoremove -y", langMessages);
  runCmd("snap refresh", langMessages);
}
