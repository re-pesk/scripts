#! /usr/bin/env elvish

use str

var messages = [
  &en.UTF-8= [
    &succ= "Successfully finished!"
    &err= "Error! Script execution was terminated!"
  ]
  &lt_LT.UTF-8= [
    &succ= "Komanda sėkmingai įvykdyta!"
    &err= "Klaida! Scenarijaus vykdymas sustabdytas!"
  ]
]
var lang = (get-env LANG)
var errorMessage = $messages[$lang][err]
var successMessage = $messages[$lang][succ]

# echo $messages
# exit

var runCmd = {| param |

  # Sukuria komandos tekstinę eilutę iš funkcijos argumento
  var command = "sudo "$param

  # (count $command) grąžina eilutės ilgį
  # str:repeat  - generuoja seką iš "-" simbolių
  var separator = (str:repeat "-" (count $command) )
  
  # spausdina separatorių ir komandos eilutę
  echo $separator "\n" $command "\n" $separator "\n" &sep=''
  
  # vykdo komandą
  try {
    sudo (str:split ' ' $param)
  } catch err {
      # komanda įvykdyta nesėkmingai
      # echo $err[reason][exit-status] # spausdinama klaidos priežastis
      echo "\n"$errorMessage"\n" # išvedamas klaidos pranešimas
      exit 99
  } else {
    echo "\n"$successMessage"\n"
  }
}

echo

$runCmd "apt-get update"
$runCmd "apt-get upgrade -y"
$runCmd "apt-get autoremove -y"
$runCmd "snap refresh"
