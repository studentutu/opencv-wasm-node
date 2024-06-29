# Options for opecv js build

## opencv js python general options

usage: build_js.py [-h] [--opencv_dir OPENCV_DIR]
                   [--emscripten_dir EMSCRIPTEN_DIR] [--build_wasm]
                   [--disable_wasm] [--disable_single_file] [--threads]
                   [--simd] [--build_test] [--build_perf] [--build_doc]
                   [--build_loader] [--clean_build_dir] [--skip_config]
                   [--config_only] [--enable_exception]
                   [--cmake_option CMAKE_OPTION] [--build_flags BUILD_FLAGS]
                   [--build_wasm_intrin_test] [--config CONFIG] [--webnn]
                   build_dir

Build OpenCV.js by Emscripten

positional arguments:
  build_dir             Building directory (and output)

optional arguments:
  -h, --help            show this help message and exit
  --opencv_dir OPENCV_DIR
                        Opencv source directory (default is "../.." relative
                        to script location)
  --emscripten_dir EMSCRIPTEN_DIR
                        Path to Emscripten to use for build (deprecated in
                        favor of 'emcmake' launcher)
  --build_wasm          Build OpenCV.js in WebAssembly format
  --disable_wasm        Build OpenCV.js in Asm.js format
  --disable_single_file
                        Do not merge JavaScript and WebAssembly into one
                        single file
  --threads             Build OpenCV.js with threads optimization
  --simd                Build OpenCV.js with SIMD optimization
  --build_test          Build tests
  --build_perf          Build performance tests
  --build_doc           Build tutorials
  --build_loader        Build OpenCV.js loader
  --clean_build_dir     Clean build dir
  --skip_config         Skip cmake config
  --config_only         Only do cmake config
  --enable_exception    Enable exception handling
  --cmake_option CMAKE_OPTION
                        Append CMake options
  --build_flags BUILD_FLAGS
                        Append Emscripten build options
  --build_wasm_intrin_test
                        Build WASM intrin tests
  --config CONFIG       Specify configuration file with own list of exported
                        into JS functions
  --webnn               Enable WebNN Backend

## opencv js python build_flags options

``` python
    def get_build_flags(self):
        flags = ""
        if self.options.build_wasm:
            flags += "-s WASM=1 "
        elif self.options.disable_wasm:
            flags += "-s WASM=0 "
        if not self.options.disable_single_file:
            flags += "-s SINGLE_FILE=1 "
        if self.options.threads:
            flags += "-s USE_PTHREADS=1 -s PTHREAD_POOL_SIZE=4 "
        else:
            flags += "-s USE_PTHREADS=0 "
        if self.options.enable_exception:
            flags += "-s DISABLE_EXCEPTION_CATCHING=0 "
        if self.options.simd:
            flags += "-msimd128 "
        if self.options.build_flags:
            flags += self.options.build_flags
        if self.options.webnn:
            flags += "-s USE_WEBNN=1 "
        flags += "-s EXPORTED_FUNCTIONS=\"['_malloc', '_free']\""
        return flags
```

  --WASM = 0 | 1                Build OpenCV.js in WebAssembly format
  --SINGLE_FILE = 0 | 1         Do not merge JavaScript and WebAssembly into one
                                single file
  --USE_PTHREADS = 0 | 1        Build OpenCV.js with threads optimization
  --SIMD = 0 | 1                Build OpenCV.js with SIMD optimization
  --BUILD_TEST = 0 | 1          Build tests
  --BUILD_PERF = 0 | 1          Build performance tests
  --BUILD_DOC = 0 | 1           Build tutorials
  --BUILD_LOADER = 0 | 1        Build OpenCV.js loader
  --CLEAN_BUILD_DIR = 0 | 1     Clean build dir
  --SKIP_CONFIG = 0 | 1         Skip cmake config
  --CONFIG_ONLY = 0 | 1         Only do cmake config
  --ENABLE_EXCEPTION = 0 | 1    Enable exception handling
  
## opencv js python cmake_options options

DO NOT OVERWRITE "-DCMAKE_TOOLCHAIN_FILE" as it is required for emscripten to work.

See <https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html>

Generated options from all available options:

``` bash
# initial configuration
cmake ../opencv
 
# print all options
cmake -L
 
# print all options with help message
cmake -LH
 
# print all options including advanced
cmake -LA

```

Options:

  -lembind                     Links against embind library
  --emit-tsd                   Generates TypeScript definition file ( requires -lembind  and Node to be installed )
  --O1                         Enables optimizations [ -00, -01, -02, -03 ]
