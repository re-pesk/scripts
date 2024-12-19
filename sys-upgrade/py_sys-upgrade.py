#!/usr/bin/env python3

import os
import subprocess

# Klaidų ir sėkmės pranešimų tekstai
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

# Įvykdo išorinę programą, terminale atspausdindama komandą, jos pranešimus ir vykdymo rezultatus
def runCmd(cmdArg):
    # Sukuria komandos tekstinę eilutę iš funkcijos argumento
    command = f"sudo {cmdArg}"
    # Generuoja komandinės eilutės ilgio separatorių iš '-' simbolių
    separator = "-" * len(command)
    # Spausdina komandą, apsuptą separatorių
    print(f"{separator}\n{command}\n{separator}\n")

    # Vykdo komandą, komandos vykdymo rezultatą išsaugo į kintamąjį 
    result = subprocess.run(command.split(' '))

    # Jeigu procesas pasibaigė klaida, išveda klaido pranešimą ir išeina iš programos
    if(result.returncode != 0):
        print(f"\n{errorMessage}\n")
        exit(result.returncode)

    # Jeigu klaidos nėra, išveda sėkmės pranešimą
    print(f"\n{successMessage}\n")

print()

# Kviečiamos komandos
runCmd('apt update')
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd('snap refresh')
