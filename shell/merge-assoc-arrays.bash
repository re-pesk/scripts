#!/usr/bin/env bash

# Proposed solution https://stackoverflow.com/a/79352629/29179535 in the thread on the Stack Overflow
# https://stackoverflow.com/questions/29804909/how-to-combine-associative-arrays-in-bash/79352629#79352629

declare -Ar array1=( [5]=true [10]=true ["15 and ab"]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=true )

echo "${array1[@]@K}"

# convert both associative arrays to new associative array
declare -A array_both="("${array1[@]@K}" "${array2[@]@K}")"

# show array definition
declare -p array_both

# iterate on array
for key in "${!array_both[@]}"; do
  echo "array_both[${key}]=${array_both[${key}]}" 
done
