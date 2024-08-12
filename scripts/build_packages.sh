#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

#Sourcing Variables
source $HOME/scripts/variables.sh

# Check if package list file exists
if [[ ! -f $PACKAGE_LIST ]]; then
  echo "Package list file $PACKAGE_LIST not found!"
  exit 1
fi

# Check if $AUR_DIR exists
if [[ ! -d $AUR_DIR ]]; then
  echo "$AUR_DIR not found!"
  echo "Creating $AUR_DIR "
  mkdir -p $AUR_DIR

fi

#Clonig $REPO_URL
git clone https://$REPO_URL $REPO_DIR

# Moving into Aur Directory
cd $AUR_DIR

# Read package names from the list and build each package
while IFS= read -r pkg; do
  pkg=$(echo "$pkg" | xargs) # Trim any leading/trailing whitespace

  # Skip empty lines
  if [[ -z $pkg ]]; then
    continue
  fi

  echo "Building package: $pkg"

  # Clone the AUR repository
  git clone "https://aur.archlinux.org/$pkg.git" || {
    echo "Failed to clone $pkg"
    continue
  }
  cd "$pkg"

  # Build the package
  makepkg -s --noconfirm --needed || {
    echo "Failed to build $pkg"
    cd ..
    continue
  }

  # Moving Build package to repo directory
  mv *.pkg.tar.zst ../../$REPO_DIR/$ARCH || {
    echo "Failed to move $pkg"
    continue
  }
  # Return to the AUR directory
  cd ..

  echo "Successfully built package: $pkg"

done <"../$PACKAGE_LIST"

echo "Package building process completed."
