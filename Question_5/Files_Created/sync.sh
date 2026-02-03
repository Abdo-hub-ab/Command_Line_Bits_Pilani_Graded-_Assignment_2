#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
  echo "Error: Please provide exactly TWO directory paths."
  echo "Usage: ./sync.sh <dirA> <dirB>"
  exit 1
fi

dirA="$1"
dirB="$2"

if [ ! -d "$dirA" ] || [ ! -d "$dirB" ]; then
  echo "Error: Both arguments must be existing directories."
  exit 1
fi

listA=$(mktemp)
listB=$(mktemp)

# List only files (not folders) directly inside each directory
find "$dirA" -maxdepth 1 -type f -printf "%f\n" | sort > "$listA"
find "$dirB" -maxdepth 1 -type f -printf "%f\n" | sort > "$listB"

echo "Files present only in $dirA:"
comm -23 "$listA" "$listB"

echo
echo "Files present only in $dirB:"
comm -13 "$listA" "$listB"

echo
echo "Files present in both directories (content check):"
comm -12 "$listA" "$listB" | while read -r fname; do
  if diff -q "$dirA/$fname" "$dirB/$fname" >/dev/null 2>&1; then
    echo "$fname -> MATCH"
  else
    echo "$fname -> DIFFER"
  fi
done

rm -f "$listA" "$listB"
