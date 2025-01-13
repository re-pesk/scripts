#! /usr/bin/env -S fish

# set fish_trace 1

# Klaidų ir sėkmės pranešimų masyvas - kiekvienas pranešimas naujoje eilutėje
set -g messages \
  "[en.UTF-8.err]=Error! Script execution was terminated!"
set -a messages \
  "[en.UTF-8.succ]=Successfully finished!"
set -a messages \
  "[lt_LT.UTF-8.err]=Klaida! Scenarijaus vykdymas sustabdytas!"
set -a messages \
  "[lt_LT.UTF-8.succ]=Komanda sėkmingai įvykdyta!"

# Funkcija pranešimui iš masyvo paimti pagal raktą
function getMessageText --argument-names key
  # -q - vykdoma be pranešimų, -r - regexas
  string match -qr -- "^\[$key\]=(?<value>.*)\$" $messages
  echo $value
end

# Išsaugomi pranešimai, atitinkantys aplinkos kalbą
set -g errorMessage (getMessageText "$LANG.err")
set -g successMessage (getMessageText "$LANG.succ")

# Išorinių komandų iškvietimo funkcija
function runCmd ()

    # Sukuriama komandos tekstinė eilutė iš funkcijos argumento 
    set -l command "sudo $argv"

    # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
    # (string length $command) - grąžina eilutės, saugomos $command, ilgį
    # (string repeat --count (string length $command) '-') - generuoja duoto ilgio separatorių iš '-' simbolių
    # set -l separator (string repeat --count (string length $command) '-')
    set -l separator (string replace -a -r '.' '-' $command)

    # Išvedama komandos eilutė, apsupta skirtuko eilučių
    echo -e "$separator\n$command\n$separator\n"

    # Vykdoma komanda
    sudo $argv

    # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    # Įvykdymo rezultatas programos kintamajame $status išsaugomas automatiškai
    if test $status -gt 0
      echo -e "\n$errorMessage\n"
      exit 99
    end

    # Kitu atveju išvedamas sėkmės pranešimas
    echo -e "\n$successMessage\n"
end

echo ""

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh
