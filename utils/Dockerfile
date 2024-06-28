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
WORKDIR /my_files/opencv

RUN ls
RUN rm -rf build_wasm
RUN mkdir build_wasm

# Run the build script for opencv-wasm
RUN emcmake python3 ./platforms/js/build_js.py ./build_wasm --clean_build_dir --build_wasm --build_doc --build_test --build_flags "-s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=0 -s USE_PTHREADS=0 "

# no need to copy build files, as we are using mounted volume as workdirectory.
# COPY opencv/build_wasm /my_files