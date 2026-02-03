#!/usr/bin/env bash

file="marks.txt"

if [ ! -e "$file" ]; then
  echo "Error: File does not exist: $file"
  exit 1
fi

if [ ! -r "$file" ]; then
  echo "Error: File is not readable: $file"
  exit 1
fi

failed_one=0
passed_all=0
failed_more=0

echo "Students who failed in exactly ONE subject:"
echo "-----------------------------------------"

while IFS=',' read -r roll name m1 m2 m3; do
  [ -z "$roll" ] && continue

  fail_count=0
  [ "$m1" -lt 33 ] && fail_count=$((fail_count+1))
  [ "$m2" -lt 33 ] && fail_count=$((fail_count+1))
  [ "$m3" -lt 33 ] && fail_count=$((fail_count+1))

  if [ "$fail_count" -eq 1 ]; then
    echo "$roll, $name"
    failed_one=$((failed_one+1))
  elif [ "$fail_count" -eq 0 ]; then
    passed_all=$((passed_all+1))
  else
    failed_more=$((failed_more+1))
  fi
done < "$file"

echo
echo "Students who passed in ALL subjects:"
echo "-----------------------------------"

while IFS=',' read -r roll name m1 m2 m3; do
  [ -z "$roll" ] && continue
  if [ "$m1" -ge 33 ] && [ "$m2" -ge 33 ] && [ "$m3" -ge 33 ]; then
    echo "$roll, $name"
  fi
done < "$file"

echo
echo "Counts:"
echo "Failed exactly one subject: $failed_one"
echo "Passed all subjects:        $passed_all"
echo "Failed in 2 or 3 subjects:  $failed_more"
