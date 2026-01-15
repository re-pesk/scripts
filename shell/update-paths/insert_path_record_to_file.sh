#!/usr/bin/env bash

insert_path_record_to_file() {
  # Use 'single quotes' to prevent expansion of variables.
  # app_dir  must be in single quotes.
  # File name must be in double quotes
  app_dir="${1}"
  app_name="${2}"
  file_name="${3}"

  # Check if the record already exists in the file
  [[ "$(grep -F "${app_dir}" < "${file_name}" | wc -l)" > 0 ]] && return 0

  # Delete record from the file if it exists, creating a backup
  sed --in-place=".$(date +"%Y%m%d-%H%M%S-%3N")" "/#begin ${app_name} init/,/#end ${app_name} init/d"  "${file_name}"

  # Delete empty lines from the file
  sed --in-place '/^[[:space:]]*$/N; /^\n$/D' "${file_name}"
  # Add an empty line to the file, if it doesn't already exist
  [[ "$( tail -n 1 "${file_name}" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${file_name}"

  # Append the record to the file
  printf '#begin '"${app_name}"' init

[[ ":${PATH}:" == *":'"${app_dir}"':"* ]] \
  || export PATH="'"${app_dir}"'${PATH:+:${PATH}}"

#end '"${app_name}"' init\n\n' >> "${file_name}"
}

# Create copy of the file to prevent overwriting the original file
cp -T "${HOME}/.pathrc" "${HOME}/.pathrc_test"
printf '${HOME}/.opt/scala3/bin' 'scala' "${HOME}/.pathrc_test"

# Use 'single quotes' to prevent expansion of variables. File name must be in double quotes
insert_path_record_to_file '${HOME}/.opt/scala3/bin' 'scala' "${HOME}/.pathrc_test"
