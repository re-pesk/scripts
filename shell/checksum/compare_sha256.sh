#! /usr/bin/env bash

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

# Standard input
printf "abc\ndef\nghi\njkl\nmno\npqr\nstu\nvwx\nyz\n" > scal.txt
printf "57f6a2d126d6ca0529015f8865391a8e4f8362ca9ecb05a20f67206be6e54d44  scal.txt\n" > scal.txt.sha256

compare_sha256 "scal.txt" "scal.txt.sha256"

rm -f scal.txt*

# BSD style input
printf "abcdefghijklmnopqrstuvwxyz\n" > bal.txt
printf "SHA2-256(shell/check-sum/bal.txt)= 1010a7e761610980ac591359c871f724de150f23440ebb5959ac4c0724c91d91\n" > bal.txt.sha256

compare_sha256 "bal.txt" "bal.txt.sha256" '{print $1}' '{print $NF}'

rm -f bal.txt*
