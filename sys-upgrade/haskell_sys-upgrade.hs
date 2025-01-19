#!/usr/bin/env -S runghc -- --

import System.Environment (getEnv)
import System.Exit (exitWith, ExitCode(..))
import System.Process (spawnProcess, waitForProcess)
import System.IO (hFlush, stdout)

-- Klaidų ir sėkmės pranešimų medis
messages :: [(String, (String, String))]
messages = [
    ("en.UTF-8", ("Error! Script execution was terminated!", "Successfully finished!")),
    ("lt_LT.UTF-8", ("Klaida! Scenarijaus vykdymas sustabdytas!", "Komanda sėkmingai įvykdyta!"))
  ]


-- Funkcija, kuri grąžina pranešimus pagal kalbos nuostatą
getMessages :: String -> (String, String)
getMessages lang = 
  case lookup lang messages of
    Just msgs -> msgs
    Nothing   -> ("Error! Unknown language!", "Success!")

-- Funkcija, kuri suskaido eilutę, naudodamą kaip skirtuką duotą simbolį
split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = split cs delim

-- Išorinių komandų iškvietimo funkcija
runCmd :: String -> IO ()
runCmd cmdArg = do
  -- Sukuriama komandos tekstinė eilutė
  let command = "sudo " ++ cmdArg
  
  -- Sukuriamas komandos ilgio skirtukas iš "-" simbolių
  let separator = replicate (length command) '-'
  
  -- Išvedama komandos eilutė, apsupta skirtuko eilučių
  putStrLn $ separator ++ "\n" ++ command ++ "\n" ++ separator ++ "\n"
  hFlush stdout
  
  -- Įvykdoma komanda
  process <- spawnProcess "sudo" (split cmdArg ' ')
  exitCode <- waitForProcess process
  
  -- Gaunama aplinkos kalbos nuostata
  lang <- getEnv "LANG"

  -- Gaunamos pranešimų eilutės pagal kalbos nuostatas
  let (errorMessage, successMessage) = getMessages lang
  
  -- Patikrinama, ar komanda buvo sėkminga
  -- Jeigu vykdant komandą įvyko klaida, išvedamas klaidos pranešimas ir nutraukiamas programos vykdymas
  -- Kitu atveju išvedamas sėkmės pranešimas
  case exitCode of
    ExitSuccess -> putStrLn $ "\n" ++ successMessage ++ "\n"
    ExitFailure _ -> do
      putStrLn $ "\n" ++ errorMessage ++ "\n"
      exitWith (ExitFailure 99)

main :: IO ()
main = do
  putStrLn ""

  -- Komandų vykdymo funkcijos iškvietimai su vykdomų komandų duomenimis
  runCmd "apt-get update"
  runCmd "apt-get upgrade -y"
  runCmd "apt-get autoremove -y"
  runCmd "snap refresh"

