#!/bin/bash

# assume you are in ./utils
node generateCvProps.js
npx tsc --declaration --allowJs --emitDeclarationOnly --outDir ../types ../types/opencv.ts