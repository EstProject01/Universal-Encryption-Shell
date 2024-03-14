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

  output="${input}.enc.sh"

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

  output="${input}.enc.sh"

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

  output="${input}.enc.sh"

  base64 "$input" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using base64."
  echo "Encrypted file saved as: $output"
}

sleep 1
echo "Encryption-Shell-EstProject V1.0"
sleep 2
echo ""
echo "Choose encryption method:"
echo "1. shc"
echo "2. eval"
echo "3. base64"
echo ""

read -p "Enter your choice (1/2/3): " choice

case $choice in
  1) encrypt_shc "$1" ;;
  2) encrypt_eval "$1" ;;
  3) encrypt_base64 "$1" ;;
  *) echo "Invalid choice. Please select 1, 2, or 3." ;;
esac