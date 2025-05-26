module sys_upgrade;

import core.stdc.stdlib;
import std.array;
import std.process;
import std.stdio;

void main()
{

  const auto messages = [
    "en.UTF-8": [
      "err": "Error! Script execution was terminated!",
      "succ": "Successfully finished!"
    ],
    "lt_LT.UTF-8": [
      "err": "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ": "Komanda sėkmingai įvykdyta!"
    ]
  ];

  const auto lang = environment.get("LANG");
  const auto errMsg = messages[lang]["err"];
  const auto succMsg = messages[lang]["succ"];

  void runCmd(string cmdStr)
  {
    const auto command = "sudo " ~ cmdStr;
    const auto separator = replicate("-", command.length);
    writefln("%s\n%s\n%s\n", separator, command, separator);

    auto pipesPid = spawnShell(command);

    const auto code = wait(pipesPid);

    if (code != 0)
    {
      writefln("\n%s\n", errMsg);
      exit(99);
    }

    writefln("\n%s\n", succMsg);

  }

  writeln();

  runCmd("apt-get update");
  runCmd("apt-get upgrade -y");
  runCmd("apt-get autoremove -y");
  runCmd("snap refresh");

}
