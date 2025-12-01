#!/bin/bash
set -e

ORG="actual-software"
REPO_NAME="generic-python-repo"
DESCRIPTION="Generic Python repository with GitHub testing tools"

echo "Creating GitHub repository: $ORG/$REPO_NAME"

gh repo create "$ORG/$REPO_NAME" \
    --public \
    --description "$DESCRIPTION" \
    --confirm

echo "Setting remote origin..."
git remote add origin "https://github.com/$ORG/$REPO_NAME.git"

echo "Creating initial commit..."
git add .
git commit -m "Initial commit: GitHub testing tools

- Basic Python repository structure
- Tool for creating GitHub repositories using gh CLI
- Setup for future org and account management tools"

echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "Repository created and pushed successfully!"
echo "View at: https://github.com/$ORG/$REPO_NAME"
