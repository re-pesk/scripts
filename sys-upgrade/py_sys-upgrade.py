#!/usr/bin/env python3

import os

# Klaidų ir sėkmės pranešimų medis
messages = {
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
lang = os.environ["LANG"]
errorMessage = messages[lang]['err']
successMessage = messages[lang]['succ']

import subprocess

## Išorinių komandų iškvietimo funkcija
def runCmd(cmdArg):

    # Sukuria komandos tekstinę eilutę iš funkcijos argumento
    command = f"sudo {cmdArg}"
    
    # Generuoja skirtuką, visus komandos $command simbolius pakeisdamas "-" simboliu
    # "-" * - simbolio "-" kartojimas
    # len(command) - komandos eilutės ilgis
    separator = "-" * len(command)
    
    # Išveda komandos eilutę, apsuptą skirtuko eilučių
    print(f"{separator}\n{command}\n{separator}\n")

    # Vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
    exitCode = subprocess.run(command.split(' ')).returncode

    # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
    if(exitCode != 0):
        print(f"\n{errorMessage}\n")
        exit(exitCode)

    # Jeigu klaidos nėra, išveda sėkmės pranešimą
    print(f"\n{successMessage}\n")

print()

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd('apt update')
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd('snap refresh')
