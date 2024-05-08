#!/bin/sh

# Function to search and delete files by mask
search_and_delete_files() {
  local dir="$1"
  local mask="*\.tmp"

  # Find files matching the mask and delete them
  find "$dir" -type f -name "$mask" -delete

  echo "Files matching the mask have been deleted."
}

# Prompt user for directory path
read -p "Enter the directory path: " directory

# Call the function with user input
search_and_delete_files "$directory"