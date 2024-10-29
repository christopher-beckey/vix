importScripts("DicomInputStreamReader.js");
importScripts("../pako.js");
importScripts("../BinFileReader.js");
importScripts("SliceCalculator.js");

function loadImageFromURL(workerData) {
    if (workerData.request == 'xRefSlice') {
        processXRefLines(workerData);
    } else {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                switch (workerData.request) {
                    case 'Image':
                        if (!workerData.excludeImageInfo) {
                            postMessage({
                                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                                //getResponseHeader is case-insensitive (https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/getResponseHeader)
                                headerResponse: xmlhttp.getResponseHeader("imageinfo"),
                                responseText: workerData.isJpeg ? xmlhttp.response : xmlhttp.responseText
                            });
                        } else {
                            if (workerData.isJpeg) {
                                postMessage({
                                    responseText: xmlhttp.response
                                });
                            } else {
                                if (!workerData.isDecompressionRequired) {
                                    postMessage(prepareImage(workerData, xmlhttp.responseText));
                                }
                            }
                        }
                        break;
                    case 'overlay6000':
                        process6000Overlay(workerData, xmlhttp.responseText);
                        break;
                    case 'DicomInfo':
                    case 'thumbAbstract':
                        postMessage(xmlhttp.responseText);
                        break;
                    default:
                        self.postMessage('Unknown command: ');
                };
            } else if (xmlhttp.readyState == 4 && (xmlhttp.status == 404 || xmlhttp.status == 500)) {
                postMessage("Failure");
            }
        }
        workerData.url += "&ts=" + Date.now();
        const myUrl = "/vix/api/context/getUrlResponse"; //VAI-1316
        xmlhttp.open("GET", myUrl, true);
        xmlhttp.setRequestHeader("url", workerData.url); //VAI-1316

        //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
        xmlhttp.setRequestHeader("cache-control", "max-age=0, no-cache, no-store, must-revalidate");
        if (workerData.headers) {
            for (var key in workerData.headers) {
                xmlhttp.setRequestHeader(key, workerData.headers[key]);
            }
        }

        if (workerData.isJpeg) {
            xmlhttp.responseType = "blob";
        } else {
            xmlhttp.overrideMimeType("text/plain; charset=x-user-defined");
        }

        xmlhttp.send();
    }
}

self.addEventListener("message", function (e) {
    // the passed-in data is available via e.data
    if (e.data.cmd) {
        if (!e.data.workerData.isDecompressionRequired) {
            postMessage(prepareImage(e.data.workerData, e.data.responseText));
        }
    } else {
        loadImageFromURL(e.data);
    }

}, false);

function getRefLinesFromStudy(imagesArray) {
    for (var sourceImageIndex = 0; sourceImageIndex < imagesArray.length; sourceImageIndex++) {
        var sourceImage = imagesArray[sourceImageIndex];

        for (var targetImageIndex = 0; targetImageIndex < imagesArray.length; targetImageIndex++) {
            var targetImage = imagesArray[targetImageIndex];
            if (sourceImage.imageUid === targetImage.imageUid) {
                continue;
            }

            var value = dicomViewer.xRefLineViewer.calculateProjectSlice(sourceImage.imagePlane, targetImage.imagePlane);
            var refLine = {
                sourceImageUid: sourceImage.imageUid,
                targetImageUid: targetImage.imageUid,
                value: value
            };
            postMessage(refLine);
        }
    }
}

function prepareImage(workerData, dicomBuffer, dicomReader) {
    var dicomInfo = workerData.dicominfo;
    var minMax = {
        min: dicomInfo.imageInfo.minPixelValue,
        max: dicomInfo.imageInfo.maxPixelValue
    };

    var isCompressed = true;
    if (isCompressed) {
        if (!workerData.isDecompressionRequired) {
            pixelBuffer = dicomBuffer;
        } else {
            // decompress image
            pixelBuffer = pako.inflate(dicomBuffer);

            //convert to 16 bit array if necessary
            var bitsAllocated = dicomInfo.imageInfo.bitsAllocated;
            if (bitsAllocated == 16) {

                var arraySize8 = pixelBuffer.length;
                var pixelBuffer16 = new Uint16Array(arraySize8 / 2);
                var pixelIndex = 0;
                for (var i = 0; i < arraySize8; i += 2) {
                    pixelBuffer16[pixelIndex++] = (pixelBuffer[i + 1] * 256) + pixelBuffer[i];
                }
                pixelBuffer = pixelBuffer16;
            }
        }
    } else {
        var bitsAllocated = dicomInfo.imageInfo.bitsAllocated;
        var bytesPerPixel = (bytesPerPixel == 8) ? 1 : 2;
        var pixelBuffer = new Array(dicomBuffer.length);
        var pixelIndex = 0;
        for (var i = 0; i < dicomBuffer.length; i += bytesPerPixel) {
            pixelBuffer[pixelIndex++] = dicomReader.readNumber(bytesPerPixel, i);
        }
    }

    var renderImage = {
        pixelArray: pixelBuffer,
        minMaxPixel: minMax
    };

    return renderImage;
}

/**
 * process xRef line for the specified slice
 * @param {Type} workerData - Specifies the worker data
 */
function processXRefLines(workerData) {
    try {
        var refLines = [];
        if (workerData === undefined || workerData === null) {
            postMessage(refLines);
            return;
        }

        var sourceImage = workerData.sourceImage;
        if (sourceImage === undefined || sourceImage === null) {
            postMessage(refLines);
            return;
        }

        var targetImages = workerData.targetImages;
        if (targetImages === undefined || targetImages === null || targetImages.length === 0) {
            postMessage(refLines);
            return;
        }

        for (var targetImageIndex = 0; targetImageIndex < targetImages.length; targetImageIndex++) {
            var targetImage = targetImages[targetImageIndex];
            if (sourceImage.imageUid === targetImage.imageUid) {
                continue;
            }

            // Process slice values
            var sliceValues = dicomViewer.xRefLineViewer.calculateProjectSlice(sourceImage.imagePlane, targetImage.imagePlane);
            refLines.push({
                sourceImageUid: sourceImage.imageUid,
                targetImageUid: targetImage.imageUid,
                value: sliceValues
            });
        }

        postMessage(refLines);
    } catch (e) {}
}

/**
 * Process the 6000 overlay
 * @param {Type} workerData - Specifies the worker data 
 * @param {Type} imageData - Specifies the image buffer
 */
function process6000Overlay(workerData, imageData) {
    var pixelBuffer = undefined;
    try {
        pixelBuffer = pako.inflate(imageData);
        if (workerData.bitsAllocated == 16) {

            var arraySize8 = pixelBuffer.length;
            var pixelBuffer16 = new Uint16Array(arraySize8 / 2);
            var pixelIndex = 0;
            for (var i = 0; i < arraySize8; i += 2) {
                pixelBuffer16[pixelIndex++] = (pixelBuffer[i + 1] * 256) + pixelBuffer[i];
            }

            pixelBuffer = pixelBuffer16;
        }
    } catch (e) {}

    postMessage({
        overlayData: pixelBuffer
    });
}

