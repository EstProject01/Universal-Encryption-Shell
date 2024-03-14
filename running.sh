#!/bin/bash

encrypt_shc() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.shc"

  shc -r -f "$input" -o "$output"

  echo "Success: Encryption of $(basename "$input") completed using shc."
  echo "Encrypted file saved as: $output"
}

encrypt_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.eval"

  eval "echo \"$(cat "$input")\"" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using eval."
  echo "Encrypted file saved as: $output"
}

encrypt_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.base64"

  base64 "$input" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using base64."
  echo "Encrypted file saved as: $output"
}

echo ""
echo "Choose encryption method:"
echo "1. shc"
echo "2. eval"
echo "3. base64"
echo ""

read -p "Enter your choice (1/2/3): " choice

case $choice in
  1) method="shc" ;;
  2) method="eval" ;;
  3) method="base64" ;;
  *) echo "Invalid choice. Please select 1, 2, or 3." ;;
esac

read -p "Enter the file location: " file_location

case $method in
  shc) encrypt_shc "$file_location" ;;
  eval) encrypt_eval "$file_location" ;;
  base64) encrypt_base64 "$file_location" ;;
  *) echo "Invalid encryption method." ;;
esac
