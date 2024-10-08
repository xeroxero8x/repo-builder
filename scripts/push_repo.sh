#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Moving to repo directory
cd "$USER_HOME/$REPO_DIR"

# Configure git
git_config() {
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global --add safe.directory "$USER_HOME/$REPO_DIR"
}

# Function to check if Git LFS is installed
check_git_lfs_installed() {
    if ! command -v git-lfs &> /dev/null; then
        echo "Git LFS is not installed. Attempting to install..."
        sudo pacman -S git-lfs --noconfirm
        git lfs install
    else
        git lfs install
    fi
}

# Function to find .zst files larger than 100MB and track them with Git LFS
track_large_files() {
    for file in $(find "$ARCH" -name "*.*"); do
        filesize=$(du -b "$file" | cut -f1)
        if (( filesize > 104857600 )); then
            echo "File $file is larger than 100MB ($((filesize / 1048576))MB)."
            echo "Tracking $file with Git LFS..."
            git lfs track "$file"
            git add "$file"
            git add .gitattributes
        else
            echo "File $file is under 100MB ($((filesize / 1048576))MB). Adding normally..."
            git add "$file"
        fi
    done
}

# Function to commit and push changes
commit_and_push() {
    echo "Committing changes..."
    git commit -m "Add files, tracking large files with Git LFS"
    echo "Pushing to the remote repository..."
    git push https://"$GIT_USERNAME":"$PAT"@"$REPO_URL"
    git lfs push --all https://"$GIT_USERNAME":"$PAT"@"$REPO_URL"
}

# Main script
main() {
    git_config
    check_git_lfs_installed
    track_large_files
    commit_and_push
}

main
