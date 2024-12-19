#! /usr/bin/env -S zsh

declare -A messages messages=(
  [en.UTF-8.err]="Error! Script execution was terminated!"
  [en.UTF-8.succ]="Successfully finished!"
  [lt_LT.UTF-8.err]="Klaida! Scenarijaus vykdymas sustabdytas!"
  [lt_LT.UTF-8.succ]="Komanda sėkmingai įvykdyta!"
)

errorMessage="${messages[$LANG.err]}"
successMessage="${messages[$LANG.succ]}"

runCmd() {

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  command="sudo $@"

  # generuoja separatorių, visus komandos $command simbolius pakeisdamas "-" simboliu
  separator=${command//?/'-'}

  # spausdina separatorių ir komandos eilutę, -- pasako, kad tolimesnis argumentas, prasidedantis '-', nėra raktas
  printf "%s\n%s\n%s\n\n" "$separator" "$command" "$separator"

  # vykdo komandą
  (sudo $@)

  code="$?"

  # tikrina, ar komanda įvykdyta sėkmingai, $? gražina įvykdymo rezultatą
  if [ $code -gt 0 ]; then
    printf "\n%s\n\n" "$errorMessage" # išvedamas klaidos pranešimas
    exit $code                        # išeinama iš skripto
  fi

  printf "\n%s\n\n" "$successMessage"
  return #grįžtama iš funkcijos
}

echo

runCmd apt-get update
runCmd apt-get upgrade -y
runCmd apt-get autoremove -y
runCmd snap refresh
