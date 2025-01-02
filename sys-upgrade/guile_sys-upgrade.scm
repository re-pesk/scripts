#!/usr/bin/env -S guile --no-auto-compile -s 
!#

;; Klaidų ir sėkmės pranešimų medis
(define messages '(
  ("en.UTF-8" . (
    ("err" . "Error! Script execution was terminated!")
    ("succ" . "Successfully finished!")
  ))
  ("lt_LT.UTF-8" . (
    ("err" . "Klaida! Scenarijaus vykdymas sustabdytas!")
    ("succ" . "Komanda sėkmingai įvykdyta!")
  ))
))

;; Pranešimai pagal aplinkos kalbos nuostatą
(define lang (getenv "LANG"))
(define 
  (get-message-text language key) 
  (assoc-ref 
    (assoc-ref messages language)
    key
  )
)
(define errorMessage (get-message-text lang "err"))
(define successMessage (get-message-text lang "succ"))

(define 
  (display-strings . args)
  (display (string-join args ""))
)

;; Išorinių komandų iškvietimo funkcija
(define 
  (runCmd cmdArg) 

  ;; Sukuriama komanda iš funkcijos argumento
  (define command (string-append "sudo " cmdArg))

  ;; Generuojamas skirtukas iš "-" simbolių
  ;; (make-string ... #\-) - kartojamas simbolis '-'
  ;; (string-length command) - gaunamas komandos ilgis
  (define separator (make-string (string-length command) #\- ))

  ;; Išvedama komanda, apsupta skirtuko eilučių
  (display-strings separator "\n" command "\n" separator "\n\n")

  ;; Įvykdoma komanda, procesos statusas išsaugomas į kintamąjį
  (define status (system command))

  ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (if (> (status:exit-val status) 0) (
    (display-strings "\n" errorMessage "\n\n")
    (exit 99)
  ))

  ;; Kitu atveju išvedamas sėkmės pranešimas
  (display-strings "\n" successMessage "\n\n")
)

(newline)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")
