#!/usr/bin/env zsh

declare -Ar array1=( [5]=true [10]=true ["15 and ab"]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=true )

# convert both associative arrays to new associative array
declare -A array_both=(${(kv)array1} ${(kv)array2})

# show array definition
declare -p array_both

# iterate on array
for key val in "${(@kv)array_both}"; do
  echo "array_both[${key}]=$val"
done
