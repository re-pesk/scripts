[Atgal](./readme.md)

# Groovy [&#x2B67;](https://groovy-lang.org/)

* Paskiausias leidimas: 4.0.26
* Išleista: 2025-02-25

## Diegimas

```bash
version="4.0.26"
# Įrašykite norimą versiją
# Versijos numerį galima rasti "https://groovy.apache.org/download.html#distro"
wget -qO "groovy-sdk-${version}.zip" \
  "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${version}.zip" 

unzip "groovy-sdk-${version}.zip" -d "$HOME"
mv -T "${HOME}/groovy-${version}" "${HOME}/.groovy"
rm "groovy-sdk-${version}.zip"

echo '#begin groovy init

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ":${PATH}:" == *":${HOME}/.groovy/bin:"* ]] \
  || export PATH="${HOME}/.groovy/bin${PATH:+:${PATH}}"

#end groovy init' >> "${HOME}/.bashrc"

export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
export PATH="${HOME}/.groovy/bin${PATH:+:${PATH}}"

unset version

groovy -version
```

arba

```bash
bash groovy_install.sh
```

## Paleistis

```bash
groovy kodo-failas.groovy
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env groovy
```

arba

```bash
///usr/bin/env groovy "$0" "$@"; exit $?
```
