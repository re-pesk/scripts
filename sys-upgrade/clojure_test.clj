#!/usr/bin/env -S clojure -M

;; Įkeliamas clojure.string modulis, sukuriant kai kurių funkcijų pravardes  
(use '[clojure.string :rename {
  replace str-replace, split str-split, reverse str-reverse
}])

;; Klaidų ir sėkmės pranešimų medis
(def messages {
  "en.UTF-8" {
    :err "Error! Script execution was terminated!"
    :succ "Successfully finished!"
  }
  "lt_LT.UTF-8" {
    :err "Klaida! Scenarijaus vykdymas sustabdytas!"
    :succ "Komanda sėkmingai įvykdyta!"
  }
})

;; Pranešimai pagal aplinkos kalbos nuostatą
(def lang (System/getenv "LANG"))
(def errorMessage (get-in messages [lang :err]))
(def successMessage (get-in messages [lang :succ]))

;; Išorinių komandų iškvietimo funkcija
(defn runCmd [cmdArg]
  ;; Sukuriama komanda iš funkcijos argumento
  (def command (str "sudo " cmdArg))
  
  ;; Generuojamas skirtukas iš "-" simbolių
  ;; (Str/replace command #"." "-") - sukuria neują eilutę,
  ;; bet kurį "command" eilutės simbolį pakeisdamas "-"
  (def separator (str-replace command #"." "-"))

  ;; Išvedama komanda, apsupta skirtuko eilučių
  (println (str separator "\n" command "\n" separator "\n"))

  ;; Įvykdoma komanda, proceso statusas išsaugomas į kintamąjį
  (def exitCode (-> (ProcessBuilder. (str-split command #" ")) .inheritIO .start .waitFor))

  ;; Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  (if (not(= exitCode 0)) (
    (println (str "\n" errorMessage "\n"))
    (System/exit 99)
  ))

  ;; Kitu atveju išvedamas sėkmės pranešimas
  (println (str "\n" successMessage "\n"))
)

(println)

;; Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
(runCmd "apt-get update")
(runCmd "apt-get upgrade -y")
(runCmd "apt-get autoremove -y")
(runCmd "snap refresh")
