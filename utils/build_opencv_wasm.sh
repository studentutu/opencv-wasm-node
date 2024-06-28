#!/bin/bash

# assume you are running in ./utils
git clone --branch 4.10.0 --depth 1 https://github.com/opencv/opencv.git
git fetch --tags && git checkout 4.10.0

docker stop $(docker ps -q)
docker rm opencv-wasm
# Clean existing container (optional)
# docker rm -f $(docker ps -aq --filter name=opencv-wasm)

# docker system prune -a -f
docker build -t opencv-wasm .
docker volume rm -f my_files
docker volume create my_files
echo "Trying to run docker at $(pwd)"

# for windows we need to explicitly change path to linux like path.
if [[ "$OSTYPE" =~ ^cygwin|msys|mingw ]]; then
    echo "You are running on Windows, please change path to linux like path"
    # check files and folders, sandbox with 
    # docker run --rm -v //c/fast-opencv-wasm/utils:/my_files -d opencv-wasm sleep infinity
    docker run --rm -v //c/fast-opencv-wasm/utils:/my_files -d opencv-wasm 
else
    # use current active directory from bash
    docker run --rm -v $(pwd):/my_files -d opencv-wasm 
fi