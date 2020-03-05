#!/bin/bash

dir="samples"
mkdir -p $dir

for ((i=0;i<$(($2));i++)); do
  file="${1%.*}_$i.${1#*.}"
  echo "Copying $1 to $dir/$file..."
  cp "$1" "$dir/${1%.*}_$i.${1#*.}"
done