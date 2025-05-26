package main

import (
  "fmt"
  "os"
  "os/exec"
  "strings"
)

// Išorinių komandų iškvietimo funkcija
func runCmd(cmdArg string, langMessages map[string]string) {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command := strings.Join([]string{"sudo", cmdArg}, " ")

  // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  // strings.Repeat("-", n) - simbolio kartojimas, len(command) - komandos simbolių skaičius
  separator := strings.Repeat("-", len(command))

  // Išveda komandos eilutę, apsuptą skirtuko eilučių
  fmt.Printf("%v\n%v\n%v\n\n", separator, command, separator)

  // Komandos eilutę pverčia masyvu
  cmdArray := strings.Fields(command)

  // Sukuria procesą, jo išvedimo srautus nukreipia į pagrindinį procesą
  cmd := exec.Command(cmdArray[0], cmdArray[1:]...)
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr

  // Įvykdo komandą, klaidos būseną išaugo į kintamąjį
  err := cmd.Run()

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if err != nil {
    fmt.Printf("\n%v\n\n", langMessages["err"])
    os.Exit(0)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  fmt.Printf("\n%v\n\n", langMessages["succ"])
}

// Pagrindinė funkcija - programos įeigos taškas
func main() {

  // Klaidų ir sėkmės pranešimų medis
  messages := map[string]map[string]string{
    "en.UTF-8": {
      "err":  "Error! Script execution was terminated!",
      "succ": "Successfully finished!",
    },
    "lt_LT.UTF-8": {
      "err":  "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ": "Komanda sėkmingai įvykdyta!",
    },
  }

  // Pranešimai, atitinkantys aplinkos kalbą
  lang := os.Getenv("LANG")
  langMessages := messages[lang]

  fmt.Println("")

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update", langMessages)
  runCmd("apt-get upgrade -y", langMessages)
  runCmd("apt-get autoremove -y", langMessages)
  runCmd("snap refresh", langMessages)
}
