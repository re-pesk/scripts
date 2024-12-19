import 'dart:io';
import 'dart:convert';

// Klaidų ir sėkmės pranešimų tekstų rinkinys
const messages = {
  'en.UTF-8': {
    'err': "Error! Script execution was terminated!",
    'succ': "Successfully finished!",
  },
  'lt_LT.UTF-8': {
    'err': "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ': "Komanda sėkmingai įvykdyta!",
  },
};

// Aplinkos kintamasis, nurodantis kalbą
Map<String, String> env = Platform.environment;
var lang = env["LANG"];

// Klaidų ir sėkmės pranešimų tekstai pagal pasirinktą kalbą
var langMessages = messages[lang];

runCmd(String cmdArg) async {
  var command = "sudo $cmdArg";
  var separator = "-" * command.length;
  print("$separator\n$command\n$separator\n");

  var process = await Process.start("sudo", cmdArg.split(' '));
  process.stdout.transform(utf8.decoder).forEach(stdout.write);
  process.stderr.transform(utf8.decoder).forEach(stderr.write);

  var exitCode = await process.exitCode;

  if (exitCode > 0) {
    print("\n${langMessages?['err']}\n");
    exit(99);
  }

  print("\n${langMessages?['succ']}\n");
}

// Programos įeigos taškas
void main() async {
  // Kviečiamos programos
  print("");

  await runCmd("apt-get update");
  await runCmd("apt-get upgrade -y");
  await runCmd("apt-get autoremove -y");
  await runCmd("snap refresh");
}
