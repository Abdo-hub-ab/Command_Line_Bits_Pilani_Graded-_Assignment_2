#!/usr/bin/env bash

file="input.txt"

if [ ! -e "$file" ]; then
  echo "Error: File does not exist: $file"
  exit 1
fi

if [ ! -r "$file" ]; then
  echo "Error: File is not readable: $file"
  exit 1
fi

words=$(mktemp)

# Extract words (letters only), lowercase, one word per line
tr -cs '[:alpha:]' '\n' < "$file" | tr '[:upper:]' '[:lower:]' | sed '/^$/d' > "$words"

if [ ! -s "$words" ]; then
  echo "Error: No words found in $file"
  rm -f "$words"
  exit 1
fi

longest=$(awk 'length($0)>max{max=length($0); w=$0} END{print w}' "$words")
shortest=$(awk 'NR==1{min=length($0); w=$0} length($0)<min{min=length($0); w=$0} END{print w}' "$words")

total_words=$(wc -l < "$words")
total_chars=$(awk '{sum+=length($0)} END{print sum+0}' "$words")
avg_len=$(awk -v c="$total_chars" -v w="$total_words" 'BEGIN{printf "%.2f", c/w}')

unique_words=$(sort "$words" | uniq | wc -l)

echo "Longest word: $longest"
echo "Shortest word: $shortest"
echo "Average word length: $avg_len"
echo "Total number of unique words: $unique_words"

rm -f "$words"

