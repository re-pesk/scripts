///usr/bin/env -S haxe --run "${0#.\/}" "$@"; exit $?

// Klaidų ir sėkmės pranešimų medis
var messages = [
  'en.UTF-8' => [
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!",
  ],
  'lt_LT.UTF-8' => [
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!",
  ],
];

// Aplinkos kalbos nuostata
var lang = Sys.getEnv('LANG');

// Pranešimai pagal aplinkos kalbos nuostatą
var errorMessage = messages.get(lang).get('err');
var successMessage = messages.get(lang).get('succ');

// Išorinių komandų iškvietimo funkcija
function runCmd(cmdArg) {

  // Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  var command = 'sudo $cmdArg';

  // Sukuriamas skirtukas, komandos simbolius pakeičiant "-" simboliais
  var separator = (~/./g).replace(command, '-');

  // Išvedama komandos eilutė, apsupta skirtuko eilučių
  Sys.println('$separator\n$command\n$separator\n');

  // Įvykdoma komanda, išėjimo kodas išsaugomas į kintamąjį 
  // final process = new sys.io.Process('sudo', cmdArg.split(' '));
  // final exitCode = process.exitCode();
  // process.close();
  final exitCode = Sys.command('sudo', cmdArg.split(' '));

  // Išvedamas buferio turinys
  Sys.stdout().flush();
  Sys.stderr().flush();

  // Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  if (exitCode != 0) {
    Sys.stderr().writeString('\n$errorMessage\n\n');
    Sys.exit(exitCode);
  }
  
  // Kitu atveju išvedamas sėkmės pranešimas
  Sys.print('\n$successMessage\n\n');
}

// Pagrindinė klasė
class Haxe_sys_upgrade {
  // Pagrindinė funkcija - programos įeigos taškas
  static public function main():Void {
    Sys.println('');
    runCmd("apt-get update");
    runCmd("apt-get upgrade -y");
    runCmd("apt-get autoremove -y");
    runCmd("snap refresh");
  }
}

