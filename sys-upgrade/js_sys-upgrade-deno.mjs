#!/usr/bin/env -S deno run --allow-run --allow-env

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
const LANG = Deno.env.get("LANG")
const errorMessage = messages[LANG].err
const successMessage = messages[LANG].succ


let runCmd = (cmdArg) => {

  // Sukuria komandos tekstinę eilutę iš funkcijos argumento
  let command = `sudo ${cmdArg}`

  // "-".repeat() - generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
  // command.length paima komandinės eilutės ilgį
  let separator = "-".repeat(command.length)

  // spausdina separatorių ir komandos eilutę
  console.log(`${separator}\n${command}\n${separator}\n`)

  // vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
  const child_proc = new Deno.Command('sudo', {
    args: [...cmdArg.split(' ')],
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit'
  });
  const { code } = child_proc.outputSync();

  // tikrina, ar komanda įvykdyta sėkmingai
  if (code > 0) {
    console.log(`\n${errorMessage}\n`);
    process.exit(99) // išeinama iš skripto su klaidos pranešimu
  }

  console.log(`\n${successMessage}\n`)
  return // grįžtama iš funkcijos
}

console.log()

runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
