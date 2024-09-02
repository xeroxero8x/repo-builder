#!/bin/bash

# Function to delete older .zst files, keeping only the latest and one older version
cleanup_old_versions() {
    # Navigate to the target directory
    cd "$USER_HOME/$REPO_DIR/$ARCH" || exit

    # Find all .zst files and process them
    for file in $(ls *.zst 2> /dev/null | sort -V | uniq -w 20); do
        # Extract the base name of the file (without version, -debug, and extension)
        base_name=$(echo "$file" | sed -r 's/-[0-9]+.*//')
        is_debug=$(echo "$file" | grep -o '\-debug' || echo "")

        # Append -debug to the base name if the file is a debug package
        if [ -n "$is_debug" ]; then
            base_name="${base_name}-debug"
        fi

        # Find all versions of this base file, sorted by version
        versions=($(ls "$base_name"-*.zst 2> /dev/null | sort -V))

        # If there are more than two versions, delete the older ones
        if [ ${#versions[@]} -gt 2]; then
            echo "Keeping latest and one older version of $base_name:"
            echo "Latest: ${versions[-1]}"
            echo "One older: ${versions[-2]}"
            for ((i=0; i<${#versions[@]}-2; i++)); do
                echo "Deleting: ${versions[i]}"
                rm -f "${versions[i]}"
            done
        fi
    done
}

# Main script
clean() {
    cleanup_old_versions
}

clean
