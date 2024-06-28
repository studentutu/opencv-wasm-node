#!/bin/bash
set -x  # Enable script debugging for logging

# assume you are in root folder
cd ./utils

echo "Generating types"
node generateCvProps.js

echo "Finished generating types"
# npx tsc --declaration --allowJs --emitDeclarationOnly --outDir ../types ../types/opencv.ts