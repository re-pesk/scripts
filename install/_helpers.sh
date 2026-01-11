ask_to_install() {
  local current_version="${1}"
  local version="${2}"
  local app_name="${3}"
  local install_dir="${4}"
  local to_install=""
  # If the app is not working
  if [ "${current_version}" == "" ]; then
    printf "\n${app_name} is not installed. Do you want to install v${version}?"
  # If the app is working, but installed not in the specified directory
  elif [ ! -d "${install_dir}" ]; then
    printf "\n${app_name} v${current_version} is installed, but not in ${install_dir}. Delete it first manually and then run this script again.\n"
    to_install="n"
  # If the app is working and installed in the specified directory
  else
    printf "\n${app_name} v${current_version} is installed. Do you want overwrite it with v${version}?"
  fi
  # If the program is not installed differently than specified int this script.
  if [ "${to_install}" != "n" ]; then
    printf "\nPrint 'y' to install, 'n' or <Enter> to exit: \e[s"
    read -e -r to_install
    [[ "${to_install}" == "" ]] && printf "\e[u<Enter>\n"
  fi
  # If the program will not be installed.
  [[ "${to_install}" != "y" ]] && { printf "\nNo changes were made.\n\n"; exit 0; }
  # If the program will be installed.
  printf "\nInstalling ${app_name} v${version}\n\n"
}

# The awk commands ($3 and $4) must be quoted in single quotes to prevent expansion of variables
compare_sha256() {
  app_file="${1}"
  checksum_file="${2}"
  awk_1='{print $1}'
  awk_2='{print $1}'
  [[ "${3}" == "" ]] || awk_1="${3}"
  [[ "${4}" == "" ]] || awk_2="${4}"
  # Calculate the SHA256 checksum of the file
  local sha256sum_calculated="$(sha256sum "${app_file}" | awk "${awk_1}")"
  # Read the SHA256 checksum from the file
  local sha256sum_from_file="$(cat "${checksum_file}" | awk "${awk_2}")"
  # If the checksums do not match, print an error message and exit the script
  [[ "${sha256sum_calculated}" == "${sha256sum_from_file}" ]] || {
    printf "\n%s\n\n" "Checksum mismatch!"
    exit 1
  }
  # If the checksums match, print a success message
  printf "\n%s\n\n" "Checksum match!"
}

# Use 'single quotes' to prevent expansion of variables.
# app_dir must be in 'single quotes'.
# file name must be in "double quotes".
# Example: insert_path '${HOME}/.opt/ballerina/bin' 'ballerina' "${HOME}/.pathrc"
insert_path() {
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
