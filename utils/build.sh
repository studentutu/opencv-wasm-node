git clone --branch 4.10.0 --depth 1 https://github.com/opencv/opencv.git

# Build
(
    cd opencv &&
    git fetch --tags &&
    git checkout 4.10.0 &&

    # Add non async flag before compiling in the python build_js.py script
    docker run --rm --workdir /code -v "$PWD":/code -u $(id -u):$(id -g) emscripten/emsdk emcmake python3 ./platforms/js/build_js.py ./build_wasm --clean_build_dir --build_wasm --build_test --build_flags "-s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=0 -s USE_PTHREADS=0 "
)

# Copy compilation result
cp -a ./opencv/build_wasm/ ./build_wasm

# Transpile opencv.js files
node opencvJsMod.js

# Beautify and Uglify JS
(
    cd ./build_wasm/bin &&
    npx uglify-js opencv.js -o opencv.min.js --compress --mangle
    npx js-beautify opencv.js -r
)

# Copy bins to root
(
    cp ./build_wasm/bin/opencv_js.wasm ../opencv.wasm &&
    cp ./build_wasm/bin/opencv.js ../opencv.js &&
    cp ./build_wasm/bin/opencv.min.js ../opencv.min.js &&
    cp -r ./build_wasm/ ../build_wasm_test
)