#!/usr/bin/env -S scala shebang

//> using scala 3.6.2
import scala.collection.immutable.HashMap
import scala.sys.process._

val messages = HashMap(
  // "key1"->"value1", "key2"->"value2", "key3"->"value3"
  "en.UTF-8" -> HashMap(
    "err" -> "Error! Script execution was terminated!",
    "succ" -> "Successfully finished!"
  ),
  "lt_LT.UTF-8" -> HashMap(
    "err" -> "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" -> "Komanda sėkmingai įvykdyta!"
  )
)

val lang = sys.env("LANG")
val errorMessage = messages(lang)("err")
val successMessage = messages(lang)("succ")

def runCmd(cmdArg: String) : Unit = {
  val command = s"sudo $cmdArg"
  val separator = "-" * command.length() 
  println(s"$separator\n$command\n$separator\n")

  val exitCode = Process(command).!

  if (exitCode > 0) {
    println(s"\n$errorMessage\n")
    System.exit(exitCode)
  }
  
  println(s"\n$successMessage\n")
}

@main
def main(): Unit = {
  println()

  runCmd("apt-get update")
  runCmd("apt-get upgrade -y")
  runCmd("apt-get autoremove -y")
  runCmd("snap refresh")
}
