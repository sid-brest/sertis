#!/bin/bash

# Function to delete files and directories recursively and print output
delete_recursively() {
    local path="$1"
    if [ -d "$path" ]; then
        for item in "$path"/*; do
            delete_recursively "$item"
        done
    fi
    rm -rf "$path"
    echo "Deleted: $path"
}

# Main function to search and delete files and directories within .recycle directories
delete_files_in_recycle_directories() {
    local folder="$1"
    local recycle_dirs=$(find "$folder" -type d -name ".recycle")

    
    for i in "${!recycle_dirs[@]}"; do
    delete_recursively "${recycle_dirs[i]}"
    done
    
    #for recycle_dir in $recycle_dirs; do
     #   delete_recursively "$recycle_dir"
    #done
}

# Usage: ./script.sh <folder_path>
# Example: ./script.sh /path/to/folder
folder_path="$1"

delete_files_in_recycle_directories "$folder_path"