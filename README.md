# OpenCV-Wasm

Precompiled OpenCV to (JavaScript + WebAssembly) for node.js and web environment.

To use it in your project, please use NPM link. See [UsaInstallationge](#installation) section for more details.

Generally wasm will run slower and will have fewer available API (wasm limitation) compared to the native OpenCV. But it's a good option if you want to run OpenCV on the web.

Please check available APIs at [OpenCV-Wasm API](./types/opencv.ts).

In this Wasm-compiled OpenCV, there's no need to have OpenCV installed in the machine. The entire OpenCV library is already inside this package (`opencv.js` and `opencv.wasm`).

This module has zero runtime dependencies.
See build section for more details.

## Table of Contents

- [Examples](#examples)
- [Installation](#installation)
  - [node](#node)
  - [Using in the browser](#using-in-the-browser)
- [Documentation](#documentation)
- [Error Handling](#error-handling)
- [Versioning](#versioning)
- [Development](#development)
  - [Prerequisites](#prerequisites)
  - [Building](#building)
  - [Testing](#testing)
  - [TODO](#todo)
- [Authors](#authors)
- [License](#license)

## Examples

| Code | Input | Output |
|---|---|---|
| [dilation.js](https://github.com/echamudi/opencv-wasm/blob/master/examples/dilation.js) (node)| ![image sample 1](https://github.com/echamudi/opencv-wasm/blob/master/examples/input/image-sample-1.jpg?raw=true) | ![dilation](https://github.com/echamudi/opencv-wasm/blob/master/examples/expected-output/dilation.png?raw=true) |
| [templateMatching.js](https://github.com/echamudi/opencv-wasm/blob/master/examples/templateMatching.js) (node) | source:<br>![image sample 2](https://github.com/echamudi/opencv-wasm/blob/master/examples/input/image-sample-2.png?raw=true) <br>template:<br> ![image sample 2 template](https://github.com/echamudi/opencv-wasm/blob/master/examples/input/image-sample-2-template.png?raw=true) | ![template matching](https://github.com/echamudi/opencv-wasm/blob/master/examples/expected-output/template-matching.png?raw=true) |

## Installation

### node

Currently, this module is not published on NPM. You can install it only from repo.

Use this command on the repo from the root folder:

``` bash
npm link
```

This will link the module 'opencv-wasm-node' globally.
Install it into your project with the following code:

``` bash
npm link opencv-wasm-node
```

Code example in node environment:

```js
const { cv, cvTranslateError } = require('opencv-wasm-node');

let mat = cv.matFromArray(2, 3, cv.CV_8UC1, [1, 2, 3, 4, 5, 6]);
console.log('cols =', mat.cols, '; rows =', mat.rows);
console.log(mat.data8S);

cv.transpose(mat, mat);
console.log('cols =', mat.cols, '; rows =', mat.rows);
console.log(mat.data8S);

/*
cols = 3 ; rows = 2
Int8Array(6) [ 1, 2, 3, 4, 5, 6 ]
cols = 2 ; rows = 3
Int8Array(6) [ 1, 4, 2, 5, 3, 6 ]
*/
```

When finished with the project, don't forget to remove the link.

Remove the link from your project with the following command:

``` bash
npm unlink opencv-wasm-node
```

Navigate to the repo root folder and run the following command:

``` bash
npm unlink -g
```

## Using in the browser

``` html
<script src="./opencv.min.js"></script>


<script>
// Separate initialization for wasm.
function getBinaryPromise(wasmBinary) {
  return fetch(wasmBinary, {
    credentials: "same-origin",
    crossOrigin: "anonymous",
  }).then(function(response) {
    if (!response["ok"]) {
      throw "failed to load wasm binary file at '" + wasmBinary + "'"
    }
    return response["arrayBuffer"]();
  });
}

getBinaryPromise('./opencv_js.wasm').then((wasmBinary) => {
  const Module = {
    wasmBinary,
  };

  cv = cv(Module);
});
</script> 
```

## Documentation

Because this module is using the similar code as the official OpenCV.js for the web, you can use the documentation at the web: <https://docs.opencv.org/4.10.0/d5/d10/tutorial_js_root.html> or build opencv with generated documentation using build script.

There are some minor initialization changes, because this module will be loaded synchronously instead of the OpenCV's default (asynchronously).

You can check the files inside [examples](https://github.com/echamudi/opencv-wasm/tree/master/examples) folder as reference on how to initialize, loading images, and saving images.

## Error Handling

By default, mistakes in code will produce error code. You can use the following snippet to translate the error code into meaningful statement from OpenCV.

```js
const { cv, cvTranslateError } = require('opencv-wasm-node');

try {
    // Your OpenCV code
} catch (err) {
    console.log(cvTranslateError(cv, err));
}
```

## Versioning

This npm module uses the following versioning number:

```
<opencv version>-<this module version>
```

For Example

```
4.10.0-1
OpenCV version 4.10.0
OpenCV-Wasm Module version 1
```

## Development

### Prerequisites

- nvm
- node version 20.x
- yarn
- docker

### Building

Run the following script on macOS or Linux (tested on Ubuntu, Windows).
You need docker on the system.
Prefer yarn over npm.

``` bash
npm install or yarn install
npm run build or yarn build
npm run generateTypes or yarn generateTypes
npm run test or yarn test
```

Please note that after each build, you need to manually remove opencv repo folder (currently not supported running multiple builds with different options).
To do this, run `rm -rf ./utils/opencv` from the root of this repo or delete folder manually.

Actual opencv build script for is located at `./utils/docker_wasm_build.sh`.
For more build options, please check `./utils/readme.md`.

### Testing

After completing the build script, you can run the test provided by OpenCV, and the test from this repo.

```sh
# OpenCV's test
(cd ./build_wasm_test/bin && npm install)
(cd ./build_wasm_test/bin && node tests.js)

# This repo's test
npm test
```

### TODO

Checklist:

- [x]   Add docker build image in order to build opencv from source. Helpful for building opencv on windows as we have docker UI on windows and we can run image in sandbox mode (docker run ... sleep infinity).
- [x]   Fix missing npm build script.
- [x]   Fix missing npm generateTypes script and test generated types (edit: types are alsmost useless as they are simple variables with comments on top of it).
- [x]   Fix missing npm test script and test it.
- [ ]   Fix repo corruption issue after opencv build from yarn|npm build (cmake configuration error).
- [ ]   Add typescript definition files for different `opencv.js` configurations. Generate types from Doxygen XML (xml2typescript).
- [ ]   Add support for `opencv.js` and `opencv.wasm` for electron.
- [ ]   Add npm dry-run script for testing as well as npm publish script.
- [ ]   Add build scripts for different configuration based on available opencv presets. Example : electron-wasm-core, electron-full, electron-core. Full list of presets can be found at [opencv-js-build-presets](https://github.com/opencv/opencv/blob/4.x/platforms/js/opencv_js.config.py).
- [ ]   Add perfomance tests based on the different configurations.

## Authors

- **Ezzat Chamudi** - [echamudi](https://github.com/echamudi)
- **Roman Fedorov** - [studentutu](https://github.com/studentutu)

See also the list of [contributors](https://github.com/echamudi/opencv-wasm/graphs/contributors) who participated in this project.

## License

Copyright © 2020 [Ezzat Chamudi](https://github.com/echamudi) and [OpenCV-Wasm Project Authors](https://github.com/echamudi/opencv-wasm/graphs/contributors)

OpenCV-Wasm code is licensed under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause). Images, logos, docs, and articles in this project are released under [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

[OpenCV License](https://opencv.org/license/).

Libraries, dependencies, and tools used in this project are tied with their licenses.
