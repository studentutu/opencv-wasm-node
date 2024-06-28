import * as OpenCV from './types/opencv';
export * as OpenCV from './types/opencv';

/**
 * OpenCV Object
 */
export declare const cv: typeof OpenCV;

/**
 * Translate error number from OpenCV into a meaningful message
 * @param cvObject OpenCV object
 * @param err OpenCV error number 
 */
export function cvTranslateError(cvObject: typeof OpenCV, err: any): string | Error | undefined;
