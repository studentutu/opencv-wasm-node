#!/bin/bash

# stop if any error
# set -e
# set -x  # Enable script debugging for logging

# assume you are running in ./utils
# check if opencv is already cloned
if [ ! -d "./opencv" ]; then
    git clone --branch 4.10.0 --depth 1 https://github.com/opencv/opencv.git
fi

git fetch --tags

# docker system prune -a -f
echo "Trying to build docker at $(pwd), not that ./utils should be mounted volume and /opencv folder should be available in container"

if [ ! -d "./opencv/build_wasm" ]; then
    mkdir ./opencv/build_wasm
fi

docker stop $(docker ps -q)
docker rm opencv-wasm
docker volume rm -f my_files
docker volume prune -f
docker volume create my_files
docker build -t opencv-wasm .

chmod +x ./docker_wasm_build.sh

# for windows we need to explicitly change path to linux like path.
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