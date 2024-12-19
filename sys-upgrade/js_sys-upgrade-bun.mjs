#! /usr/bin/env -S bun run

const { spawnSync } = Bun;
// Node kodo variantas irgi veikia
// import { spawnSync } from 'node:child_process';

// Klaidų ir sėkmės pranešimų tekstai
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

// Pranešimai pagal aplinkos kalbos nuostatą
const LANG = process.env.LANG
const errorMessage = messages[LANG].err
const successMessage = messages[LANG].succ

// Įvykdo išorinę programą, terminale atspausdindama komandą, jos pranešimus ir vykdymo rezultatus
const runCmd = (cmdArg) => {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  const command = `sudo ${cmdArg}`

  // "-".repeat() - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // command.length paima komandinės eilutės ilgį
  const separator = "-".repeat(command.length)

  // spausdina separatorių ir komandos eilutę
  console.log(`${separator}\n${command}\n${separator}\n`)

  // vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
  const child_proc = spawnSync(["sudo", ...cmdArg.split(' ')], {
    stdio: ['inherit', 'inherit', 'inherit'],
    shell: true
  })
  
  // veikiantis Nodejs kodo variantas
  // const child_proc = spawnSync(`sudo ${cmdArg}`, {
  //   stdio: 'inherit',
  //   shell: true
  // })

  // Jeigu procesas pasibaigė klaida, išveda pranešimą apie klaidą ir išeina iš programos 
  if (child_proc.exitCode !== 0) {
    // veikiantis Nodejs kodo variantas
    // if (child_proc.status !== 0) {
    console.log(`\n${errorMessage}\n`);
    process.exit(99);
  }

  // Jeigu klaidos nėra, išvedamas sėkmės pranešimas
  console.log(`\n${successMessage}\n`)

}

console.log()

// Kviečiamos komandos
runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
