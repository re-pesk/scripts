import std::io;
import std::collections::elastic_array;
import std::collections::map;
import std::core::string;
import std::os::env;
import libc;

def LangMessages = HashMap(<String, String>); // Kalbos pranešimai
def Messages = HashMap(<String, LangMessages>); // Bendras pranešimų medis
def Separator = ElasticArray(<char, 255>); // Dinaminis masyvas, naudojamas separatoriui paruošti

// Separatoriaus užpildymas
fn void Separator.new(&self, char x, String* str) @dynamic {
  for (int i = 0; i < str.len; i++) {
    self.push(x);
  }
}

// Separatoriaus eilutės suformavimas
fn String Separator.toString(&self) @dynamic {
  return (String)(self.entries[0:self.size]);
}

// Išorinės programso vykdymas, komandos su argumentais, jos pranešimų ir vykdymo rezultatų išvedimas terminale
fn void runCmd(String cmdStr, LangMessages langMessages) {
  // Sudaroma komandos eilutė
  String command = string::join_new({"sudo", cmdStr}, " ");
  // Sukuriama komandų eilutės ilgio sepratoriaus eilutė
  Separator sepArray = {};
  sepArray.new('-', &command);
  String separator = sepArray.toString();
  //Terminale išvedama komanda, apsupta separatoriaus eilutėmis
  io::printfn("%s\n%s\n%s\n", separator, command, separator);

  // Komanda paverčiama į C eilutę
  ZString zCommand = (ZString)command;

  // Vykdoma komanda
  CInt status = libc::system(zCommand);

  uint result = (uint)status;

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir išeinama iš programos
  if (result != 0) {
    io::printfn("\n%s\n", langMessages["err"] ?? "");
    libc::exit(99);
  }

  // Sėkmės atveju išspausdinamas sėkmės pranešimas
  io::printfn("\n%s\n", langMessages["succ"] ?? "");
}

fn void main() {
  // Kalbos pranešimai
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
  // Paimami kalbą aitinkantys pranešimų tekstai
  LangMessages langMessages = messages[lang] ?? LangMessages{};

  io::printn("");

  // Vykdomos komandas
  runCmd("apt-get update", langMessages);
  runCmd("apt-get upgrade -y", langMessages);
  runCmd("apt-get autoremove -y", langMessages);
  runCmd("snap refresh", langMessages);
}
