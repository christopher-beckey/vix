/**
 * WorkerThread.js
 * Process the worker queue jobs.
 */

var  WorkerThread = function (jobData) {
    this.jobData = jobData;
}

/**
 * Handle image/info response
 */ 
function handleLoaderResponse (jobData) {
    try {
        if (!jobData.excludeImageInfo) {
            var dicominfo = new ImageInfoManager(jobData.response.headerResponse);
            var imageType = dicominfo.imageInfo.imageType;
            var seriesTime = dicominfo.imageInfo.seriesTime;
            //getting the div id to display series time inside the image thumbnails
            var ImageThumbseriesTime = jobData.imageUid + "seriesTime";
            var imageThumbnailDom = document.getElementById(ImageThumbseriesTime);
            var studyDetails = dicomViewer.getStudyDetails(jobData.studyUid);
            if (dicominfo.imageInfo && dicominfo.imageInfo.overlays) {
                if (!studyDetails.is6000OverLay) {
                    studyDetails.is6000OverLay = true;
                    showAndHide6000OverlayMenu(dicomViewer.getActiveSeriesLayout());
                }
            }

            // Set the no of frame is 1. Since we are going to display the first frame of each image if it is invoked from QA page
            if (dicominfo.imageInfo && invokerIsQA()) {
                dicominfo.imageInfo.numberOfFrames = 1;
                if (dicominfo.imageInfo.imageType == IMAGETYPE_RADECHO) {
                    dicominfo.imageInfo.imageType = IMAGETYPE_RAD;
                }
            }

            dicomViewer.header.putDicomHeader(jobData.imageUid, dicominfo);
            jobData.dicominfo = dicominfo;
        } else if (jobData.isJpeg) {
            handleJpegResponse(jobData);
        } else {
            var image = dicomViewer.processDicomImage(jobData.imageUid, jobData.frameNumber, jobData.dicominfo,
                                                      jobData.response, true, jobData.seriesIndex, jobData.studyUid);
            image.studyUid = jobData.studyUid;
            jobData.deferred.resolve(image);
        }
    } catch (e) {}
}

function handleOverlayResponse (jobData) {
    try {
        var image = jobData.image;
        image.overlay6000.overlayData = jobData.response.overlayData;
        dicomViewer.refresh6000Overlay(image);
    } catch (e) {}
}

function handleJpegResponse (jobData) {
    try {
        dicomViewer.processGeneralImage(jobData.imageUid, jobData.frameNumber, jobData.dicominfo,
                                        jobData.response.responseText, jobData.deferred);
    } catch (e) {}
}

