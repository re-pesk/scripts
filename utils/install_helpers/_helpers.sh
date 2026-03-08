# shellcheck shell=bash

# DEBUG: production mode - null or unset, debug mode - any other value
DEBUG="${DEBUG:-}"

APP_NAME="${APP_NAME:-}"
CURRENT="${CURRENT:-}"
LATEST="${LATEST:-}"

# If there are no messages, source the messages file
if [ -z "${MESSAGES[*]}" ]; then
  # shellcheck disable=SC1094
  UTILS_DIR="$(cd -- "$(realpath "${BASH_SOURCE[0]}" | xargs dirname)" &> /dev/null && pwd )"
  . "${UTILS_DIR}/_messages.sh"
fi

# Prints an info message
: <<"USAGE"
infoMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
infoMessage "Info!"
infoMessage "Info!" "my_function"
EXAMPLE

infoMessage() {
  printf "%s%s\n\n" "${2}" "${1}" 1>&2
}

# Prints a warning message
: <<"USAGE"
warningMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
warningMessage "Warning!"
warningMessage "Warning!" "my_function"
EXAMPLE

warningMessage() {
  printf "%s\033[33m%s\033[39m\n\n" "${2}" "${1}" 1>&2
}

# Prints an error message
: <<"USAGE"
errorMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
errorMessage "Error!"
errorMessage "Error!" "my_function"
EXAMPLE
errorMessage() {
  printf "%s\033[31m%s\033[39m\n\n" "${2}" "${1}" 1>&2
}

# Prints a success message
: <<"USAGE"
successMessage <MESSAGE> ?<FUNCTION_NAME>
USAGE
: <<"EXAMPLE"
successMessage "Success!"
successMessage "Success!" "my_function"
EXAMPLE

successMessage() {
  printf "%s\033[32m%s\033[39m\n\n" "${2}" "${1}" 1>&2
}

# Check if the commands are available
: <<"USAGE"
check_command <COMMAND_1> ...
USAGE
: <<"EXAMPLE"
check_command curl xargs
EXAMPLE

check_command() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not commands
  readarray -t NOT_COMMANDS < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(compgen -c | sort -u))

  # If there are names not in the commands' list, exit the script
  (( ${#NOT_COMMANDS[@]} > 0 )) && {
    errorMessage "$(
      printf '%s\n\n  %s\n\n' \
      "${LANG_MESSAGES[missing_commands]}" \
      "${NOT_COMMANDS[*]}"
      )" "${FUNC_NAME}"
    exit 1
  }

  exit 0
)

# Check if the packages are installed
: <<"USAGE"
check_package <PACKAGES_LIST>
USAGE
: <<"EXAMPLE"
check_package gcc make
EXAMPLE

