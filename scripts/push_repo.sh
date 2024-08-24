#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Configure git
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
cd $HOME/$USER/$REPO_DIR
echo "Pushing changes to GitLab"
git add .
git commit -m "auto: Update packages and database"
git push https://$GIT_USERNAME:$PAT@$REPO_URL
