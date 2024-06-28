#!/bin/bash

# assume you are in root folder
cd ./utils

echo "Generating types"
node generateCvProps.js

echo "Finished generating types"
# npx tsc --declaration --allowJs --emitDeclarationOnly --outDir ../types ../types/opencv.ts