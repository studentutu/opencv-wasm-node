#!/bin/bash

# assume you are running from root folder

# this script is used to build opencv.js and opencv_js.wasm. Result is copied to root folder

# debug
set -e
set -x  # Enable script debugging for logging

cd ./utils

chmod +x ./build_opencv_wasm.sh
chmod +x ./build.sh


# execute build_opencv_wasm.sh
./build_opencv_wasm.sh

# execute build.sh
./build.sh