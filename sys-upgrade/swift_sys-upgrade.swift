import Foundation

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

let env: [String: String] = ProcessInfo.processInfo.environment
let lang: String = env["LANG"] ?? ""
let langMessages: [String: String] = messages[lang] ?? [:]

func runCmd(_ cmdArgs: String) {
  let command = "sudo \(cmdArgs)"
  let separator = String(repeating: "-", count: command.count)
  print("\(separator)\n\(command)\n\(separator)\n")

  let status: Int32 = system(command)

  if status != 0 {
    print("\n\(langMessages["err"] ?? "")\n")
    exit(99)
  }

  print("\n\(langMessages["succ"] ?? "")\n")
}

print()

runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
