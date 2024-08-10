#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Configure git
sudo -u builder git config --global user.name "$GIT_USERNAME"
sudo -u builder git config --global user.email "$GIT_EMAIL"

cd $REPO_DIR
echo "Pushing changes to GitLab"
sudo -u builder git add .
sudo -u builder git commit -m "auto: Update packages and database"
sudo -u builder git push https://$GIT_USERNAME:${{secrets.PAT}}@$REPO_URL
