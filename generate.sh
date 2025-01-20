#!/bin/bash

# Output file
OUTPUT_FILE="prompt.txt"

# Clear existing output file
> "$OUTPUT_FILE"

# Separator
SEPARATOR="---"

# Function to append file path and content
append_file() {
    local file="$1"
    echo "$SEPARATOR" >> "$OUTPUT_FILE"
    echo "File: $(realpath "$file")" >> "$OUTPUT_FILE"
    echo "$SEPARATOR" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
}

# Find and append .swift files excluding Pods directory
find "$(pwd)" -type f -name "*.swift" ! -path "*/Pods/*" | while read -r file; do
    append_file "$file"
done

# Append Podfile if it exists
if [ -f "Podfile" ]; then
    append_file "Podfile"
fi

# Append README.md if it exists
if [ -f "README.md" ]; then
    append_file "README.md"
fi

# Append Info.plist files excluding Pods directory
find "$(pwd)" -type f -name "Info.plist" ! -path "*/Pods/*" | while read -r file; do
    append_file "$file"
done

echo "prompt.txt has been generated successfully."

