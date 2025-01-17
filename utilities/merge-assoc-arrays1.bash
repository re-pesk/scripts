#!/usr/bin/env bash

declare -Ar array1=( [5]=true [10]=true [15]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=true )

# convert both associative arrays to combined string
printf -v array_both_string '[%s]="%s" ' "${array1[@]@k}" "${array2[@]@k}"

# create new associative array from string
declare -A array_both="($array_both_string)"

# show array definition
declare -p array_both

# iterate on array
for key in "${!array_both[@]}"; do
    echo "array_both[${key}]=${array_both[${key}]}"
done
