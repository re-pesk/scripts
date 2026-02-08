///usr/bin/env -S scala shebang "$0" "$@"; exit $?

//> using scala 3.6.2
import scala.collection.immutable.HashMap
import scala.sys.process._

// Klaidų ir sėkmės pranešimų medis
val messages = HashMap(
  "en.UTF-8" -> HashMap(
    "err" -> "Error! Script execution was terminated!",
    "succ" -> "Successfully finished!"
  ),
  "lt_LT.UTF-8" -> HashMap(
    "err" -> "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" -> "Komanda sėkmingai įvykdyta!"
  )
)

// Pranešimai pagal aplinkos kalbos nuostatą
val lang = sys.env("LANG")
val errorMessage = messages(lang)("err")
val successMessage = messages(lang)("succ")

// Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg: String) : Unit = {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento to 
  val command = s"sudo $cmdArg"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-" * - kartoja '-' simbolį
  // command.length() - paima komandinės eilutės ilgį
  val separator = "-" * command.length() 

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  println(s"$separator\n$command\n$separator\n")

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį 
  val exitCode = Process(command).!

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode > 0) {
    println(s"\n$errorMessage\n")
    System.exit(exitCode)
  }
  
  // Kitu atveju išvedamas sėkmės pranešimas
  println(s"\n$successMessage\n")
}


@main def main(): Unit = {
  println()

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update")
  runCmd("apt-get upgrade -y")
  runCmd("apt-get autoremove -y")
  runCmd("snap refresh")
}
