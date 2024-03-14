#!/bin/bash

sleep 1
echo ""
echo " Universal-Encryption-Shell V2.0 "
echo ""
sleep 2

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

encrypt_random_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.random_eval"

  random_variable=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  eval "$random_variable=\"$(cat "$input")\"" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using random eval."
  echo "Encrypted file saved as: $output"
}

encrypt_random_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.random_base64"

  random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  base64 "$input" | sed "s/^/$random_string/" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using random base64."
  echo "Encrypted file saved as: $output"
}

encrypt_random_shc() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.random_shc"

  shc -r -f "$input" -o "$output"

  echo "Success: Encryption of $(basename "$input") completed using random shc."
  echo "Encrypted file saved as: $output"
}

echo ""
echo "Choose encryption method:"
echo "1. shc"
echo "2. eval"
echo "3. base64"
echo "4. random eval"
echo "5. random base64"
echo "6. random shc"  # Added option for random shc

read -p "Enter your choice (1/2/3/4/5/6): " choice
echo ""
case $choice in
  1) method="shc" ;;
  2) method="eval" ;;
  3) method="base64" ;;
  4) method="random_eval" ;;
  5) method="random_base64" ;;
  6) method="random_shc" ;;  # Added case for random shc
  *) echo "Invalid choice. Please select 1, 2, 3, 4, 5, or 6." ;;
esac

read -p "Enter the file location: " file_location

case $method in
  shc) encrypt_shc "$file_location" ;;
  eval) encrypt_eval "$file_location" ;;
  base64) encrypt_base64 "$file_location" ;;
  random_eval) encrypt_random_eval "$file_location" ;;
  random_base64) encrypt_random_base64 "$file_location" ;;
  random_shc) encrypt_random_shc "$file_location" ;;  # Added case for random shc
  *) echo "Invalid encryption method." ;;
esac
