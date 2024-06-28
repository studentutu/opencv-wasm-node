#!/bin/bash
# set -e
set -x  # Enable script debugging for logging

# assume you are in ./utils folder

# Copy compilation result
echo "Copying build_wasm to root"
cp -a ./opencv/build_wasm/ ./build_wasm

# Transpile opencv.js files
echo "Started transpiling opencv.js"
node opencvJsMod.js

# Beautify original and Uglify and compress to min for web
(
    cd ./build_wasm/bin &&
    npx js-beautify opencv.js -r &&
    npx uglify-js opencv.js -o opencv.min.js --compress --mangle
)

# Copy bins to root
(
    cp ./build_wasm/bin/opencv_js.wasm ../opencv_js.wasm &&
    cp ./build_wasm/bin/opencv.js ../opencv.js &&
    cp ./build_wasm/bin/opencv.min.js ../opencv.min.js &&
    cp -r ./build_wasm/ ../build_wasm_test
)