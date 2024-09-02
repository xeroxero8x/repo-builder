#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Change to the repository directory
cd "$USER_HOME/$REPO_DIR"

# Check for the presence of the database files and rename them if found
if [[ -f "$ARCH/$DB_FILE" && -f "$ARCH/$FILES_FILE" ]]; then
  echo "Database files found. Renaming them with a .old extension..."
  mv "$ARCH/$DB_FILE" "$ARCH/$DB_FILE.old"
  mv "$ARCH/$FILES_FILE" "$ARCH/$FILES_FILE.old"
else
  echo "Database files not found."
fi

# Add all packages to the repository
echo "Running repo-add to update the repository..."
repo-add "$ARCH/$DB_FILE.tar.gz" "$ARCH"/*.pkg.tar.zst

#Removing Syslinks
echo "Removing Linking "
rm "$ARCH/$DB_FILE" "$ARCH/$FILES_FILE"

# Copy the newly created database and files files
echo "Copying the new database and files files..."
cp "$ARCH/$DB_FILE.tar.gz" "$ARCH/$DB_FILE"
cp "$ARCH/$FILES_FILE.tar.gz" "$ARCH/$FILES_FILE"

echo "Repository update complete."
