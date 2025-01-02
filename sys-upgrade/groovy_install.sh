#!/usr/bin/env bash

version="4.0.24"
file="apache-groovy-sdk-$version.zip"
tmpfile="/tmp/$file"
url="https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/$file"
configfile="$HOME/.bashrc"

groovy -version > /dev/null 2>&1; status="$?"
[[ "$status" -eq 0 ]] && echo "Groovy's jau įdiegtas!" && exit

java -version > /dev/null 2>&1; status="$?"
[[ "$status" -gt 0 ]] && echo "Pirmiau įdiekite Javą!" && exit

wget --version > /dev/null 2>&1; status="$?"
[[ "$status" -gt 0 ]] && echo "Pirmiau įdiekite Wget!" && exit

[ -f "$tmpfile" ] && rm $tmpfile
wget -qO $tmpfile $url
[ ! -f "$tmpfile" ] && echo "Failo $file atsiųsti nepavyko!" && exit

[ -d "$HOME/.groovy" ] && rm --recursive "$HOME/.groovy"
[ -d "$HOME/groovy-$version" ] && rm --recursive "$HOME/groovy-$version"

unzip "$tmpfile" -d "$HOME" > /dev/null
[ -f "$tmpfile" ] && rm "$tmpfile"

[ -d "$HOME/groovy-$version" ] && mv -T "$HOME/groovy-$version" "$HOME/.groovy"
[ ! -d "$HOME/.groovy" ] && echo "Katalogas $HOME/.groovy nebuvo sukurtas!" && exit

set_java_home='[ -z "${JAVA_HOME}" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"'
set_path='[[ ! ":$PATH:" == *":$HOME/.groovy/bin:"* ]] \
  && export PATH="$HOME/.groovy/bin${PATH:+:${PATH}}"'

configstrings="#begin groovy init

${set_java_home}

${set_path}

#end groovy init"

readarray -td '
' PATTERN <<< "$configstrings"

sed -i "/${PATTERN[0]}/,/${PATTERN[@]: -1:1}/c\\" "$configfile"
echo "$configstrings" >> "$configfile"

eval $"$set_java_home"
eval $"$set_path"

groovy -version
