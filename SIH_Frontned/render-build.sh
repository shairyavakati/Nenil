#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Fetching dependencies..."
flutter pub get

echo "Building for Web..."
flutter build web
