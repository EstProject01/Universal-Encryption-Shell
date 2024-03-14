#!/bin/bash

generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$1" | head -n 1
}

encrypt_base64() {
    base64 "$file_to_encrypt" > "$file_to_encrypt.enc"
    echo "Encryption using Base64 completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_shc() {
    shc -f "$file_to_encrypt" -o "$file_to_encrypt.enc"
    echo "Encryption using shc completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_base64_shc() {
    base64 "$file_to_encrypt" | shc -o "$file_to_encrypt.enc" -
    echo "Encryption using Base64+shc completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_random_eval() {
    random_string=$(generate_random_string 8)
    echo -n "$random_string=\"$(base64 "$file_to_encrypt" | tr -d '\n')\";" > "$file_to_encrypt.enc"
    echo "$random_string=\$(echo \$$random_string | base64 -d)" >> "$file_to_encrypt.enc"
    echo "Encryption using random eval completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_base64_random_eval() {
    random_string=$(generate_random_string 8)
    echo -n "$random_string=\"$(base64 "$file_to_encrypt" | tr -d '\n')\";" > "$file_to_encrypt.enc"
    echo "$random_string=\$(echo \$$random_string | base64 -d)" >> "$file_to_encrypt.enc"
    echo "Encryption using Base64+random eval completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_eval() {
    echo -n 'eval "$(echo -n "' > "$file_to_encrypt.enc"
    cat "$file_to_encrypt" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_to_encrypt.enc"
        echo -n "\\n" >> "$file_to_encrypt.enc"
    done
    echo -n ' | base64 -d)"' >> "$file_to_encrypt.enc"
    echo '"' >> "$file_to_encrypt.enc"
    echo "Encryption using eval completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_eval_shc() {
    echo -n 'eval "$(echo -n "' > "$file_to_encrypt.enc"
    cat "$file_to_encrypt" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_to_encrypt.enc"
        echo -n "\\n" >> "$file_to_encrypt.enc"
    done
    echo -n ' | base64 -d)"' >> "$file_to_encrypt.enc"
    echo '"' >> "$file_to_encrypt.enc"
    echo "Encryption using eval+shc completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_random_hash() {
    hash_key=$(generate_random_string 32)
    openssl enc -aes-256-cbc -salt -in "$file_to_encrypt" -out "$file_to_encrypt.enc" -k "$hash_key"
    echo "Encryption using random hash completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_random_base64() {
    random_key=$(generate_random_string 16)
    echo "$random_key" | base64 | tr -d '\n' > "$file_to_encrypt.enc.key"
    openssl enc -base64 -aes-256-cbc -salt -in "$file_to_encrypt" -out "$file_to_encrypt.enc" -pass "file:$file_to_encrypt.enc.key"
    echo "Encryption using random Base64 completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_random_shc() {
    random_key=$(generate_random_string 100)
    shc -f "$file_to_encrypt" -o "$file_to_encrypt.enc" -r "$random_key"
    echo "Encryption using random shc completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_eval_base64_eval_shc() {
    echo -n 'eval "$(echo -n "' > "$file_to_encrypt.enc"
    cat "$file_to_encrypt" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_to_encrypt.enc"
        echo -n "\\n" >> "$file_to_encrypt.enc"
    done
    echo -n ' | base64 -d | eval)"' >> "$file_to_encrypt.enc"
    echo '"' >> "$file_to_encrypt.enc"
    echo "Encryption using eval+base64+eval+shc completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_shc_random_hash() {
    random_key=$(generate_random_string 32)
    shc -f "$file_to_encrypt" -o "$file_to_encrypt.enc" -r "$random_key"
    echo "Encryption using shc+random hash completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_base64_base64() {
    base64 "$file_to_encrypt" | base64 > "$file_to_encrypt.enc"
    echo "Encryption using Base64+Base64 completed. Encrypted file: '$file_to_encrypt.enc'"
}

encrypt_base64_eval_base64() {
    echo -n 'echo -n "' > "$file_to_encrypt.enc"
    cat "$file_to_encrypt" | base64 | tr -d '\n' >> "$file_to_encrypt.enc"
    echo -n '" | base64' >> "$file_to_encrypt.enc"
    echo "Encryption using Base64+Eval+Base64 completed. Encrypted file: '$file_to_encrypt.enc'"
}

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file_to_encrypt>"
  exit 1
fi

file_to_encrypt="$1"

if [ ! -f "$file_to_encrypt" ]; then
  echo "Error: File '$file_to_encrypt' not found."
  exit 1
fi

echo "Choose encryption method:"
echo "1. Encrypt using Base64"
echo "2. Encrypt using shc"
echo "3. Encrypt using Base64+shc"
echo "4. Encrypt using random eval"
echo "5. Encrypt using Base64+random eval"
echo "6. Encrypt using eval"
echo "7. Encrypt using eval+shc"
echo "8. Encrypt using random hash"
echo "9. Encrypt using random Base64"
echo "10. Encrypt using random shc"
echo "11. Encrypt using eval+base64+eval+shc"
echo "12. Encrypt using shc+random hash"
echo "13. Encrypt using Base64+Base64"
echo "14. Encrypt using Base64+Eval+Base64"
read -p "Enter your choice (1 to 14): " choice

case $choice in
  1) encrypt_base64 ;;
  2) encrypt_shc ;;
  3) encrypt_base64_shc ;;
  4) encrypt_random_eval ;;
  5) encrypt_base64_random_eval ;;
  6) encrypt_eval ;;
  7) encrypt_eval_shc ;;
  8) encrypt_random_hash ;;
  9) encrypt_random_base64 ;;
  10) encrypt_random_shc ;;
  11) encrypt_eval_base64_eval_shc ;;
  12) encrypt_shc_random_hash ;;
  13) encrypt_base64_base64 ;;
  14) encrypt_base64_eval_base64 ;;
  *) echo "Invalid choice. Exiting." ;;
esac
