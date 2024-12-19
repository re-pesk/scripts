#! /usr/bin/env nu

let messages = {
  "en.UTF-8" : {
    'succ' : "Successfully finished!",
    'err' : "Error! Script execution was terminated!"
  },
  'lt_LT.UTF-8' : {
    'succ' : "Komanda sėkmingai įvykdyta!",
    'err' : "Klaida! Scenarijaus vykdymas sustabdytas!"
  },
}

let lang = $env.LANG
let errorMessage = $messages | get $lang | get "err"
let successMessage = $messages | get $lang | get "succ"

# Pagalbinė komanda išorinėms komandoms iškviesti 
def runCmd [
    ...args # parametrų sąrašas
] {

    # Sukuria komandos tekstinę eilutę iš funkcijos argumentų
    let command = ["sudo" ...$args] | str join " "

    # pakeičia visas eilutės raides "-" simboliu
    let separator = $command | str replace --all --regex "." "-"

    # spausdina separatorių ir komandos eilutę
    print $separator $command $separator ""

    # vykdo komandą
    run-external "sudo" ...$args

    if $env.LAST_EXIT_CODE > 0 {
        printf "" $errorMessage "" # išvedamas klaidos pranešimas
        exit
    }

    print "" $successMessage ""
}

print ""

runCmd apt-get update
runCmd apt-get upgrade "-y"
runCmd apt-get autoremove "-y"
runCmd snap refresh
