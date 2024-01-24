#!/bin/bash

# Define the input and output file paths
addr_file="addr.txt"
winroute_file="winroute.cfg"
output_file="missingaddr.txt"

# Remove spaces and empty lines from addr.txt
sed -i '/^\s*$/d; s/ //g' "$addr_file"

# Remove missingaddr.txt if it already exists
if [ -f "$output_file" ]; then
  rm "$output_file"
fi

# Read addr.txt line by line and check if it exists in winroute.cfg
while IFS= read -r line; do
  grep -qF "$line" "$winroute_file" || echo "$line" >> "$output_file"
done < "$addr_file"