WorkerThread.prototype.processJob = function (workerQueue) {
    try {
        if (this.jobData !== undefined) {
            var bgWorker = workerQueue.worker;
            if (this.jobData.type === "xRef") {
                if (!this.jobData.isProcessing) {
                    dumpConsoleLogs(LL_INFO, undefined, "processJob", "Processing => job id: " + this.jobData.id);
                    this.jobData.isProcessing = true;

                    bgWorker.postMessage({
                        sourceImage: this.jobData.sourceImage,
                        targetImages: this.jobData.targetImages,
                        request: "xRefSlice"
                    });

                    bgWorker.jobData = this.jobData;
                    bgWorker.onmessage = function (event) {
                        if (event.data !== null) {
                            event.data.forEach(function (slice) {
                                dicomViewer.xRefLine.addRefLinesViewerCode(
                                    slice.sourceImageUid,
                                    slice.targetImageUid,
                                    slice.value
                                );
                            });

                            dumpConsoleLogs(LL_INFO, undefined, undefined, "Process completed => job id: " + this.jobData.id);
                            workerQueue.remove();
                            if(bgWorker.jobData.terminateWorker) {
                                bgWorker.terminate();
                                bgWorker = null;
                            }
                        }
                    };
                }
            } else if (this.jobData.type === "manage") {
                if (!this.jobData.isProcessing) {
                    dumpConsoleLogs(LL_INFO, undefined, "processJob", "Processing => job id: " + this.jobData.id);
                    this.jobData.isProcessing = true;

                    var thumbUrl = dicomViewer.Metadata.ThumbnailUrl(this.jobData.sourceImage.thumbnailUri);
                    dicomViewer.thumbnail.displayInformation(this.jobData.studyUid, this.jobData.thumbRendererObject.seriesIndex, 0);
                    var workerData = {
                        request: "Thumbnail",
                        url: thumbUrl
                    };

                    bgWorker.postMessage(workerData);
                    bgWorker.jobData = this.jobData;
                    bgWorker.onmessage = function (event) {
                        if (event.data !== null) {
                            this.jobData.response = event.data;
                            dicomViewer.thumbnail.startWorkerToDownloadThumbnail(this.jobData);
                            dumpConsoleLogs(LL_INFO, undefined, undefined, "Process completed => job id: " + this.jobData.id);
                            workerQueue.remove();
                        }
                    };
                }
            } else if (this.jobData.type === "thumbnail") {
                if (!this.jobData.isProcessing) {
                    dumpConsoleLogs(LL_INFO, undefined, "processJob", "Processing => job id: " + this.jobData.id);
                    this.jobData.isProcessing = true;

                    var workerData = {
                        request: this.jobData.request,
                        url: this.jobData.url,
                        headers: this.jobData.headers
                    };

                    bgWorker.postMessage(workerData);
                    bgWorker.jobData = this.jobData;
                    bgWorker.onmessage = function (event) {
                        if (event.data !== null) {
                            this.jobData.response = event.data;
                            this.jobData.deferred.resolve(this.jobData.response);
                            dumpConsoleLogs(LL_INFO, undefined, undefined, "Process completed => job id: " + this.jobData.id);
                            workerQueue.remove();
                        }
                    };
                }
            } else if (this.jobData.type === "cache") {
                if (!this.jobData.isProcessing) {
                    dumpConsoleLogs(LL_INFO, undefined, "processJob", "Processing => job id: " + this.jobData.id);
                    this.jobData.isProcessing = true;

                    var workerData;
                    switch (this.jobData.request) {
                        case "Image":
                            workerData = {
                                request: this.jobData.request,
                                url: this.jobData.url,
                                isJpeg: this.jobData.isJpeg,
                                dicominfo: this.jobData.dicominfo,
                                excludeImageInfo: this.jobData.excludeImageInfo,
                                isDecompressionRequired: this.jobData.isDecompressionRequired,
                                headers: this.jobData.headers,
                                imageUid: this.jobData.imageUid
                            };
                            break;
                        case "overlay6000":
                            workerData = {
                                request: this.jobData.request,
                                url: this.jobData.url,
                                headers: this.jobData.headers,
                                bitsAllocated: this.jobData.bitsAllocated
                            };
                            break;
                    }

                    bgWorker.postMessage(workerData);
                    bgWorker.jobData = this.jobData;
                    bgWorker.onmessage = function (event) {
                        if (event.data !== null) {
                            this.jobData.response = event.data;
                            switch (this.jobData.request) {
                                case "Image":
                                    handleLoaderResponse(this.jobData);
                                    break;
                                case "overlay6000":
                                    handleOverlayResponse(this.jobData);
                                    break;
                            }
                            dumpConsoleLogs(LL_INFO, undefined, undefined, "Process completed => job id: " + this.jobData.id);
                            if (this.jobData.request == "Image" && !this.jobData.excludeImageInfo) {
                                this.jobData.excludeImageInfo = true;
                                workerData.excludeImageInfo = this.jobData.excludeImageInfo;
                                workerData.dicominfo = this.jobData.dicominfo;
                                if (!this.jobData.isJpeg) {
                                    bgWorker.postMessage({
                                        cmd: "prepareImage",
                                        workerData: workerData,
                                        responseText: this.jobData.response.responseText
                                    });
                                } else {
                                    handleJpegResponse(this.jobData);
                                    workerQueue.remove(workerData.imageUid);
                                }
                            } else {
                                workerQueue.remove(workerData.imageUid);
                            }
                        }
                    };
                }
            } else {
                dumpConsoleLogs(LL_INFO, undefined, undefined, "WorkerQueue => Invalid job");
            }
        }
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, "WorkerQueue => Failed to process the job");
    }
};