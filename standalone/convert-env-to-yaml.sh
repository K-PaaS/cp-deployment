#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" ]]; then
  echo "Usage: $0 <input_env.sh> <output.yml>"
  exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Error: Input file not found: $INPUT_FILE"
  exit 1
fi

echo "" > "$OUTPUT_FILE"
 
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*# ]]; then
    continue
  fi

  if [[ -z "$line" ]]; then
    continue
  fi

  if [[ "$line" =~ ^([A-Za-z0-9_]+)=(.*)$ ]]; then
    VAR="${BASH_REMATCH[1]}"
    VAL="${BASH_REMATCH[2]}"
  else
    continue
  fi

  VAR_LOWER=$(echo "$VAR" | tr 'A-Z' 'a-z')

  if [[ -z "$VAL" ]]; then
    echo "${VAR_LOWER}: \"\"" >> "$OUTPUT_FILE"
  else
    echo "${VAR_LOWER}: \"${VAL}\"" >> "$OUTPUT_FILE"
  fi

done < "$INPUT_FILE"
