#!/usr/bin/env -S bash

app_name="euphoria"
install_dir="${HOME}/.opt/${app_name}"
initial_dir="$PWD"
tmp_dir="/tmp"
repo_dir="${tmp_dir}/${app_name}"
cd "$tmp_dir"

echo -e "\nInstalling euphoria 4.2 to ${install_dir}\n"
echo -e "Current directory => $PWD\n"

echo -e "Cloning git repository of Euphoria 4.2\n"

[ -d "$repo_dir" ] && rm --recursive --force "$repo_dir"

git clone https://github.com/OpenEuphoria/euphoria "$app_name"

echo -e "\nCompiling Euphoria 4.2\n"

cd "${repo_dir}/source"
echo -e "Current directory => $PWD\n"
./configure
make

echo -e "Copying compiled files to bin\n"

find build -maxdepth 1 -type f ! -name "*.*" -exec mv -t ../bin/ {} \+
# find build -maxdepth 1 -type f -exec mv -t "${repo_dir}/bin" {} \+
cd "${repo_dir}/bin"

echo -e "Current directory => $PWD\n"

for file in *.{ex,exw} ;do
  [ -f "${file%.*}" ] && continue
  ./euc "$file"
  exit_code="$?"
  if [[ "$exit_code" > 0 ]]; then
    exit "$exit_code"
  fi 
done

cd "${tmp_dir}"

echo -e "Current directory => $PWD\n"

echo -e "Replacing Euphoria 4.1 with 4.2\n"

[ -d "${install_dir}" ] && mv -T "${install_dir}" "${install_dir}-4.1"
mv "$repo_dir" $HOME/.opt/

echo -e "eui --version => \n"; eui --version
echo -e "euc --version => \n"; euc --version

echo -e "Updating config file\n"

cd "${install_dir}/source"
echo -e "Current directory => $PWD\n"
./configure
find build -maxdepth 1 -type f -exec mv -t "${install_dir}/bin/" {} \+
rm --recursive --force build

sed -i 's/source\/build/bin/g' "${install_dir}/bin/eu.cfg"

rm --recursive --force "${install_dir}-4.1"

cd $initial_dir

echo -e "\nCurrent directory => $PWD\n"

echo -e "Euphoria 4.2 is installed!\n"
