package main

import (
  "fmt"
  "os"
  "os/exec"
  "strings"
)

func runCmd(cmdArgString string, langMessages map[string]string) {

  command := strings.Join([]string{"sudo", cmdArgString}, " ")
  separator := strings.Repeat("-", len(command))
  fmt.Printf("%v\n%v\n%v\n\n", separator, command, separator)

  cmdArray := strings.Fields(command)

	cmd := exec.Command(cmdArray[0], cmdArray[1:]...)
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr
  err := cmd.Run()

  if err != nil {
    fmt.Printf("\n%v\n\n", langMessages["err"])
    os.Exit(0)
  }

  fmt.Printf("\n%v\n\n", langMessages["succ"])
}

func main() {

  messages := map[string]map[string]string {
    "en.UTF-8" : {
      "err" : "Error! Script execution was terminated!",
      "succ" : "Successfully finished!",
    },
    "lt_LT.UTF-8" : {
      "err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" : "Komanda sėkmingai įvykdyta!",
    },
  }

  lang := os.Getenv("LANG")
  langMessages := messages[lang]

  fmt.Println("")

  runCmd("apt-get update", langMessages)
  runCmd("apt-get upgrade -y", langMessages)
  runCmd("apt-get autoremove -y", langMessages)
  runCmd("snap refresh", langMessages)

}

