package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"

runCmd :: proc(cmdStr: string, langMessages: map[string]string) {

  command := strings.join({"sudo", cmdStr}, " ")
  separator := strings.repeat("-", len(command))
  fmt.printfln("%v\n%v\n%v\n", separator, command, separator)

  csCommand := strings.clone_to_cstring(command)
  status := libc.system(csCommand);

  if status != 0 {
    fmt.printfln("\n%v\n", langMessages["err"])
    os.exit(99)
  }

  fmt.printfln("\n%v\n", langMessages["succ"])
}

main :: proc() {
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
  
  lang : string = os.get_env("LANG")
  langMessages := messages[lang]

  fmt.println()

  runCmd("apt-get update", langMessages)
  runCmd("apt-get upgrade -y", langMessages)
  runCmd("apt-get autoremove -y", langMessages)
  runCmd("snap refresh", langMessages)

}
