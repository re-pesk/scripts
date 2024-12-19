#! /usr/bin/env -S fish

# set fish_trace 1

set -g messages "[en.UTF-8.err]=Error! Script execution was terminated!"
set -a messages "[en.UTF-8.succ]=Successfully finished!"
set -a messages "[lt_LT.UTF-8.err]=Klaida! Scenarijaus vykdymas sustabdytas!"
set -a messages "[lt_LT.UTF-8.succ]=Komanda sėkmingai įvykdyta!"

# Grąžina reikalingą pranešimo tekstą iš \$messages sąrašo
function getMessageText --argument-names key
  # -q - vykdoma be pranešimų, -r - regexas
  string match -qr -- "^\[$key\]=(?<value>.*)\$" $messages
  echo $value
end

set -g errorMessage (getMessageText "$LANG.err")
set -g successMessage (getMessageText "$LANG.succ")

function runCmd ()

    # Sukuria komandos tekstinę eilutę iš funkcijos argumento
    set -l command "sudo $argv"

    # (string length $command) - grąžina eilutės, saugomos $command, ilgį
    # (string repeat --count (string length $command) '-') - generuoja duoto ilgio separatorių iš '-' simbolių
    # set -l separator (string repeat --count (string length $command) '-')
    # generuoja separatorių, visus komandos $command simbolius pakeisdamas "-" simboliu
    set -l separator (string replace -a -r '.' '-' $command)

    #išveda komandos eilutę, apsuptą separatorių
    echo -e "$separator\n$command\n$separator\n"

    # vykdo komandą
    sudo $argv

    # tikrina, ar komanda įvykdyta sėkmingai, \$tatus gražina įvykdymo rezultatą
    if test $status -gt 0
      echo -e "\n$errorMessage\n" # išvedamas klaidos pranešimas
      exit 99 # išeinama iš skripto
    end

    echo -e "\n$successMessage\n"
    return 0
end

echo ""

runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh
