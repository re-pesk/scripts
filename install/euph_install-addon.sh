#!/usr/bin/env -S bash

for addon in $@ ;do
  app_name="$addon"
  euph_dir="euphoria"
  install_dir="${HOME}/.local/${euph_dir}"
  initial_dir="$PWD"
  tmp_dir="${HOME}/Projektai"
  repo_dir="${tmp_dir}/${app_name}"
  cd "$tmp_dir"


  echo -e "\nCompiling ${app_name^}\n"
  echo -e "Current directory => $PWD\n"

  [ -d "$repo_dir" ] && rm --recursive --force "$repo_dir"

  git clone https://github.com/OpenEuphoria/${app_name}
  cd "$repo_dir"
  echo -e "\nCurrent directory: $PWD\n"
  ./configure
  make
  cd "$tmp_dir"
  mv "${repo_dir}/build/${app_name}" "${install_dir}/bin"
  rm --recursive --force "$repo_dir"

  cd "$initial_dir"

  echo -e "\nCurrent directory: $PWD\n"

  echo -e "${app_name^} is installed!"
done
