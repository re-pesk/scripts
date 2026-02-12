#!/usr/bin/perl
use strict;
use warnings;

# Klaidų ir sėkmės pranešimų medis
my $messages = {
  'en.UTF-8' => {
    'err' => "Error! Script execution was terminated!",
    'succ' => "Successfully finished!",
  },
  'lt_LT.UTF-8' => {
    'err' => "Klaida! Scenarijaus vykdymas sustabdytas!",
    'succ' => "Komanda sėkmingai įvykdyta!",
  },
};

# Aplinkos kalbos nuostata
my $lang = $ENV{'LANG'};

# Pranešimai, atitinkantys aplinkos kalbą
my $errorMessage = $messages->{$lang}->{'err'};
my $successMessage = $messages->{$lang}->{'succ'};

# Išorinių komandų iškvietimo funkcija
sub runCmd {
  
  #Funkcijos argumentas išsaugomas į kintamajame
  my ($cmdArg) = @_;

  # Sukuriama komandos tekstinė eilutė iš funkcijos argumento
  my $command = "sudo $cmdArg";
  
  # Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  # length($command) - komandos ilgis
  my $separator = "-" x length($command);

  # Išvedama komandos eilutė, apsupta skirtuko eilučių
  print "\n$separator\n$command\n$separator\n\n";

  # Įvykdoma komanda, įvykdytos komandos išėjimo kodas išsaugomas kintamajame
  my $exitCode = system($command);
  
  # Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiams programos vykdymas
  $exitCode == 0 or die "\n$errorMessage\n\n";

  # Kitu atveju išvedamas sėkmės pranešimas
  print "\n$successMessage\n\n";
}


print "";

# Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
runCmd("apt-get update");
runCmd("apt-get upgrade -y");
runCmd("apt-get autoremove -y");
runCmd("snap refresh");
