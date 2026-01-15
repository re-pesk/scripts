#!/usr/bin/env bash

create_file_for_paths() {
  config_file="${1}"
  paths_file="${2}"

    # If the record already exists in the file, return from the function
  [[ "$(grep "#begin include ${paths_file}" < "${HOME}/${config_file}" | wc -l)" > 0 ]] && return 0

  # Create the file for the paths if it doesn't exist
  [ -f "${HOME}/${paths_file}" ] || touch "${HOME}/${paths_file}"

  # Create a backup of the config file
  cp -T "${HOME}/${config_file}" "${HOME}/${config_file}.$(date +"%Y%m%d-%H%M%S-%3N")"

  # Delete empty lines from the file
  sed --in-place '/^[[:space:]]*$/N; /^\n$/D' "${HOME}/${config_file}"

  # Add an empty line to the end of the file, if it doesn't already exist
  [[ "$( tail -n 1 "${HOME}/${config_file}" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${HOME}/${config_file}"

  # Append the record to the file
  [[ "$(grep "#begin include ${paths_file}" < "${HOME}/${config_file}" | wc -l)" > 0 ]] \
    || printf '#begin include '"${paths_file}"'

if [ -f "${HOME}/'"${paths_file}"'" ]; then
  . ${HOME}/'"${paths_file}"'
fi

#end include '"${paths_file}"'\n\n' >> "${HOME}/${config_file}"
}

# Create copy of the file for test to prevent overwriting the original file
cp -T "${HOME}/.bashrc" "${HOME}/.bashrc_test"
printf '\nCreating separate file for paths\n
Configuration file: %s
Paths file: %s\n\n' '.bashrc_test' '.pathrc_test'

create_file_for_paths '.bashrc_test' '.pathrc_test'
