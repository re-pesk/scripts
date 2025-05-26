@file:OptIn(kotlinx.cinterop.ExperimentalForeignApi::class)
import kotlinx.cinterop.ByteVar
import kotlinx.cinterop.CPointer
import kotlinx.cinterop.toKString
import kotlin.system.exitProcess
import platform.posix.getenv
import platform.posix.system

// Klaidų ir sėkmės pranešimų medis
val messages = hashMapOf(
  "en.UTF-8" to hashMapOf(
    "err" to "Error! Script execution was terminated!",
    "succ" to "Successfully finished!"
  ),
  "lt_LT.UTF-8" to hashMapOf(
    "err" to "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ" to "Komanda sėkmingai įvykdyta!"
  )
)

// Pranešimai pagal aplinkos kalbos nuostatą
val cpLang : CPointer<ByteVar>? = getenv("LANG")
val lang = cpLang?.toKString() ?: "en.UTF-8"
val errorMessage = messages.get(lang)?.get("err")
val successMessage = messages.get(lang)?.get("succ")

// Išorinių komandų iškvietimo funkcija
fun runCmd(cmdArg : String) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
  val command = "sudo ${cmdArg}"

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-".repeat(n) - kartoja '-' simbolį
  // command.length - paima komandinės eilutės ilgį
  val separator = "-".repeat(command.length)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  println("$separator\n$command\n$separator\n")

  // Vykdoma komanda, išėjimo kodas išsaugomas į kintamąjį

  val exitCode = system(command);

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode != 0) {
    println("\n$errorMessage\n")
    exitProcess(exitCode)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  println("\n$successMessage\n")
}

//Pagrindinė funkcija
fun main() {

  println()

  // Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd("apt-get update")
  runCmd("apt-get upgrade -y")
  runCmd("apt-get autoremove -y")
  runCmd("snap refresh")
}
