
# Klaidų ir sėkmės pranešimų tekstai
Messages = {
  "en.UTF-8": {
    "err": "Error! Script execution was terminated!",
    "succ": "Successfully finished!",
  },
  "lt_LT.UTF-8": {
    "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
    "succ": "Komanda sėkmingai įvykdyta!",
  },
}

# Pranešimai pagal aplinkos kalbos nuostatą
Lang = ENV["LANG"]
ErrorMessage = Messages[Lang]["err"]
SuccessMessage = Messages[Lang]["succ"]

# Įvykdoma išorinė programa, terminale atspausdinama komanda, jos pranešimai ir vykdymo rezultatai
def runCmd(cmdArgString : String)

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command = "sudo " + cmdArgString

  # Sukuriamas komandų skirtukas, "-" simbolį kartojant tiek kartų, kiek simbolių turi komandos eilutė
  separator = "-" * command.size

  # Išvedama komanda su skirtukais
  puts separator, command, separator, ""

  # Argumentų eilutė suskaidoma į masyvą
  cmdArgs = cmdArgString.split(' ')

  # Vykdo komandą, komandos vykdymo statusą išsaugo į kintamąj
  status = Process.run(
    "sudo",
    cmdArgs,
    input: Process::Redirect::Inherit,
    output: Process::Redirect::Inherit,
    error: Process::Redirect::Inherit,
  )

  # Jeigu įvyko klaida, išvedamas klaidos pranešimas ir išeinama iš programos
  if !status.success?
    puts "", ErrorMessage, ""
    Process.exit(99)
  end

  # Jeigu klaidos nėra, išvedamas sėkmės pranešimas
  puts "", SuccessMessage, ""

end # def runCmd

puts ""

runCmd "apt-get update"
runCmd "apt-get upgrade -y"
runCmd "apt-get autoremove -y"
runCmd "snap refresh"
