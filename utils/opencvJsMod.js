// @ts-check

const fs = require('fs');
const path = require('path');

const openCvJs = fs.readFileSync(path.join(__dirname, './build_wasm/bin/opencv.js'), 'utf-8');

// Add modifications for node.js code
let openCvJsMod = openCvJs;

// Immidiately invoke request for opencv.js and link to wasm binary
openCvJsMod =
    `(function() {
    /* opencv-wasm@${require('../package.json').version} */
    let opencvWasmBinaryFile = './opencv_js.wasm';

    return ${openCvJsMod};
})();`;

openCvJsMod = openCvJsMod.replace(/if \(typeof Module === 'undefined'\)(.*)return cv\(Module\)/gms, 'return cv');

fs.writeFileSync(
    path.join(__dirname, './build_wasm/bin/opencv.js'),
    openCvJsMod,
    { encoding: 'utf8' }
);
console.log('Updated opencv.js');
