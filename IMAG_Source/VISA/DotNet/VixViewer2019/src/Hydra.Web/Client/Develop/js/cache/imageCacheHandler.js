/**
 * New node file
 */
var dicomViewer = (function (dicomViewer) {

    "use strict";

    var imageRendererMap = {};
    var prevNextCount = 2;
    var timeOutSecs = 2;
    var cacheDataMap = {};
    var studiesToCache = new Array();
    var CACHE_START = 0;
    var CACHE_INPROGRESS = 1;
    var CACHE_INCOMPLETE = 2;
    var CACHE_END = 3;
    var CACHE_RESET = 4;

    function cacheImages(studyUid) {
        var cacheData = getCacheData(studyUid);
        if (!cacheData || cacheData.enabled === false) {
            return;
        }

        if (cacheData.cacheStatus == CACHE_INPROGRESS || cacheData.cacheStatus == CACHE_END || cacheData.cacheStatus == CACHE_RESET) {
            return;
        }

        if (cacheData.cacheStatus == CACHE_START || cacheData.cacheStatus == CACHE_INCOMPLETE) {
            cacheData.cacheStatus = CACHE_INPROGRESS;
            setCacheData(studyUid, cacheData);
        }

        var studyDetail = cacheData.studyDetail;
        if (cacheData.seriesIndexToCache != undefined) {
            var seriesIndexToCache = cacheData.seriesIndexToCache;
            var series = studyDetail.series[seriesIndexToCache];
            var imageIndexToCache = (cacheData.imageIndexToCache == undefined) ? getImageIndexToLoad(series) : cacheData.imageIndexToCache;
            cacheData.seriesIndexToCache = undefined;
            cacheData.imageIndexToCache = undefined;
            var prioritySeriesPromise = new $.Deferred();
            cacheData.prioritySeriesPromise = prioritySeriesPromise;
            setCacheData(studyUid, cacheData);
            getImages(studyUid, series, seriesIndexToCache, imageIndexToCache, true);
            prioritySeriesPromise.done(function (prioritySeries) {
                cacheNextSerieses(prioritySeries, studyDetail, cacheData);
            });
        } else {
            var detail = dicomViewer.getStudyDetails(studyUid);
            var appliedSeriesLayout = (detail.displaySettings.Rows * detail.displaySettings.Columns);
            var cacheFirstImageDeferred = dicomViewer.imageCache.cacheFirstImage(detail, appliedSeriesLayout, studyDetail, studyUid);
            cacheFirstImageDeferred.done(function (studyDetail, studyUid) {
                var prioritySeriesPromise = new $.Deferred();
                cacheData.prioritySeriesPromise = prioritySeriesPromise;
                setCacheData(studyUid, cacheData);
                cacheSelectedSeries(studyDetail, studyUid, detail.selectedImage);
                prioritySeriesPromise.done(function (prioritySeries) {
                    cacheNextSerieses(prioritySeries, studyDetail, cacheData, true);
                });
            });
        }
    }

    function cacheNextSerieses(prioritySeries, studyDetail, cacheData, isInitialCache) {
        try {
            setTimeout(function (cacheSeries) {
                var prioritySeries = cacheSeries.prioritySeries;
                var studyDetail = cacheSeries.studyDetail;
                var isInitialCache = cacheSeries.isInitialCache;
                var cacheData = cacheSeries.cacheData;
                if (!prioritySeries.isCacheFull) {
                    var nextSeriesIndex = 0;
                    var nextImageIndex = 0;
                    for (; nextSeriesIndex < studyDetail.seriesCount; nextSeriesIndex++) {
                        nextImageIndex = 0;
                        var series = studyDetail.series[nextSeriesIndex];
                        var image = undefined;
                        var isMutliframe = false;
                        if (series.images) {
                            image = series.images[nextImageIndex];
                        } else {
                            image = series;
                        }
                        var isRepeat = false;
                        if (!image.frameCount) {
                            isRepeat = (nextSeriesIndex == prioritySeries.seriesIndex);
                        } else {
                            isRepeat = (nextImageIndex == prioritySeries.imageIndex);
                            isMutliframe = true;
                            if (isRepeat) {
                                isRepeat = false;
                                nextImageIndex++;
                            }
                        }

                        if (series && series.imageCount > nextImageIndex && !isRepeat) {
                            if (!isInitialCache) {
                                cacheData.initialCache = true;
                                cacheData.seriesIndexToCache = undefined;
                                cacheData.imageIndexToCache = undefined;
                                setCacheData(cacheData.studyUid, cacheData);
                                nextImageIndex = isMutliframe ? nextImageIndex : getImageIndexToLoad(series);
                            }
                            getImages(cacheData.studyUid, series, nextSeriesIndex, nextImageIndex);
                        }
                    }
                }
            }, 1000, {
                    prioritySeries: prioritySeries,
                    studyDetail: studyDetail,
                    cacheData: cacheData,
                    isInitialCache: isInitialCache
                });
        }
        catch (e) { }
    }

    function getImageIndexToLoad(series) {
        var imageIndexToLoad = 0;
        if (!series.images)
            imageIndexToLoad = -1;
        else {
            $.each(series.images, function (key, image) {
                if (!image.isCompleted || image.isPurged) {
                    imageIndexToLoad = key;
                    return false;
                }
            });
        }
        return imageIndexToLoad;
    }

    function cacheSelectedSeries(studyDetail, studyUid, selectedImage) {
        var seriesIndex = 0;
        var imageIndex = 0;
        var isRecache = false;
        if (selectedImage) {
            seriesIndex = selectedImage.seriesIndex;
            imageIndex = selectedImage.imageIndex;
        }

        var series = studyDetail.series[seriesIndex];
        var image = undefined;
        if (series.images) {
            image = series.images[imageIndex];
        } else {
            image = series;
        }

        if (image.frameCount) {
            isRecache = true;
        }

        var tempImageIndex = imageIndex;
        if (selectedImage) {
            if (!image.frameCount) {
                tempImageIndex = "";
            }
            /*$("#" + "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + seriesIndex + "_thumb" + tempImageIndex)[0].click();*/
        }
        getImages(studyUid, series, seriesIndex, imageIndex, isRecache);
    }

    function resolveCachePromise(studyUid, seriesIndex, imageIndex) {
        var cacheData = getCacheData(studyUid);
        var isCacheFull = (dicomViewer.imageCache.getCachePercentage() > 90);
        var resolvePriority = false;
        if (cacheData.prioritySeriesPromise) {
            setTimeout(function (prioritySeries) {
                prioritySeries.promise.resolve({
                    seriesIndex: prioritySeries.seriesIndex,
                    imageIndex: prioritySeries.imageIndex,
                    isMultiframe: true,
                    isCacheFull: prioritySeries.isCacheFull
                });
            }, 500, {
                promise: cacheData.prioritySeriesPromise,
                seriesIndex: seriesIndex,
                imageIndex: imageIndex,
                isCacheFull: isCacheFull
            });

            resolvePriority = true;
            cacheData.prioritySeriesPromise = null;
            setCacheData(studyUid, cacheData);
        } else {
            cacheData.cacheStatus = CACHE_START;
            setCacheData(studyUid, cacheData);
        }

        return resolvePriority;
    }

    function getImages(studyUid, series, seriesIndex, imageIndex, isRecache) {
        var image = undefined;
        if (series.images) {
            image = series.images[imageIndex];
        } else {
            image = series;
        }

        if (!image.isDicom) {

        } else {
            if (image.frameCount) {
                var skipFrames = false;
                if (image.isCompleted) {
                    skipFrames = true;
                    if (resolveCachePromise(studyUid, seriesIndex, imageIndex)) {
                        return;
                    }
                }

                var framePromise = new $.Deferred();
                if (!skipFrames) {
                    getFrames(studyUid, image, seriesIndex, imageIndex, 0, framePromise);
                } else {
                    framePromise.resolve();
                }

                if (isRecache) {
                    return;
                }

                framePromise.done(function(data) {
                    imageIndex++;
                    if (imageIndex < series.imageCount) {
                        getImages(studyUid, series, seriesIndex, imageIndex);
                    }
                });
            } else {
                if (series.isCompleted) {
                    return resolveCachePromise(studyUid, seriesIndex, imageIndex);
                }

                var cacheDeferred = getImageOrFrame(studyUid, seriesIndex, imageIndex, 0);
                cacheDeferred.done(function (indexToCache) {
                    var cacheData = getCacheData(studyUid);
                    if (cacheData.cacheStatus == CACHE_RESET) {
                        //console.log("CACHE_RESET :" + seriesIndex);
                        return;
                    }
                    dumpCacheSize();
                    setCacheImageComplete(studyUid, seriesIndex, imageIndex, false, CACHE_INPROGRESS);
                    //console.log(seriesIndex + ":" + imageIndex);
                    imageIndex++;
                    var isCacheFull = (dicomViewer.imageCache.getCachePercentage() > 90);
                    if (isCacheFull && !cacheData.initialCache) {
                        var bytesNeeded = series.imageCount * 5 * 1000;
                        dicomViewer.imageCache.purgeCache(studyUid, bytesNeeded);
                        isCacheFull = false;
                    }
                    if (imageIndex < series.imageCount && !isCacheFull) {
                        if (indexToCache.seriesIndexToCache != undefined && indexToCache.seriesIndexToCache != seriesIndex) {
                            seriesIndex = indexToCache.seriesIndexToCache;
                            imageIndex = 0;
                        }
                        series = cacheData.studyDetail.series[seriesIndex];
                        getImages(studyUid, series, seriesIndex, imageIndex);
                    } else {
                        if (cacheData.prioritySeriesPromise) {
                            setTimeout(function (prioritySeries) {
                                prioritySeries.promise.resolve({
                                    seriesIndex: prioritySeries.seriesIndex,
                                    isCacheFull: prioritySeries.isCacheFull
                                });
                            }, 500, {
                                promise: cacheData.prioritySeriesPromise,
                                seriesIndex: seriesIndex,
                                isCacheFull: isCacheFull
                            });
                            cacheData.prioritySeriesPromise = null;
                            setCacheData(studyUid, cacheData);
                        }
                        setCacheSeriesComplete(studyUid, seriesIndex, imageIndex, isCacheFull);
                    }
                });
            }
        }
    }

    function getFrames(studyUid, image, seriesIndex, imageIndex, frameIndex, framePromise) {
        if (image.isCompleted) {
            if(framePromise) {
                framePromise.resolve();
            }

            return;
        }

        var cacheDeferred = getImageOrFrame(studyUid, seriesIndex, imageIndex, frameIndex);
        cacheDeferred.done(function (indexToCache) {
            var cacheData = getCacheData(studyUid);
            if (cacheData.cacheStatus == CACHE_RESET) {
                return;
            }

            dumpCacheSize();
            frameIndex++;
            var isCacheFull = (dicomViewer.imageCache.getCachePercentage() > 90);
            if (isCacheFull && !cacheData.initialCache) {
                var bytesNeeded = image.frameCount * 5 * 1000;
                dicomViewer.imageCache.purgeCache(studyUid, bytesNeeded);
                isCacheFull = false;
            }
            if (frameIndex < image.frameCount && !isCacheFull) {
                if ((indexToCache.seriesIndexToCache != undefined && indexToCache.seriesIndexToCache != seriesIndex) || (indexToCache.imageIndexToCache != undefined && indexToCache.imageIndexToCache != imageIndex)) {
                    seriesIndex = indexToCache.seriesIndexToCache;
                    imageIndex = indexToCache.imageIndexToCache;
                    frameIndex = 0;
                }
                var series = cacheData.studyDetail.series[seriesIndex];
                if (series.images) {
                    image = series.images[imageIndex];
                } else {
                    image = series;
                }
                getFrames(studyUid, image, seriesIndex, imageIndex, frameIndex, framePromise);
            } else {
                setCacheImageComplete(studyUid, seriesIndex, imageIndex, isCacheFull);
                if (cacheData.prioritySeriesPromise) {
                    setTimeout(function (prioritySeries) {
                        prioritySeries.promise.resolve({
                            seriesIndex: prioritySeries.seriesIndex,
                            imageIndex: prioritySeries.imageIndex,
                            isMultiframe: true,
                            isCacheFull: prioritySeries.isCacheFull
                        });
                    }, 500, {
                        promise: cacheData.prioritySeriesPromise,
                        seriesIndex: seriesIndex,
                        imageIndex: imageIndex,
                        isCacheFull: isCacheFull
                    });
                    cacheData.prioritySeriesPromise = null;
                    setCacheData(studyUid, cacheData);
                } else if (framePromise) {
                    framePromise.resolve();
                }
            }
        });
    }

    function setCacheImageComplete(studyUid, seriesIndex, imageIndex, isCacheFull, cacheStatus) {
        var cacheData = getCacheData(studyUid);
        var studyDetail = cacheData.studyDetail;
        if (isCacheFull) {
            setCacheSeriesComplete(studyUid, seriesIndex, imageIndex, isCacheFull);
        } else {
            var series = studyDetail.series[seriesIndex];
            if (series.images) {
                var image = series.images[imageIndex];
                image.isCompleted = true;
                image.isPurged = false;
                series.images[imageIndex] = image;
                studyDetail.series[seriesIndex] = series;
                var isSeriesComplete = true;
                $.each(series.images, function (key, image) {
                    if (!image.isCompleted || image.isPurged) {
                        isSeriesComplete = false;
                        return false;
                    }
                });

                if (isSeriesComplete) {
                    setCacheSeriesComplete(studyUid, seriesIndex, imageIndex, isCacheFull);
                } else {
                    cacheData.cacheStatus = cacheStatus ? cacheStatus : CACHE_INCOMPLETE;
                    cacheData.studyDetail = studyDetail;
                    setCacheData(studyUid, cacheData);
                }
            } else {
                series.isCompleted = true;
                studyDetail.series[seriesIndex] = series;
                setCacheStudyComplete(studyUid);
            }
        }
    }

    function setCacheSeriesComplete(studyUid, seriesIndex, imageIndex, isCacheFull) {
        var cacheData = getCacheData(studyUid);
        var studyDetail = cacheData.studyDetail;
        if (isCacheFull && cacheData.requestCount == 0) {
            cacheData.initialCache = false;
            cacheData.cacheStatus = CACHE_INCOMPLETE;
            cacheData.enabled = false;
            setCacheData(studyUid, cacheData);
        } else if (!isCacheFull) {
            var series = studyDetail.series[seriesIndex];
            series.isCompleted = true;
            series.isPurged = false;
            studyDetail.series[seriesIndex] = series;
            setCacheStudyComplete(studyUid);
        }
    }

    function setCacheStudyComplete(studyUid) {
        var cacheData = getCacheData(studyUid);
        var studyDetail = cacheData.studyDetail;
        var isStudyComplete = true;
        $.each(studyDetail.series, function (key, series) {
            if (!series.isCompleted || series.isPurged) {
                isStudyComplete = false;
                return false;
            }
        });
        if (isStudyComplete) {
            studyDetail.isCompleted = true;
            cacheData.enabled = false;
            cacheData.cacheStatus = CACHE_END;
            cacheData.studyDetail = studyDetail;
            setCacheData(studyUid, cacheData);
        } else {
            studyDetail.isCompleted = false;
            cacheData.enabled = true;
            cacheData.cacheStatus = CACHE_START;
            cacheData.studyDetail = studyDetail;
            setCacheData(studyUid, cacheData);
        }
    }

    function getImageOrFrame(studyUid, seriesIndex, imageIndex, frameIndex) {
        var loadImageDeferred;
        var cachePrmoise = new $.Deferred();
        var imageInfo = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        var imageUid = dicomViewer.Series.Image.getImageUid(imageInfo);
        var cacheData = getCacheData(studyUid);
        cacheData.requestCount++;
        setCacheData(studyUid, cacheData);

        var viewport = dicomViewer.viewports.getViewportByImageIndex(studyUid, seriesIndex, imageIndex);
        var layoutId;
        if (viewport) {
            layoutId = viewport.seriesLayoutId;
        }

        var requestData = {
            studyUid: studyUid,
            seriesIndex: seriesIndex,
            imageIndex: imageIndex,
            frameIndex: frameIndex,
            imageUid: imageUid,
            imageType: imageInfo.imageType,
            layoutId: layoutId
        };

        loadImageDeferred = dicomViewer.getImage(requestData);
        loadImageDeferred.done(function (image) {
            var cacheData = getCacheData(studyUid);
            cacheData.requestCount--;
            setCacheData(studyUid, cacheData);
            if (!image.studyUid) {
                dumpConsoleLogs(LL_DEBUG, undefined, "getImageOrFrame", "Image promise did not have studyUid");
                return;
            }

            // Dump the cache memory size in console
            dumpCacheSize();
            var indexToCache = {
                seriesIndexToCache: cacheData.seriesIndexToCache,
                imageIndexToCache: cacheData.imageIndexToCache
            }
            cachePrmoise.resolve(indexToCache);

            //Get Renderer object
            var renderer = dicomViewer.renderer.getImageRenderer(image.imageUid + "_" + image.frameNumber);
            if (renderer) {
                removeImageRenderer(image.imageUid + "_" + image.frameNumber);
                var deferred = $.Deferred();
                deferred.resolve(image);
                renderer.loadImageRenderer(deferred, undefined, image.studyUid);
            }
        });

        return cachePrmoise;
    }

    function setImageRenderer(imageUid, renderer) {
        if (imageUid === undefined) {
            throw "Exception: imageUid should not be null/undefined"
        }
        imageRendererMap[imageUid] = renderer;
    }

    function getImageRenderer(imageUid) {
        return imageRendererMap[imageUid];
    }

    function removeImageRenderer(imageUid) {
        delete imageRendererMap[imageUid];
    }

    /**
     * Dump cache memory size
     */
    function dumpCacheSize() {
        var cacheInfo = dicomViewer.imageCache.getCacheInfo();
        if (cacheInfo !== undefined && cacheInfo !== null) {
            var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
            var i = parseInt(Math.floor(Math.log(cacheInfo.cacheSizeInBytes) / Math.log(1024)));
            var totalsize = Math.round(cacheInfo.cacheSizeInBytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
            dumpConsoleLogs(LL_DEBUG, undefined, "dumpCacheSize", "Cache size : " + totalsize);
        }
    }

    function getCacheData(studyUid) {
        if (!cacheDataMap[studyUid]) {
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (!studyDetails) {
                return undefined;
            }

            var seriesCount = studyDetails.seriesCount;
            var imageCount = undefined;
            var frameCount = undefined;
            var seriesCol = [];
            var imageCol = [];
            var isMultiframe = false;
            if (studyDetails.series) {
                $.each(studyDetails.series, function (key, series) {
                    imageCount = series.imageCount;
                    $.each(series.images, function (key, images) {
                        if (series.hasMutiframeImages) {
                            isMultiframe = true;
                            frameCount = images.numberOfFrames;
                        }
                        var imageType = {
                            type: images.imageType,
                            isDicom: isDicomModality(images.imageType),
                            frameCount: frameCount,
                            isCompleted: false,
                            isPurged: false
                        };
                        imageCol.push(imageType);
                    });
                    var series = {
                        imageCount: imageCount,
                        images: imageCol,
                        isCompleted: false
                    };
                    imageCol = [];
                    seriesCol.push(series);
                });
            } else if (Array.isArray(studyDetails)) {
                $.each(studyDetails, function (key, series) {
                    imageCount = series.imageCount;
                    frameCount = series.numberOfFrames;
                    var series = {
                        type: series.imageType,
                        isDicom: isDicomModality(series.imageType),
                        imageCount: imageCount,
                        frameCount: frameCount,
                        isCompleted: false,
                        isPurged: false
                    };
                    seriesCol.push(series);
                });
            }

            var studyDetail = {
                seriesCount: seriesCount,
                series: seriesCol,
                isCompleted: false,
            };
            seriesCol = [];

            var cacheData = {
                studyUid: studyUid,
                enabled: true,
                studyDetail: studyDetail,
                initialCache: true,
                cacheStatus: CACHE_START,
                seriesIndexToCache: undefined,
                imageIndexToCache: undefined,
                isMultiframe: isMultiframe,
                requestCount: 0
            };
            setCacheData(studyUid, cacheData);
        }

        return cacheDataMap[studyUid];
    }

    function isDicomModality(imageType) {
        if (imageType == IMAGETYPE_RAD || imageType == IMAGETYPE_RADECHO ||
            imageType === IMAGETYPE_JPEG || imageType == IMAGETYPE_RADSR ||
            imageType == IMAGETYPE_CDA) {
            return true;
        }
        return false;
    }

    function setCacheData(studyUid, cacheData) {
        cacheDataMap[studyUid] = cacheData;
    }

    function enableCacheData(studyUid, enabled) {
        cacheDataMap[studyUid].enabled = enabled;
    }

    function isSeriesInComplete(studyUid, seriesIndex, imageIndex) {
        var cacheData = getCacheData(studyUid);
        var series = cacheData.studyDetail.series[seriesIndex];
        if (!cacheData.initialCache) {
            if (cacheData.isMultiframe || series.frameCount>1 ) {
                var image;
                if (series.images) {
                    image = series.images[imageIndex];
                } else {
                    image = series;
                }

                if (!image.isCompleted || image.imageIndexToCache != imageIndex || image.isPurged) {
                    cacheData.seriesIndexToCache = seriesIndex;
                    cacheData.imageIndexToCache = imageIndex;
                    setCacheData(studyUid, cacheData);
                    return true;
                }
            } else {
                if (!series.isCompleted || (cacheData.seriesIndexToCache != undefined && cacheData.seriesIndexToCache != seriesIndex) || series.isPurged) {
                    cacheData.seriesIndexToCache = seriesIndex;
                    setCacheData(studyUid, cacheData);
                    return true;
                }
            }
        }
        return false;
    }

    function purgeSeries(studyUid, seriesIndex, imageIndex) {
        var cacheData = getCacheData(studyUid);
        var series = cacheData.studyDetail.series[seriesIndex];
        series.isCompleted = false;
        if (series.images) {
            var images = [];
            $.each(series.images, function (key, image) {
                var canPurge = true;
                if (imageIndex != undefined && imageIndex != key) {
                    canPurge = false;
                }
                if (canPurge) {
                    image.isCompleted = false;
                    image.isPurged = true;
                }
                images.push(image);
            });
            series.images = images;
            series.isPurged = true;
        }
        cacheData.studyDetail.series[seriesIndex] = series;
        setCacheData(studyUid, cacheData);
    }

    function resetCache(studyUid, seriesIndex, imageIndex) {
        var cacheData = getCacheData(studyUid);
        if (cacheData.initialCache || isSeriesInComplete(studyUid, seriesIndex, imageIndex)) {
            cacheData.initialCache = false;
            if(cacheData.prioritySeriesPromise) {
                cacheData.prioritySeriesPromise.reject();
                cacheData.prioritySeriesPromise = null;
            }

            cacheData.cacheStatus = CACHE_RESET;
            setCacheData(studyUid, cacheData);
            setTimeout(function () {
                var cacheData = getCacheData(studyUid);
                if (cacheData.cacheStatus != CACHE_INPROGRESS) {
                    cacheData.initialCache = false;
                    cacheData.cacheStatus = CACHE_START;
                    cacheData.seriesIndexToCache = seriesIndex;
                    cacheData.imageIndexToCache = imageIndex;
                    setCacheData(studyUid, cacheData);
                    cacheImages(studyUid);
                }
            }, 500, studyUid);
        }
    }

    dicomViewer.renderer = {
        setImageRenderer: setImageRenderer,
        getImageRenderer: getImageRenderer,
        removeImageRenderer: removeImageRenderer
    };

    dicomViewer.cacheImages = cacheImages;
    dicomViewer.isSeriesInComplete = isSeriesInComplete;
    dicomViewer.enableCacheData = enableCacheData;
    dicomViewer.purgeSeries = purgeSeries;
    dicomViewer.getCacheData = getCacheData;
    dicomViewer.setCacheData = setCacheData;
    dicomViewer.resetCache = resetCache;

    return dicomViewer;

}(dicomViewer));
