#!/usr/bin/env bash

input="emails.txt"
valid_out="valid.txt"
invalid_out="invalid.txt"

if [ ! -e "$input" ]; then
  echo "Error: File does not exist: $input"
  exit 1
fi

if [ ! -r "$input" ]; then
  echo "Error: File is not readable: $input"
  exit 1
fi

# Clear old outputs
: > "$valid_out"
: > "$invalid_out"

# Valid email format: <letters_and_digits>@<letters>.com (underscores allowed)
valid_re='^[A-Za-z0-9_]+@[A-Za-z]+\.com$'

# Extract tokens containing '@' and classify them
grep -Eo '[^[:space:]]+@[^[:space:]]+' "$input" | while read -r email; do
  clean=$(echo "$email" | sed 's/[),.;:!?"]*$//')
  if [[ "$clean" =~ $valid_re ]]; then
    echo "$clean" >> "$valid_out"
  else
    echo "$clean" >> "$invalid_out"
  fi
done

# Remove duplicates from valid.txt
sort -u "$valid_out" -o "$valid_out"

echo "Valid emails saved to: $valid_out"
echo "Invalid emails saved to: $invalid_out"
