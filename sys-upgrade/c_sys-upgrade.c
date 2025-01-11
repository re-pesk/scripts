#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Pagalbiniai makrosai 
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
#define MALLOC_SIZE(len) malloc (sizeof (char) * len)

//Medžio šakos struktūra 
struct Message {
  char* key;
  char* value;
};

// Klaidų ir sėkmės pranešimų medis
struct Message messages[] = (struct Message[]){
  (struct Message) {"en.UTF-8.err", "Error! Script execution was terminated!"},
  (struct Message) {"en.UTF-8.succ", "Successfully finished!"},
  (struct Message) {"lt_LT.UTF-8.err", "Klaida! Scenarijaus vykdymas sustabdytas!"},
  (struct Message) {"lt_LT.UTF-8.succ", "Komanda sėkmingai įvykdyta!"}
};

// Funkcija pranešimui iš masyvo paimti pagal raktą
char* getMessage(char* key) {
  for (int i = 0; i < ARRAY_SIZE(messages); i++) {
    if (strcmp(messages[i].key, key) == 0) {
      return messages[i].value;
    }
  }
  return "";
}

// Funkcija, suliejanti dvi duotas teksto eilutes ir grąžinanti naują eilutę
char* strMerge(char* first, char* second) {
  size_t len = strlen(first) + strlen(second);
  char* mergedString = MALLOC_SIZE(len);
  strcpy(mergedString, first);
  strcat(mergedString, second);
  return mergedString;
}

// Funkcija, pakeičianti visus eilutės simbolius nurodytu simboliu ir grąžinanti naują eilutę
char* strReplace(char* str, char character) {
  char* newString = strMerge(str, "");
  for (int i = 0; i < strlen(newString); i++) {
    newString[i] = character;
  }
  return newString;
}

// Pagrindinė funkcija - programos įeigos taškas
int main() {
  // Paimama aplinkos kalbos nuostata
  char* lang = getenv("LANG");

  // Pranešimų raktai
  char* errLang = strMerge(lang, ".err");
  char* succLang = strMerge(lang, ".succ");

  // Parenkami pranešimai pagal aplinkos kalbos nuostatą
  char* errorMessage = getMessage(errLang);
  char* successMessage = getMessage(succLang);

  // Išlaisvinama alokuota atmintis
  free(errLang); free(succLang);

  // Išorinių komandų iškvietimo funkcija
  void runCmd(char* cmdArg) {
  
    // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
    char* command = strMerge("sudo ", cmdArg);

    // Generuojamas skirtukas, visus komandos kopijos simbolius pakeičiant "-" simboliu
    char* separator = strReplace(command, '-');

    printf("%s\n%s\n%s\n\n", separator, command, separator); 

    // Įvykdoma komanda, iėjimo kodas išsaugomas į kintamąjį 
    int exitCode = system(command);

    // Išlaisvinama alokuota atmintis
    free(command); free(separator);

    // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if (exitCode > 0 ) {
      printf("\n%s\n\n", errorMessage);
      exit(99);
    }

    // Kitu atveju išvedamas sėkmės pranešimas
    printf("\n%s\n\n", successMessage);
  }

  puts("");

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");
  
  return 0;
}
