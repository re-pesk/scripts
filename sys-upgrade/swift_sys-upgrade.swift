import Foundation

// Klaidų ir sėkmės pranešimų medis
let messages: [String: [String: String]] = [
  "en.UTF-8": [
    "err": "Error! Script execution was terminated!",
    "succ": "Successfully finished!",
  ],
  "lt_LT.UTF-8": [
    "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ": "Komanda sėkmingai įvykdyta!",
  ],
]

// Pranešimai, atitinkantys aplinkos kalbą
let env: [String: String] = ProcessInfo.processInfo.environment
let lang: String = env["LANG"] ?? ""
let errorMesage: String = (messages[lang] ?? [:] )["err"] ?? ""
let successMesage: String = (messages[lang] ?? [:] )["succ"] ?? ""

// Išorinių komandų iškvietimo funkcija
func runCmd(_ cmdArg: String) {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  let command = "sudo \(cmdArg)"

  // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
	// String(repeating: "-", count: n) - simbolio kartojimas, command.count - komandos simbolių skaičius
  let separator = String(repeating: "-", count: command.count)
  
  // Išveda komandos eilutę, apsuptą skirtuko eilučių
  print("\(separator)\n\(command)\n\(separator)\n")

  // Įvykdo komandą, išsaugo išėjimo kodą į kintamąjį
  let exitCode: Int32 = system(command)

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if exitCode != 0 {
    print("\n\(errorMesage)\n")
    exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  print("\n\(successMesage)\n")
}

print()

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
