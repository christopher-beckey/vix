var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    function addEndingSlashIfMissing(urlPart) {
        if (urlPart == undefined) {
            throw "addEndingSlashIfMissing: urlPart is empty/null";
        }
        if (urlPart.substr(urlPart.length - 1) == '/')
            return urlPart;
        return urlPart + '/';
    }

    function getStudyDetailURL(urlParameters) {
        if (urlParameters == undefined) {
            throw "Study URL: URL Parameters are empty/null";
        }
        return addEndingSlashIfMissing(baseURL) + "studies?" + $.param(urlParameters);
    }

    function getOverlayTextURL() {
        return addEndingSlashIfMissing(baseURL) + "config?Parameter=TextOverlay";
    }

    function getMeasurementsURL() {
        return addEndingSlashIfMissing(baseURL) + "config?Parameter=measurements";
    }

    function getViewerVersionURL() {
        return addEndingSlashIfMissing(baseViewerURL) + "version";
    }

    function getDicomImageURL(urlParameters) {
        if (urlParameters == undefined) {
            throw "Dicom Image URL: URL Parameters are empty/null";
        }
        return addEndingSlashIfMissing(baseURL) + "images?" + $.param(urlParameters);
    }

    function getDicomImageMetadataURL(urlParameters) {
        if (urlParameters == undefined) {
            throw "Dicom Image URL: URL Parameters are empty/null";
        }
        return addEndingSlashIfMissing(baseViewerURL) + "metadata?" + $.param(urlParameters);
    }

    function getReferenceLineURL(urlParameters) {
        if (urlParameters == undefined) {
            throw "Dicom Image URL: URL Parameters are empty/null";
        }
        return addEndingSlashIfMissing(baseURL) + "xreflines?" + $.param(urlParameters);
    }

    function getReleaseHistoryUrl() {
        return addEndingSlashIfMissing(baseViewerURL) + "releasehistory";
    }

    function getMessageHistoryUrl() {
        return addEndingSlashIfMissing(baseViewerURL) + "events";
    }

    /**
     * Get the Remove Context Url
     * @param {Type} sessionId - Specify the session id
     */
    function getRemoveContextUrl(sessionId) {
        var baseUrl = baseURL.split("/v");
        var url = addEndingSlashIfMissing(baseUrl[0]) + "vix/session/" + sessionId + "/context";
        return url;
    }

    /**
     * PState Url (Presentation State)
     */
    function getPStateUrl(contextId) {
        var n = dicomViewer.getWindowLocationUrl().indexOf("&");
        var myBase = addEndingSlashIfMissing(baseURL);
        var url = myBase.replace("/viewer", "") + "context/pstate?" + "ContextId=" + decodeURIComponent(contextId) + dicomViewer.getWindowLocationUrl().substring(n);
        return url;
    }

    /**
     * Get the 6000 overlay url
     * @param {Type} imageUid - Specifies the image uid
     * @param {Type} frameNumber - Specifies the image number
     * @param {Type} overlayIndex - Specifies the overlay index
     */
    function get6000overlayUrl(imageUid, frameNumber, overlayIndex) {
        var urlParameters = {
            Format: "Overlay",
            ImageUid: imageUid,
            FrameNumber: frameNumber,
            Transform: "Dicom",
            SecurityToken: dicomViewer.security.getSecurityToken(),
        };

        return addEndingSlashIfMissing(baseURL) + "images?" + $.param(urlParameters);
    }

    dicomViewer.url = {
        getStudyDetailURL: getStudyDetailURL,
        getOverlayTextURL: getOverlayTextURL,
        getMeasurementsURL: getMeasurementsURL,
        getDicomImageURL: getDicomImageURL,
        getReferenceLineURL: getReferenceLineURL,
        getViewerVersionURL: getViewerVersionURL,
        getReleaseHistoryUrl: getReleaseHistoryUrl,
        getMessageHistoryUrl: getMessageHistoryUrl,
        getDicomImageMetadataURL: getDicomImageMetadataURL,
        getRemoveContextUrl: getRemoveContextUrl,
        getPStateUrl: getPStateUrl,
        get6000overlayUrl: get6000overlayUrl
    };

    return dicomViewer;
}(dicomViewer));
