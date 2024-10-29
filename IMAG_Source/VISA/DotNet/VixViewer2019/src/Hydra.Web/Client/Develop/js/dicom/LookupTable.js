/**
 *  LookupTable.js
 *  Version 0.5
 *  Author: BabuHussain<babuhussain.a@raster.in>
 */
function LookupTable() {
    this.ylookup;
    this.rescaleSlope;
    this.rescaleIntercept;
    this.windowCenter;
    this.windowWidth;
    this.minPixel;
    this.maxPixel;
    this.invert;
    this.calculateLookup = calculateLookup;
    this.setWindowingdata = setWindowingdata;
    this.setInvertData = setInvertData;
}
LookupTable.prototype.setData = function (wc, ww, rs, ri, minMax, invert) {
    this.windowCenter = wc;
    this.windowWidth = ww;
    this.rescaleSlope = rs;
    this.rescaleIntercept = ri;
    this.minPixel = minMax.min;
    this.maxPixel = minMax.max;
    this.invert = invert;
    this.calculateLookup();
};

LookupTable.prototype.applyLUT = function (pixelData, pixelDataToStore, row, column) {

    /*************************************************************************
     * Referred from 'cornerstoneDemo' to improve performance in IE
     * http://chafey.github.io/cornerstoneDemo/
     **************************************************************************/
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "applyLUT ", "Start");

        var minPixelValue = this.minPixel;
        var canvasImageDataIndex = 3;
        var storedPixelDataIndex = 0;
        var localNumPixels = pixelData.length;
        var localPixelData = pixelData;
        var localLut = this.ylookup;
        var localCanvasImageDataData = pixelDataToStore.data;
        if (minPixelValue < 0) {
            while (storedPixelDataIndex < localNumPixels) {
                localCanvasImageDataData[canvasImageDataIndex] = localLut[localPixelData[storedPixelDataIndex++] + (-minPixelValue)]; // alpha
                canvasImageDataIndex += 4;
            }
        } else {
            while (storedPixelDataIndex < localNumPixels) {
                localCanvasImageDataData[canvasImageDataIndex] = localLut[localPixelData[storedPixelDataIndex++]]; // alpha
                canvasImageDataIndex += 4;
            }
        }
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
};

/**
 * ApplySharpen method works once the sharpen tool enabled 
 * Then Click on canvas to apply sharpen 
 **/
LookupTable.prototype.applySharpen = function (canvasData, w, h, sharpenValue) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, "applySharpen ", "Start");

        var mix = sharpenValue;
        var x, sx, sy, r, g, b, a, dstOff, srcOff, wt, cx, cy, scy, scx,
            weights = [0, -1, 0, -1, 5, -1, 0, -1, 0],
            katet = Math.round(Math.sqrt(weights.length)),
            half = (katet * 0.5) | 0,
            dstData = canvasData.createImageData(w, h),
            dstBuff = dstData.data,
            srcBuff = canvasData.getImageData(0, 0, w, h).data,
            y = h;
        while (y--) {
            x = w;
            while (x--) {
                sy = y;
                sx = x;
                dstOff = (y * w + x) * 4;
                r = 0;
                g = 0;
                b = 0;
                a = 0;

                for (cy = 0; cy < katet; cy++) {
                    for (cx = 0; cx < katet; cx++) {
                        scy = sy + cy - half;
                        scx = sx + cx - half;

                        if (scy >= 0 && scy < h && scx >= 0 && scx < w) {
                            srcOff = (scy * w + scx) * 4;
                            wt = weights[cy * katet + cx];

                            r += srcBuff[srcOff] * wt;
                            g += srcBuff[srcOff + 1] * wt;
                            b += srcBuff[srcOff + 2] * wt;
                            a += srcBuff[srcOff + 3] * wt;
                        }
                    }
                }

                dstBuff[dstOff] = r * mix + srcBuff[dstOff] * (1 - mix);
                dstBuff[dstOff + 1] = g * mix + srcBuff[dstOff + 1] * (1 - mix);
                dstBuff[dstOff + 2] = b * mix + srcBuff[dstOff + 2] * (1 - mix);
                dstBuff[dstOff + 3] = srcBuff[dstOff + 3];
            }
        }
        canvasData.putImageData(dstData, 0, 0);
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, "End", (Date.now() - t0));
    }
};


