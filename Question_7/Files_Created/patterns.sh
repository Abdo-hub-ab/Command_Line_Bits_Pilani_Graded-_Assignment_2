#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Error: Please provide exactly ONE input text file."
  echo "Usage: ./patterns.sh <inputfile>"
  exit 1
fi

file="$1"

if [ ! -e "$file" ]; then
  echo "Error: File does not exist: $file"
  exit 1
fi

if [ ! -r "$file" ]; then
  echo "Error: File is not readable: $file"
  exit 1
fi

: > vowels.txt
: > consonants.txt
: > mixed.txt

# Convert text to lowercase words (letters only) and classify
tr -cs '[:alpha:]' '\n' < "$file" | tr '[:upper:]' '[:lower:]' | sed '/^$/d' | awk '
{
  w=$0
  if (w ~ /^[aeiou]+$/) {
    print w >> "vowels.txt"
  } else if (w ~ /^[bcdfghjklmnpqrstvwxyz]+$/) {
    print w >> "consonants.txt"
  } else if (w ~ /^[bcdfghjklmnpqrstvwxyz]/ && w ~ /[aeiou]/ && w ~ /[bcdfghjklmnpqrstvwxyz]/) {
    print w >> "mixed.txt"
  }
}
'

echo "Created: vowels.txt, consonants.txt, mixed.txt"

