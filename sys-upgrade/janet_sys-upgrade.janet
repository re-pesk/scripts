#!/usr/bin/env janet

# Klaidų ir sėkmės pranešimų medis
(def messages {"en.UTF-8" {:err "Error! Script execution was terminated!"
                           :succ '"Successfully finished!"}
               "lt_LT.UTF-8" {:err "Klaida! Scenarijaus vykdymas sustabdytas!"
                              :succ "Komanda sėkmingai įvykdyta!"}})

# Aplinkos kalbos nuostata
(def lang (os/getenv "LANG"))

# Pranešimai, atitinkantys aplinkos kalbą
(def errorMessage (get (get messages lang) :err))
(def successMessage (get (get messages lang) :succ))

# Išorinių komandų iškvietimo funkcija
(defn runCmd (cmdArg) (do
                        # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
                        (def command (string "sudo " cmdArg))

                        # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
                        (def separator (string/repeat "-" (length command)))

                        # Išvedama komandos eilutė, apsupta skirtuko eilučių
                        (print separator "\n" command "\n" separator "\n")

                        # Įvykdoma komanda, išėjimo kodas išsaugomas
                        (def exitCode (os/execute (string/split " " command) :p))
                        
                        # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
                        (if (> exitCode 0) (do
                                             (print "\n" errorMessage "\n")
                                             (os/exit 99)))

                        # Kitu atveju išvedamas sėkmės pranešimas
                        (print "\n" successMessage "\n")))

(print)

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")
