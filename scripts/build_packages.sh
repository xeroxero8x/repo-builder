#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Check if package list file exists
if [[ ! -f $PACKAGE_LIST ]]; then
  echo "Package list file $PACKAGE_LIST not found!"
  exit 1
fi

# Read package names from the list and build each package
while IFS= read -r pkg; do
  pkg=$(echo "$pkg" | xargs) # Trim any leading/trailing whitespace

  # Skip empty lines
  if [[ -z $pkg ]]; then
    continue
  fi

  echo "Building package: $pkg"

  #Building the package with aurutils
  aur sync --noview --noconfirm $pkg || {
    echo "Failed to Build $pkg "
    continue
  }

done <"./$PACKAGE_LIST"
