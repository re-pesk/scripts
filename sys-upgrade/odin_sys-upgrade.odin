package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"

// Išorinių komandų iškvietimo funkcija
runCmd :: proc(cmdArg: string, langMessages: map[string]string) {

  //Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command := strings.join({"sudo", cmdArg}, " ")
  
  // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  // strings.repeat("-", ...) - simbolio kartojimas, len(command) - komandos ilgis
  separator := strings.repeat("-", len(command))

  // Išveda komandos eilutę, apsuptą skirtuko eilučių
  fmt.printfln("%v\n%v\n%v\n", separator, command, separator)

  // Kovertuoja komandos teksto eilutę į C kalbos eilutę
  csCommand := strings.clone_to_cstring(command)

  // Įvykdo komandą, išėjimo kodą išsaugo į kintamąjį
  exitCode := libc.system(csCommand);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    fmt.printfln("\n%v\n", langMessages["err"])
    os.exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  fmt.printfln("\n%v\n", langMessages["succ"])
}

// Pagrindinė funkcija - programos įeigos taškas
main :: proc() {

  // Klaidų ir sėkmės pranešimų medis
  messages := map[string]map[string]string{
    "en.UTF-8" = {
      "err" = "Error! Script execution was terminated!",
      "succ" = "Successfully finished!",
    },
    "lt_LT.UTF-8" = {
      "err" = "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" = "Komanda sėkmingai įvykdyta!",
    },
  }
  
  // Pranešimai, atitinkantys aplinkos kalbą
  lang : string = os.get_env("LANG")
  langMessages := messages[lang]

  fmt.println()

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update", langMessages)
  runCmd("apt-get upgrade -y", langMessages)
  runCmd("apt-get autoremove -y", langMessages)
  runCmd("snap refresh", langMessages)

}
