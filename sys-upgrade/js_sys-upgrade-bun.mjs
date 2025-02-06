#! /usr/bin/env -S bun run

// Klaidų ir sėkmės pranešimų medis
const messages = {
  'en.UTF-8': {
    'err': "Error! Script execution was terminated!",
    'succ': "Successfully finished!",
  },
  'lt_LT.UTF-8': {
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ': "Komanda sėkmingai įvykdyta!",
  },
}

// Aplinkos kalbos nuostata
const LANG = process.env.LANG

// Pranešimai pagal aplinkos kalbos nuostatą
const errorMessage = messages[LANG].err
const successMessage = messages[LANG].succ

// Sisteminė komandos vykdymo funkcija
const { spawnSync } = Bun;
// Node kodo variantas
// import { spawnSync } from 'node:child_process';

// Išorinių komandų iškvietimo funkcija
const runCmd = (cmdArg) => {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  const command = `sudo ${cmdArg}`

  // Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  // "-".repeat() - kartoja '-' simbolį
  // command.length - paimamas komandinės eilutės ilgis
  const separator = "-".repeat(command.length)

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  console.log(`${separator}\n${command}\n${separator}\n`)

  // Įvykdoma komanda, procesas išsaugomas į kintamąjį 
  const child_proc = spawnSync(
    ["sudo", ...cmdArg.split(' ')], {
    stdio: ['inherit', 'inherit', 'inherit'],
    shell: true
  })

  // Išsaugomas įvykdytos komandos išėjimo kodas
  const exitCode = child_proc.exitCode

  // Nodejs kodo variantas
  // const child_proc = spawnSync(`sudo ${cmdArg}`, {
  //   stdio: 'inherit',
  //   shell: true
  // })
  // const exitCode = child_proc.status

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode !== 0) {
    console.log(`\n${errorMessage}\n`);
    process.exit(99);
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
