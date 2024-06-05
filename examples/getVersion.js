const { cv: cvLoader } = require('../'); // replace with require('opencv-wasm'); in prod
const Module = {};
const cv = cvLoader(Module);

console.log(cv.getBuildInformation());
