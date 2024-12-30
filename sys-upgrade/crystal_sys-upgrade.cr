
# Klaidų ir sėkmės pranešimų medis
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
ErrorMessage = Messages[ENV["LANG"]]["err"]
SuccessMessage = Messages[ENV["LANG"]]["succ"]

# Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg : String)

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command = "sudo " + cmdArg

  # Generuoja skirtuką, visus komandos komandos simbolius pakeisdamas "-" simboliu
  # "-" * - simbolio kartojimas, command.size - komandos simbolių skaičius
  separator = "-" * command.size

  # Išveda komandos eilutę, apsuptą skirtuko eilučių
  puts separator, command, separator, ""

  # Argumentų eilutė suskaidoma į masyvą
  args = cmdArg.split(' ')

  # Vykdo komandą, komandos vykdymo išėjimo kodą išsaugo į kintamąjį, išvedimas nukreipiamas į pagrindinį proceso
  status = Process.run(
    "sudo",
    args,
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

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd "apt-get update"
runCmd "apt-get upgrade -y"
runCmd "apt-get autoremove -y"
runCmd "snap refresh"
