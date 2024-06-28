const fs = require('fs');

const { cv: cvLoader } = require('../.'); // will use index.js and opencv.js

const Module = {};
const cv = cvLoader(Module);

const removeProps = [
    // Invalid item
    'arguments',
];

let keys = Object.keys(cv);

let result = '';
result += `// Generated types by generateCvProps.js, don't edit this file\n`;
result += `// A bit useless right now, but we can probably link Doxygen documentation to this file\n`;
result += `\n`;
result += `\n`;

keys.forEach(key => {
    if (removeProps.indexOf(key) !== -1) return;

    // @ts-ignore
    let type = typeof cv[key];

    if (type === 'string' || type === 'number' || type === 'boolean') {
        result += `export var ${key}: ${type};\n`;
    } else if (type === 'function') {
        result += `\n`;
        result += `/** function */\n`;
        result += `export var ${key}: any;\n`;
    } else if (type === 'object') {
        result += `\n`;
        result += `/** object */\n`;
        result += `export var ${key}: any;\n`;
    } else if (type === 'undefined') {
        result += `\n`;
        result += `/** undefined */\n`;
        result += `export var ${key}: any;\n`;
    } else {
        throw new Error(key + ' ' + type);
    }

});

fs.mkdirSync('../types', { recursive: true });
fs.writeFileSync('../types/opencv.ts', result, { encoding: 'utf8' });
