#!/bin/bash
# stop if any error
set -e
set -x  # Enable script debugging for logging

cd ./utils

chmod +x ./build_opencv_wasm.sh
chmod +x ./build.sh


# execute build_opencv_wasm.sh
./build_opencv_wasm.sh

# execute build.sh
./build.sh