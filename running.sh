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

decrypt_shc() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.shc}"

  shc -e -f "$input" -o "$output"

  echo "Success: Decryption of $(basename "$input") completed using shc."
  echo "Decrypted file saved as: $output"
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

decrypt_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.eval}"

  eval "$(cat "$input")" > "$output"

  echo "Success: Decryption of $(basename "$input") completed using eval."
  echo "Decrypted file saved as: $output"
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

decrypt_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.base64}"

  base64 -d "$input" > "$output"

  echo "Success: Decryption of $(basename "$input") completed using base64."
  echo "Decrypted file saved as: $output"
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

decrypt_random_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.random_eval}"

  eval "$(grep -o '".*"' "$input" | sed 's/"//g')" > "$output"

  echo "Success: Decryption of $(basename "$input") completed using random eval."
  echo "Decrypted file saved as: $output"
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

decrypt_random_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.random_base64}"

  sed 's/^.* //' "$input" | base64 -d > "$output"

  echo "Success: Decryption of $(basename "$input") completed using random base64."
  echo "Decrypted file saved as: $output"
}

encrypt_base64_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.base64_base64"

  base64 "$input" | base64 > "$output"

  echo "Success: Encryption of $(basename "$input") completed using base64+base64."
  echo "Encrypted file saved as: $output"
}

decrypt_base64_base64() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.base64_base64}"

  base64 -d "$input" | base64 -d > "$output"

  echo "Success: Decryption of $(basename "$input") completed using base64+base64."
  echo "Decrypted file saved as: $output"
}

encrypt_eval_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.eval_eval"

  eval "echo \"$(eval "echo \"$(cat "$input")\"")\"" > "$output"

  echo "Success: Encryption of $(basename "$input") completed using eval+eval."
  echo "Encrypted file saved as: $output"
}

decrypt_eval_eval() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.eval_eval}"

  eval "$(eval "$(grep -o '".*"' "$input" | sed 's/"//g')")" > "$output"

  echo "Success: Decryption of $(basename "$input") completed using eval+eval."
  echo "Decrypted file saved as: $output"
}

encrypt_shc_shc() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input}.shc_shc"

  shc -r -f "$input" -o - | shc -r -o "$output"

  echo "Success: Encryption of $(basename "$input") completed using shc+shc."
  echo "Encrypted file saved as: $output"
}

decrypt_shc_shc() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <file_location>"
    exit 1
  fi

  input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File '$input' not found."
    exit 1
  fi

  output="${input%.shc_shc}"

  shc -e -f "$input" -o - | shc -e -o "$output"

  echo "Success: Decryption of $(basename "$input") completed using shc+shc."
  echo "Decrypted file saved as: $output"
}

echo ""
echo "Choose encryption/decryption method:"
echo "1. shc"
echo "2. eval"
echo "3. base64"
echo "4. random eval"
echo "5. random base64"
echo "6. base64+base64"
echo "7. Eval+Eval"
echo "8. shc+shc"

read -p "Enter your choice (1/2/3/4/5/6/7/8): " choice
echo ""
case $choice in
  1) method="shc" ;;
  2) method="eval" ;;
  3) method="base64" ;;
  4) method="random_eval" ;;
  5) method="random_base64" ;;
  6) method="base64_base64" ;;
  7) method="eval_eval" ;;
  8) method="shc_shc" ;;
  *) echo "Invalid choice. Please select 1, 2, 3, 4, 5, 6, 7, or 8." ;;
esac

read -p "Enter the file location: " file_location

case $method in
  shc) encrypt_shc "$file_location" ;;
  eval) encrypt_eval "$file_location" ;;
  base64) encrypt_base64 "$file_location" ;;
  random_eval) encrypt_random_eval "$file_location" ;;
  random_base64) encrypt_random_base64 "$file_location" ;;
  base64_base64) encrypt_base64_base64 "$file_location" ;;
  eval_eval) encrypt_eval_eval "$file_location" ;;
  shc_shc) encrypt_shc_shc "$file_location" ;;
  shc) decrypt_shc "$file_location" ;;
  eval) decrypt_eval "$file_location" ;;
  base64) decrypt_base64 "$file_location" ;;
  random_eval) decrypt_random_eval "$file_location" ;;
  random_base64) decrypt_random_base64 "$file_location" ;;
  base64_base64) decrypt_base64_base64 "$file_location" ;;
  eval_eval) decrypt_eval_eval "$file_location" ;;
  shc_shc) decrypt_shc_shc "$file_location" ;;
  *) echo "Invalid method." ;;
esac
