#!/bin/bash
# assume you are running in ./utils

# this script is used to build and run docker container for opencv locally. Result is stored in ./utils/opencv/build_wasm

# debug
# set -e
# set -x  # Enable script debugging for logging

# check if opencv is already cloned
if [ ! -d "./opencv" ]; then
    git clone --branch 4.10.0 --depth 1 https://github.com/opencv/opencv.git
fi

cd ./opencv
git fetch --tags
git status
git reset --hard
git checkout 4.10.0

cd ../

# docker system prune -a -f
echo "Trying to build docker at $(pwd), not that ./utils should be mounted volume and /opencv folder should be available in container"

if [ ! -d "./opencv/build_wasm" ]; then
    mkdir ./opencv/build_wasm
fi

sed -i -e "s/GENERATE_XML *= NO/GENERATE_XML =YES/" ./opencv/doc/Doxyfile.in

docker stop $(docker ps -q)
docker stop opencv-wasm
docker rm opencv-wasm
docker volume rm -f my_files

# clean all cached for docker
docker system prune -a -f
docker volume prune -f


chmod +x ./docker_wasm_build.sh
docker volume create my_files
docker build -t opencv-wasm .


if [[ "$OSTYPE" =~ ^cygwin|msys|mingw ]]; then
    echo "You are running on Windows, please make sure path is suitable for linux environment"
    echo "Using Path: $(pwd)"

    # check files and folders from volume in docker in sandbox with docker for windows.
    # remove entry point and sleep infinity
    # docker run --rm -v //c/fast-opencv-wasm/utils:/my_files -d opencv-wasm sleep infinity
    docker run --privileged --rm -v /$(pwd):/my_files -d opencv-wasm
else
    # use current active directory from bash
    docker run --privileged --rm -v $(pwd):/my_files -u $(id -u):$(id -g) -d opencv-wasm 
fi

container_name="opencv-wasm"
container_status="not running"
timeout=20

# Loop until the container is not running or timeout is reached
until [ "$container_status" == "running" ]; do
    sleep 1
    timeout=$((timeout-1))
    if [ $timeout -eq 0 ]; then
        echo "Timeout reached, container not running"
        exit 1
    fi

    container_status=$(docker ps | grep -q "$container_name" && echo "running" || echo "not running")
    echo "container_status" "$container_status"
done

echo "Waiting for container to finish..."
# Loop until the container is not running or timeout is reached
until [ "$container_status" == "not running" ]; do
    sleep 1
    container_status=$(docker ps | grep -q "$container_name" && echo "running" || echo "not running")
    echo "container_status" "$container_status"
done

sleep 1
last_line=$(tac ./loghere.txt | grep .)

echo "Cleaning up.."

docker stop opencv-wasm
docker rm opencv-wasm
docker volume rm -f my_files
# clean all cached for docker
docker system prune -a -f
docker volume prune -f

echo "Container finished with exit code" "$last_line"

# check if build was successful with file at ./optncv/build_wasm/bin/opencv_js.js
if [ ! -f "./opencv/build_wasm/bin/opencv_js.js" ]; then
    echo "Build failed, please check ./logbuild.txt"
    exit 1
fi