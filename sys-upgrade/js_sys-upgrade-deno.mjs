#!/usr/bin/env -S deno run --allow-run --allow-env

// Klaidų ir sėkmės pranešimų medis
const messages = {
  'en.UTF-8': {
    'succ': "Successfully finished!",
    'err': "Error! Script execution was terminated!"
  },
  'lt_LT.UTF-8': {
    'succ': "Komanda sėkmingai įvykdyta!",
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!"
  },
}

// Pranešimai pagal aplinkos kalbos nuostatą
const LANG = Deno.env.get("LANG")
const errorMessage = messages[LANG].err
const successMessage = messages[LANG].succ

// Išorinių komandų iškvietimo funkcija
const runCmd = (cmdArg) => {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  let command = `sudo ${cmdArg}`

  // Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
  // "-".repeat() - kartoja '-' simbolį
  // command.length - paima komandinės eilutės ilgį
  let separator = "-".repeat(command.length)

  // Išveda komandos eilutę, apsuptą skirtuko eilučių
  console.log(`${separator}\n${command}\n${separator}\n`)

  // Įvykdo komandą, procesą išsaugo į kintamąjį 
  const child_proc = new Deno.Command('sudo', {
    args: [...cmdArg.split(' ')],
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit'
  });

  // Išsaugo įvykdytos komandos išėjimo kodą
  const { code } = child_proc.outputSync();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas 
  if (code !== 0) {
    console.log(`\n${errorMessage}\n`);
    process.exit(99)
  }

  // Kitu atveju išvedamas sėkmės pranešimas
  console.log(`\n${successMessage}\n`)
}

console.log()

// Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
