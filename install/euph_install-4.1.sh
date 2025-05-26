#!/usr/bin/env -S bash

owner="OpenEuphoria"
app_name="euphoria"
json="$(curl -sL https://api.github.com/repos/${owner}/${app_name}/releases/latest)"
url="$(echo "$json" | jq -r '.assets[] | select(.name | contains("Linux-x64")) | .browser_download_url' )"
version="$(echo "$json" | jq -r '.tag_name' )"

install_dir="${HOME}/.opt/${app_name}"

config_file="${HOME}/.pathrc"
[ -f "$config_file" ] || touch "config_file"
# [ -f "$HOME/.pathrc" ] || touch "$HOME/.pathrc"
initial_dir="$PWD"

echo -e "\nInstalling ${app_name^} ${version}\n"
echo -e "Current directory => ${initial_dir}\n"

echo -e "Getting latest release\n"

[ -d "$install_dir" ] && rm --recursive --force "$install_dir"

curl -sSLo - "$url" \
| tar --transform "flags=r;s/^(euphoria)-$version[^\/]+x64/\1/x" --show-transformed-names -xzC "${HOME}/.opt"

touch "${install_dir}/v${version}.txt"

echo -e "Updating config file\n"

cd "${install_dir}/source"
./configure
find build -maxdepth 1 -type f -exec mv -t ../bin/ {} \+
rm --recursive --force build
cd "${install_dir}/bin"
sed -i 's/source\/build/bin/g' eu.cfg

echo -e "Compiling files\n"

for file in *.ex ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi 
done

cd $initial_dir

echo -e "\nWriting path to .pathrc\n"

set_path='[[ ":${PATH}:" == *":${HOME}/.opt/'"${app_name}"'/bin:"* ]] \
  || export PATH="${HOME}/.opt/'"${app_name}"'/bin${PATH:+:${PATH}}"'

config_strings="#begin ${app_name} init

${set_path}

#end ${app_name} init"

readarray -td '
' PATTERN <<< "$config_strings"

sed -i "/${PATTERN[0]}/,/${PATTERN[@]: -1:1}/c\\" "$config_file"

[[ "$( tail -n 1 "$config_file" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "$config_file"

echo "$config_strings" >> "$config_file"

eval $"$set_path"

echo -e "eui --version => "; eui --version
echo -e "\neuc --version => "; euc --version

cd $initial_dir

echo -e "\nCurrent directory => $PWD\n"

echo -e "${app_name^} ${version} is installed!\n"
