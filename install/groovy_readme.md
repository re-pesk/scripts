[Atgal](./readme.md)

# Groovy [&#x2B67;](https://groovy-lang.org/)

* Paskiausias leidimas: 4.0.26
* Išleista: 2025-02-25

## Diegimas

```bash
version="4.0.26"
install_dir=".opt/groovy"
# Įrašykite norimą versiją
# Versijos numerį galima rasti "https://groovy.apache.org/download.html#distro"
wget -qO "groovy-sdk-${version}.zip" \
  "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-${version}.zip" 

unzip "groovy-sdk-${version}.zip" -d "/tmp"
mv -T "/tmp/groovy-${version}" "${HOME}/$install_dir"
rm "groovy-sdk-${version}.zip"

echo '#begin groovy init

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

[[ ":${PATH}:" == *":${HOME}/'${install_dir}'/bin:"* ]] \
  || export PATH="${HOME}/'${install_dir}'/bin${PATH:+:${PATH}}"

#end groovy init' >> "${HOME}/.bashrc"

[ -z "$JAVA_HOME" ] \
&& export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
[[ ":${PATH}:" == *":${HOME}/${install_dir}/bin:"* ]] \
export PATH="${HOME}/${install_dir}/bin${PATH:+:${PATH}}"

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
