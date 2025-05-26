#!/usr/bin/env bash

declare -Ar array1=( [5]=true [10]=true [15]="true and false" )
declare -Ar array2=( [20]=true [25]=true [30]=true )

# convert associative arrays to strings
printf -v a1 '[%s]="%s" ' "${array1[@]@k}"
printf -v a2 '[%s]="%s" ' "${array2[@]@k}"

#combine the two strings
array_both_string="${a1} ${a2}"

# create new associative array from string
eval "declare -A array_both=($array_both_string)"

# show array definition
declare -p array_both

# iterate on array
for key in "${!array_both[@]}"; do
    echo "array_both[${key}]=${array_both[${key}]}"
done
