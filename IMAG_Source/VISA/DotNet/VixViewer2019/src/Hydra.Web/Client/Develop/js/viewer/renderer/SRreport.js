var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    var srMap = {};
    var srLayoutMap = {};
    var SRCacheDetails = [];

    function loadSR(urlParameters, divId, imagePromise, imageType, requestHeaders) {
        var imageUid = urlParameters.ImageUid;
        if (divId != null) {
            $("#" + divId).empty();
            var srDIvId = "SR" + divId;
            var viewportDiv = "<div id=" + srDIvId + "/>"
            $("#" + divId).append(viewportDiv);

            // Add the html data property
            $("#" + divId)[0].isHtml = true;
            $("#" + divId)[0].HtmlId = srDIvId;

            $("#" + srDIvId).css("background", "white");
            $("#" + srDIvId).css("overflow", "auto");
            $("#" + srDIvId).css("width", $("#" + divId).width() - 3);
            $("#" + srDIvId).css("height", $("#" + divId).height() - 3);
            $("#" + srDIvId).css("padding", 5);
            $("#" + srDIvId).removeClass('disableSelection');
            $("#" + divId).removeClass('disableSelection');
            $("#" + getStudyLayoutId(divId)).removeClass('disableSelection');
        }

        if (srMap[imageUid] == undefined) {
            var imageInfoURL = dicomViewer.url.getDicomImageURL(urlParameters);
            var request;
            if (window.XMLHttpRequest) {
                // If the browser if IE7+[or]Firefox[or]Chrome[or]Opera[or]Safari
                request = new XMLHttpRequest();
            } else {
                //If browser is IE6, IE5
                request = new ActiveXObject("Microsoft.XMLHTTP");
            }

            urlParameters = dicomViewer.getSRreportUrl(urlParameters.ImageUid);
            var SrReportURL = dicomViewer.url.getDicomImageURL(urlParameters);
            request.onreadystatechange = function () {
                if (request.readyState == 4 && request.status == 200) {
                    if (srDIvId) document.getElementById(srDIvId).innerHTML = request.responseText; //VAI-1316 and INC30536054
                    srMap[imageUid] = request.responseText;
                    var image = {
                        imageUid: imageUid,
                        imageData: srMap[imageUid],
                        imageType: "nonimage",
                    };
                    srLayoutMap[srDIvId] = imageUid;
                    imagePromise.resolve(srMap[imageUid]);
                }
            }
            request.open("get", SrReportURL, true);
            if (requestHeaders) {
                for (var key in requestHeaders) {
                    request.setRequestHeader(key, requestHeaders[key]);
                }
            }
            request.send();
        } else {
            document.getElementById(srDIvId).innerHTML = srMap[imageUid]; //VAI-1316 and INC30536054
            var status = imagePromise.state()
            if (status != "resolved")
                imagePromise.resolve(srMap[imageUid]);
        }

        document.getElementById(srDIvId).addEventListener(/Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel", onMouseWheel);
        if (imagePromise) {
            var color = (imagePromise.state() == "resolved") ? "green" : "yellow";
            updateCacheIndicatorIconAndCountForSR(urlParameters.ImageUid, color);
        }
    }

    function containsSR(divId) {
        if (srLayoutMap[divId] === undefined) return false;
        else return true;
    }

    /**
     * Update the zoom value for the SR modality (HTML) files by increasing/decreasing the font size
     * @param {Type} zoom - zoom button id/ custom zoom value
     */
    function zoomSR(zoom) {
        var activeLayout = dicomViewer.getActiveSeriesLayout();
        var srDIvId = "SR" + activeLayout.getSeriesLayoutId();
        var size = parseFloat($("#" + srDIvId).css("font-size"))
        if (zoom == 1) {
            //refresh
            $("#" + srDIvId).css({
                fontSize: 12.75
            });
        } else if (zoom == "4_zoom") {
            //SR Zoom In
            $("#" + srDIvId).css({
                fontSize: size + 1
            });
        } else if (zoom == "5_zoom") {
            //SR Zoom Out
            $("#" + srDIvId).css({
                fontSize: size - 1
            });
        } else {
            //Calculating the zoom factor from the zoom percentage given in custom zoom dialog box
            var zoomFactor = (parseFloat(zoom.split("-")[1])) / 100;
            zoomFactor = zoomFactor - 1;
            $("#" + srDIvId).css({
                fontSize: 12.75 + zoomFactor
            });
        }
    }

    /**
     * Update the cache indicator icon and image cache iamge count for SR
     * @param {Type} imageUid - specifies the iamge Uid
     * @param {Type} indicatorColor - specifies the progress indicatorColor
     */
    function updateCacheIndicatorIconAndCountForSR(imageUid, indicatorColor) {
        try {
            if (SRCacheDetails.indexOf(imageUid) == -1 && indicatorColor == "green") {
                nonDICOMRenderedCount++;
                SRCacheDetails.push(imageUid);
            }

            $("#cachemanager_progress").trigger("image_cache_updated", dicomViewer.imageCache.getCacheInfo());
            updateThumbnailCacheIndication(imageUid, indicatorColor);
        } catch (e) {}
    }

    /**
     * Clear the SR cache details
     * @param {Type} imageUid - specifies the imageUid
     */
    function ClearSRCacheDetails(imageUid) {
        try {
            if (imageUid !== undefined) {
                nonDICOMRenderedCount--;
                SRCacheDetails.splice(imageUid, 1);
                $("#cachemanager_progress").trigger("image_cache_updated", dicomViewer.imageCache.getCacheInfo());
            }
        } catch (e) {}
    }


    dicomViewer.loadSR = loadSR;
    dicomViewer.containsSR = containsSR;
    dicomViewer.zoomSR = zoomSR;
    dicomViewer.ClearSRCacheDetails = ClearSRCacheDetails;

    return dicomViewer;
}(dicomViewer));
