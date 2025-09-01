#!/bin/sh
# ralphie-stream.sh
# Author: Steven Olsen
# GitHub: https://github.com/OlsenSM91
# Streams adjectivenoun000..999 to stdout immediately.

ADJECTIVE_FILE="${1:-adjective_large.txt}"
NOUN_FILE="${2:-noun_large.txt}"
START="${3:-0}"
END="${4:-999}"

# Validate input files
if [ ! -f "$ADJECTIVE_FILE" ]; then
  echo "Adjective file not found: $ADJECTIVE_FILE" >&2
  exit 1
fi
if [ ! -f "$NOUN_FILE" ]; then
  echo "Noun file not found: $NOUN_FILE" >&2
  exit 1
fi
if [ "$START" -gt "$END" ]; then
  echo "Start ($START) cannot be greater than End ($END)" >&2
  exit 1
fi

# Read files into arrays (trim blank lines)
# POSIX sh doesn't have arrays, so use while/read loops
while IFS= read -r adj; do
  [ -n "$adj" ] && adjectives="${adjectives}${adj}\n"
done < "$ADJECTIVE_FILE"

while IFS= read -r noun; do
  [ -n "$noun" ] && nouns="${nouns}${noun}\n"
done < "$NOUN_FILE"

# Generate and stream combinations
# printf handles zero-padding with %03d
printf "%s" "$adjectives" | while IFS= read -r adj; do
  printf "%s" "$nouns" | while IFS= read -r noun; do
    i="$START"
    while [ "$i" -le "$END" ]; do
      printf "%s%s%03d\n" "$adj" "$noun" "$i"
      i=$((i + 1))
    done
  done
done