#! /usr/bin/env -S node

import { spawnSync } from 'node:child_process';

const messages = {
  'en.UTF-8' : {
    'succ' : "Successfully finished!",
    'err' : "Error! Script execution was terminated!"
  },
  'lt_LT.UTF-8' : {
    'succ' : "Komanda sėkmingai įvykdyta!",
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!"
  },
}

const LANG = process.env.LANG
const errorMessage = messages[LANG].err
const successMessage = messages[LANG].succ

const runCmd = (cmdArg) => {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  const command = `sudo ${cmdArg}`

  // "-".repeat() - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // command.length paima komandinės eilutės ilgį
  const separator = "-".repeat(command.length)

  // spausdina separatorių ir komandos eilutę
  console.log(`${separator}\n${command}\n${separator}\n`)

  // vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
  const child_proc = spawnSync(command, {
    stdio: 'inherit',
    shell: true
  })
  
  if (child_proc.status !== 0) {
    console.log(`\n${errorMessage}\n`);
    process.exit(99);
  }

  console.log(`\n${successMessage}\n`)

}

console.log()

runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
