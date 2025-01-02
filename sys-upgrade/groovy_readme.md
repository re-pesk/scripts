[Atgal](./readme.md)

# Groovy [&#x2B67;](https://groovy-lang.org/)

## Diegimas

```bash
# version="4.0.24"
# Vietoje $version visur įrašykite norimą versiją
wget -qO "groovy-sdk-$version.zip" \
  "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-$version.zip" 

unzip "groovy-sdk-$version.zip" -d "$HOME"
mv -T "$HOME/groovy-$version" "$HOME/.groovy"
rm "groovy-sdk-$version.zip"

echo '#begin groovy init

[ -z "${JAVA_HOME}" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ! ":$PATH:" == *":$HOME/.groovy/bin:"* ]] \
  && export PATH="$HOME/.groovy/bin${PATH:+:${PATH}}"

#end groovy init' >> "$HOME/.bashrc"

export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
export PATH="$HOME/.groovy/bin${PATH:+:${PATH}}"

groovy -version
```

arba

```bash
bash groovy_install.sh
```

## Paleistis

```bash
```
