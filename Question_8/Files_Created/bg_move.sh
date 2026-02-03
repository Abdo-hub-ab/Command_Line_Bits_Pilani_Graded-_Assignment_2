#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Error: Please provide exactly ONE directory path."
  echo "Usage: ./bg_move.sh <directory>"
  exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
  echo "Error: Directory does not exist: $dir"
  exit 1
fi

backup_dir="$dir/backup"
mkdir -p "$backup_dir"

echo "Script PID ( $$ ): $$"

# Move each file into backup/ in background
for f in "$dir"/*; do
  if [ -f "$f" ]; then
    mv "$f" "$backup_dir/" &
    echo "Started background move for $(basename "$f") with PID: $!"
  fi
done

echo "Waiting for all background processes to finish..."
wait
echo "All background processes finished."
