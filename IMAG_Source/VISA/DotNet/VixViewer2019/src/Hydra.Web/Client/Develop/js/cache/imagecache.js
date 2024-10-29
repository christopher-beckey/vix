/**
 * This module deals with caching images
 */

var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var cachedImages = {};
    var cachedImagesBySeries = {};
    var maximumSizeInBytesForMobileDevice = 100 * 1024 * 1024; // 100 MB cache
    var maximumSizeInBytesForSystem = 800 * 1024 * 1024; // 800 MB cache

    var maximumSizeInBytes = 800 * 1024 * 1024; // 800 MB cache
    var maximumSizeToReduceInBytes = (maximumSizeInBytes * 0.40); // 250 MB cache
    var maximumSizeToReduceInBytesInViewingSeries = (maximumSizeInBytes * 0.20); // 125 MB cache

    var browserLoadingMemorySize = 50 * 1024 * 1024; // 50 MB cache approximately
    var compilationMemorySize = 10 * 1024 * 1024; // 10 MB cache approximately
    var stringMemorySize = 8 * 1024 * 1024; // 8 MB cache approximately
    var cacheSizeInBytes = browserLoadingMemorySize + compilationMemorySize + stringMemorySize;

    var cacheInformation = {
        series: {}
    };

    // Hold the visual viewport image raw data
    var viewportImageDataMap = new Map();
    function putImagePromise(requestData) {
        if (requestData.imageUid === undefined) {
            throw "putImagePromise: imageUid must not be undefined";
        }

        if (requestData.imagePromise === undefined) {
            throw "putImagePromise: imagePromise must not be undefined";
        }

        if (cachedImages.hasOwnProperty(requestData.imageUid) === true) {
            return;
        }
        var imagePromise = requestData.imagePromise;
        var copyData = JSON.parse(JSON.stringify(requestData));
        copyData.imagePromise = imagePromise;

        var cachedImage = {
            imageUid: copyData.imageUid,
            studyUid: copyData.studyUid,
            frameIndex: copyData.frameIndex,
            imagePromise: copyData.imagePromise,
            timeStamp: new Date(),
            sizeInBytes: 0,
            seriesIndex: copyData.seriesIndex,
            index: copyData.imageIndex
        };

        copyData.imagePromise.done(function (image) {
            if (image.imageType == "image" && cachedImages[copyData.imageUid + "_" + copyData.frameIndex] === undefined) {

                purgeCache(copyData.studyUid, image.sizeInBytes);
                //var objectSizeInBytes = memorySizeOf(image);
                //purgeCache(studyUid, objectSizeInBytes);

                cachedImages[copyData.imageUid + "_" + copyData.frameIndex] = cachedImage;

                var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(copyData.studyUid, copyData.seriesIndex);
                var tempIndex = isMultiFrame ? copyData.imageIndex : copyData.seriesIndex;
                if (tempIndex == undefined) {
                    tempIndex = 0;
                }

                if (cachedImagesBySeries[tempIndex] === undefined) {
                    cachedImagesBySeries[tempIndex] = {};
                }

                if (cachedImagesBySeries[tempIndex][copyData.imageUid] === undefined) {
                    cachedImagesBySeries[tempIndex][copyData.imageUid] = {};
                }
                cachedImagesBySeries[tempIndex][copyData.imageUid][copyData.frameIndex] = copyData.imageUid + "_" + copyData.frameIndex;
                cachedImage.loaded = true;

                if (image.sizeInBytes === undefined) {
                    throw "putImagePromise: image does not have sizeInBytes property or";
                }

                if (image.sizeInBytes.toFixed === undefined) {
                    throw "putImagePromise: image.sizeInBytes is not a number";
                }

                cachedImage.sizeInBytes = image.sizeInBytes;
                //cachedImage.sizeInBytes = memorySizeOf(image);
                cachedImage.image = image;
                cacheSizeInBytes += cachedImage.sizeInBytes;
                addCacheInfo(copyData);
            }
        });
    }

    function purgeCache(studyUid, bytesNeeded, reducedSizeInBytes, count, unload) {
        if (reducedSizeInBytes && (reducedSizeInBytes > bytesNeeded)) {
            return;
        }

        var cacheData = dicomViewer.getCacheData(studyUid);
        if (getCachePercentage() < 90 || cacheData.initialCache) {
            return;
        }

        var arrayToSearchImage = Object.keys(cachedImages);
        var prevNextCount = (count == undefined) ? 2 : 0;
        reducedSizeInBytes = 0;

        for (var i = 0; i < arrayToSearchImage.length; i++) {
            if (reducedSizeInBytes && (reducedSizeInBytes > bytesNeeded)) {
                return;
            }

            var lastCachedImageKey = arrayToSearchImage[i];
            var lastCachedImage = cachedImages[lastCachedImageKey];
            if (lastCachedImage != null) {
                var imageIndex = parseInt(dicomViewer.Series.Image.getImageIndex(lastCachedImage.studyUid,
                    lastCachedImage.seriesIndex,
                    lastCachedImage.imageUid));
                var isViewing = false;
                var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(lastCachedImage.studyUid, lastCachedImage.seriesIndex);
                if (isMultiFrame) {
                    for (var j = imageIndex - prevNextCount; j <= (imageIndex + prevNextCount); j++) {
                        if (dicomViewer.viewports.isImageVisible(lastCachedImage.seriesIndex, j) === true) {
                            isViewing = true;
                            break;
                        }
                    }
                } else {
                    for (var j = lastCachedImage.seriesIndex - prevNextCount; j <= (lastCachedImage.seriesIndex + prevNextCount); j++) {
                        if (dicomViewer.viewports.isImageVisible(j) === true) {
                            isViewing = true;
                            break;
                        }
                    }
                }

                if (unload) {
                    isViewing = false;
                }

                var isPurge = isPurgeFirstImage(lastCachedImage);
                if (isViewing === false && isPurge) {
                    cacheSizeInBytes -= lastCachedImage.sizeInBytes;
                    reducedSizeInBytes += cacheSizeInBytes;
                    deleteCache(lastCachedImage, lastCachedImageKey);
                    var purgeSeriesIndex = lastCachedImage.seriesIndex;
                    var purgeImageIndex = !isMultiFrame ? lastCachedImage.index : lastCachedImage.frameIndex;
                    dicomViewer.purgeSeries(studyUid, purgeSeriesIndex, purgeImageIndex);

                    try {
                        var viewportList = dicomViewer.viewports.getAllViewports();
                        $.each(viewportList, function (key, value) {
                            if (value && value.progressbar && value.progressbar.seriesIndex == purgeSeriesIndex) {
                                value.progressbar.drawImageCacheIndicator();
                            }
                        });
                    } catch (e) {

                    }
                }
            }
        }
        arrayToSearchImage = [];
        if (getCachePercentage() > 90 && count == undefined) {
            purgeCache(studyUid, bytesNeeded, reducedSizeInBytes, 0);
        }
        if (getCachePercentage() > 90 && count == 0 && unload == undefined) {
            purgeCache(studyUid, bytesNeeded, reducedSizeInBytes, 0, true);
        }
    }

    function clearCache(studyUid) {
        var arrayToSearchImage = Object.keys(cachedImages);
        for (var i = 0; i < arrayToSearchImage.length; i++) {
            var lastCachedImageKey = arrayToSearchImage[i];
            var lastCachedImage = cachedImages[lastCachedImageKey];
            if (lastCachedImage != null) {
                if (studyUid !== undefined && lastCachedImage.studyUid !== studyUid) {
                    continue;
                }

                cacheSizeInBytes -= lastCachedImage.sizeInBytes;
                deleteCache(lastCachedImage, lastCachedImageKey);
            }
        }
        arrayToSearchImage = [];
    }

    function addCacheInfo(requestData) {
        try {
            var frameInfo = {
                frameNumber: requestData.frameIndex,
                imageUid: requestData.imageUid,
                seriesIndex: requestData.seriesIndex
            };

            var series = cacheInformation.series[requestData.seriesIndex];
            if (series === undefined) {
                series = {};
                cacheInformation.series[requestData.seriesIndex] = series;
            }

            var image = series[requestData.imageUid];
            if (image === undefined) {
                image = {};
                series[requestData.imageUid] = image;
            }
            image[requestData.frameIndex] = frameInfo;

            $("#cachemanager_progress").trigger("image_cache_updated", getCacheInfo());
            updateCacheIndicators(requestData.studyUid, requestData.seriesIndex, requestData.imageUid, requestData.imageIndex);
            var progressBar = dicomViewer.cacheIndicator.getCacheIndicator(requestData.seriesIndex, requestData.imageIndex);
            if (progressBar == undefined) {
                progressBar = dicomViewer.cacheIndicator.getCacheIndicator(requestData.seriesIndex, requestData.imageIndex - 1);
            }

            if (progressBar != undefined) {
                var progressBarId = progressBar.imageIndicator.id
                var image = dicomViewer.Series.Image.getImage(requestData.studyUid, requestData.seriesIndex, requestData.imageIndex);
                if (image !== undefined) {
                    var totalFrame = dicomViewer.Series.Image.getImageFrameCount(image);
                    var frameIndex = requestData.frameIndex + 1;
                    var thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(requestData.studyUid) + "_" + (requestData.seriesIndex) + "_thumb" + (requestData.imageIndex);
                    var element = document.getElementById(thumbnailId);
                    if (element == null) {
                        totalFrame = dicomViewer.Series.getImageCount(requestData.studyUid, requestData.seriesIndex);
                        frameIndex = requestData.imageIndex + 1;
                    }

                    $("#" + progressBarId).trigger("update", [totalFrame, frameIndex, progressBar]);
                }
            }
        }
        catch (e) {
            console.error("Error: Add cacheinfo - " + e);
        }
    }

    function updateCacheIndicators(studyUid, seriesIndex, imageUid, imageIndex) {
        if (imageIndex == undefined) {
            var imageIndex = dicomViewer.getImageIndexForImageUid(studyUid, seriesIndex, imageUid);
        }

        if (imageIndex !== undefined) {
            var imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
            if (imageValue !== undefined) {
                if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex)) {
                    var totalNumberOfFrames = dicomViewer.Series.Image.getImageFrameCount(imageValue) - 1;
                    if (totalNumberOfFrames == 0) {
                        totalNumberOfFrames++;
                    }
                    if ((cachedImagesBySeries[imageIndex] === undefined ||
                            cachedImagesBySeries[imageIndex][imageUid] === undefined) ||
                        Object.keys(cachedImagesBySeries[imageIndex]).length === 0 ||
                        Object.keys(cachedImagesBySeries[imageIndex][imageUid]).length === 0) {
                        updateThumbnailCacheIndication(imageUid, "red");
                    } else {
                        if (Object.keys(cachedImagesBySeries[imageIndex][imageUid]).length >= totalNumberOfFrames) {
                            updateThumbnailCacheIndication(imageUid, "green");
                        } else if (Object.keys(cachedImagesBySeries[imageIndex][imageUid]).length === 0) {
                            updateThumbnailCacheIndication(imageUid, "red");
                        } else {
                            updateThumbnailCacheIndication(imageUid, "yellow");
                        }
                    }
                } else {
                    var imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, 0);
                    var totalNumberOFImages = dicomViewer.Series.getImageCount(studyUid, seriesIndex) - 1;
                    if (cachedImagesBySeries[seriesIndex] !== undefined && cachedImagesBySeries[seriesIndex].length !== 0) {
                        if (Object.keys(cachedImagesBySeries[seriesIndex]).length >= totalNumberOFImages) {
                            var thumbnailImageId = dicomViewer.Series.Image.getImageUid(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, 0));
                            updateThumbnailCacheIndication(thumbnailImageId, "green");
                        } else if (Object.keys(cachedImagesBySeries[seriesIndex]).length === 0) {
                            updateThumbnailCacheIndication(imageValue.imageUid, "red");
                        } else {
                            updateThumbnailCacheIndication(imageValue.imageUid, "yellow");
                        }
                    } else {
                        updateThumbnailCacheIndication(imageValue.imageUid, "red");
                    }
                }
            }
        }
    }

    function removeCacheInfo(seriesIndex, imageUid, frameIndex) {
        var series = cacheInformation.series[seriesIndex];
        if (series === undefined) {
            throw "removeCacheInfo : series is undefind";
        }

        var image = series[imageUid];
        if (image === undefined) {
            throw "removeCacheInfo : image is undefind";
        }
        image[frameIndex] = undefined;

        if (Object.keys(image).length == 0) {
            image = undefined;
        }

        $("#cachemanager_progress").trigger("image_cache_updated", getCacheInfo());
    }


    function getImagePromise(imageUid) {
        if (imageUid === undefined) {
            throw "getImagePromise: imageUid must not be undefined";
        }

        var cachedImage = cachedImages[imageUid];
        if (cachedImage === undefined) {
            return undefined;
        }

        // bump time stamp for cached image
        cachedImage.timeStamp = new Date();
        return cachedImage.imagePromise;
    }


    function getCachedImage(imageUid) {
        if (imageUid === undefined) {
            throw "getImagePromise: imageUid must not be undefined";
        }

        var cachedImage = cachedImages[imageUid];
        if (cachedImage === undefined) {
            return undefined;
        }

        return cachedImage;
    }

    /**
     * Check the given imageUid is available in cache array or image array.
     */
    function isInCache(imageUid) {
        if (imageUid === undefined) {
            return false;
        }

        var cachedImage = cachedImages[imageUid];
        if (cachedImage === undefined) {
            return undefined;
        }

        return cachedImage.imagePromise != null;
    }

    function getCacheInfo() {
        return {
            maximumSizeInBytes: maximumSizeInBytes,
            cacheSizeInBytes: cacheSizeInBytes,
            numberOfImagesCached: Object.keys(cachedImages).length
        };
    }

    function setCacheSize(isMobileDevice) {
        if (isMobileDevice) {
            maximumSizeInBytes = maximumSizeInBytesForMobileDevice; // 800 MB cache
        } else {
            maximumSizeInBytes = maximumSizeInBytesForSystem; // 800 MB cache
        }

        maximumSizeToReduceInBytes = (maximumSizeInBytes * 0.40); // 250 MB cache
        maximumSizeToReduceInBytesInViewingSeries = (maximumSizeInBytes * 0.20); // 125 MB cache 
    }

    /**
     * Get the cache percentage
     */
    function getCachePercentage() {
        var cacheInfo = getCacheInfo();
        return ((cacheInfo.cacheSizeInBytes / cacheInfo.maximumSizeInBytes) * 100);
    }

    /**
     * Return the image's raw pixel buffer array data
     * @param {Type} image - Rendered image in the viewport
     */
    function getRawData(image) {
        try {
            if (image === undefined || image === null) {
                return undefined;
            }

            if (!image.isCompressed) {
                return image.imageData;
            }

            var rawImageData = pako.inflate(image.imageData);
            if (image.bitsAllocated == 16) {
                var imageDataLength = rawImageData.length;
                var rawImageData16 = new Uint16Array(imageDataLength / 2);
                var pixelIndex = 0;
                for (var i = 0; i < imageDataLength; i += 2) {
                    rawImageData16[pixelIndex++] = (rawImageData[i + 1] * 256) + rawImageData[i];
                }

                rawImageData = rawImageData16;
                rawImageData16 = null;
            }

            return rawImageData;
        } catch (e) {}
    }

    /**
     * To set the Visual viewport image id as well as raw pixel data in Key value form
     * @param {Type} image - Rendered image in the viewport
     * @param {Type} canvasId - specifies the canvas id
     */
    function setImageData(image, canvasId, isBackup) {
        try {
            if (image == null || image == undefined ||
                canvasId == null || canvasId == undefined) {
                // Invalid object
                return;
            }

            if (!image.isCompressed) {
                return;
            }

            // Set the default memory
            if (cacheSizeInBytes == 0) {
                cacheSizeInBytes = browserLoadingMemorySize + compilationMemorySize + stringMemorySize;
            }

            var isNewImageData = false;
            var frameNumber = (isNaN(image.frameNumber) ? 0 : image.frameNumber);
            var imageKey = canvasId + " | " + image.imageUid + "_" + frameNumber;
            var imageData = viewportImageDataMap.get(imageKey);
            if (imageData === undefined || imageData === null) {
                viewportImageDataMap.set(imageKey, getRawData(image));
                isNewImageData = true;
            }

            // Delete the existing image in the map for same renderer
            viewportImageDataMap.forEach(function (value, key, map) {
                if (key !== imageKey) {
                    if (value !== undefined) {
                        cacheSizeInBytes -= value.length;
                        cacheSizeInBytes -= image.renderSizeInBytes;
                    }
                    map.set(key, undefined);
                } else if (isNewImageData) {
                    cacheSizeInBytes += value.length;
                    cacheSizeInBytes += image.renderSizeInBytes;
                }
            });

            var cacheInKB = cacheSizeInBytes / 1024;
            var cacheInMB = cacheInKB / 1024;
            if (cacheInMB > 800) {
                dumpConsoleLogs(LL_WARN, undefined, "setImageData", "Cache size : " + cacheInMB);
            }

            if (isBackup === true) {
                return viewportImageDataMap.get(imageKey);
            }
        } catch (e) {}
    }

    /**
     * To get the Visual viewport image's raw pixel buffer array data
     * @param {Type} image - Rendered image in the viewport
     * @param {Type} canvasId - specifies the canvas id
     */
    function getImageData(image, canvasId) {
        try {
            if (image == null || image == undefined ||
                canvasId == null || canvasId == undefined) {
                // Invalid object
                return;
            }

            if (!image.isCompressed) {
                return image.imageData;
            } else {
                var frameNumber = (isNaN(image.frameNumber) ? 0 : image.frameNumber);
                var imageKey = canvasId + " | " + image.imageUid + "_" + frameNumber;
                var imageData = viewportImageDataMap.get(imageKey);
                if (imageData === undefined || imageData === null) {
                    imageData = setImageData(image, canvasId, true);
                }

                return imageData;
            }
        } catch (e) {}

        return undefined;
    }

    /**
     * Delete the cache image
     * @param {Type} imageKey - Specifies the image key 
     */
    function deleteCacheImage(imageKey) {
        try {
            var cacheImage = cachedImages[imageKey];
            if (cacheImage === undefined) {
                return;
            }

            var image = cacheImage.image;
            if (image === undefined || image === null) {
                return;
            }

            image.imageData = undefined;
            image.wlCanvas = undefined;
            image.wlCanvasContext = undefined;
            image.wlCanvasData = undefined;

            delete cachedImages[imageKey];
        } catch (e) {}
    }

    /**
     * check the last cache image is series first image or not
     * @param {Type} lastCachedImage - Specifies the lastCachedImage details
     */
    function isPurgeFirstImage(lastCachedImage) {
        try {
            //check multi frame or not.
            var imageValue = dicomViewer.Series.Image.getImage(lastCachedImage.studyUid, 0, 0);
            var isMultiFrame = dicomViewer.thumbnail.isImageThumbnail(imageValue, true);

            var imageIndex = !isMultiFrame ? parseInt(dicomViewer.Series.Image.getImageIndex(lastCachedImage.studyUid, lastCachedImage.seriesIndex, lastCachedImage.imageUid)) : "";
            if ((isMultiFrame && lastCachedImage.frameIndex == 0) || (!isMultiFrame && imageIndex == 0)) {
                return false;
            }
        } catch (e) {}
        return true;
    }

    /**
     * Cache the first image of the series
     * @param {Type} study - Specifies the study details
     */
    function cacheFirstImage(study, appliedSeriesLayout, studyDetail, studyUid) {
        try {
            if (!study) {
                return false;
            }

            var firstSeriesOrImage = dicomViewer.Series.Image.getImage(study.studyUid, 0, 0);
            if (!firstSeriesOrImage) {
                return false;
            }

            var cacheFirstImagePrmoise = $.Deferred();
            var totalImageCount = 0;
            var loadedImageCount = 0;

            var requestData = {
                studyUid: study.studyUid,
                seriesIndex: "",
                imageIndex: "",
                frameIndex: "",
                imageUid: "",
                imageType: "",
                layoutId:""
            };
            for (var seriesIndex = 0; seriesIndex < study.seriesCount; seriesIndex++) {
                var noOfSeriesOrImages = (firstSeriesOrImage.isImageThumbnail ? study.series[seriesIndex].images.length : 1);
                totalImageCount += noOfSeriesOrImages;
                requestData.seriesIndex = seriesIndex;
                for (var imageIndex = 0; imageIndex < noOfSeriesOrImages; imageIndex++) {
                    var seriesOrImage = (study.isDicom ? study.series[seriesIndex].images[imageIndex] : study[seriesIndex]);
                    if (!isBlob(seriesOrImage.imageType) && seriesOrImage.imageType !== IMAGETYPE_TIFF) {
                        requestData.imageIndex = imageIndex;
                        requestData.imageUid = seriesOrImage.imageUid;
                        requestData.imageType = seriesOrImage.imageType;
                        requestData.frameIndex = 0;

                        var viewport = dicomViewer.viewports.getViewportByImageIndex(study.studyUid, seriesIndex, imageIndex);
                        if (viewport) {
                            requestData.layoutId = viewport.seriesLayoutId;
                        }

                        var loadImage = dicomViewer.getImage(requestData);
                        loadImage.done(function (image) {
                            loadedImageCount++;
                            if (loadedImageCount == totalImageCount) {
                                cacheFirstImagePrmoise.resolve(studyDetail, studyUid);
                            }
                            var renderer = dicomViewer.renderer.getImageRenderer(image.imageUid + "_" + image.frameNumber);
                            if (renderer) {
                                dicomViewer.renderer.removeImageRenderer(image.imageUid + "_" + image.frameNumber);
                                var deferred = $.Deferred();
                                deferred.resolve(image);
                                renderer.loadImageRenderer(deferred, undefined, study.studyUid);
                            }
                        });
                    }
                }
            }

            return cacheFirstImagePrmoise;
        } catch (e) {}

        return false;
    }

    /**
     * Delete the cache
     * @param {Type} lastCachedImage - cache image
     * @param {Type} lastCachedImageKey - cache image key
     */
    function deleteCache(lastCachedImage, lastCachedImageKey) {
        try {
            if (!lastCachedImage) {
                return false;
            }

            removeCacheInfo(lastCachedImage.seriesIndex, lastCachedImage.imageUid, lastCachedImage.frameIndex);
            deleteCacheImage(lastCachedImageKey);
            cachedImagesBySeries[lastCachedImage.seriesIndex][lastCachedImage.imageUid][lastCachedImage.frameIndex] = undefined;
            delete cachedImagesBySeries[lastCachedImage.seriesIndex][lastCachedImage.imageUid][lastCachedImage.frameIndex];

            if (cachedImagesBySeries[lastCachedImage.seriesIndex][lastCachedImage.imageUid] !== undefined && Object.keys(cachedImagesBySeries[lastCachedImage.seriesIndex][lastCachedImage.imageUid]).length === 0) {
                delete cachedImagesBySeries[lastCachedImage.seriesIndex][lastCachedImage.imageUid];
            }

            if (cachedImagesBySeries[lastCachedImage.seriesIndex] !== undefined &&
                Object.keys(cachedImagesBySeries[lastCachedImage.seriesIndex]).length === 0) {
                delete cachedImagesBySeries[lastCachedImage.seriesIndex];
            }

            updateCacheIndicators(lastCachedImage.studyUid, lastCachedImage.seriesIndex, lastCachedImage.imageUid);

            return true;
        } catch (e) {}

        return false;
    }

    function memorySizeOf(obj) {
        var bytes = 0;

        function sizeOf(obj) {
            if (obj !== null && obj !== undefined) {
                switch (typeof obj) {
                    case 'number':
                        bytes += 8;
                        break;
                    case 'string':
                        bytes += obj.length * 2;
                        break;
                    case 'boolean':
                        bytes += 4;
                        break;
                    case 'object':
                        var objClass = Object.prototype.toString.call(obj).slice(8, -1);
                        if (objClass === 'Object' || objClass === 'Array') {
                            for (var key in obj) {
                                if (!obj.hasOwnProperty(key)) continue;
                                sizeOf(obj[key]);
                            }
                        } else bytes += obj.toString().length * 2;
                        break;
                }
            }
            return bytes;
        };

        function formatByteSize(bytes) {
            if (bytes < 1024) return bytes + " bytes";
            else if (bytes < 1048576) return (bytes / 1024).toFixed(3) + " KiB";
            else if (bytes < 1073741824) return (bytes / 1048576).toFixed(3) + " MiB";
            else return (bytes / 1073741824).toFixed(3) + " GiB";
        };

        return sizeOf(obj);
    };

    function isMemoryAvailable(allocatedMemory) {
        var cacheInfo = getCacheInfo();
        return (((allocatedMemory / cacheInfo.maximumSizeInBytes) * 100) < 80 ? true : false);
    }

    // module exports
    dicomViewer.imageCache = {
        putImagePromise: putImagePromise,
        getImagePromise: getImagePromise,
        getCacheInfo: getCacheInfo,
        isInCache: isInCache,
        setCacheSize: setCacheSize,
        clearCache: clearCache,
        getCachePercentage: getCachePercentage,
        setImageData: setImageData,
        getImageData: getImageData,
        getRawData: getRawData,
        cacheFirstImage: cacheFirstImage,
        purgeCache: purgeCache,
        isMemoryAvailable: isMemoryAvailable,
        getCachedImage: getCachedImage
    };

    return dicomViewer;
}(dicomViewer));
