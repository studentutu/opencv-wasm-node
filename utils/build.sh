git clone --branch 4.5.5 --depth 1 https://github.com/opencv/opencv.git

# Build
(
    cd opencv &&
    git fetch --tags &&
    git checkout 4.5.5 &&

    # Add non async flag before compiling in the python build_js.py script
    docker run --rm --workdir /code -v "$PWD":/code "trzeci/emscripten:1.39.4-ubuntu" `emcmake python ./platforms/js/build_js.py build_wasm --disable_single_file --build_loader --build_wasm --build_test --build_flags "-s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=0 "`
    docker run --rm --workdir /code -v "$PWD":/code "trzeci/emscripten:1.39.4-ubuntu" `emcmake python ./platforms/js/build_js.py --build_loader`
    # docker run --rm --workdir /code -v "$PWD":/code "trzeci/emscripten:1.39.4-ubuntu" `python ./platforms/js/build_js.py --build_wasm --threads --build_test --build_loader --cmake_option "-DBUILD_EXAMPLES=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_calib3d=OFF" ./`
)

# Copy compilation result
cp -a ./opencv/build_wasm/ ./build_wasm

# Transpile opencv.js files
node opencvJsMod.js

# Beautify JS
(
    cd ./build_wasm/bin &&
    npx js-beautify opencv.js -r &&
    npx js-beautify opencv-deno.js -r
)

# Copy bins to root
(
    cp ./build_wasm/bin/opencv.wasm ../opencv.wasm &&
    cp ./build_wasm/bin/opencv-bin.js ../opencv-bin.js &&
    cp ./build_wasm/bin/opencv.js ../opencv.js &&
    cp ./build_wasm/bin/opencv-deno.js ../opencv-deno.js &&
    cp ./build_wasm/bin/loader.js ../loader.js &&
    cp -r ./build_wasm/ ../build_wasm_test
)