LookupTable.prototype.applyColorLUT = function (pixelData, pixelDataToStore, row, column, rgbMode) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, "applyColorLUT ", "Start");

        var n = 0;
        if (rgbMode === undefined || rgbMode === 0) {
            for (var yPix = 0; yPix < row; yPix++) {
                for (var xPix = 0; xPix < column; xPix++) {
                    var aColumn = yPix * column;
                    var offset = (aColumn + xPix) * 4;
                    pixelDataToStore.data[offset] = this.ylookup[pixelData[n++]];
                    pixelDataToStore.data[offset + 1] = this.ylookup[pixelData[n++]];
                    pixelDataToStore.data[offset + 2] = this.ylookup[pixelData[n++]];
                    pixelDataToStore.data[offset + 3] = 255;
                }
            }
        } else if (rgbMode === 1) {
            for (var yPix = 0; yPix < row; yPix++) {
                for (var xPix = 0; xPix < column; xPix++) {
                    var aColumn = yPix * column;
                    var offset = (aColumn + xPix) * 4;
                    var pixel = this.ylookup[pixelData[n++]];
                    n++;
                    n++;
                    pixelDataToStore.data[offset] = pixel;
                    pixelDataToStore.data[offset + 1] = pixel;
                    pixelDataToStore.data[offset + 2] = pixel;
                    pixelDataToStore.data[offset + 3] = 255;
                }
            }
        } else if (rgbMode === 2) {
            for (var yPix = 0; yPix < row; yPix++) {
                for (var xPix = 0; xPix < column; xPix++) {
                    var aColumn = yPix * column;
                    var offset = (aColumn + xPix) * 4;
                    n++;
                    var pixel = this.ylookup[pixelData[n++]];
                    n++;
                    pixelDataToStore.data[offset] = pixel;
                    pixelDataToStore.data[offset + 1] = pixel;
                    pixelDataToStore.data[offset + 2] = pixel;
                    pixelDataToStore.data[offset + 3] = 255;
                }
            }
        } else if (rgbMode === 3) {
            for (var yPix = 0; yPix < row; yPix++) {
                for (var xPix = 0; xPix < column; xPix++) {
                    var aColumn = yPix * column;
                    var offset = (aColumn + xPix) * 4;
                    n++;
                    n++;
                    var pixel = this.ylookup[pixelData[n++]];
                    pixelDataToStore.data[offset] = pixel;
                    pixelDataToStore.data[offset + 1] = pixel;
                    pixelDataToStore.data[offset + 2] = pixel;
                    pixelDataToStore.data[offset + 3] = 255;
                }
            }
        }
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
}

/**
 * Apply the 6000 overlay
 */
LookupTable.prototype.apply6000Overlay = function (image, canvasPixelData) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "apply6000Overlay ", "Start");

        var overlay6000 = image.overlay6000;
        if (overlay6000 === undefined) {
            return;
        }

        var overlayData = overlay6000.overlayData;
        if (overlayData === undefined) {
            return;
        }

        var canvasImageDataIndex = 3;
        var storedPixelDataIndex = 0;
        var canvasPixelImageData = canvasPixelData.data;

        while (storedPixelDataIndex < overlayData.length) {
            var pixelData = overlayData[storedPixelDataIndex++];
            if (pixelData !== 0) {
                canvasPixelImageData[canvasImageDataIndex] = 255;
            }
            canvasImageDataIndex += 4;
        }
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
};

function setInvertData(data) {
    this.invert = data;
    this.calculateLookup();
}

var setWindowingdata = function (wc, ww) {
    var isCalculateLookup = false;
    if (this.windowCenter != wc || this.windowWidth != ww) {
        isCalculateLookup = true;
    }
    this.windowCenter = wc;
    this.windowWidth = ww;
    if (isCalculateLookup) this.calculateLookup();
}

function calculateLookup() {

    /*************************************************************************
     * Referred from 'cornerstoneDemo' to improve performance in IE
     * http://chafey.github.io/cornerstoneDemo/
     **************************************************************************/

    if (this.maxPixel === undefined && this.minPixel === undefined) {
        return;
    }

    if (this.ylookup === undefined) {
        this.ylookup = new Int16Array(this.maxPixel - Math.min(this.minPixel, 0) + 1);
    }

    var lut = this.ylookup;
    var maxPixelValue = this.maxPixel;
    var minPixelValue = this.minPixel;
    var slope = this.rescaleSlope;
    var intercept = this.rescaleIntercept;
    var localWindowWidth = this.windowWidth;
    var localWindowCenter = this.windowCenter;

    var modalityLutValue;
    var voiLutValue;
    var clampedValue;
    var storedValue;

    var offset = 0;
    if (minPixelValue < 0) {
        offset = minPixelValue;
    }

    if (this.invert === true) {
        for (storedValue = minPixelValue; storedValue <= maxPixelValue; storedValue++) {
            modalityLutValue = storedValue * slope + intercept;
            voiLutValue = (((modalityLutValue - (localWindowCenter)) / (localWindowWidth) + 0.5) * 255.0);
            clampedValue = Math.min(Math.max(voiLutValue, 0), 255);
            lut[storedValue + (-offset)] = Math.round(255 - clampedValue);
        }
    } else {
        for (storedValue = minPixelValue; storedValue <= maxPixelValue; storedValue++) {
            modalityLutValue = storedValue * slope + intercept;
            voiLutValue = (((modalityLutValue - (localWindowCenter)) / (localWindowWidth) + 0.5) * 255.0);
            clampedValue = Math.min(Math.max(voiLutValue, 0), 255);
            lut[storedValue + (-offset)] = Math.round(clampedValue);
        }
    }
}
