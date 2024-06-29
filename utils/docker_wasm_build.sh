#!/bin/bash

# assume you are running from under ./utils ( mounted volume )

# this script is used to build opencv.js and opencv_js.wasm. Result is under ./utils/opencv/build_wasm


#debug
set -x  # Enable script debugging for logging

# clear log file
echo "" > ./loghere.txt 
echo "" > ./logbuild.txt 

echo "Started build wasm" >> ./loghere.txt 

cd ./opencv

echo "current directory is $(pwd)" >> ../loghere.txt 


if [ ! -d "./build_wasm" ]; then
    makdir ./build_wasm
fi

if [ ! -d "./platforms" ]; then
    echo "There are no platform folder!!!!! Check if you are running volume from the correct directory." >> ../loghere.txt
    echo "1" >> ../loghere.txt
    exit 1
else
    echo "Platform folder exists" >> ../loghere.txt
fi

echo "Start build wasm. For any errors, please check ./logbuild.txt" >> ../loghere.txt
emcmake python3 ./platforms/js/build_js.py ./build_wasm --clean_build_dir --build_wasm --build_doc --build_test --build_flags "-s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=0 -s USE_PTHREADS=0 " | tee ../logbuild.txt

echo "Finished build wasm" >> ../loghere.txt
echo "0" >> ../loghere.txt