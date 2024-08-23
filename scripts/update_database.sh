#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Check for the presence of the database files
cd $HOME/$REPO_DIR
if [[ -f "$ARCH/$DB_FILE" && -f "$ARCH/$FILES_FILE" ]]; then
  echo "Database files found. Deleting them..."
  rm "$ARCH/$DB_FILE" "$ARCH/$FILES_FILE"
else
  echo "Database files not found."
fi

# Add all packages to the repository
echo "Running repo-add to update the repository..."
repo-add "$ARCH/$DB_FILE.tar.gz" "$ARCH"/*.pkg.tar.zst

# Rename the newly created database files
echo "Renaming the new database files..."
mv "$ARCH/$DB_FILE.tar.gz" "$ARCH/$DB_FILE"
mv "$ARCH/$FILES_FILE.tar.gz" "$ARCH/$FILES_FILE"

echo "Repository update complete."
