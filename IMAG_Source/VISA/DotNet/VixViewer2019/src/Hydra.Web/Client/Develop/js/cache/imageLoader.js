/**
 * This module deals with ImageLoaders, loading images and caching images
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    /**
     * Get the image promise
     */
    function getImagePromise(requestData) {
        return getImageInfo(requestData);
    }

    // Loads an image given an imageUid and returns a promise which will resolve
    // to the loaded image object or fail if an error occurred.  The image is
    // stored in the cache
    function getImage(requestData) {
        if (requestData.imageUid === undefined) {
            throw "getImage: parameter imageUid must not be undefined";
        }

        if (dicomViewer.isSeriesInComplete(requestData.studyUid, requestData.seriesIndex, requestData.imageIndex)) {
            dicomViewer.enableCacheData(requestData.studyUid, true);
            dicomViewer.cacheImages(requestData.studyUid);
        }

        var imagePromise = dicomViewer.imageCache.getImagePromise(requestData.imageUid + "_" + requestData.frameIndex);
        if (imagePromise !== undefined) {
            return imagePromise;
        }

        imagePromise = getImagePromise(requestData);
        if (imagePromise === undefined) {
            throw "getImage: no image loader for imageUid";
        }
        requestData.imagePromise = imagePromise;

        dicomViewer.imageCache.putImagePromise(requestData);
        return imagePromise;
    }

    function updateImage(imageCanvas, image, presentation) {
        //var presentation = image.presentation;
        var lookUpTable = presentation.getlookupTable();
        imageCanvas.height = image.rows;
        imageCanvas.width = image.columns;
        var context = imageCanvas.getContext("2d");
        context.setTransform(1, 0, 0, 1, 0, 0);
        // clear the canvas
        context.fillStyle = 'black';
        context.fillRect(0, 0, image.columns, image.rows);

        if (image.isWLApplied == false ||
            image.lastAppliedwindowCenter != presentation.windowCenter ||
            image.lastAppliedWindowWidth != presentation.windowWidth ||
            image.lastAppliedBrightness != presentation.brightness ||
            image.lastAppliedContrast != presentation.contrast ||
            image.lastAppliedInvert != presentation.invert ||
            image.lastAppliedRGBMode != presentation.rgbMode ||
            image.lastAppliedSharpenLevel != presentation.sharpen ||
            image.is6000Overlay != dicomViewer.tools.is6000OverlayVisible()) {
            // Update the flags
            image.lastAppliedwindowCenter = presentation.windowCenter;
            image.lastAppliedWindowWidth = presentation.windowWidth;
            image.lastAppliedBrightness = presentation.brightness;
            image.lastAppliedContrast = presentation.contrast;
            image.lastAppliedInvert = presentation.invert;
            image.presentation.invert = presentation.invert;
            image.presentation.rgbMode = presentation.rgbMode;
            image.lastAppliedRGBMode = presentation.rgbMode;
            image.lastAppliedWindowLevel = presentation.windowLevel;
            image.is6000Overlay = dicomViewer.tools.is6000OverlayVisible();
            image.isWLApplied = true;
            image.presentation.sharpen = presentation.sharpen;
            image.lastAppliedSharpenLevel = presentation.sharpen;

            // Get the wl canvas context
            image.wlCanvasContext.fillStyle = 'white';
            image.wlCanvasContext.fillRect(0, 0, image.wlCanvas.width, image.wlCanvas.height);
            image.wlCanvasData = image.wlCanvasContext.getImageData(0, 0, image.wlCanvas.width, image.wlCanvas.height);

            var imageData = dicomViewer.imageCache.getImageData(image, imageCanvas.canvasId);
            if (!imageData) {
                imageData = dicomViewer.imageCache.getRawData(image)
            }

            if (image.isColorImage) {
                lookUpTable.applyColorLUT(imageData, image.wlCanvasData, image.columns, image.rows, presentation.getRGBMode());
            } else {
                lookUpTable.applyLUT(imageData, image.wlCanvasData, image.columns, image.rows);

                // Apply 6000 overlay
                if (dicomViewer.tools.is6000OverlayVisible()) {
                    lookUpTable.apply6000Overlay(image, image.wlCanvasData);
                }
            }

            image.wlCanvasContext.putImageData(image.wlCanvasData, 0, 0);
            image.wlCanvasData = null;

            // If applysharpen true then use sharpen tool
            // Sharpen tool will work once the canvas image is created
            if (image.applySharpen) {
                lookUpTable.applySharpen(image.wlCanvasContext, image.wlCanvas.width, image.wlCanvas.height, image.presentation.sharpen);
            }
        }

        context.drawImage(image.wlCanvas, 0, 0, image.columns, image.rows, 0, 0, image.columns, image.rows);
    }

    function getImageInfo(requestData) {
        requestData.deferred = $.Deferred();
        requestData.urlParameters = dicomViewer.getImageInfoURl(requestData.imageUid);
        requestData.dicominfo = dicomViewer.header.getDicomHeader(requestData.imageUid);
        requestData.imageInfo = dicomViewer.Series.Image.getImage(requestData.studyUid, requestData.seriesIndex, requestData.imageIndex);
        requestImage(requestData);
        return requestData.deferred;
    }

    function processDicomImage(imageUid, frameNumber, dicominfo, fileContent, compressDone, seriesIndex, studyUid) {
        var renderImage;
        if (compressDone) {
            renderImage = fileContent;
        } else {
            var reader = new DicomInputStreamReader();
            reader.readDICOMBytes(fileContent);
            var dicomBuffer = reader.getInputBuffer();
            var dicomReader = reader.getReader();
            renderImage = prepareImage(dicominfo, dicomBuffer, dicomReader);
        }

        var pixelBuffer = renderImage.pixelArray;
        var minMaxPixel = renderImage.minMaxPixel;
        var image = {
            studyUid: studyUid,
            imageUid: imageUid,
            frameNumber: frameNumber,
            dicominfo: dicominfo,
            imageData: pixelBuffer,
            canvas: null,
            sizeInBytes: (isCacheCompressedImageData ? pixelBuffer.length : dicominfo.getFrameSize()),
            canvasCtx: null,
            presentation: new Presentation(),
            lastAppliedInvert: false,
            lastAppliedRGBMode: 0,
            rows: dicominfo.getRows(),
            columns: dicominfo.getColumns(),
            minPixel: minMaxPixel.min,
            maxPixel: minMaxPixel.max,
            invert: (dicominfo.getPhotometricInterpretation() === "MONOCHROME1" ? true : false),
            isColorImage: dicominfo.isColor(),
            imageType: "image",
            isWLApplied: false,
            bitsAllocated: dicominfo.getBitsAllocated(),
            isCompressed: isCacheCompressedImageData,
            minMaxPixel: minMaxPixel,
            isRGBToolEnabled: true,
            lastAppliedWindowLevel: 1,
            is6000Overlay: false,
            lastAppliedSharpenLevel: 0,
            applySharpen: isShowSharpen
        };

        /*************************************************************************
         * Create the separate canvas for WL
         * Referred from 'cornerstoneDemo' to improve performance in IE
         * http://chafey.github.io/cornerstoneDemo/
         **************************************************************************/
        image.wlCanvas = document.createElement('canvas');
        image.wlCanvas.width = image.columns;
        image.wlCanvas.height = image.rows;
        image.wlCanvasContext = image.wlCanvas.getContext('2d');
        image.wlCanvasContext.fillStyle = 'white';
        image.wlCanvasContext.fillRect(0, 0, image.wlCanvas.width, image.wlCanvas.height);
        image.wlCanvasData = null;

        // Calculate the render size
        image.renderSizeInBytes = getRenderSize(image);
        image.sizeInBytes *= 8;

        // Update window level
        updateWindowLevel(image);

        // Update the 6000 overlay
        update6000Overlay(image, 0, seriesIndex);

        return image;
    }

    function processGeneralImage(imageUid, frameNumber, dicominfo, imageData, deferred) {
        var brightness = 100;
        var contrast = 100;
        var presentation = new Presentation();
        var backgroudRenderer = document.createElement("canvas");
        var context = backgroudRenderer.getContext("2d");

        presentation.setBrightnessContrast(brightness, contrast);
        var imageObj = new Image();
        imageObj.onload = function () {
            dicominfo.setRows(imageObj.height);
            dicominfo.setColumns(imageObj.width);
            var sizeInBytes = imageObj.height * imageObj.width;
            var image = {
                imageUid: imageUid,
                frameNumber: frameNumber,
                dicominfo: dicominfo,
                imageData: imageObj,
                canvas: null,
                sizeInBytes: sizeInBytes,
                canvasCtx: null,
                presentation: presentation,
                windowWidth: 0,
                windowCenter: 0,
                brightness: brightness,
                contrast: contrast,
                lastAppliedWindowWidth: 0,
                lastAppliedwindowCenter: 0,
                lastAppliedBrightness: brightness,
                lastAppliedContrast: contrast,
                lastAppliedInvert: false,
                rows: imageObj.height,
                columns: imageObj.width,
                invert: false,
                isColorImage: false,
                imageType: "image",
                isWLApplied: false,
                isRGBToolEnabled: false,
                lastAppliedWindowLevel: 1
            };
            image.studyUid = deferred.studyUid;
            deferred.resolve(image);
        };
        var blob = new Blob([imageData], {
            type: 'application/jpeg'
        });
        imageObj.src = window.URL.createObjectURL(blob);
    }

    function requestImage(requestData) {
        try {
            var t0 = Date.now();
            dumpConsoleLogs(LL_DEBUG, undefined, "loader", "Start");

            if (!requestData.imageInfo && requestData.dicominfo) {
                requestData.imageInfo = requestData.dicominfo.imageInfo;
            }
            var imageType = requestData.imageInfo.imageType;
            var excludeImageInfo = true;
            if (!requestData.dicominfo) {
                excludeImageInfo = false;
            }

            if (requestData.deferred) {
                requestData.deferred.studyUid = requestData.studyUid;
            }
            var imageIndex = requestData.imageIndex;
            if (imageIndex == undefined) {
                imageIndex = dicomViewer.Series.Image.getImageIndex(requestData.studyUid, requestData.seriesIndex, requestData.imageUid);
            }

            //VAI-307 Tell the server side to execute its operation via SignalR to request the PDF
            var imageFile = dicomViewer.Series.Image.getImageFilePath(requestData.studyUid, requestData.seriesIndex, requestData.imageUid);
            if (imageFile.includes("Tiff;"))
                requestPdfFile(requestData.seriesIndex,requestData.imageUid);
            
            
            var isMultiframe = (requestData.imageInfo.numberOfFrames > 1) && (requestData.imageInfo.modality === "US");
            var cachePriority = getCachePriority(requestData, isMultiframe);
            requestData.priority = cachePriority;
            var requestHeaders = getRequestHeaders(requestData.studyUid, requestData.seriesIndex, requestData.imageUid);
            if (imageType == IMAGETYPE_RADECHO || imageType == IMAGETYPE_RAD || imageType == null) {
                if (isMultiframe) {
                    requestGeneralImage(requestData, excludeImageInfo, requestHeaders);
                } else {
                    var urlParameters = dicomViewer.getDicomFrameUrl(requestData.imageUid, requestData.frameIndex, excludeImageInfo);
                    var url = dicomViewer.url.getDicomImageURL(urlParameters);
                    var logMessage = "Imageinfo request url : " + url + "\n \
                          Image request for => " + requestData.imageUid + "_" + requestData.frameIndex;
                    dumpConsoleLogs(LL_DEBUG, undefined, undefined, logMessage);
                    if (typeof (Worker) !== "undefined") {
                        var workerJob = {
                            studyUid: requestData.studyUid,
                            seriesIndex: requestData.seriesIndex,
                            imageUid: requestData.imageUid,
                            frameNumber: requestData.frameIndex,
                            deferred: requestData.deferred,
                            url: url,
                            headers: requestHeaders,
                            dicominfo: requestData.dicominfo,
                            excludeImageInfo: excludeImageInfo,
                            isDecompressionRequired: !isCacheCompressedImageData,
                            type: "cache",
                            request: "Image",
                            isProcessing: false,
                            priority: cachePriority,
                            id: "Image_" + requestData.seriesIndex + "_" + imageIndex + "_" + requestData.frameIndex,
                            isCineRunning: dicomViewer.scroll.isCineRunningInViewport(),
                            imageIndex: requestData.imageIndex,
                            isMultiframe: false
                        };
                        workerJob.__proto__ = null;
                        doWorkerQueue(workerJob);
                    } else {
                        $.ajax({
                            url: url,
                            beforeSend: function (xhr) {
                                xhr.overrideMimeType("text/plain; charset=x-user-defined");
                            }
                        })
                            .done(function (data) {
                                var image = processDicomImage(requestData.imageUid, requestData.frameNumber, requestData.dicominfo, data, false);
                                deferred.resolve(image);
                            })
                            .fail(function (data) {
                                deferred.reject();
                            })
                            .error(function (xhr, status) {
                                var description = xhr.statusText + "\nFailed to read the image." + "\nImage UID: " + imageUid;
                                sendViewerStatusMessage(xhr.status.toString(), description);
                            });
                    }
                    $("#ecgPreference").prop("disabled", true);
                }
            } else if (imageType == IMAGETYPE_JPEG) {
                requestGeneralImage(requestData, excludeImageInfo, requestHeaders);
            } else if (imageType == IMAGETYPE_RADPDF) {
                requestPdf(requestData);
            } else if (imageType == IMAGETYPE_RADECG) {
                dicomViewer.loadEcg(requestData.urlParameters, "imageviewer1x1", undefined, undefined, requestHeaders);
            } else if (imageType == IMAGETYPE_RADSR || imageType == IMAGETYPE_CDA) {
                dicomViewer.loadSR(requestData.urlParameters, null, requestData.deferred, imageType, requestHeaders);
            }
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
        } finally {
            dumpConsoleLogs(LL_DEBUG, undefined, undefined, "End", (Date.now() - t0));
        }
    }

    function getCachePriority(requestData, isMultiframe) {
        var priority = PRIORITY_BACKGROUND;
        var seriesLayout = dicomViewer.viewports.getViewportByImageIndex(requestData.studyUid, requestData.seriesIndex, requestData.imageIndex);
        if (seriesLayout) {
            priority = PRIORITY_VISIBLE;
        }

        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var activeSeriesIndex, activeImageIndex;
        if (activeSeriesLayout) {
            activeSeriesIndex = activeSeriesLayout.seriesIndex;
            activeImageIndex = activeSeriesLayout.scrollData.imageIndex;
        }

        if (isMultiframe) {
            priority = ((requestData.seriesIndex == activeSeriesIndex) 
                        && (requestData.imageIndex == activeImageIndex)) ? PRIORITY_ACTIVE : priority;
        } else {
            priority = (requestData.seriesIndex == activeSeriesIndex) ? PRIORITY_ACTIVE : priority;
        }

        return priority;
    }

    function requestGeneralImage(requestData, excludeImageInfo, requestHeaders) {
        var imageUid = requestData.imageUid;
        var frameNumber = requestData.frameIndex;
        var urlParameters = requestData.urlParameters;
        var deferred = requestData.deferred;
        var dicominfo = requestData.dicominfo;

        urlParameters = dicomViewer.getJpegFrameUrl(imageUid, frameNumber, excludeImageInfo);
        var url = dicomViewer.url.getDicomImageURL(urlParameters);
        var logMessage = "Imageinfo request url : " + url + "\n \
                          Image request for => " + imageUid + "_" + frameNumber;
        dumpConsoleLogs(LL_DEBUG, undefined, "requestGeneralImage ", logMessage);

        if (typeof (Worker) !== "undefined") {
            var workerJob = {
                imageUid: imageUid,
                frameNumber: frameNumber,
                deferred: deferred,
                url: url,
                headers: requestHeaders,
                dicominfo: dicominfo,
                excludeImageInfo: excludeImageInfo,
                type: "cache",
                request: "Image",
                isJpeg: true,
                isProcessing: false,
                priority: requestData.priority,
                id: "Image_" + imageUid,
                isCineRunning: dicomViewer.scroll.isCineRunningInViewport(),
                imageIndex: requestData.imageIndex,
                isMultiframe: true
            };
            doWorkerQueue(workerJob);
        } else {
            var request = new XMLHttpRequest();
            request.open('GET', url, true);
            if (requestHeaders) {
                for (var key in requestHeaders) {
                    request.setRequestHeader(key, requestHeaders[key]);
                }
            }
            request.send();
            request.onreadystatechange = function () {
                if (request.readyState == 4 && request.status == 200) {
                    processGeneralImage(imageUid, frameNumber, dicominfo, request.response, deferred);
                } else if (request.readyState == 4 && (request.status == 404 || request.status == 500)) {
                    deferred.resolve("Failure");
                    var description = xhr.statusText + "\nFailed to read the image." + "\nImage UID: " + imageUid;
                    sendViewerStatusMessage(xhr.status.toString(), description);
                }
            }
        }

        $("#ecgPreference").prop("disabled", true);
    }

    function requestPdf(requestData) {
        $("#ecgPreference").prop("disabled", true);
        var urlParameters = dicomViewer.getPdfFrameUrl(requestData.imageUid);
        var url = dicomViewer.url.getDicomImageURL(urlParameters);
        $("#imageviewer1x1").empty();
        var pdfDiv = "<div id='pdf' style='height:100%;width:100%'><iframe name='pdfviewer1x1' style='height:100%;width:100%' src=" + url + "/></div>";
        $("#imageviewer1x1").append(pdfDiv);
        document.getElementsByName("pdfviewer1x1")[0].contentWindow.document.body.focus();
    }

    function prepareImage(dicominfo, dicomBuffer, dicomReader) {
        var minMax = {
            min: dicominfo.getMinPixelValue(),
            max: dicominfo.getMaxPixelValue()
        };

        var isCompressed = true;
        if (isCompressed) {
            if (!isCacheCompressedImageData) {
                pixelBuffer = dicomBuffer;
            } else {
                // decompress image
                pixelBuffer = pako.inflate(dicomBuffer);

                // convert to 16 bit array if necessary
                var bitsAllocated = dicominfo.getBitsAllocated();
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
            var bitsAllocated = dicominfo.getBitsAllocated();
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

    function getWindowLevelLimits(minMaxPixel, dicominfo) {
        var aRescaleSlope = dicominfo.getRescaleSlope();
        var aRescaleIntercept = dicominfo.getRescaleIntercept();

        var minLevelValue = (minMaxPixel.min * aRescaleSlope) + aRescaleIntercept;
        var maxLevelValue = (minMaxPixel.max * aRescaleSlope) + aRescaleIntercept;
        var minWindowValue = 1; // As per the Standard
        var maxWindowValue = (maxLevelValue - minLevelValue) * 2.0;

        return {
            wwLimit: {
                min: minWindowValue,
                max: maxWindowValue
            },
            wcLimit: {
                min: minLevelValue,
                max: maxLevelValue
            }
        };
    }

    function findMinMax(dicominfo, pixelBuffer) {
        var min = 65536;
        var max = -65536;
        for (var i = 0; i < pixelBuffer.length; i++) {
            var pixel = pixelBuffer[i];
            if (min > pixel) min = pixel;
            if (max < pixel) max = pixel;
        }
        var minMax = {
            min: min,
            max: max
        };

        return minMax;
    }

    function calculateAutoWindowLevel(dicominfo, minMaxPixel) {
        var aRescaleSlope = dicominfo.getRescaleSlope();
        var aRescaleIntercept = dicominfo.getRescaleIntercept();
        if (aRescaleSlope === undefined) {
            aRescaleSlope = 1;
        }
        if (aRescaleIntercept === undefined) {
            aRescaleIntercept = 0;
        }
        var vMinPixel = minMaxPixel.min;
        var vMaxPixel = minMaxPixel.max;
        if (dicominfo.getBitsAllocated() === 16 && Math.pow(2, dicominfo.getBitsAllocated() - 1) < (vMaxPixel - vMinPixel)) {
            vMinPixel = 0 - minMaxPixel.min;
            vMaxPixel = 65536 - minMaxPixel.max;
        } else if (vMinPixel === 0 && vMaxPixel === Math.pow(2, dicominfo.getBitsAllocated() - 1)) {
            vMinPixel = 0;
            vMaxPixel = (1 / aRescaleSlope) - aRescaleIntercept;;
        }

        var itsMinLevelRange = (vMinPixel * aRescaleSlope) + aRescaleIntercept; // Minimum Level can be accepted for this image
        var itsMaxLevelRange = (vMaxPixel * aRescaleSlope) + aRescaleIntercept; // Maximum Level can be accepted for this image

        // Window level should be within itsMinLevelRange and itsMaxLevelRange
        var level = (itsMinLevelRange + itsMaxLevelRange) / 2; // Expected Window Level

        var theMinWindowRange = 1; // As per the Standard. Minimum width can be accepted for this image
        var theMaxWindowRange = (itsMaxLevelRange - itsMinLevelRange) * 2.0; // Maximum width can be accepted for this image

        // Window width should be within theMinWindowRange and theMaxWindowRange
        var window = (theMinWindowRange + theMaxWindowRange) / 2; // Expected Window Level

        return {
            ww: parseInt(window),
            wc: parseInt(level)
        };
    }

    function changeNullToEmpty(value) {
        if (value == undefined || value == null) {
            return "";
        }
        return value;
    }

    /**
     * Calculate the render size
     * @param {Type} image - Specifies the image object
     */
    function getRenderSize(image) {
        try {
            if (image == undefined || image == null) {
                return 0;
            }

            if (!image.isCompressed) {
                return 0;
            }

            var isWLRequired = (image.dicominfo.getModality() === "US" ? false : true);
            var sizeInBytes = image.dicominfo.getFrameSize();
            var renderCanvasSize = sizeInBytes;
            var wlCanvasSize = (isWLRequired ? sizeInBytes : 0);
            var minMaxPixel = (isWLRequired ? (image.maxPixel - Math.min(image.minPixel, 0)) + 1 : 0);
            var renderSize = (sizeInBytes / 4);
            var totalRenderSize = 0;

            totalRenderSize += renderCanvasSize;
            totalRenderSize += wlCanvasSize;
            totalRenderSize += minMaxPixel;
            totalRenderSize += renderSize;

            return totalRenderSize;
        } catch (e) {}

        return 0;
    }

    /**
     * update the window level
     * @param {Type} image - Specifies the image
     */
    function updateWindowLevel(image) {
        try {
            /*
            *  Window / Level
            // windowWidth => Window
            // windowCenter => Level
            */

            var windowCenter = image.dicominfo.getWindowCenter();
            var windowWidth = image.dicominfo.getWindowWidth();
            var pixelBuffer = dicomViewer.imageCache.getRawData(image);
            var dicominfo = image.dicominfo;
            var minMaxPixel = image.minMaxPixel;
            var windowLevelLimits = getWindowLevelLimits(minMaxPixel, dicominfo);
            var invert = image.invert;
            var brightness = 100;
            var contrast = 100;

            var autoCalWinLvl = false;
            if (isNaN(windowCenter) || isNaN(windowWidth)) {
                if (image.isColor) {
                    windowCenter = 128;
                    windowWidth = 255;
                } else {
                    autoCalWinLvl = true;
                }
            } else if (windowCenter === 0 && windowWidth === 0) {
                autoCalWinLvl = true;
            }

            if (autoCalWinLvl) {
                var autoWindowLevel = {
                    wc: windowCenter,
                    ww: windowWidth
                };
                minMaxPixel = findMinMax(dicominfo, pixelBuffer);
                windowLevelLimits = getWindowLevelLimits(minMaxPixel, dicominfo);
                autoWindowLevel = calculateAutoWindowLevel(dicominfo, minMaxPixel);
                windowCenter = autoWindowLevel.wc;
                windowWidth = autoWindowLevel.ww;
            }

            image.windowWidth = windowWidth;
            image.windowCenter = windowCenter;
            image.brightness = brightness;
            image.contrast = contrast;
            image.lastAppliedWindowWidth = windowWidth;
            image.lastAppliedwindowCenter = windowCenter;
            image.lastAppliedBrightness = brightness;
            image.lastAppliedContrast = contrast;
            image.presentation.setWindowingdata(windowCenter, windowWidth);
            image.presentation.setWindowLevel(dicominfo, minMaxPixel, invert);
            image.presentation.setWindowLevelLimits(windowLevelLimits);
            image.presentation.setBrightnessContrast(brightness, contrast);
        } catch (e) {}
    }

    /**
     * 
     * @param {Type} image - Specifies the image
     * @param {Type} overlayIndex - Specifies the overlay index
     */
    function update6000Overlay(image, overlayIndex, seriesIndex) {
        try {
            var dicominfo = image.dicominfo;
            if (!dicominfo) {
                return;
            }

            var imageInfo = dicominfo.imageInfo;
            if (!imageInfo) {
                return;
            }

            var overlays = imageInfo.overlays;
            if (!overlays) {
                return;
            }

            if (overlayIndex < 0 || overlayIndex > overlays.length - 1) {
                return;
            }

            var overlay = overlays[overlayIndex];
            if (!overlay) {
                return;
            }

            if (!image.overlay6000) {
                image.overlay6000 = {};
            }

            // Check whether the 6000 overlay data is already processed 
            if (image.overlay6000.overlayData !== undefined) {
                return;
            }

            // 6000 Overlay canvas 
            image.overlay6000.column = overlay.columns;
            image.overlay6000.row = overlay.rows;
            image.overlay6000.description = overlay.description;
            image.overlay6000.label = overlay.label;
            image.overlay6000.overlayData = undefined;

            // Update the render size
            image.renderSizeInBytes += (overlay.columns * overlay.rows * (overlay.bitDepth / 8));

            var requestHeaders = getRequestHeaders(image.studyUid, seriesIndex, image.imageUid);
            // Process 6000 overlay image data
            if (typeof (Worker) !== "undefined") {
                var workerJob = {
                    image: image,
                    seriesIndex: seriesIndex,
                    bitsAllocated: overlay.bitDepth,
                    url: dicomViewer.url.get6000overlayUrl(image.imageUid, image.frameNumber, overlayIndex),
                    headers: requestHeaders,
                    type: "cache",
                    request: "overlay6000",
                    isProcessing: false,
                    id: "overlay6000_" + image.imageUid,
                };
                doWorkerQueue(workerJob);
            }
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, "update6000Overlay ", e.message);
        }
    }

    /**
     * Refresh the 6000 overlay
     * @param {Type} image - specifies the image 
     */
    function refresh6000Overlay(image) {
        try {
            var allViewports = dicomViewer.viewports.getAllViewports();
            if (allViewports === null || allViewports === undefined) {
                return undefined;
            }

            $.each(allViewports, function (key, value) {
                if (value.studyUid) {
                    $("#" + value.seriesLayoutId + " div").each(function () {
                        var imageLevelId = $(this).attr('id');
                        var imageRender = value.getImageRender(imageLevelId);
                        if (imageRender) {
                            if (imageRender.imageUid === image.imageUid && image.is6000Overlay) {
                                image.is6000Overlay = false;
                                imageRender.renderImage(false);
                            }
                        }
                    });
                }
            });
        } catch (e) {}
    }

    // module exports
    dicomViewer.requestImage = requestImage;
    dicomViewer.getImage = getImage;
    dicomViewer.updateImage = updateImage;
    dicomViewer.processDicomImage = processDicomImage;
    dicomViewer.processGeneralImage = processGeneralImage;
    dicomViewer.getImagePromise = getImagePromise;
    dicomViewer.refresh6000Overlay = refresh6000Overlay;

    return dicomViewer;
}(dicomViewer));
