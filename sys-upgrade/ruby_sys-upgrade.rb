#! /usr/bin/env -S ruby

messages = {
  :"en.UTF-8" => {
    :"err" => "Error! Script execution was terminated!",
    :"succ" => "Successfully finished!",
  },
  :"lt_LT.UTF-8" => {
    :"err" => "Klaida! Scenarijaus vykdymas sustabdytas!",
    :"succ" => "Komanda sėkmingai įvykdyta!",
  },
}

lang = ENV['LANG']
@errorMessage = messages[:"#{lang}"][:err]
@successMessage = messages[:"#{lang}"][:succ]

def runCmd(cmdArg)
  command = "sudo #{cmdArg}"
  # separator = command.gsub(/./, '-')
  separator = '-' * command.length 
  puts separator, command, separator, ""

  status = system( command )
  
  if !status
    puts "", @errorMessage, ""
    exit(99)
  end

  puts "", @successMessage, ""
end

puts

runCmd("apt-get update")
runCmd("apt-get upgrade -y")
runCmd("apt-get autoremove -y")
runCmd("snap refresh")
