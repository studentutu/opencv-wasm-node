# Base image for building with emscripten
FROM emscripten/emsdk:latest

# Update package lists
RUN apt-get update && \
    apt-get install -y build-essential curl && \
    apt-get install -y --no-install-recommends wget unzip git python3 doxygen

# Define volume as main directory
VOLUME /my_files

# User for running commands for linux
# USER $(id -u):$(id -g)

# Use volume as current directory
# Move into opencv directory
WORKDIR /my_files


# Run the build script for opencv-wasm
ENTRYPOINT [ "./docker_wasm_build.sh" ]

# no need to copy build files, as we are using mounted volume as workdirectory.
# COPY opencv/build_wasm /my_files