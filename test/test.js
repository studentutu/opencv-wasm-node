const { cv: cvLoader, cvTranslateError } = require('../'); // replace with require('opencv-wasm') in dry-run
const Module = {};
const cv = cvLoader(Module);

const fs = require('fs');
const { assert } = require('chai');
const { execSync } = require("child_process");
const { PNG } = require('pngjs');
const pixelmatch = require('pixelmatch');
const { errorExample } = require('./error-example');

describe('opencv-wasm', function () {
    this.timeout(40000);

    it('can be loaded', function () {
        assert.isObject(cv);
        assert.isFunction(cv.Scalar);
        assert.isFunction(cv.Point);
        assert.isFunction(cv.Mat);
        assert.isFunction(cv.MatVector);
        assert.isFunction(cvTranslateError);
    });

    it('runs dilation example', function () {
        execSync('node ./examples/dilation.js');
        const expectedOutput = PNG.sync.read(fs.readFileSync('./examples/expected-output/dilation.png'));
        const testOutput = PNG.sync.read(fs.readFileSync('./examples/test-output/dilation.png'));

        const pixelmatchResult = pixelmatch(expectedOutput.data, testOutput.data, null, expectedOutput.width, expectedOutput.height, { threshold: 0.01 });
        assert.deepStrictEqual(pixelmatchResult, 0);
    });

    it('runs template matching example', function () {
        execSync('node ./examples/templateMatching.js');
        const expectedOutput = PNG.sync.read(fs.readFileSync('./examples/expected-output/template-matching.png'));
        const testOutput = PNG.sync.read(fs.readFileSync('./examples/test-output/template-matching.png'));

        const pixelmatchResult = pixelmatch(expectedOutput.data, testOutput.data, null, expectedOutput.width, expectedOutput.height, { threshold: 0.01 });
        assert.deepStrictEqual(pixelmatchResult, 0);
    });
});

describe('cvTranslateError', function () {
    it('translates error correctly', async function () {
        const errString = await errorExample();
        assert.deepStrictEqual(errString,
            "Exception: OpenCV(4.10.0) /code/modules/imgproc/src/contours.cpp:197: error: (-210:Unsupported format or combination of formats) [Start]FindContours supports only CV_8UC1 images when mode != CV_RETR_FLOODFILL otherwise supports CV_32SC1 images only in function 'cvStartFindContours_Impl'\n");
    });
});
