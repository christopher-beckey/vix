//VAI-915: requires basic.js
var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    //Patient URL(Contains studyInformation and Patient Information)
    var patientUrl = {};
    //Thumbnail URL Object
    var thumbnailurl = {};
    //ImageIfo URL Object
    var imageInfoUrl = {};
    //Frame URL Object
    var frameRequestUrl = {};
    //Ecg waveform URL Object
    var ecgWaveformUrl = {};
    //ECG menu URL Object
    var ecgMenuUrl = {};
    //SR report URL Object
    var srReportUrl = {};
    //Dicom Header URL Object
    var dicomHeaderUrl = {};
    //Url for blob data
    var blobDataUrl = {};

    var videoUrl = {};
    var audioUrl = {};

    /**
     *@param imageUid
     *@return thumbnail url object
     *Add the imageUid in thumbnailUrl
     */
    function getThumbnailUrl(imageUid) {
        thumbnailurl.Format = "Abstract";
        thumbnailurl.ImageUid = imageUid;
        thumbnailurl.SecurityToken = dicomViewer.security.getSecurityToken();
        thumbnailurl.RequestId = new Date().getTime();
        return thumbnailurl;
    }

    /**
     *@param imageUid
     *@return imageInfo url object
     *Add the imageuid  in the imageInfoURl object
     */
    function getImageInfoURl(imageUid) {
        imageInfoUrl.Format = "ImageInfo";
        imageInfoUrl.ImageUid = imageUid;
        imageInfoUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        imageInfoUrl.RequestId = new Date().getTime();
        return imageInfoUrl;
    }

    /**
     *@param imageUid
     *@return frame request url object for DIcom Images
     *Add the  imageUid and frameNumber to the frameRequestURL  Object
     */
    function getDicomFrameUrl(imageUid, frameNumber, excludeImageInfo) {
        frameRequestUrl.Format = "Frame";
        frameRequestUrl.ImageUid = imageUid;
        frameRequestUrl.FrameNumber = frameNumber;
        frameRequestUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        frameRequestUrl.excludeImageInfo = excludeImageInfo;
        delete frameRequestUrl.Transform;
        return frameRequestUrl;
    }

    /**
     *@param imageUid
     *@return frame request url object for Jpeg Images
     *Add the imageUid and frameNumber to the frameRequestUrl Object
     */
    function getJpegFrameUrl(imageUid, frameNumber, excludeImageInfo) {
        frameRequestUrl.Format = "Frame";
        frameRequestUrl.ImageUid = imageUid;
        frameRequestUrl.FrameNumber = frameNumber;
        frameRequestUrl.Transform = "Jpeg";
        frameRequestUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        frameRequestUrl.RequestId = new Date().getTime();
        frameRequestUrl.excludeImageInfo = excludeImageInfo;
        return frameRequestUrl;
    }

    /**
     *@param imageUid
     *@return frame request url object for pdf 
     */
    function getPdfFrameUrl(imageUid) {
        frameRequestUrl.Format = "Frame";
        frameRequestUrl.ImageUid = imageUid;
        frameRequestUrl.Transform = "Pdf";
        frameRequestUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        frameRequestUrl.RequestId = new Date().getTime();
        return frameRequestUrl;

    }

    /**
     *@param imageUid
     *@return frameRequestUrl for ecg informations
     */
    function getEcgInformationUrl(imageUid) {
        frameRequestUrl.Format = "Waveform";
        frameRequestUrl.ImageUid = imageUid;
        frameRequestUrl.Transform = "Json";
        frameRequestUrl.FrameNumber = -1;
        frameRequestUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        frameRequestUrl.RequestId = new Date().getTime();
        return frameRequestUrl;
    }

    /**
     *@param imageUid
     *@param drawType
     *@param grid
     *@param gridColor
     *@param signalThikness
     *@param gain
     *@return ecgWaveformUrl
     */
    function getEcgWaveformUrl(imageUid, drawType, grid, gridColor, signalThikness, gain) {
        ecgWaveformUrl.Format = "Waveform";
        ecgWaveformUrl.ImageUid = imageUid;
        ecgWaveformUrl.FrameNumber = -1;
        ecgWaveformUrl.Transform = "Png";
        ecgWaveformUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        ecgWaveformUrl.DrawType = drawType;
        ecgWaveformUrl.GridType = grid;
        ecgWaveformUrl.GridColor = gridColor;
        ecgWaveformUrl.SignalThickness = signalThikness;
        ecgWaveformUrl.Gain = gain;
        getEcgWaveformUrl.RequestId = new Date().getTime();
        return ecgWaveformUrl;
    }

    /**
     *@param imageUid
     *@return ecgmenuUrl with extraLeads 
     */
    function getEcgMenuUrl(imageUid, extraLeads) {
        ecgMenuUrl.Format = "Waveform";
        ecgMenuUrl.ImageUid = imageUid;
        ecgMenuUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        ecgMenuUrl.Transform = "Png";
        ecgMenuUrl.ExtraLeads = extraLeads;
        ecgMenuUrl.RequestId = new Date().getTime();
        return ecgMenuUrl;
    }

    /**
     *@param imageUid
     *@return srReportUrl
     */
    function getSRreportUrl(imageUid) {
        srReportUrl.Format = "Frame";
        srReportUrl.ImageUid = imageUid;
        srReportUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        srReportUrl.Transform = "Html";
        srReportUrl.RequestId = new Date().getTime();
        return srReportUrl;
    }

    /**
     *@param imageUid
     *@return dicomHeaderUrl
     */
    function getDicomHeaderUrl(imageUid) {
        dicomHeaderUrl.Format = "Header";
        dicomHeaderUrl.ImageUid = imageUid;
        dicomHeaderUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        dicomHeaderUrl.RequestId = new Date().getTime();
        return dicomHeaderUrl;
    }

    /**
     *return the object for hydra version call
     */
    function getHydraVersion() {
        dicomHeaderUrl.Format = "Version";
        dicomHeaderUrl.SecurityToken = dicomViewer.security.getSecurityToken();
        dicomHeaderUrl.RequestId = new Date().getTime();
        return dicomHeaderUrl;
    }

    function getDisplayContextUrl() {
        var URL = baseViewerURL + "/context?" + BasicUtil.getCurrentUrlParamsAfterQM();
        return URL;
    }

    /*
     * Create a subpage from the current page's URL and replace the ContextId URL parameter's value
     * @param {any} subpageName The name of the subpage
     * @param {any} contextId The value of the ContextId
     */
    function getNewSubpageUrlForContext(subpageName, contextId) { //VAI-915: Refactored to make generic
        var url = baseViewerURL + "/" + subpageName;
        return url.searchParams.set('ContextId', contextId);
    }

    function getVideoUrls(imageUid) {

        var urls = [];

        urls.push({
            urlParameters: {
                ImageUID: imageUid,
                Format: "Media",
                Transform: "Mp4"
            },
            type: "video/mp4"
        });

        urls.push({
            urlParameters: {
                ImageUID: imageUid,
                Format: "Media",
                Transform: "Webm"
            },
            type: "video/webm"
        });

        urls.push({
            urlParameters: {
                ImageUID: imageUid,
                Format: "Media",
                Transform: "Avi"
            },
            type: "video/avi"
        });

        return urls;
    }

    function getAudioUrl(imageUid) {
        audioUrl.ImageUID = imageUid;
        audioUrl.Format = "Media";
        audioUrl.Transform = "Mp3";
        return audioUrl;
    }

    function getBlobUrl(imageUid) {
        blobDataUrl.ImageUID = imageUid;
        blobDataUrl.Format = "Original";
        blobDataUrl.Transform = "Default";
        return blobDataUrl;
    }

    /**
     *@return thumbnail url object
     */
    function getMetadataThumbnailUrl(imageURN) {
        var thumbnailurl = baseURL + "/context/metadata/thumbnail?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&" + imageURN + "&RequestId=" + new Date().getTime();
        return thumbnailurl;
    }

    /**
     * argument - contextId
     * return - metadata URL
     */
    function getMetaDataUrl() {
        var url = baseURL + "/context/metadata?" + BasicUtil.getCurrentUrlParamsAfterQM();
        return url;
    }

    /**
     * Get the metadata image information Url
     * @param {Type} imageUrn - Specifies the image Urn
     */
    function getMetadataImageInfoUrl(imageUrn) {
        return (baseURL + "/context/metadata/image/imageinfo?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&ImageUrn=" + imageUrn) + "&RequestId=" + new Date().getTime();
    }

    /**
     * Get the metadata image delete url
     */
    function getMetadataImageDeleteUrl() {
        return (baseURL + "/context/metadata/image?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber") + "&_cacheBust=" + new Date().getMilliseconds());
    }

    /**
     * Get the metadata image sensitive url
     */
    function getMetadataImageSensitiveUrl() {
        return (baseURL + "/context/metadata/image/sensitive?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber") + "&_cacheBust=" + new Date().getMilliseconds());
    }

    /**
     * Get the metadata image delete reasons url
     */
    function getMetadataImageDeleteReasonsUrl() {
        return (baseURL + "/context/metadata/image/reasons?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber") + "&_cacheBust=" + new Date().getMilliseconds());
    }

    /**
     * Get the user details url
     */
    function getUserDetailsUrl() {
        return baseViewerURL + "/user/details?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Get the eSignature Url
     */
    function geteSignatureUrl(signature) {
        var siteId = BasicUtil.getUrlParameter("AuthSiteNumber");
        return (baseViewerURL + "/site/" + siteId + "/esignature/" + signature + "/verify?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + siteId + "&_cacheBust=" + new Date().getMilliseconds());
    }

    /**
     * Cine Url
     */
    function getCineUrl(level) {
        return baseViewerURL + "/dict/" + level + "/cine?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Ecg Url
     */
    function getEcgUrl(level) {
        return baseViewerURL + "/dict/" + level + "/ecg?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * CopyAttributes Url
     */
    function getCopyAttribUrl(level) {
        return baseViewerURL + "/dict/" + level + "/copyattributes?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Settings Url (Hanging Protocol)
     */
    function getSettingsUrl(level) {
        return baseViewerURL + "/dict/" + level + "/layouts?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Measurement preferences Url
     */
    function getMeasurementPrefUrl(level) {
        return baseViewerURL + "/dict/" + level + "/mpref?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Get the print image reasons url
     */
    function getPrintReasonsUrl() {
        return (baseViewerURL + "/print/reasons?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber"));
    }

    /**
     * Get the the log export url
     */
    function getLogExportUrl() {
        var siteId = BasicUtil.getUrlParameter("AuthSiteNumber");
        return (baseViewerURL + "/site/" + siteId + "/logexport?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + siteId);
    }

    /**
     * Log config Url
     */
    function getLogConfigUrl(level) {
        return baseViewerURL + "/dict/" + level + "/log?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber");
    }

    /**
     * Get the metadata image edit options url
     */
    function getMetadataImageEditOptionsUrl(indexes) {
        return (baseURL + "/context/metadata/image/editOptions/" + indexes + "?SecurityToken=" + dicomViewer.security.getSecurityToken() + "&AuthSiteNumber=" + BasicUtil.getUrlParameter("SiteNumber") + "&SiteNumber=" + BasicUtil.getUrlParameter("SiteNumber") + "&_cacheBust=" + new Date().getMilliseconds());
    }

    /**
     * Get the metadata image edit options url
     */
    function getMetadataImageEditSaveUrl() {
        return baseViewerURL + "/qa/review/imageproperties" + window.location.search + "&_cacheBust=" + new Date().getMilliseconds();
    }

    /**
     * Study details Url
     */
    function geStudyDetailsUrl() {
        return baseViewerURL + "/studyDetails?" + BasicUtil.getCurrentUrlParamsAfterQM() + "&IncludeImageDetails=true" + "&_cacheBust=" + new Date().getMilliseconds();
    }

    function getQaImagePropertiesUrl(imageIEN) {
        return (window.location.origin + "/vix/viewer/qa/review/imageproperties/" + imageIEN + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaSearchParamUrl() {
        return (window.location.origin + "/vix/viewer/qa/search/params" + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaSearchUrl(siteNumber) {
        return (window.location.origin + "/vix/viewer/qa/search/" + siteNumber + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaCaptureUsersUrl(searchFilter) {
        return (window.location.origin + "/vix/viewer/qa/search/captureusers/" + searchFilter.fromDate + "/" + searchFilter.throughDate + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaImageFiltersUrl(filters) {
        return (window.location.origin + "/vix/viewer/qa/search/imagefilters/" + filters.captureUser.userId + "/" + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaImageFilterDetailsUrl(filters) {
        return (window.location.origin + "/vix/viewer/qa/search/imagefilterdetails/" + filters.imageFilter.filterIEN + "/" + window.location.search + "&_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaStudyQueryUrl() {
        return (window.location.origin + "/vix/viewer/studyquery?_cacheBust=" + new Date().getMilliseconds());
    }

    function getQaReportsUrl() {
        return (window.location.origin + "/vix/viewer/qa/reports?_cacheBust=" + new Date().getMilliseconds());
    }


    dicomViewer.getDisplayContextUrl = getDisplayContextUrl;
    dicomViewer.getThumbnailUrl = getThumbnailUrl;
    dicomViewer.getImageInfoURl = getImageInfoURl;
    dicomViewer.getDicomFrameUrl = getDicomFrameUrl;
    dicomViewer.getJpegFrameUrl = getJpegFrameUrl;
    dicomViewer.getPdfFrameUrl = getPdfFrameUrl;
    dicomViewer.getEcgInformationUrl = getEcgInformationUrl;
    dicomViewer.getEcgWaveformUrl = getEcgWaveformUrl;
    dicomViewer.getEcgMenuUrl = getEcgMenuUrl;
    dicomViewer.getSRreportUrl = getSRreportUrl;
    dicomViewer.getDicomHeaderUrl = getDicomHeaderUrl;
    dicomViewer.getHydraVersion = getHydraVersion;
    dicomViewer.getVideoUrls = getVideoUrls;
    dicomViewer.getAudioUrl = getAudioUrl;
    dicomViewer.getBlobUrl = getBlobUrl;
    dicomViewer.getNewSubpageUrlForContext = getNewSubpageUrlForContext;
    dicomViewer.getUserDetailsUrl = getUserDetailsUrl;
    dicomViewer.getCineUrl = getCineUrl;
    dicomViewer.getEcgUrl = getEcgUrl;
    dicomViewer.getCopyAttribUrl = getCopyAttribUrl;
    dicomViewer.getSettingsUrl = getSettingsUrl;
    dicomViewer.getMeasurementPrefUrl = getMeasurementPrefUrl;
    dicomViewer.getPrintReasonsUrl = getPrintReasonsUrl;
    dicomViewer.getLogExportUrl = getLogExportUrl;
    dicomViewer.getLogConfigUrl = getLogConfigUrl;
    dicomViewer.geStudyDetailsUrl = geStudyDetailsUrl;
    dicomViewer.getQaImagePropertiesUrl = getQaImagePropertiesUrl;
    dicomViewer.getQaSearchParamUrl = getQaSearchParamUrl;
    dicomViewer.getQaSearchUrl = getQaSearchUrl;
    dicomViewer.getQaCaptureUsersUrl = getQaCaptureUsersUrl;
    dicomViewer.getQaImageFiltersUrl = getQaImageFiltersUrl;
    dicomViewer.getQaImageFilterDetailsUrl = getQaImageFilterDetailsUrl;
    dicomViewer.getQaStudyQueryUrl = getQaStudyQueryUrl;
    dicomViewer.getQaReportsUrl = getQaReportsUrl;

    dicomViewer.Metadata = {
        Url: getMetaDataUrl,
        ThumbnailUrl: getMetadataThumbnailUrl,
        ImageInfoUrl: getMetadataImageInfoUrl,
        ImageDeleteUrl: getMetadataImageDeleteUrl,
        ImageSensitiveUrl: getMetadataImageSensitiveUrl,
        ReasonsUrl: getMetadataImageDeleteReasonsUrl,
        eSignatureUrl: geteSignatureUrl,
        EditOptionsUrl: getMetadataImageEditOptionsUrl,
        EditSaveUrl: getMetadataImageEditSaveUrl
    };
    return dicomViewer;
}(dicomViewer));
