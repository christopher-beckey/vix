var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var dicomHeaders = {};
    /**
     *@param url
     *Send the request based  on the url(image info call)
     *when the call is success(200) it will be resolved in jquery deffered
     *if the result is not success it will be rejected in jquery deffered
     *and return the jquery deffered object
     */
    function getDicomHeaderInfo(url) {
        try {

            if (url === undefined) {
                throw "Exception: url should not be undefined";
            }
            var deferred = $.Deferred();
            var oReq = new XMLHttpRequest();
            oReq.open("get", url, true);
            oReq.responseType = 'application/json';
            oReq.onreadystatechange = function (oEvent) {
                var t0 = Date.now();
                dumpConsoleLogs(LL_INFO, undefined, "getDicomHeaderInfo ", "Start", undefined, true);

                // TODO: consider sending out progress messages here as we receive the pixel data
                if (oReq.readyState === 4) {
                    if (oReq.status === 200) {
                        var text = oReq.responseText;
                        deferred.resolve(text);
                        dumpConsoleLogs(LL_INFO, undefined, "getDicomHeaderInfo", "End", (Date.now() - t0), true);
                    } else {
                        deferred.reject();
                    }
                } else if (oReq.status === 500) {
                    var description = xhttp.statusText + "\nFailed to get the dicom geader information for this url." + "\nURL: " + url;
                    sendViewerStatusMessage(xhttp.status.toString(), description);
                    dumpConsoleLogs(LL_ERROR, undefined, "getDicomHeaderInfo", description, undefined, true);
                }
            };
            oReq.send();
            return deferred;
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, "getDicomHeaderInfo", e.message, undefined, true);
        } finally {

        }
    }

    function getDicomHeaderInfo(url) {
        try {

            if (url === undefined) {
                throw "Exception: url should not be undefined";
            }
            var deferred = $.Deferred();
            var oReq = new XMLHttpRequest();
            oReq.open("get", url, true);
            //oReq.responseType = 'application/json';
            oReq.onreadystatechange = function (oEvent) {

                var t0 = Date.now();
                dumpConsoleLogs(LL_INFO, undefined, "getDicomHeaderInfo", "Start", undefined, true);

                // TODO: consider sending out progress messages here as we receive the pixel data
                if (oReq.readyState === 4) {

                    if (oReq.status === 200) {
                        var text = oReq.responseText;
                        deferred.resolve(text);

                        dumpConsoleLogs(LL_INFO, undefined, "getDicomHeaderInfo", "End", (Date.now() - t0), true);
                    } else {
                        deferred.reject();
                    }
                } else if (oReq.status === 500) {
                    var description = xhttp.statusText + "\nFailed to get the dicom geader information for this url." + "\nURL: " + url;
                    sendViewerStatusMessage(xhttp.status.toString(), description);
                    dumpConsoleLogs(LL_ERROR, undefined, "getDicomHeaderInfo", description);
                }
            };
            oReq.send();
            return deferred;
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, "getDicomHeaderInfo", e.message, undefined, true);
        } finally {

        }
    }

    function getDicomHeaderValues(studyUid, seriesIndex, imageUid) {
        var urlParameters = dicomViewer.getDicomHeaderUrl(imageUid);
        var metaURL = dicomViewer.url.getDicomImageURL(urlParameters);
        var request = new XMLHttpRequest();
        request.open('GET', metaURL, false);
        var requestHeaders = getRequestHeaders(studyUid, seriesIndex, imageUid);
        if (requestHeaders) {
            for (var key in requestHeaders) {
                request.setRequestHeader(key, requestHeaders[key]);
            }
        }
        var thumbnailRendererObject = this;
        if (request.status === 500) {
            var description = xhttp.statusText + "\nFailed to get the dicom header values for the respective images." + "\nImage UID: " + imageUid + "\nStudy UID: " + studyUid;
            sendViewerStatusMessage(xhttp.status.toString(), description);
        }
        request.send();
        return JSON.parse(request.responseText);
    }

    function getMetadata(studyUid, seriesIndex, imageUid) {
        var urlParameters = dicomViewer.getDicomHeaderUrl(imageUid);
        var metaURL = dicomViewer.url.getDicomImageMetadataURL(urlParameters);
        var deferred = $.Deferred();
        var oReq = new XMLHttpRequest();
        oReq.open("get", metaURL, true);
        //oReq.responseType = 'application/json';
        oReq.onreadystatechange = function (oEvent) {
            // TODO: consider sending out progress messages here as we receive the pixel data
            if (oReq.readyState === 4) {

                if (oReq.status === 200) {
                    var text = oReq.responseText;
                    deferred.resolve(text);
                } else {
                    deferred.reject();
                }
            } else if (oReq.status === 500) {
                var description = xhttp.statusText + "\nFailed to get the meta data for the respective image." + "\nImage UID: " + imageUid + "\nStudy UID: " + studyUid;
                sendViewerStatusMessage(xhttp.status.toString(), description);
            }
        };
        var headers = getRequestHeaders(studyUid, seriesIndex, imageUid);
        if (headers) {
            for (var key in headers) {
                oReq.setRequestHeader(key, headers[key]);
            }
        }
        oReq.send();
        return deferred;
    }

    function putDicomHeader(imageUid, dicomHeader) {
        if (imageUid === undefined) {
            throw "putDicomHeader: imageUid should not be null/undefined";
        }
        if (dicomHeader === undefined) {
            throw "putDicomHeader: dicomHeader not be null/undefined";
        }
        dicomHeaders[imageUid] = dicomHeader;
    }

    /**
     *@param imageUid
     *@param dicomHeader
     *store the imageInfo object to the dicomHeaders using the image id as key
     */
    function putDicomHeader(imageUid, dicomHeader) {
        if (imageUid === undefined) {
            throw "putDicomHeader: imageUid should not be null/undefined";
        }
        if (dicomHeader === undefined) {
            throw "putDicomHeader: dicomHeader not be null/undefined";
        }

        dicomHeaders[imageUid] = dicomHeader;
    }

    /**
     *@param imageUid
     *Retrieve the imageInfo object from the dicomHeaders using the image id as key
     */
    function getDicomHeader(imageUid) {
        if (imageUid === undefined) {
            throw "getDicomHeader: imageUid should not be null/undefined";
        }
        return dicomHeaders[imageUid];
    }

    dicomViewer.header = {
        getDicomHeaderInfo: getDicomHeaderInfo,
        putDicomHeader: putDicomHeader,
        getDicomHeader: getDicomHeader,
        getDicomHeaderValues: getDicomHeaderValues,
        getMetadata: getMetadata
    };

    return dicomViewer;

}(dicomViewer));
