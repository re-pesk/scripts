import os
import strings

const messages := {
	"en.UTF-8" : {
		"err" : "Error! Script execution was terminated!",
		"succ" : "Successfully finished!",
	},
	"lt_LT.UTF-8" : {
		"err" : "Klaida! Scenarijaus vykdymas sustabdytas!",
		"succ" : "Komanda sėkmingai įvykdyta!",
	},
}

const lang := os.getenv("LANG")
const lang_messages := messages[lang].clone()

fn run_cmd(cmdArgs string) {
  command := "sudo ${cmdArgs}"
  separator := strings.repeat(`-`, command.len)

  println("${separator}\n${command}\n${separator}\n")

  status := os.system(command)

  if status != 0 {
    println("\n${lang_messages['err']}\n")
    exit(99)
  }

  println("\n${lang_messages['succ']}\n")
}

println("")

run_cmd("apt-get update")
run_cmd("apt-get upgrade -y")
run_cmd("apt-get autoremove -y")
run_cmd("snap refresh")
