#!/bin/bash

# Build the Flutter web app
flutter build web

# Move to the build/web directory
cd build/web

# Initialize Git
git init
git add .
git commit -m "Deploy to GitHub Pages"

# Add GitHub remote (replace with your actual repository)
git remote add origin https://github.com/ESaiShubham/ban-hunger.git

# Force push to the gh-pages branch
git push -f origin master:gh-pages

echo "Deployed to GitHub Pages!"
