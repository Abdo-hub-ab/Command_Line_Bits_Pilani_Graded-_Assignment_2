#!/usr/bin/env bash
# analyze.sh - accepts exactly ONE command-line argument.
# If argument is a file: display number of lines, words, and characters.
# If argument is a directory: display total number of files and number of .txt files.
# If invalid argument count or path does not exist: display an appropriate error message.

# 1) Validate argument count
if [ "$#" -ne 1 ]; then
  echo "Error: Please provide exactly ONE argument (file or directory path)."
  echo "Usage: ./analyze.sh <path>"
  exit 1
fi

path="$1"

# 2) Validate existence
if [ ! -e "$path" ]; then
  echo "Error: Path does not exist: $path"
  exit 1
fi

# 3) If file -> show lines, words, chars
if [ -f "$path" ]; then
  if [ ! -r "$path" ]; then
    echo "Error: File is not readable: $path"
    exit 1
  fi

  echo "Type: File"
  echo "Path: $path"
  echo "Lines:      $(wc -l < "$path")"
  echo "Words:      $(wc -w < "$path")"
  echo "Characters: $(wc -m < "$path")"
  exit 0
fi

# 4) If directory -> total files + .txt files
if [ -d "$path" ]; then
  if [ ! -r "$path" ]; then
    echo "Error: Directory is not readable: $path"
    exit 1
  fi

  # Count only regular files directly inside the directory (not recursive)
  total_files=$(find "$path" -maxdepth 1 -type f 2>/dev/null | wc -l)
  txt_files=$(find "$path" -maxdepth 1 -type f -name "*.txt" 2>/dev/null | wc -l)

  echo "Type: Directory"
  echo "Path: $path"
  echo "Total files: $total_files"
  echo ".txt files:  $txt_files"
  exit 0
fi

# 5) Other types (links/devices/etc.)
echo "Error: Path is neither a regular file nor a directory: $path"
exit 1