check_package() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not packages
  readarray -t NOT_PKGNAMES < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(apt-cache pkgnames | sort -u ))

  # If there are names that are not packages, exit the script
  (( ${#NOT_PKGNAMES[@]} > 0 )) && {
    errorMessage "$(
      printf '%s\n\n  %s\n\n' \
      "${LANG_MESSAGES[erroneous_names]}" \
      "${NOT_PKGNAMES[*]}"
      )" "${FUNC_NAME}"
    exit 1
  }

  # Get names of the packages that are not installed
  readarray -t NOT_INSTALLED < <( printf "%s\n" "${NAMES[@]}" "${NOT_PKGNAMES[@]}" | sort | uniq -u |
    grep -Fvxf <( dpkg-query -f '${Package}\n' -W 2> /dev/null | sort -u ))

  # If there are packages that are not installed, exit the script
  (( ${#NOT_INSTALLED[@]} > 0 )) && {
    errorMessage "$(
      printf '%s\n\n  %s\n\n' \
      "${LANG_MESSAGES[missing_packages]}" \
      "${NOT_INSTALLED[*]}"
      )" "${FUNC_NAME}"
    exit 1
  }

  exit 0
)

# Returns a list of packages that are not installed
: <<"USAGE"
packages_to_install <PACKAGES_LIST>
USAGE
: <<"EXAMPLE"
packages_to_install gcc make
EXAMPLE

packages_to_install() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  # Get names
  readarray -t NAMES < <( printf '%s\n' "$@" | sort -u )

  # Get names that are not packages
  readarray -t NOT_PKGNAMES < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(apt-cache pkgnames | sort -u ))

  # If there are packages that are not installed, exit the script
  (( ${#NOT_PKGNAMES[@]} > 0 )) && {
    errorMessage "$(
      printf '%s\n\n  %s\n\n' \
      "${LANG_MESSAGES[erroneous_names]}" \
      "${NOT_PKGNAMES[*]}"
      )" "${FUNC_NAME}"
    exit 1
  }

  # Get names of the packages that are not installed
  readarray -t NOT_INSTALLED < <( printf "%s\n" "${NAMES[@]}" "${NOT_PKGNAMES[@]}" | sort | uniq -u |
    grep -Fvxf <( dpkg-query -f '${Package}\n' -W 2> /dev/null | sort -u ))

  # If there are names that are not packages, exit the script
  (( ${#NOT_INSTALLED[@]} > 0 )) && {
    printf '%s\n' "${NOT_INSTALLED[@]}"
    exit 0
  }

  exit 1
)

install_missing_packages() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  # If there are no arguments, exit the script
  # shellcheck disable=SC2128
  (( $# > 0)) || {
    errorMessage "${LANG_MESSAGES[missing_arguments]}" "${FUNC_NAME}"
    exit 1
  };

  readarray -t NOT_INSTALLED < <(packages_to_install "$@")
  (( ${#NOT_INSTALLED[@]} > 0 )) && {
    sudo apt-get install -y "${NOT_INSTALLED[@]}"
    errorMessage "${LANG_MESSAGES[missing_packages_are_not_installed]}" "${FUNC_NAME}"
    exit 1
  }
  exit 0
)

# Cleanup function
: << "USAGE"
trap cleanup EXIT
USAGE

cleanup() {
  # shellcheck disable=SC2164
  [[ -n "${INIT_DIR}" ]] && [[ -d "${INIT_DIR}" ]] && cd "${INIT_DIR}"
  [[ -n "${TMP_DIR}" ]] && [[ -d "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"
}

# Ask the user to install a program.
: << "USAGE"
ask_to_install <COMMAND NAME> <INSTALL DIR>
USAGE
: << "EXAMPLE"
ask_to_install "bal" "${HOME}/.opt/ballerina"
EXAMPLE

ask_to_install() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  local -r COMMAND_NAME="${1}"
  local -r COMMAND_PATH="$(command -v "${COMMAND_NAME}"| xargs realpath)"
  local -r INSTALL_DIR="${2}"
  local TO_CONTINUE=""

  # Vykdoma išeinant iš funkcijos
  # shellcheck disable=SC2329
  on_exit() {
    EXIT_CODE=$?
    (( EXIT_CODE > 0 )) && warningMessage "${LANG_MESSAGES[no_changes]}" "${FUNC_NAME}"
    exit "${EXIT_CODE}"
  }
  trap on_exit EXIT

  # If there is no command name, exit the script
  [[ -z "${COMMAND_NAME}" ]] && {
    errorMessage "${LANG_MESSAGES[no_command_name]}" "${FUNC_NAME}"
    exit 1
  }

  # If there is no installation directory, exit the script
  [[ -z "${INSTALL_DIR}" ]] && {
    errorMessage "${LANG_MESSAGES[no_install_dir]}" "${FUNC_NAME}"
    exit 1
  }

  if [[ -z "${CURRENT}" ]]; then
    # The current version is not provided
    if [[ -n "${COMMAND_PATH}" ]]; then
      # but the command path is found
      # This is a contradiction, so you are asked to check the app code, and the script is exited
      errorMessage "${LANG_MESSAGES[no_current]}" "${FUNC_NAME}"
      exit 1
    fi
    # The current version is not provided,
    # so app is not installed and you are asked to install a new version
    infoMessage \
      "${LANG_MESSAGES[install_new]}" \
      "${FUNC_NAME}"
  fi

  if [[ -z "${COMMAND_PATH}" ]]; then
    # The current version is provided
    # but the command path is not found, so app is not installed
    # This is a contradiction, so you are asked to check the app code, and the script is exited
    errorMessage \
      "${LANG_MESSAGES[no_app]}" \
      "${FUNC_NAME}"
    exit 1
  fi

  # The command path is found, the current version is provided, app is installed,
  # but the installation directory is different.
  # so you are asked about deleting the current version manually, and the script is exited
  if [[ ! "${COMMAND_PATH}" =~ ^${INSTALL_DIR}.*$ ]]; then
    infoMessage \
    "${LANG_MESSAGES[installed_not_in_dir]//'{INSTALL_DIR}'/"${INSTALL_DIR}"}" \
    "${FUNC_NAME}"
    exit 1
  else
    # and the installation directory is the same as the directory of the current version
    # so you are asked about overwriting the current version
    infoMessage "${LANG_MESSAGES[overwrite]}" "${FUNC_NAME}"
  fi

  # If the program is not installed or this installation directory is not different from ${INSTALL_DIR},
  # ask the user to install the program.
  if [[ "${TO_CONTINUE}" != "n" ]]; then
    printf '%s: \e[s' "${LANG_MESSAGES[prompt]}" 1>&2
    read -e -r TO_CONTINUE
    [[ "${TO_CONTINUE}" == "" ]] && printf '\e[u%s\n' "${LANG_MESSAGES[enter]}" 1>&2
    echo ""
  fi

  # If the user does not want to continue, print a message and exit the script.
  if [[ "${TO_CONTINUE}" != "y" ]]; then
    exit 1
  fi

  # If the installation will be continued, print a info message.
  infoMessage \
    "${LANG_MESSAGES[installing]}" \
    "${FUNC_NAME}"
)

# Compare checksums of a file.
# The awk commands ($3 and $4) must be quoted with single quotes inside
# and use escaped \$ to prevent expansion of variables
: << "USAGE"
compare_checksum_strings <CHECKSUM_1> <CHECKSUM_2> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
compare_checksum_strings \
  "0cf2650e53c353b0643ce1c518c99852 hilbish-v2.3.4-linux-amd64.tar.gz" \
  "sha256:0cf2650e53c353b0643ce1c518c99852" "'{print \$1}'" "-F':' '{print \$2}'"
EXAMPLE

compare_checksum_strings() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  # Check if the checksums are provided
  for i in {1..2}; do
    if [[ -z "${!i}" ]] ; then
      errorMessage "${LANG_MESSAGES[empty_parameter]//'{i}'/${i}}" "${FUNC_NAME}"
      exit 1
    fi
  done
  CHECKSUM_1="${1}"
  CHECKSUM_2="${2}"

  # shellcheck disable=SC2016
  AWK_1="'{print"'$1'"}'"
  # shellcheck disable=SC2016
  AWK_2="'{print"'$1'"}'"

  [[ "${3}" == "" ]] || AWK_1="${3}"
  [[ "${4}" == "" ]] || AWK_2="${4}"

  [ -n "${DEBUG}" ] && {
    echo "AWK_1:$AWK_1" 1>&2
    echo "AWK_2:$AWK_2" 1>&2
  }

  CHECKSUM_1="$(bash -c "awk ${AWK_1}" <<< "${CHECKSUM_1}")"
  CHECKSUM_2="$(bash -c "awk ${AWK_2}" <<< "${CHECKSUM_2}")"

  # If the checksums do not match, print an error message and exit the script
  [[ "${CHECKSUM_1}" != "${CHECKSUM_2}" ]] && {
    errorMessage "${LANG_MESSAGES[mismatch]}" "${FUNC_NAME}"
    exit 1
  }

  # If the checksums match, print a success message
  successMessage "${LANG_MESSAGES[match]}" "${FUNC_NAME}"
)

# Compare checksum of a file with a string.
# The awk commands ($4 and $5) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
check_sums_str <CHECKSUM TYPE> <FILE_NAME> <CHECKSUM_STRING> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sums_str sha1 "./file_name.ext" \
  "sha1:acca7d792b95f66af8c62f261775ef1b6fb0e92c" \
  "'{print \$1}'" "-F':' '{print \$2}'"
EXAMPLE

check_sums_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  [[ -z "${1}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_checksum_type]}" "${FUNC_NAME}"
    exit 1
  }

  [[ -z "${2}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_filename]}" "${FUNC_NAME}"
    exit 1
  }

  if ! compare_checksum_strings "$("${1}" "${2}")" "${3}" "${4}" "${5}"; then
    exit 1
  fi
)

# Compare checksums of a file.
# The awk commands ($4 and $5) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
check_sums <CHECKSUM_TYPE> <FILE_NAME> <CHECKSUM_FILE_NAME> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sums sha1 "./file_name.ext" "./checksum_file_name.ext" "'{print \$1}'" "'{print \$2}'"
EXAMPLE

check_sums() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  [[ -z "${3}" ]] && {
    errorMessage "${LANG_MESSAGES[missing_chksum_fname]}" "${FUNC_NAME}"
    exit 1
  }
  if ! check_sums_str "${1}" "${2}" "$(cat "${3}")" "${4}" "${5}"; then
    exit 1
  fi
)

# Compare SHA1 checksums of a file.
# The awk commands ($3 and $4) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
check_sha1_str <FILE_NAME> <CHECKSUM_STRING> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sha1_str "./file_name.ext" \
  "sha1:acca7d792b95f66af8c62f261775ef1b6fb0e92c" \
  "'{print \$1}'" "-F':' '{print \$2}'"
EXAMPLE

check_sha1_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums_str sha1sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Compare SHA1 checksums of a file.
: << "USAGE"
check_sha1 <FILE_NAME> <CHECKSUM_FILE_NAME> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sha1 "./file_name.ext" "./checksum_file_name.ext" '{print $1}' '{print $1}'
EXAMPLE

check_sha1() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums sha1sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Compare SHA256 checksums of a file.
# The awk commands ($3 and $4) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
check_sha256_str <FILE_NAME> <CHECKSUM_STRING> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sha256_str "./file_name.ext" \
  "a435460ddf3b2b5c1327e5a02f5b0ed69e5196426a5ef7e7b72e9478b68defc6 file_name.ext" \
  "'{print \$1}'" "'{print \$1}'"
EXAMPLE

check_sha256_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums_str sha256sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Compare SHA256 checksums of a file.
: << "USAGE"
check_sha256 <FILE_NAME> <CHECKSUM_FILE_NAME> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_sha256 "./file_name.ext" "./checksum_file_name.ext" "'{print \$1}'" "'{print \$1}'"
check_sha256 "./file_name.ext" "./checksum_file_name.ext" "'{print \$1}'"
check_sha256 "./file_name.ext" "./checksum_file_name.ext"
EXAMPLE

check_sha256() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums sha256sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Compare md5 checksums of a file.
# The awk commands ($3 and $4) must be quoted with single quotes to prevent expansion of variables
: << "USAGE"
compare_md5_str <FILE_NAME> <CHECKSUM_STRING> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
compare_md5_str "./file_name.ext" \
  "md5:a435460ddf3b2b5c1327e5a02f5b0ed69e5196426a5ef7e7b72e9478b68defc6" \
  "'{print \$1}'" "'{print \$2}'"
EXAMPLE

compare_md5_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums_str md5sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Compare md5 checksums of a file.
: << "USAGE"
check_md5 <FILE_NAME> <CHECKSUM_FILE_NAME> ?(<AWK_CODE_1>="'{print \$1}'" ?<AWK_CODE_2>="'{print \$1}'")
USAGE
: << "EXAMPLE"
check_md5 "${./file_name.ext}" "${./checksum_file_name.ext}" "'{print \$1}'" "'{print \$2}'"
EXAMPLE

check_md5() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"
  [ -n "${DEBUG}" ] && printf '"%s"\n' "$FUNC_NAME\$# is $#." "$@" 1>&2

  if ! check_sums md5sum "${1}" "${2}" "${3}" "${4}"; then
    exit 1
  fi
)

# Create a ${HOME}/.pathrc file if it does not exist.
: << "USAGE"
create_file_if_not_exists <FILE_NAME>
USAGE
: << "EXAMPLE"
create_file_if_not_exists "${HOME}/.pathrc"
EXAMPLE

create_file_if_not_exists() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  FILE_NAME="${1}"
  CONTENT="${2}"

  # Create a file if it does not exist
  if [ -f "${FILE_NAME}" ]; then
    infoMessage "${LANG_MESSAGES[file_exists]//'{FILE_NAME}'/"${FILE_NAME}"}" "${FUNC_NAME}"
  else
    touch -c "${FILE_NAME}"
    [ -n "${CONTENT}" ] && printf '%s\n\n' "${CONTENT}" >> "${FILE_NAME}"
  fi
)

# Insert a path record to the certain file.
: << "USAGE"
insert_path_str <FILE NAME> <STRING TO INSERT>
USAGE
: << "EXAMPLE"
insert_path_str "${HOME}/.pathrc" \
'[[ -d "${HOME}/.opt/go/bin" ]] \
  && [[ ":${PATH}:" != *":${HOME}/.opt/go/bin:"* ]] \
  && export PATH="${HOME}/.opt/go/bin${PATH:+:${PATH}}"

[[ -d "${HOME}/.opt/go/bin" ]] \
  && [[ ":${PATH}:" == *":${HOME}/go/bin:"* ]] \
  && export PATH="${HOME}/go/bin${PATH:+:${PATH}}"'
EXAMPLE

insert_path_str() (
  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  FILE_NAME="${1}"
  INSERT_STR="${2}"

  # Check if the record already exists in the file.
  if [[ "$(grep -c -F "#begin ${APP_NAME,,} init" < "${FILE_NAME}")" -gt 0 ]]; then
    infoMessage \
      "${LANG_MESSAGES[record_exists]//'{FILE_NAME}'/"${FILE_NAME}"}" \
      "${FUNC_NAME}"
    exit 0
  fi

  # Create a backup otherwise.
  cp -T "${FILE_NAME}" "${FILE_NAME}.$(date "+%Y%m%d-%H%M%S-%3N")"

  # Delete empty lines from the file
  sed -i '/^[[:space:]]*$/N; /^\n$/D' "${FILE_NAME}"

  # Add an empty line to the file, if it doesn't already exist
  [[ "$( tail -n 1 "${FILE_NAME}" )" =~ ^[[:blank:]]*$ ]] || echo "" >> "${FILE_NAME}"

  # Append the record to the file
  printf '%s\n\n' '#begin '"${APP_NAME,,}"' init

'"${INSERT_STR}"'

#end '"${APP_NAME,,}"' init' >> "${FILE_NAME}"
)

# Insert several paths in one record to the certain file.
: << "COMMENT"
Use 'single quotes' to prevent expansion of variables.
FILE_NAME must be in "double quotes".
Letter case of app_name does not matter.
Other parameters must be in 'single quotes'.
COMMENT
: << "USAGE"
insert_path <FILE NAME> <APP DIR 1> <APP DIR 2> ...
USAGE
: << "EXAMPLE"
insert_path "${HOME}/.pathrc" '${HOME}/.opt/go/bin' '${HOME}/go/bin'
EXAMPLE

insert_path() (

  FUNC_NAME="${DEBUG:+"${FUNCNAME[0]}: "}"

  FILE_NAME="${1}"
  # APP_NAME from variable in outer scope
  shift 1
  APP_DIRS=("$@")

  # Check if the record already exists in the file.
  # shellcheck disable=SC2031
  if [[ "$(grep -c -F "#begin ${APP_NAME,,} init" < "${FILE_NAME}")" -gt 0 ]]; then
    infoMessage "$(
      sed -e "s|{APP_NAME}|${APP_NAME}|g;s|{FILE_NAME}|${FILE_NAME}|g" \
        <<< "${LANG_MESSAGES[record_exists]}"
      )" "${FUNC_NAME}"
    exit 0
  fi

  # Create a string of paths to be added to the PATH variable
  PATH_LIST=""
  # shellcheck disable=SC2068
  for APP_DIR in ${APP_DIRS[@]}; do
    # shellcheck disable=SC2016
    PATH_LIST="${PATH_LIST:+"${PATH_LIST}"$'\n\n'}"'[[ -d "'"${APP_DIR}"'" ]] &&
  [[ ":${PATH}:" != *":'"${APP_DIR}"':"* ]] &&
    export PATH="'"${APP_DIR}"'${PATH:+:${PATH}}"'
  done

  # shellcheck disable=SC2031
  if ! insert_path_str "${FILE_NAME}" "${PATH_LIST}"; then
    exit 1
  fi
)
