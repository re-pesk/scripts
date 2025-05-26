#!/usr/bin/env bash

sudo apt-get update
# Jeigu nėra instaliuotas, instaliuojamas paketas 'apt-transport-https'
[[ $(apt list --installed 2>/dev/null | grep -P '^apt-transport-https' | wc -l ) -gt 0 ]] || \
  sudo apt-get install apt-transport-https
# Diegiamas raktas ir Darto šaltinis
[ -s "/usr/share/keyrings/dart.gpg" ] || \
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |\
  sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
[ -s "/etc/apt/sources.list.d/dart_stable.list" ] || \
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' |\
  sudo tee /etc/apt/sources.list.d/dart_stable.list
# Instaliuojamas Dartas 
sudo apt-get update && 
  ([[ $(apt list --installed 2>/dev/null | grep -P '^dart' | wc -l ) -gt 0 ]] || \
    sudo apt-get install dart)
# Tikrinamas Darto veikimas
echo ; dart --version

