#!/usr/bin/env -S julia

module sysUpgrade

  import Printf: @printf

  messages = Dict(
    "en.UTF-8" => Dict(
      "err" => "Error! Script execution was terminated!",
      "succ" => "Successfully finished!",
    ),
    "lt_LT.UTF-8" => Dict(
      "err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
      "succ" => "Komanda sėkmingai įvykdyta!",
    ),
  )

  function runCmd(cmdArgStr, langMessages)

    command = "sudo $cmdArgStr"
    separator = repeat("-", length(command))
    @printf("%s\n%s\n%s\n\n", separator, command, separator)

    cmdArgs = split(cmdArgStr, " ")
    objCmd = Cmd(`sudo $cmdArgs`, ignorestatus=true)

    proc = run(objCmd)
    code = proc.exitcode

    if code != 0
      @printf("\n%s\n\n", langMessages["err"])
      exit(code)
    end
    
    @printf("\n%s\n\n", langMessages["succ"])

  end

  Base.@ccallable function main()::Cint

    lang = ENV["LANG"]
    langMessages = messages[lang]

    println()

    runCmd("apt-get update", langMessages)
    runCmd("apt-get upgrade -y", langMessages)
    runCmd("apt-get autoremove -y", langMessages)
    runCmd("snap refresh", langMessages) 
  end

end
