#!/bin/bash

# Copy compilation result
cp -a ./opencv/build_wasm/ ./build_wasm

# Transpile opencv.js files
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