#!/bin/bash

# Function to generate a random string
generate_random_string() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w "$1" | head -n 1
}

# Function to display error message and exit the program
error_exit() {
    echo "$1" >&2
    exit 1
}

# Function to prompt the user to select a file location
select_file() {
    echo ""
    echo "Please select the file location:"
    read  -p "Enter the file path: " file_path
}

# Function to check if the selected file exists
check_file_existence() {
    if [ ! -f "$file_path" ]; then
        error_exit "Error: File not found at the specified location."
    fi
}

# Function to confirm the file selection with the user
confirm_file_selection() {
    echo ""
    echo "You have selected the file: $file_path"
    read -p "Is this the correct file? (yes/no): " confirmation
    if [ "$confirmation" != "yes" ]; then
        select_file
        check_file_existence
        confirm_file_selection
    fi
}

# Selecting the file location
select_file

# Checking if the selected file exists
check_file_existence

# Confirming the file selection with the user
confirm_file_selection

# Function for encrypting using Base64
encrypt_base64() {
    base64 "$file_path" > "$file_path.enc"
    echo "Encryption using Base64 completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using shc
encrypt_shc() {
    shc -f "$file_path" -o "$file_path.enc"
    echo "Encryption using shc completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using Base64+shc
encrypt_base64_shc() {
    base64 "$file_path" | shc -o "$file_path.enc" -
    echo "Encryption using Base64+shc completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using random eval
encrypt_random_eval() {
    random_string=$(generate_random_string 8)
    echo -n "$random_string=\"$(base64 "$file_path" | tr -d '\n')\";" > "$file_path.enc"
    echo "$random_string=\$(echo \$$random_string | base64 -d)" >> "$file_path.enc"
    echo "Encryption using random eval completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using Base64+random eval
encrypt_base64_random_eval() {
    random_string=$(generate_random_string 8)
    echo -n "$random_string=\"$(base64 "$file_path" | tr -d '\n')\";" > "$file_path.enc"
    echo "$random_string=\$(echo \$$random_string | base64 -d)" >> "$file_path.enc"
    echo "Encryption using Base64+random eval completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using eval
encrypt_eval() {
    echo -n 'eval "$(echo -n "' > "$file_path.enc"
    cat "$file_path" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_path.enc"
        echo -n "\\n" >> "$file_path.enc"
    done
    echo -n ' | base64 -d)"' >> "$file_path.enc"
    echo '"' >> "$file_path.enc"
    echo "Encryption using eval completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using eval+shc
encrypt_eval_shc() {
    echo -n 'eval "$(echo -n "' > "$file_path.enc"
    cat "$file_path" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_path.enc"
        echo -n "\\n" >> "$file_path.enc"
    done
    echo -n ' | base64 -d)"' >> "$file_path.enc"
    echo '"' >> "$file_path.enc"
    echo "Encryption using eval+shc completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using random hash
encrypt_random_hash() {
    hash_key=$(generate_random_string 32)
    openssl enc -aes-256-cbc -salt -in "$file_path" -out "$file_path.enc" -k "$hash_key"
    echo "Encryption using random hash completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using random Base64
encrypt_random_base64() {
    random_key=$(generate_random_string 16)
    echo "$random_key" | base64 | tr -d '\n' > "$file_path.enc.key"
    openssl enc -base64 -aes-256-cbc -salt -in "$file_path" -out "$file_path.enc" -pass "file:$file_path.enc.key"
    echo "Encryption using random Base64 completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using random shc
encrypt_random_shc() {
    random_key=$(generate_random_string 100)
    shc -f "$file_path" -o "$file_path.enc" -r "$random_key"
    echo "Encryption using random shc completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using eval+Base64+eval+shc
encrypt_eval_base64_eval_shc() {
    echo -n 'eval "$(echo -n "' > "$file_path.enc"
    cat "$file_path" | while read -r line; do
        echo -n "$line" | base64 | tr -d '\n' >> "$file_path.enc"
        echo -n "\\n" >> "$file_path.enc"
    done
    echo -n ' | base64 -d | eval)"' >> "$file_path.enc"
    echo '"' >> "$file_path.enc"
    echo "Encryption using eval+Base64+eval+shc completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using shc+random hash
encrypt_shc_random_hash() {
    random_key=$(generate_random_string 32)
    shc -f "$file_path" -o "$file_path.enc" -r "$random_key"
    echo "Encryption using shc+random hash completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using Base64+Base64
encrypt_base64_base64() {
    base64 "$file_path" | base64 > "$file_path.enc"
    echo "Encryption using Base64+Base64 completed. Encrypted file: '$file_path.enc'"
}

# Function for encrypting using Base64+eval+Base64
encrypt_base64_eval_base64() {
    echo -n 'echo -n "' > "$file_path.enc"
    cat "$file_path" | base64 | tr -d '\n' >> "$file_path.enc"
    echo -n '" | base64' >> "$file_path.enc"
    echo "Encryption using Base64+eval+Base64 completed. Encrypted file: '$file_path.enc'"
}

# Displaying the menu for selecting the encryption method
echo ""
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
echo "11. Encrypt using eval+Base64+eval+shc"
echo "12. Encrypt using shc+random hash"
echo "13. Encrypt using Base64+Base64"
echo "14. Encrypt using Base64+Eval+Base64"
read -p "Enter your choice (1 to 14): " choice

# Running the encryption function based on user choice
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
