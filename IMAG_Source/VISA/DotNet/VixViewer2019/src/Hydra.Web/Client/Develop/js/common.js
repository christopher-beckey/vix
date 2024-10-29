//window.onload = loadStudy;
var viewerType = "viewer";
var leadTypeObject = {};
// image would load first in the viewer

var layoutMap = {};

//use to create the webworker count for caching in imageloader.js
var numberOfWebWorkers = 0;
var maxWebWorkers = 30;

var studyUids = new Array();

//To prevent cache start in the setImageLevelLayout method
//of imageViewport.js
var cacheFlag = false;
var myLayout; // a var is required because this page utilizes: myLayout.allowOverflow() method	
var customSeriesLayout = "";

var studyLayoutValue = "1x1";

//Current status for full screen option based on the study level
var isFullScreenEnabled = false;

//previous series index of imageViewer1x1 viewport(first viewport in first study level)
//help to set the image while disable the full screen option in  study level
var seriesIndexBackup = 0;

var imageDisplayed = false;
var useKendoTooltip = false;

var toolbarHeight;
var WINDOWWIDTH = $(window).width();
var thumbnailHeight;
var thumbnailWidth;

var WINDOWHEIGHT = $(window).height();
var BROWSER_ZOOM_LEVEL = window.devicePixelRatio;

var layoutRow = 1;
var layoutColumn = 1;
var imageThumbWidth = 0;

var playerToolBarElement = null;
var imageNavigationToolBarElement = null;
var pdfToolBarElement = null;
var tiffToolBarElement = null;
var cacheIndicatorElement = null;
var showStudyCacheIndicator = !releaseBuild;
var myDropDown = null;
var calibrationToolId = undefined;

var playerFiledSetElement = null;
var imageFiledSetElement = null;
var pdfFiledSetElement = null;
var tiffFiledSetElement = null;
var pageFiledSetElement = null;
var previouseSelectdTool = undefined;
var ishowKendoTools = false;

var improvement = "Improvement";
var bug = "Bug";
var feature = "Feature";
var TOOLNAME_WINDOWLEVEL = "WindowLevel";
var TOOLNAME_WINDOWLEVEL_ROI = "WindowLevelROI";
var TOOLNAME_DEFAULTTOOL = "defaultTool";
var TOOLNAME_ZOOM = "Zoom";
var TOOLNAME_PAN = "Pan";
var TOOLNAME_LINK = "Link";
var TOOLNAME_XREFLINESELECTIONTOOL = "XRefLineSelectionTool";
var TOOLNAME_SHARPENTOOL = "Sharpen";
var TOOLNAME_PEN = "pen"
var TOOLNAME_COPYATTRIBUTES = "CopyAttributes"

var IMAGETYPE_RADECHO = "radecho";
var IMAGETYPE_RAD = "rad";
var IMAGETYPE_JPEG = "jpeg";
var IMAGETYPE_BLOB = "blob";
var IMAGETYPE_PDF = "pdf";
var IMAGETYPE_VIDEO = "video";
var IMAGETYPE_AUDIO = "audio";
var IMAGETYPE_RADSR = "radsr";
var IMAGETYPE_RADPDF = "radpdf";
var IMAGETYPE_RADECG = "radecg";
var IMAGETYPE_TIFF = "tiff";
var IMAGETYPE_CDA = "cda";
var isRGBToolEnabled = false;

//To hold the custom/embeded pdf viewer
var embedPdfViewer = {
    isGenreal: true,
    isECGPdf: true
};

var STUDY_TYPE_DICOM = "dicom";
var STUDY_TYPE_NON_DICOM = "nonDicom";

// To hold the pixel spacing and unit type
var calibrated2DPixelSpacingMap = new Map();

var activeCalibratedImage;
var iconSize = 0;

// Preferences page name 
var PREF_PAGE_ANNOTATION = "Annotation";
var PREF_PAGE_CINE = "Cine";
var PREF_PAGE_ECG = "ECG";
var PREF_PAGE_LAYOUT = "Layout";
var PREF_PAGE_COPY_ATTRIBUTES = "Copy Attributes";
var PREF_PAGE_LOG = "Log";

/**
 * Study layout max rows and columns
 */
var STUDY_LAYOUT_MAX_ROW = "3";
var STUDY_LAYOUT_MAX_COLUMN = "3";

var isStudyRequested = false;
var numberOfRetryAttempts = 0;
var isStudyCacheInProgress = false;
var numberOfCacheRetryAttempts = 0;
var ecgRenderedCount = 0;
var nonDICOMRenderedCount = 0;
var nonDICOMCacheDetails = {};
var defaultViewportInThumbnailViewHiddenMode = undefined;
var isShowSharpen = false;

var activeSeriesPDFData = undefined;
var isPDFActiveSeries = false;
var isServerFailed = false;

var THUMBNAIL_PANEL_MIN_WIDTH = ((screen.width * 135) / 1280) < 135 ? 135 : (screen.width * 135) / 1280;
var THUMBNAIL_PANEL_MAX_WIDTH = 150;
var THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MIN_WIDTH;
if (THUMBNAIL_PANEL_WIDTH > THUMBNAIL_PANEL_MAX_WIDTH) {
    THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MAX_WIDTH;
}

// Holding the compressed image data based on this flag
var isCacheCompressedImageData = true;

var LL_TRACE = "Trace";
var LL_DEBUG = "Debug";
var LL_INFO = "Info";
var LL_WARN = "Warn";
var LL_ERROR = "Error";
var LL_NONE = "None";

var canPrint = false;
var canExport = false;
var isVerifySignature = false;
var isPState = false;
var isReformatContentDateTime = false;
var activeThumbnailTab = "generalA";

// Global measurement preference tab settings
var activePrefTab = null;
var activeMeasurementType = [];
var tempMeasurementStyleCol = {};
var tempCinePreference = {};
var tempEcgPreference = {};
var tempDisplayPreference = {};
var tempCopyAttribPreference = {};
var tempLogPreference = {};
var MT_TypeCol = [];
var MT_EX_TypeCol = [];
var MT_PS_TypeCol = ["LENGTH", "LINE", "ARROW", "POINT", "ANGLE", "ELLIPSE", "HOUNSFIELDELLIPSE", "RECT", "HOUNSFIELDRECT", "TEXT", "TRACE", "MG", "ASPV", "ARPV", "MRPV", "ARL", "MRL", "MVALT", "FREEHAND", "PEN", "LBLANNOTATION", "LBLOVERLAY", "LBLORIENTATION", "LBLSCOUT", "LBLRULER"];
var prefTabs = {
    tabList: ['annotationPreference', 'cinePreference', 'ecgPreference', 'layoutPreference', 'copyAttributesPreference'],
    enabled: [true, true, true, true, true, true]
}
var useDefaultIDList = ["ASTROKESTYLEchk", "LINEchk", "ARROWchk", "MSTROKESTYLEchk", "LENGTHchk", "ANGLEchk", "ERSTROKESTYLEchk", "HOUNSFIELDchk", "LBLANNOTATIONchk", "LBLOVERLAYchk", "LBLORIENTATIONchk", "LBLSCOUTchk", "LBLRULERchk", "TEXTchk", "MAchk", "MITRALchk"];

var MT_Lbl_Col = [];
var logPreferences = [];
logPreferences["loglevel"] = LL_NONE;
logPreferences["linelimit"] = 1000;
logPreferences["keys"] = "CTRL+I";

var QAType = {
    imageInfo: "IMG_INFO",
    deleteImage: "IMG_D",
    indexEdit: "IMG_IE",
    needsReview: "IMG_NR",
    qaReviewed: "IMG_R",
    imageStatus: "IMG_STATUS",
    addStudy: "ADD_STUDY",
    closeStudy: "CLOSE_STUDY",
    emptyViewport: "EMPTY_VIEWPORT"
};

var gridType = "1";
var gridColor = "0";
var signalThickness = "1";
var gain = "1";
var drawType = "8";
var gridColorSelection = "redGrid";

/**
 * Check whether the signature is enabled or not 
 */
function isSignatureEnabled() {
    return isVerifySignature;
}

/**
 * 
 * Enable or Disable the PState
 */
function isPStateEnabled() {
    return isPState;
}

/**
 * Get the session id
 */
var sessionId = undefined;

function getSessionId() {
    try {
        if (sessionId !== undefined) {
            return sessionId;
        }

        sessionId = BasicUtil.getUrlParameter("sessionId");
    } catch (e) {

    } finally {

    }
    return sessionId;
}

var isQA = undefined;

function invokerIsQA() {
    try {
        if (isQA !== undefined) {
            return isQA;
        }

        isQA = BasicUtil.getUrlParameter("Invoker") == "QA" ? true : false; //VAI-915
    } catch (e) {}

    return isQA;
}

function isCurrentSession(sessionIdParam) {
    return (getSessionId() ? (sessionIdParam.toLowerCase() == getSessionId().toLowerCase()) : undefined);
}

/*JavaScript Closures help us to change the value of the global variable by calling 
 *method isCineEnabled(flag) will set true or false
 *call using empty paramenter(i.e isCineEnabled()) will return the
 *previous value set on the flag
 *cineFlag help us to mainatin play cine while changing layouts or resize the browser window
 **/
var isCineEnabled = (function () {
    var cineFlag = false;
    return function (flag) {
        if (flag != undefined) {
            cineFlag = flag
        } else {
            return cineFlag;
        }
    }
})();

/**
 * Return the viewer type
 */
function getViewerType() {
    return viewerType;
}

/**
 * Set the measurementUnits to an array
 * @param {Type} studyUid - it has the Studyuid,series index and image index
 * @param {Type} measurementUnits -  it has pixel spacing and unit type
 */
function setUnitMeasurementMap(studyUid, measurementUnits) {
    calibrated2DPixelSpacingMap.set(studyUid, measurementUnits);
}

/**
 * Return the respective unitMeasurementMap if studyuid is present
 * @param {Type} studyUid - it has the Studyuid,series index and image index
 */
function getUnitMeasurementMap(studyUid) {
    if (calibrated2DPixelSpacingMap.has(studyUid)) {
        return calibrated2DPixelSpacingMap.get(studyUid);
    }
    return null;
}

/**
 * Update the Image/Series level selection icon size.
 * @param {Type} viewportId  - it holds the image/series level selection icon id
 */
function changeIconSize(viewportId) {
    if (iconSize) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        if (activeSeriesLayout || viewportId) {
            var property = null;
            var key = viewportId ? viewportId : (activeSeriesLayout.seriesLayoutId).split("_")[1];
            (property = document.getElementById("imageLevelSelection_" + key)) ? property.style.width = (iconSize) + "px" : property = 0;
            (property = document.getElementById("seriesLevelSelection_" + key)) ? property.style.width = (iconSize) + "px" : property = 0;
        }
    }
}

/**
 * Set the Icon size
 * @param {Type} size -  it holds the Image/Series level icon size
 */
function setIconSize(size) {
    if (iconSize == 0) {
        iconSize = size;
    }
}

/**
 * Update the viewport height
 * @param {Type} viewportId - it holds the viewport id
 * @param {Type} imageType - it hold the image type
 */
function viewportHeight(viewportId, imageType) {
    var tableId = "table" + viewportId.split("_")[1];
    var viewportHeight = document.getElementById(tableId).style.height;
    viewportHeight = viewportHeight.replace('px', '');
    if (imageType == "video") {
        viewportHeight = viewportHeight - 19;
    } else {
        viewportHeight = viewportHeight - 15;
    }
    document.getElementById(tableId).style.height = (viewportHeight) + "px";
}

/**
 * 
 * @param {Type} key - it holds the studyuid,imageindex,series index,frame index
 */
function setActiveCalibratedImage(key) {
    activeCalibratedImage = key;
}

/**
 * Return the active calibrated image key
 */
function getActiveCalibratedImage() {
    return activeCalibratedImage;
}

function loadSpinner() {
    var spinner = dicomViewer.progress.createAndGetSpinner('viewer');
    dicomViewer.progress.putSpinner('viewer', spinner);
}

function isBlob(imageType) {

    if ((imageType === IMAGETYPE_BLOB) ||
        (imageType === IMAGETYPE_PDF) ||
        (imageType === IMAGETYPE_TIFF) ||
        (imageType === IMAGETYPE_VIDEO) ||
        (imageType === IMAGETYPE_AUDIO))
        return true;

    return false;
}

function canPlayCine(imageType) {
    if ((imageType === IMAGETYPE_RAD) ||
        (imageType === IMAGETYPE_RADECHO))
        return true;

    return false;
}

function sendVolumeMeasurements(value) {
    if (window.console) {
        console.log(value);
    }
    dumpConsoleLogs(LL_INFO, "Volume measurements", undefined, value, undefined, undefined, true);
}

function sendMeasurement(anatomyCode, value) {
    if (window.console) {
        console.log("" + anatomyCode + ":" + value);
    }
    dumpConsoleLogs(LL_INFO, "Measurements", undefined, ("" + anatomyCode + ":" + value), undefined, undefined, true);
}

function getMeasurements() {
    var measurements = [];
    var mitralValve = {
        label: "Mitral Valve",
        items: []
    };
    mitralValve.items[mitralValve.items.length] = {
        label: "Mitral Valve Anterior Leaflet Thickness",
        shortLabel: "MV ALT",
        id: "mitralValveAnteriorLeafletThickness",
        type: 0,
        units: "mm"
    };
    mitralValve.items[mitralValve.items.length] = {
        label: "Mitral Regurgitation Length",
        shortLabel: "M RL",
        id: "mitralRegurgitationLength",
        type: 0,
        units: "cm"
    };
    mitralValve.items[mitralValve.items.length] = {
        label: "Mitral Regurgitation Peak Velocity",
        shortLabel: "M RPV",
        id: "mitralRegurgitationPeakVelocity",
        type: 1,
        units: "m/s"
    };
    mitralValve.items[mitralValve.items.length] = {
        label: "Mitral Stenosis Mean Gradient",
        shortLabel: "M SMG",
        id: "mitralStenosisMeanGradient",
        type: 5,
        units: "mmHg"
    };

    var aorticValve = {
        label: "Aortic Valve",
        items: []
    };
    aorticValve.items[aorticValve.items.length] = {
        label: "Aortic Regurgitation Length",
        shortLabel: "A RL",
        id: "aorticRegurgitationLength",
        type: 0,
        units: "cm"
    };
    aorticValve.items[aorticValve.items.length] = {
        label: "Aortic Regurgitation Peak Velocity",
        shortLabel: "A RPV",
        id: "aorticRegurgitationPeakVelocity",
        type: 1,
        units: "m/s"
    };
    aorticValve.items[aorticValve.items.length] = {
        label: "Aortic Stenosis Peak Velocity",
        shortLabel: "A SPV",
        id: "aorticStenosisPeakVelocity",
        type: 1,
        units: "m/s"
    };

    measurements[measurements.length] = mitralValve;
    measurements[measurements.length] = aorticValve;

    return measurements;
}

function addStudyUidsFromURL() {
    var ret = BasicUtil.getUrlParameter("studyUid", "", true);
    if (ret.found) {
        var arr = ret.value.split(";");
        for (var i = 0; i < arr.length; i++) {
            addStudyUid(arr[i]);
        }
    }
}

function addStudyUid(studyUid) {
    var index = jQuery.inArray(studyUid, studyUids);
    if (index === -1)
        studyUids[studyUids.length] = studyUid;
    else
        return;
}

$(document).ready(function () {
    var viewportElement = $("#viewport_View");
    var studyRow = 1;
    var studyColumn = 1;
    var isStudyLayoutAvailable = false;

    //VAI-760: removed unnecessary code

    dicomViewer.security.setSecurityToken(BasicUtil.getUrlParameter("securityToken", "", true)); //VAI-915

    dicomViewer.logUtility.initialze();

    // Update the preferences
    updatePreferences();

    var skipStudyStatus = BasicUtil.getUrlParameter('skipStudyStatus');
    if (skipStudyStatus === true || skipStudyStatus === "true") {
        loadStudy();
    } else {
        var patientURL = dicomViewer.getDisplayContextUrl();
        cacheAllImagesFunction(studyRow, studyColumn, patientURL, viewportElement, isStudyLayoutAvailable);
    }
    updatePrintImageReasons();
    startSignalrConnection();

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = $(e.target).attr("id"); // activated tab
        var relatedTarget = $(e.relatedTarget).attr("id"); // hidden tab
        document.getElementById(target).style.background = "#5C5D64";
        document.getElementById(relatedTarget).style.background = "#363636";
        activeThumbnailTab = target;
    });

    $('#keyA').on("mouseenter", function () {
        document.getElementById('keyA').style.background = activeThumbnailTab == "keyA" ? "#5C5D64" : "#f49242";
    });

    $('#generalA').on("mouseenter", function () {
        document.getElementById('generalA').style.background = activeThumbnailTab == "generalA" ? "#5C5D64" : "#f49242";
    });

    $('#keyA').on("mouseleave", function () {
        document.getElementById('keyA').style.background = activeThumbnailTab == "keyA" ? "#5C5D64" : "#363636";
    });

    $('#generalA').on("mouseleave", function () {
        document.getElementById('generalA').style.background = activeThumbnailTab == "generalA" ? "#5C5D64" : "#363636";
    });
});

/**
 * User preference settings
 * @param {Type}  
 */
function updateUserAnnotationPreferences() {

    MT_TypeCol = [
        "ANNOTATION", "MEASUREMENT", "ELLIPSE & RECTANGLE", "LABEL", "TEXT", "MITRAL & AORTIC (US)"
    ];

    MT_EX_TypeCol["ANNOTATION"] = [
        "ASTROKESTYLE", "LINE", "ARROW"
    ];

    MT_EX_TypeCol["MEASUREMENT"] = [
        "MSTROKESTYLE", "LENGTH", "ANGLE",
    ];

    MT_EX_TypeCol["ELLIPSE & RECTANGLE"] = [
        "ERSTROKESTYLE", "HOUNSFIELD"
    ];

    MT_EX_TypeCol["LABEL"] = [
        "LABEL"
    ];

    MT_EX_TypeCol["TEXT"] = [
        "TEXT"
    ];

    MT_EX_TypeCol["MITRAL & AORTIC (US)"] = [
        "MA", "MITRAL", "AORTIC"
    ];

    MT_Lbl_Col = [
        "LBLANNOTATION", "LBLOVERLAY", "LBLORIENTATION", "LBLSCOUT", "LBLRULER"
    ];

    $('#settingPreference').on('shown.bs.modal', function (e) {
        hideAccordionTabs();
        onPreferenceDialogShown();
    });

    $("#addHPPref").click(function () {
        dicomViewer.generalPreferences.addOrEditHP(undefined, 'add');
        $('#applyPref, #resetPref').prop('disabled', false);
    });

    $("#cancelPref").click(function () {
        if (activePrefTab == PREF_PAGE_LAYOUT && !$('#listHangingProtocol').is(":visible")) {
            showOrHideHPControls(true);
            showOrHideFooterControls(true);
            dicomViewer.generalPreferences.showOrHideHPTable(true);
            $('#applyPref, #resetPref').prop('disabled', true);
        } else {
            $("#settingPreference").modal('hide');
        }
    });

    $("#applyPref").click(function () {
        switch (activePrefTab) {
            case PREF_PAGE_CINE:
                dicomViewer.generalPreferences.onApply('cine');
                break;
            case PREF_PAGE_ECG:
                dicomViewer.generalPreferences.onApply('ecg');
                break;
            case PREF_PAGE_ANNOTATION:
                if (!isEmptyObject(tempMeasurementStyleCol)) {
                    if (!dicomViewer.annotationPreferences.validatePreference()) {
                        return;
                    }
                    var measurementStyleCol = dicomViewer.annotationPreferences.updateMeasurementStyle(true);
                    $.each(MT_PS_TypeCol, function (key, value) {
                        dicomViewer.measurement.draw.setUserMeasurementStyleByType(value, measurementStyleCol[value].useDefault, measurementStyleCol[value].styleCol);
                    });
                    dicomViewer.annotationPreferences.setAnnotationPreference(measurementStyleCol);
                    $('#applyPref, #resetPref').prop('disabled', true);
                }
                break;
            case PREF_PAGE_LAYOUT:
                if (!$('#listHangingProtocol').is(":visible")) {
                    dicomViewer.generalPreferences.updateHPTable();
                    showOrHideHPControls(true);
                    showOrHideFooterControls(true);
                    dicomViewer.generalPreferences.showOrHideHPTable(true);
                } else {
                    dicomViewer.generalPreferences.onApply('layout');
                }
                break;
            case PREF_PAGE_COPY_ATTRIBUTES:
                dicomViewer.generalPreferences.onApply('copyattributes');
                break;
            case PREF_PAGE_LOG:
                dicomViewer.generalPreferences.onApply('log');
                break;
            default:
                return;
        }
    });

    $("#resetPref").click(function () {
        dicomViewer.generalPreferences.resetPreference(activePrefTab);
    });

    var handleSanity = true;
    $('#settingPreference').on('hide.bs.modal', function (e) {
        tempMeasurementStyleCol = {};
        tempCinePreference = {};
        tempEcgPreference = {};
        tempDisplayPreference = {};
        tempCopyAttribPreference = {};
        tempLogPreference = {};

        if (handleSanity) {
            handleSanity = false;
            e.preventDefault();
            sanityCheck(undefined, true);
        } else {
            handleSanity = true;
        }
    });

    dicomViewer.annotationPreferences.createAnnotationPrefTabs();
    dicomViewer.generalPreferences.updateGeneralPreference(undefined, true);
    dicomViewer.annotationPreferences.updateAnnotationPreference();

    //Horizontal Tab
    $('#lblTypeMenu').easyResponsiveTabs();
    //Vertical Tab
    $('#content_View').easyResponsiveTabs({
        activate: function (event) { // Callback function if tab is switched
            var $tab = $(this);
            var $info = $('.pageHeader');
            var $name = $('span', $info);
            var text = $tab.text();
            if (text == "Overlay" || text == "Orientation" || text == "Scout & Ruler") {
                text = "Annotation";
            }
            $name.text(text + " Preferences");
            $info.show();
            activePrefTab = $tab.text();
            $("#resetPref").show();

            var classList = new Array($(this)[0].classList);
            if ((classList.join(" ")).indexOf("Prefer") > -1) {
                $('#applyPref, #resetPref').prop('disabled', true);
            }

            switch (activePrefTab) {
                case "Annotation":
                case "Overlay":
                case "Orientation":
                case "Scout & Ruler":
                    activePrefTab = PREF_PAGE_ANNOTATION;
                    break;
                case "Layout":
                    $("#resetPref").hide();
                    break;
            }
            updateFooterControls(activePrefTab);
        }
    });
}

function showOrHidePrefTabs(type) {
    $.each(prefTabs.tabList, function (key, value) {
        var isShow = true;

        switch (value) {
            case 'annotationPreference':
                isShow = (type == "NON_DICOM") ? true : (validateInputType(type) ? false : true);
                break;
            case 'cinePreference':
                isShow = validateInputType(type) ? false : true;
                break;
            case 'ecgPreference':
                isShow = (type == "ECG") ? true : false;
                break;
            case 'copyAttributesPreference':
                isShow = validateInputType(type) ? false : true;
                break;
            case 'logPreference':
                isShow = true;
                break;
        }

        if (isShow) {
            $("li." + value).show();
            prefTabs.enabled[key] = true;
        } else {
            $("li." + value).hide();
            prefTabs.enabled[key] = false;
        }
    });
    hideAccordionTabs();
}

function validateInputType(type) {
    return (type !== "DICOM");
}

function hideAccordionTabs() {
    $.each(prefTabs.tabList, function (key, value) {
        var isListVisible = $("li." + value).is(":visible");
        var isListDisplay = ($("li." + value)[0].style.display == "block") ? true : false;
        var isListEnabled = prefTabs.enabled[key];
        var isShow = isListEnabled && (isListDisplay !== "none");
        if (isListVisible) {
            isShow = false;
        }

        if (isShow) {
            $("h2." + value).show();
        } else {
            $("h2." + value).hide();
        }
    });
}

/**
 * On preference dialog shown event
 * @param {Type}  
 */
function onPreferenceDialogShown() {
    tempMeasurementStyleCol = {};
    tempCinePreference = {};
    tempEcgPreference = {};
    tempDisplayPreference = {};
    tempCopyAttribPreference = {};
    preferenceLoadingStatus = [];
    tempLogPreference = {};

    dicomViewer.annotationPreferences.updateAnnotationPreference("SYSTEM", true);
    dicomViewer.generalPreferences.updateGeneralPreference("SYSTEM", true);
    var activesSeries = dicomViewer.getActiveSeriesLayout();

    if (activesSeries && activesSeries.studyUid && activesSeries.seriesIndex != undefined) {
        var series = dicomViewer.Series.getSeries(activesSeries.studyUid, activesSeries.seriesIndex);
        $.each(MT_TypeCol, function (key, value) {
            if (value == "MITRAL & AORTIC (US)" && series.modality != "US") {
                $("#mitralaorticuspref").hide();
                return true;
            }
            var id = value.toLowerCase().replace(/\s|\(|\)|\&/g, "") + "li";
            dicomViewer.annotationPreferences.appendSelPrefDiv($("#" + id)[0], false);
        });
    }

    setTimeout(function () {
        $("#LINEgaugeLen").spinner();
        $("#MSTROKESTYLEprecision").spinner();
        $("#LENGTHgaugeLen").spinner();
        $("#ANGLEarcRadius").spinner();
    }, 1000);

    if (isInternetExplorer()) {
        $("#prefMenu .resp-tabs-list li").css('width', '100%');
        $("#cinePreferenceTable input").css('width', '100%');
        $("#cinePreferenceTable input:checkbox").css('width', '130%');
    }

    selectDefaultTab();

    dicomViewer.logUtility.minimizePanel();
}

function selectDefaultTab() {
    try {
        if (!$(".preference-tabs")) {
            return;
        }

        if (!$(".preference-tabs")[0]) {
            return;
        }

        if (!$(".preference-tabs")[0].children) {
            return;
        }

        for (var index = 0; index < $(".preference-tabs")[0].children.length; index++) {
            if ($(".preference-tabs")[0].children[index].style.display !== "none") {
                var className = $(".preference-tabs")[0].children[index].className.split(/\s+/)[0];
                if (className) {
                    $(".preference-tabs")[0].children[index].click();
                    if (className.indexOf("ecg") != -1) {
                        loadEcgValues();
                    }
                    return;
                }
            }
        }
    } catch (e) {}
}

function loadEcgValues() {
    try {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (!seriesLayout) {
            return;
        }
        var layoutDivId = seriesLayout.getSeriesLayoutId();

        if (!leadTypeObject[layoutDivId]) {
            return;
        }

        for (var key in leadTypeObject[layoutDivId]) {
            if (key.indexOf("x") != 0) {
                var leadValue = (leadTypeObject[layoutDivId])[key];
                $("#" + key).val(leadValue);
                $("#" + key)[0].preLeadValue = leadValue;
            }
        }
    } catch (e) {}
}

/**
 * Check for change in preference values
 * @param {Type} callback 
 */
function sanityCheck(callback, isForceClose) {
    var isDirty = false;
    $("#PreferenceAlert").html("");
    $("#PreferenceAlert").hide();
    if (activePrefTab == PREF_PAGE_ANNOTATION) {
        isDirty = dicomViewer.annotationPreferences.sanityCheck();
    } else if (activePrefTab != null && activePrefTab != undefined) {
        isDirty = dicomViewer.generalPreferences.sanityCheck(activePrefTab);
    }

    if (isDirty) {
        showConfirmDialog(callback, isForceClose);
    } else {
        if (callback) {
            callback.call();
        }

        if (isForceClose) {
            $("#settingPreference").modal('hide');
        }
    }
}

/**
 * Show confirmation dialog to save/cancel the preference change
 * @param {Type} callback 
 */
function showConfirmDialog(callback, isForceClose) {
    var confirmApplyDialog = document.getElementById('confirmApplyDialog');
    if (confirmApplyDialog == undefined) {
        $('<div id="confirmApplyDialog" title="Preferences"> <p style="font-size:12px;margin-left:12px;margin-top:12px"><span class="ui-icon ui-icon-alert" style="float:right; margin:1px;"></span>Do you want to apply the settings?</p></div>').dialog({
            resizable: true,
            height: "auto",
            minHeight: '39',
            width: 300,
            modal: true,
            buttons: {
                "Apply": function () {
                    if (activePrefTab == PREF_PAGE_LAYOUT) {
                        dicomViewer.generalPreferences.onApply('layout');
                    } else {
                        if (activePrefTab == "Cine") {
                            if (!dicomViewer.generalPreferences.isValidCinePreference()) {
                                dicomViewer.generalPreferences.resetPreference("Cine");
                                $(this).dialog("close");
                                if (callback) {
                                    callback.call();
                                }
                                return;
                            }
                        } else if (activePrefTab == "Annotation") {
                            if (!dicomViewer.annotationPreferences.validatePreference()) {
                                dicomViewer.generalPreferences.resetPreference("Annotation");
                                $(this).dialog("close");
                                if (callback) {
                                    callback.call();
                                }
                                return;
                            }
                        }
                        $("#applyPref").trigger('click');
                    }
                    $(this).dialog("close");

                    if (callback) {
                        callback.call();
                    }

                    if ($("#confirmApplyDialog").data("ForceClose")) {
                        $("#confirmApplyDialog").data("ForceClose", false);
                        $("#settingPreference").modal('hide');
                    }
                },
                Cancel: function () {
                    if (activePrefTab == PREF_PAGE_ANNOTATION) {
                        dicomViewer.annotationPreferences.discardChanges();
                    } else if (activePrefTab != null && activePrefTab != undefined) {
                        dicomViewer.generalPreferences.discardChanges(activePrefTab);
                    }
                    $(this).dialog("close");

                    if (callback) {
                        callback.call();
                    }

                    if ($("#confirmApplyDialog").data("ForceClose")) {
                        $("#confirmApplyDialog").data("ForceClose", false);
                        $("#settingPreference").modal('hide');
                    }
                }
            },
            open: function () {
                var zIndex = $('#modelID').zIndex();
                var parent = $('#confirmApplyDialog').parent();
                parent.zIndex(zIndex + 1);
                $('.ui-widget-overlay').zIndex('1002');
            }
        });
        $("#confirmApplyDialog").data("ForceClose", (isForceClose ? true : false));
    } else {
        $("#confirmApplyDialog").data("ForceClose", (isForceClose ? true : false));
        $('#confirmApplyDialog').dialog('open');
    }
}

function updateFooterControls(activePrefTab) {
    //$("#resetPref").hide();
    showOrHideHPControls(false);
    switch (activePrefTab) {
        case PREF_PAGE_CINE:
            showOrHideFooterControls(true);
            break;
        case PREF_PAGE_ECG:
            showOrHideFooterControls(true);
            break;
        case PREF_PAGE_ANNOTATION:
            showOrHideFooterControls(true);
            break;
        case PREF_PAGE_LAYOUT:
            if ($('#addEditHPTable').is(":visible")) {
                showOrHideHPControls(false);
                showOrHideFooterControls(true);
            } else {
                showOrHideFooterControls(true);
                showOrHideHPControls(true);
            }
            break;
        case PREF_PAGE_COPY_ATTRIBUTES:
            showOrHideFooterControls(true);
            break;
        case PREF_PAGE_LOG:
            showOrHideFooterControls(true);
            break;
        default:
            return;
    }
}

function showOrHideHPControls(isShow) {
    if (isShow && !$("#displayUseDefault")[0].checked) {
        $("#addHPPref").show();
    } else {
        $("#addHPPref").hide();
    }
}

function showOrHideFooterControls(isShow) {

    if (isShow == undefined) {
        $("#applyPref").attr("style", "visibility: hidden");
        $("#cancelPref").attr("style", "visibility: hidden");
        return;
    } else {
        $("#applyPref").attr("style", "visibility: visible");
        $("#cancelPref").attr("style", "visibility: visible");
    }

    if (isShow) {
        $("#applyPref").show();
        $("#cancelPref").show();
    } else {
        $("#applyPref").hide();
        $("#cancelPref").hide();
    }
}

/**
 * Deep objects comparision
 */
Object.compare = function (obj1, obj2) {
    //Loop through properties in object 1
    for (var p in obj1) {
        //Check property exists on both objects
        if (obj1.hasOwnProperty(p) !== obj2.hasOwnProperty(p)) return false;

        switch (typeof (obj1[p])) {
            //Deep compare objects
            case 'object':
                if (!Object.compare(obj1[p], obj2[p])) return false;
                break;
            //Compare function code
            case 'function':
                if (typeof (obj2[p]) == 'undefined' || (p != 'compare' && obj1[p].toString() != obj2[p].toString())) return false;
                break;
            //Compare values
            default:
                if ((typeof obj1[p] == "string") && obj1[p].indexOf('#') > -1) {
                    obj1[p] = hexToRgb(obj1[p]);
                }
                if ((typeof obj2[p] == "string") && obj2[p].indexOf('#') > -1) {
                    obj2[p] = hexToRgb(obj2[p]);
                }
                if (obj1[p] != null && obj2[p] != null && obj1[p] != obj2[p]) return false;
        }
    }

    //Check object 2 for any extra properties
    for (var p in obj2) {
        if (typeof (obj1[p]) == 'undefined') return false;
    }
    return true;
};

/**
 * HEX to RGB conversion
 * @param {Type} hex 
 */
function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function (m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? "rgb(" + parseInt(result[1], 16) + ", " + parseInt(result[2], 16) + ", " + parseInt(result[3], 16) + ")" : null;
}

/**
 * Starts the signalr connection.
 * @param {Type}  
 */
function startSignalrConnection() {
    $.connection.sessionHub.client.QaMessage = function (data) {
        if (invokerIsQA()) {
            processQaRequest(data);
        }
    }
    $.connection.hub.Url = baseSignalrURL;
    $.connection.hub.start()
        .done(function () {
            $.connection.hub.disconnectTimeout = 120000;
        })
        .fail(function () {
            setTimeout(function () {
                $.connection.hub.start(); // try and restart
            }, 5000); // Restart connection after 5 seconds if we loose the connection
        });

    $.connection.sessionHub.connection.start()
        .done(function () {
            $.connection.hub.disconnectTimeout = 120000;
        })
        .fail(function () {
            setTimeout(function () {
                $.connection.sessionHub.start(); // try and restart
            }, 5000); // Restart connection after 5 seconds if we loose the connection
        });

 
    $.connection.PdfRequestHub.connection.start()
        .done(function () {
            SignalRStatus.SetSignalrStarted(true);
            $.connection.hub.disconnectTimeout = 120000;
        })
        .fail(function () {
            setTimeout(function () {
                $.connection.PdfRequestHub.start(); // try and restart
            }, 5000); // Restart connection after 5 seconds if we lose the connection
        });

    $.connection.hub.disconnected(function () {
        setTimeout(function () { $.connection.hub.start() }, 5000); // Restart connection after 5 seconds if we loose the connection
    });

}

function cacheAllImagesFunction(studyRow, studyColumn, url, viewportElement, isStudyLayoutAvailable) {
    var d = new Date();
    var n = d.getMilliseconds();
    var cachedUrl = url + "&_cacheBust=" + n;

    var xhttp;
    if (window.XMLHttpRequest) {
        xhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            var data = JSON.parse(xhttp.responseText);

            // Get the default study layout
            if (isStudyLayoutAvailable === false) {
                var layout = getDefaultStudyLayout(data, studyRow, studyColumn);
                studyRow = layout.Rows;
                studyColumn = layout.Columns;
            }

            if (data.status !== undefined) {
                var totalImagesCount = data.status.totalImageCount;
                var imagesProcessed = data.status.imagesProcessed;
                var failedObject = data.status.imagesFailed;
                var imagesUploaded = data.status.imagesUploaded;
                var imagesUploadFailed = data.status.imagesUploadFailed;
                var statusCode = data.status.statusCode;

                var innerText = "Total Images: " + totalImagesCount + "\n" +
                    "Images Uploaded: " + imagesProcessed + "\n" +
                    "Images Failed: " + (failedObject + imagesUploadFailed) + "\n" +
                    "Images Processed: " + imagesUploaded;

                var spinner0 = dicomViewer.progress.getSpinner('viewer');
                if (spinner0 !== undefined) {
                    spinner0.stop();
                    spinner0 = undefined;
                }

                var spinner = dicomViewer.progress.updateSpinnerInnerText('viewer', innerText);
                dicomViewer.progress.putSpinner('viewer', spinner);

                if ((statusCode == 1) || (statusCode == 2)) {
                    isStudyCacheInProgress = true;
                    setTimeout(function () {
                        cacheAllImagesFunction(studyRow, studyColumn, url, viewportElement, true)
                    }, 2000);
                    return;
                }
                spinner.stop();
                spinner = undefined;
                isStudyCacheInProgress = false;
                loadStudy();
            } else {
                loadStudy();
            }
        } else {
            if (numberOfCacheRetryAttempts < 3) {
                isStudyCacheInProgress = true;
                numberOfCacheRetryAttempts++;
            } else {
                isStudyCacheInProgress = false;
            }

            if (xhttp.status == 500) {
                var description = xhttp.statusText + "\nFailed to cache all the images and the context id is: " + BasicUtil.getUrlParameter("ContextId");
                sendViewerStatusMessage(xhttp.status.toString(), description);
                dumpConsoleLogs(LL_ERROR, undefined, "cacheAllImagesFunction", description);
            }
        }
    };
    xhttp.open("GET", cachedUrl, true);
    xhttp.send();
}

/**
 * Cache the images for the session
 * @param {Type} session - Specifies the session information
 */
function cacheAllImagesOfStudyForSession(session) {
    try {
        var d = new Date();
        var n = d.getMilliseconds();
        var url = session.Url + "&_cacheBust=" + n;
        var xhttp;
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xhttp.onreadystatechange = function () {
            if (xhttp.readyState == 4 && xhttp.status == 200) {
                var data = JSON.parse(xhttp.responseText);
                if (data.status !== undefined) {
                    dumpConsoleLogs(LL_INFO, undefined, "cacheAllImagesOfStudyForSession", "Cached successfully" + Date());
                    totalImagesCount = data.status.totalImageCount;
                    imagesProcessed = data.status.imagesProcessed;
                    failedObject = data.status.imagesFailed;
                    imagesUploaded = data.status.imagesUploaded;
                    imagesUploadFailed = data.status.imagesUploadFailed;

                    innerText = "Total Images: " + totalImagesCount + "\n" +
                        "Images Uploaded: " + imagesProcessed + "\n" +
                        "Images Failed: " + (failedObject + imagesUploadFailed) + "\n" +
                        "Images Processed: " + imagesUploaded;

                    // Check whether all the viewports are occupied to run the spinner
                    var spinner = getAndUpdateSpinner(session, innerText);
                    if ((data.status.statusCode == 1) || (data.status.statusCode == 2)) {
                        setTimeout(function () { cacheAllImagesOfStudyForSession(session); }, 2000);
                        return;
                    }

                    // Load the cached session
                    loadStudyWithSession(session);

                    // Stop the spinner
                    if (spinner !== undefined) {
                        spinner.stop();
                        spinner = undefined;
                    }
                }
            } else {
                if (xhttp.status == 500) {
                    var description = xhttp.statusText + "\nFailed to load the context id: " + decodeURIComponent(session.ContextId);
                    sendViewerStatusMessage(xhttp.status.toString(), description);
                }
            }
        };
        xhttp.open("GET", url, true);
        xhttp.send();
    } catch (e) {}
}

/**
 * load study with session
 * @param {Type} session - Specifies the session information
 */
function loadStudyWithSession(session) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "loadStudyWithSession", "Start");

        var d = new Date();
        var n = d.getMilliseconds();
        var url = session.Url + "&_cacheBust=" + n;
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            async: false,
            success: function (data) {
                // Preprocess study
                var totalStudiesMap = preprocessStudy(data, session.ContextId);
                var hasMultipleStudyInContext = false;

                // Process studies
                if (totalStudiesMap.size > 0) {
                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        hasMultipleStudyInContext = true;
                        dicomStudy.forEach(function (study) {
                            createOrAppendStudy(study, session);
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined) {
                        if (totalStudiesMap.size > 1 && hasMultipleStudyInContext) {
                            session.hasMultipleStudyInContext = true;
                            updateLayoutWithSession(session);
                        }

                        createOrAppendStudy(nonDicomStudy, session);
                    }
                }

                // Send the viewer messgae to server
                var description = "Successfully loaded the context id: " + decodeURIComponent(session.ContextId);
                sendViewerStatusMessage("200", description);

                if (isSessionCleared) {
                    isSessionCleared = false;
                    var progressHeight = document.getElementById("imageviewer_studyViewer1x1_1x1_progress").style.top;
                    progressHeight = progressHeight.replace('px', '');
                    document.getElementById("imageviewer_studyViewer1x1_1x1_progress").style.top = (parseInt(progressHeight) - 15) + "px";
                }
            },
            error: function (xhr, status) {
                var description = xhr.statusText + " : Failed to load the study with this session for context id :" + decodeURIComponent(session.ContextId);
                sendViewerStatusMessage(xhr.status.toString(), description);
                dumpConsoleLogs(LL_ERROR, undefined, undefined, description);
            }
        });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
}

/**
 * Create or append the study
 * @param {Type} study - Specifies the Study
 * @param {Type} session - Specifies the study session
 */
function createOrAppendStudy(study, session) {
    try {
        if (study === undefined) {
            return;
        }

        // Get the existing study uid
        var existingStudy = undefined;
        var studyUids = dicomViewer.getListOfStudyUid();
        if (studyUids !== undefined) {
            studyUids.forEach(function (studyUid) {
                var studyDetails = dicomViewer.getStudyDetails(studyUid);
                if (studyDetails !== undefined) {
                    if (study.studyId === studyDetails.studyId && study.studyUid === studyDetails.studyUid) {
                        existingStudy = studyDetails;
                        return false;
                    }
                }
            });
        }

        // process studies
        if (existingStudy === undefined) {
            dicomViewer.setStudyDetails(study);
            dicomViewer.thumbnail.createThumbnail(study.studyUid);
            if (session.IsStudyCacheRequired) {
                dicomViewer.cacheImages(study.studyUid);
            } else {
                var logMessage = ("createOrAppendStudy => Failed to cache the study: " + study.studyUid + " because of low cache memory");
                dumpConsoleLogs(LL_WARN, undefined, "createOrAppendStudy", logMessage);
            }

            // process the overlay for dicom study
            if (study.isDicom === true) {
                // Initialize the overlay config
                if (dicomViewer.overlay.getOverlayConfig() === null) {
                    dicomViewer.overlay.initOverlayConfig();
                }

                // Initialize the overlay config
                if (dicomViewer.overlay.getMeasurementsConfig() === null) {
                    dicomViewer.overlay.initMeasurementsConfig();
                }

                dicomViewer.xRefLine.renderXRefLines(study);
            }
            dicomViewer.measurement.loadPState(study.studyUid);

            // display study
            if (session !== undefined) {
                if (session.IsNewSession) {
                    dispalyDemographics(study);
                }
                var toolName = dicomViewer.mouseTools.getToolName();
                if (toolName != undefined) {
                    dicomViewer.mouseTools.setToolName(undefined);
                }
                displayStudy(session, study);
            }

            // Update the image status
            if (invokerIsQA()) {
                processQaRequest({
                    target: "Viewer",
                    type: QAType.imageStatus
                });
            }
        } else {
            // Append the thumbnail with the existing thumbnail panel
            var exisingSeriesCount = existingStudy.seriesCount;
            if (existingStudy.isDicom === true && study.isDicom === false) {
                study.forEach(function (series) {
                    existingStudy.series.push(series);
                    existingStudy.seriesCount += 1;
                });
            } else if (existingStudy.isDicom === true && study.isDicom === true) {
                study.series.forEach(function (series) {
                    existingStudy.series.push(series);
                    existingStudy.seriesCount += 1;
                });
            } else if (existingStudy.isDicom === false && study.isDicom === false) {
                study.forEach(function (series) {
                    existingStudy.push(series);
                    existingStudy.seriesCount += 1;
                });
            } else if (existingStudy.isDicom === false && study.isDicom === true) {
                existingStudy.isDicom = true;
                if (existingStudy.series === undefined) {
                    existingStudy.series = new Array();
                    existingStudy.forEach(function (series) {
                        var studyUid = dicomViewer.replaceDotValue(existingStudy.studyUid);
                        var nonDicomStudy = createAndGetNonDicomStudy(studyUid, series, studyUid, existingStudy.displaySettings);
                        nonDicomStudy.images = new Array();
                        nonDicomStudy.images.push(series);
                        existingStudy.series.push(nonDicomStudy);
                    });
                }

                study.series.forEach(function (series) {
                    existingStudy.series.push(series);
                    existingStudy.seriesCount += 1;
                });

                // process the overlay for dicom study
                if (existingStudy.isDicom === true) {
                    // Initialize the overlay config
                    if (dicomViewer.overlay.getOverlayConfig() === null) {
                        dicomViewer.overlay.initOverlayConfig();
                    }

                    // Initialize the overlay config
                    if (dicomViewer.overlay.getMeasurementsConfig() === null) {
                        dicomViewer.overlay.initMeasurementsConfig();
                    }

                    dicomViewer.xRefLine.renderXRefLines(existingStudy);
                }
                dicomViewer.measurement.loadPState(existingStudy.studyUid);

            }

            // Append the series to the exising panel.
            dicomViewer.thumbnail.createOrAppendThumbnail(existingStudy.studyUid, exisingSeriesCount, false);
            $("#" + "imageviewer_" + existingStudy.studyUid + "_" + exisingSeriesCount + "_thumb")[0].click();
            var toolName = dicomViewer.mouseTools.getToolName();
            if (toolName != undefined) {
                dicomViewer.mouseTools.setToolName(undefined);
            }
        }
    } catch (e) {}
}

/**
 * Append the study with an existing session
 * @param {Type} contextIds - Specifies the context id list
 */
function AppendStudy(contextIds) {
    isCineEnabled(true);
    for (var index = 0; index < contextIds.length; index++) {
        var session = getSession(contextIds[index], contextIds.length, index);

        // update layout with session
        updateLayoutWithSession(session);

        // Prepare the study to load
        prepareStudy(session.ContextId);

        // Display spinner
        getAndUpdateSpinner(session, "Processing study...");

        // Cache the session
        cacheAllImagesOfStudyForSession(session);

        if (isSessionCleared) {
            showOrClearSession(true);
        }
    }
}

/**
 * Update the layout with session
 * @param {Type} session - Specifies the session
 */
function updateLayoutWithSession(session) {
    try {
        // Reset the flags if the study cache is not required 
        if (!session.IsStudyCacheRequired) {
            session.IsLayoutChangeRequired = false;
            session.IsAllViewportsOccupied = true;
        }

        // Change the study layout based on the unoccupied view port
        if (session.IsLayoutChangeRequired) {
            if (session.hasMultipleStudyInContext) {
                if (session.SeriesLayoutIds.length == 1) {
                    return;
                }

                var nextSeriesLayoutId = session.SeriesLayoutIds[1];
                var layout = nextSeriesLayoutId.split("_")[1].replace("studyViewer", "").split("x");
                session.SeriesLayoutId = session.SeriesLayoutIds[1];
                session.Rows = layout[0];
                session.Columns = layout[1];
                session.IsStudyLayoutUpdationRequired = true;
            }

            studyLayoutValue = session.Rows + "x" + session.Columns;
            dicomViewer.tools.setSelectedStudyLayout(session.Rows, session.Columns);
            if (session.IsStudyLayoutUpdationRequired) {
                session.IsStudyLayoutUpdationRequired = false;
                dicomViewer.setStudyLayout(session.Rows, session.Columns);
            }
        }

        // Change the view port selection based on the occupied view port.
        if (session.IsAllViewportsOccupied == false) {
            dicomViewer.changeSelection(session.SeriesLayoutId);
        }
    } catch (e) {}
}

function removeStudyByContextID(contextID) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "removeStudyByContextID ", "Start");

        var url = dicomViewer.getNewSubpageUrlForContext("context", contextID); //VAI-915
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            async: false,
            success: function (data) {
                // Preprocess study
                var totalStudiesMap = preprocessStudy(data, contextID);
                var isContextRemoved = false;

                // Process studies
                if (totalStudiesMap.size > 0) {
                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        dicomStudy.forEach(function (study) {
                            if (study.modality == "ECG") {
                                study.series.forEach(function (series) {
                                    series.images.forEach(function (image) {
                                        if (image.imageUid !== undefined) {
                                            dicomViewer.ClearECGCacheDetails(image.imageUid);
                                        }
                                    });
                                });
                            } else if (study.modality == IMAGETYPE_RADSR || study.modality == IMAGETYPE_CDA) {
                                study.series.forEach(function (series) {
                                    series.images.forEach(function (image) {
                                        if (image.imageUid !== undefined) {
                                            dicomViewer.ClearSRCacheDetails(image.imageUid);
                                        }
                                    });
                                });
                            }

                            //Remove the study level layout for removed context
                            dicomViewer.RemoveStudyLevelLayout(study.studyUid);
                            var repacedStudyUid = dicomViewer.replaceDotValue(study.studyUid);
                            $("#study_thumb_" + repacedStudyUid).remove();
                            $("#break_" + repacedStudyUid).remove();
                            dicomViewer.viewports.deleteViewportsByThumbnail(repacedStudyUid);
                            dicomViewer.removeStudyDetails(study.studyUid);
                            isContextRemoved = true;
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined) {

                        // Get the non dicom study details
                        var nonDicomStudyDetails = dicomViewer.getStudyDetails(nonDicomStudy.studyUid);
                        if (nonDicomStudyDetails !== undefined && nonDicomStudyDetails !== null) {

                            // Process thumbnail renders
                            var thumbnails = dicomViewer.thumbnail.getAllThumbnails();
                            if (thumbnails !== undefined && thumbnails !== null) {

                                // Remove the thumbnails
                                var removedThumbnails = [];
                                nonDicomStudy.forEach(function (nonDicom) {
                                    // Check the thumbnail render objects 
                                    $.each(thumbnails, function (key, value) {
                                        if (value.imageUid === nonDicom.imageUid) {
                                            $("#" + key).remove();
                                            removedThumbnails.push(key);
                                            isContextRemoved = true;
                                        }
                                    });

                                    // Check the non dicom study
                                    var seriesIndex = -1;
                                    nonDicomStudyDetails.forEach(function (series) {
                                        if (series.imageUid === nonDicom.imageUid) {
                                            seriesIndex = nonDicomStudyDetails.indexOf(series);
                                        }
                                    });

                                    // Remove the series
                                    if (seriesIndex > -1) {
                                        nonDicomStudyDetails.splice(seriesIndex, 1);
                                        if (nonDicomStudyDetails.seriesCount > 0) {
                                            nonDicomStudyDetails.seriesCount -= 1;
                                        }
                                    }
                                });

                                //Remove the study level layout for removed context
                                dicomViewer.RemoveStudyLevelLayout(nonDicomStudy.studyUid);

                                // Remove the thumbnail render objects
                                if (removedThumbnails !== undefined && removedThumbnails !== null) {
                                    removedThumbnails.forEach(function (thumbnail) {
                                        delete thumbnails[thumbnail];
                                    });
                                }

                                // Reorder the thubnail div id based on the removed thumbnails
                                if (removedThumbnails !== undefined && removedThumbnails !== null && nonDicomStudyDetails.length > 0) {
                                    var presentThumbnails = {};
                                    $.each(thumbnails, function (key, value) {
                                        if (value.studyUid === nonDicomStudy.studyUid) {
                                            presentThumbnails[key] = value;
                                        }
                                    });

                                    // Remove the present thumbnail object from the thumbnail array
                                    if (presentThumbnails !== undefined && presentThumbnails !== null) {
                                        $.each(presentThumbnails, function (key, value) {
                                            delete thumbnails[key];
                                        });
                                    }

                                    // Create the new thumbnail id for the present rendered thumbnails.
                                    var thumbnailIndex = 0;
                                    $.each(presentThumbnails, function (key, value) {
                                        // Set the new thumbnail id
                                        var thumbnailId = "imageviewer_" + nonDicomStudy.studyUid + "_" + thumbnailIndex + "_thumb";
                                        var existingThumbnailId = document.getElementById(key);
                                        existingThumbnailId.setAttribute("id", thumbnailId);

                                        // Update the series id based on the thumbnail id.
                                        value.seriesIndex = thumbnailIndex;
                                        thumbnails[thumbnailId] = value;
                                        thumbnailIndex++;
                                    });
                                }

                                // Remove the general thumbnail panel
                                if (nonDicomStudyDetails.length == 0) {
                                    var studyUid = nonDicomStudy.studyUid;
                                    $("#study_thumb_" + studyUid).remove();
                                    $("#break_" + studyUid).remove();
                                    dicomViewer.viewports.deleteViewportsByThumbnail(studyUid);
                                    dicomViewer.removeStudyDetails(studyUid);
                                    ClearNonDICOMCacheDetails(studyUid);
                                } else if (isContextRemoved) {
                                    // Show the first series
                                    $("#" + "imageviewer_" + nonDicomStudy.studyUid + "_0_thumb")[0].click();
                                }
                            }
                        }
                    }
                }

                // Send the viewer message to server
                var decodedContextID = decodeURIComponent(contextID);
                var description = "Successfully removed the context id: " + decodedContextID + " from the session: " + getSessionId();
                if (!isContextRemoved) {
                    description = "The context id: " + decodedContextID + " is not in the viewer session: " + getSessionId();
                }
                adjustLayout();
                sendViewerStatusMessage("200", description);
            },
            error: function (xhr, status) {
                var description = xhr.statusText + "\nFailed to remove the context id: " + decodeURIComponent(contextID) + "\nThe context id is not in the current session.";
                sendViewerStatusMessage(xhr.status.toString(), description);
            }
        });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
}

function loadStudy() {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "loadStudy ", "Start", undefined, true);

        var tablestudyViewer = $("#tablestudyViewer1x1").height();
        var viewerHeight = $("#viewer").height();
        var viewportElement = $("#viewport_View");
        var studyRow = 1
        var studyColumn = 1;
        var isStudyLayoutAvailable = false;

        viewportElement.height(viewerHeight - tablestudyViewer);
        viewportElement.width("100%");
        $("#studyListDropdown").hide();
        //addStudyUidsFromURL();
        var studyLayout = BasicUtil.getUrlParameter('studyLayout');
        if (studyLayout != undefined) {
            var studyRowColumArray = studyLayout.split("x");
            studyRow = studyRowColumArray[0];
            studyColumn = studyRowColumArray[1];
            isStudyLayoutAvailable = true;
        }
        //VAI-1316
        if (studyColumn) {
            var studyRowElement = studyRow + "x" + studyColumn;
            document.getElementById(studyRowElement).style.background = "#868696";
        }

        dicomViewer.security.setSecurityToken(BasicUtil.getUrlParameter("securityToken", "", true)); //VAI-915

        var patientURL = dicomViewer.getDisplayContextUrl();
        var url = patientURL;

        requestStudyMetaData(studyRow, studyColumn, patientURL, viewportElement, isStudyLayoutAvailable);

        var parentElement = $("#playForward").parent().css("background", "#868696");
        displayHydraVersion();

        dumpConsoleLogs(LL_INFO, undefined, "loadStudy ", "End", (Date.now() - t0), true);
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, "loadStudy", e.message, undefined, true);
    } finally {}
}

function requestStudyMetaData(studyRow, studyColumn, url, viewportElement, isStudyLayoutAvailable) {
    try {
        var d = new Date();
        var n = d.getMilliseconds();
        var lp = "&lp=1";
        if (BasicUtil.getUrlParameter("lp") === "")
            lp = "";
        var cachedUrl = url + lp + "&_cacheBust=" + n;
        var xhttp;
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xhttp.onreadystatechange = function () {
            var t0 = Date.now();
            dumpConsoleLogs(LL_INFO, undefined, "requestStudyMetaData ", "Start", undefined, true);

            if (xhttp.readyState == 4 && xhttp.status == 200) {
                var data = JSON.parse(xhttp.responseText);

                // Get the default study layout
                var layout;
                if (isStudyLayoutAvailable === false) {
                    layout = getDefaultStudyLayout(data, studyRow, studyColumn);
                    studyRow = layout.Rows;
                    studyColumn = layout.Columns;
                }

                //if(data.status !== undefined && data.studies !== null)
                if (data.status !== undefined) //Paul: to present infinite study loop
                {
                    var innerText = "Total Images: " + data.status.totalImageCount + "\n" +
                        "Images Uploaded: " + data.status.imagesUploaded + "\n" +
                        "Images Failed:" + (data.status.imagesFailed + data.status.imagesUploadFailed) + "\n" +
                        "Images Processed: " + data.status.imagesProcessed;

                    var spinner0 = dicomViewer.progress.getSpinner('viewer');
                    if (spinner0 !== undefined) {
                        spinner0.stop();
                        spinner0 = undefined;
                    }

                    var spinner = dicomViewer.progress.updateSpinnerInnerText('viewer', innerText);
                    dicomViewer.progress.putSpinner('viewer', spinner);

                    if ((data.status.statusCode == 1) || (data.status.statusCode == 2)) {
                        isStudyRequested = true;
                        setTimeout(function () {
                            requestStudyMetaData(studyRow, studyColumn, url, viewportElement, true);
                        }, 3000);
                        return;
                    }
                    isStudyRequested = false;
                }

                // Send the viewer message to server
                var contextId = BasicUtil.getUrlParameter("ContextId");
                var description = "Successfully loaded the context id: " + BasicUtil.getUrlParameter("ContextId", "", true);
                sendViewerStatusMessage(xhttp.status.toString(), description);

                // Preprocess Study
                var totalStudiesMap = preprocessStudy(data, contextId);

                // Process studies
                if (totalStudiesMap.size > 0) {

                    // Set the viewer cache size 
                    setCacheSize();

                    var occupiedViewports = (layout === undefined ? 1 : layout.OccupiedViewports);
                    var occupiedViewportsIncrementer = 0;
                    var selectedImageUid = data.selectedUid;
                    var firstStudy;
                    var selectedImage = undefined;
                    var selectedImageSeries = undefined;
                    var displaySettings = [];

                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        // cache first image at applied series layout level
                        dicomStudy.forEach(function (study) {
                            var appliedSeriesLayout = (study.displaySettings.Rows * study.displaySettings.Columns);
                            dicomViewer.setStudyDetails(study);
                        });

                        // cache remaining images.
                        dicomStudy.forEach(function (study) {
                            displaySettings.push(study.displaySettings);
                            dicomViewer.thumbnail.createThumbnail(study.studyUid);
                            dicomViewer.overlay.initOverlayConfig();
                            dicomViewer.overlay.initMeasurementsConfig();
                            dicomViewer.xRefLine.renderXRefLines(study);
                            dicomViewer.measurement.loadPState(study.studyUid, undefined, undefined, undefined, true);

                            // Stop the spinner
                            dicomViewer.progress.getSpinner('viewer').stop();
                            cacheFlag = false;

                            if (selectedImageUid && !selectedImageSeries) {
                                selectedImageSeries = getSelectedImageSeries(study, selectedImageUid);
                                if (selectedImageSeries) {
                                    selectedImage = {
                                        study: study,
                                        imageUid: selectedImageUid,
                                        seriesIndex: selectedImageSeries.SeriesIndex,
                                        imageIndex: selectedImageSeries.ImageIndex
                                    };
                                    study.selectedImage = selectedImage;
                                }
                            }

                            // Cache the study
                            if (occupiedViewportsIncrementer < occupiedViewports) {
                                dicomViewer.cacheImages(study.studyUid);
                                if (occupiedViewportsIncrementer == 0) {
                                    firstStudy = study;
                                }
                                occupiedViewportsIncrementer++;
                            }

                            var serieLayout = dicomViewer.getActiveSeriesLayout();
                            if (serieLayout !== null) {
                                if (serieLayout.imageType === IMAGETYPE_RAD) {
                                    viewportElement.css('cursor', 'url(images/brightness.cur), auto');
                                } else if (serieLayout.imageType === IMAGETYPE_RADECHO) {
                                    dicomViewer.tools.doPan();
                                }
                            }

                            // Enable the overlay true at the time of study loading
                            dicomViewer.tools.setOverlay(true);
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined) {
                        displaySettings.push(nonDicomStudy.displaySettings);

                        // Stop the spinner
                        dicomViewer.progress.getSpinner('viewer').stop();

                        dicomViewer.setStudyDetails(nonDicomStudy);
                        dicomViewer.thumbnail.createThumbnail(nonDicomStudy.studyUid);
                        dicomViewer.measurement.loadPState(nonDicomStudy.studyUid);

                        // Cache the study
                        if (occupiedViewportsIncrementer < occupiedViewports) {
                            dicomViewer.cacheImages(nonDicomStudy.studyUid);
                        }
                    }

                    // Display the images
                    if (!imageDisplayed) {
                        if (selectedImage) {
                            firstStudy = selectedImage.study;
                        } else if (firstStudy === undefined && nonDicomStudy !== undefined) {
                            firstStudy = nonDicomStudy;
                        }

                        dispalyDemographics(firstStudy);
                        studyLayoutValue = studyRow + "x" + studyColumn;
                        dicomViewer.setStudyLayout(studyRow, studyColumn, firstStudy.studyUid, selectedImage ? selectedImage.seriesIndex : 0, undefined, undefined, displaySettings);
                        dicomViewer.changeSelection("imageviewer_studyViewer1x1_1x1");
                        imageDisplayed = true;

                        displaySettings.forEach(function (value, index) {
                            UpdateStudyLayoutMap(value, "studyViewer1x" + (index + 1));
                        });

                        // Update the image status
                        if (invokerIsQA()) {
                            processQaRequest({
                                target: "Viewer",
                                type: QAType.imageStatus
                            });
                        }
                    }
                }

                // Enable the overlay true at the time of study loading
                dicomViewer.tools.setOverlay(true);
                addContextId(contextId);
            } else {
                if (numberOfRetryAttempts < 3) {
                    isStudyRequested = true;
                    numberOfRetryAttempts++;
                } else {
                    isStudyRequested = false;
                }

                if (xhttp.status == 500) {
                    var description = xhttp.statusText + "\nFailed to load the context id: " + BasicUtil.getUrlParameter("ContextId", "", true);
                    sendViewerStatusMessage(xhttp.status.toString(), description);
                }
            }

            dumpConsoleLogs(LL_INFO, undefined, "requestStudyMetaData ", "End", (Date.now() - t0), true);

        };
        xhttp.open("GET", cachedUrl, true);
        xhttp.send();
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, "requestStudyMetaData", e.message, undefined, true);
    } finally {

    }
}

//Display the hydra version in the browser
function displayHydraVersion() {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "displayHydraVersion ", "Start");

        var url = dicomViewer.url.getViewerVersionURL();
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            async: false,
            success: function (data) {
                $("#hydraVersionLink").text(data.version);
            },
            error: function (xhr, status) {
                var description = xhr.statusText + "\nFailed to obtain the hydra version.";
                $("#hydraVersionLink").text("Version?");
                sendViewerStatusMessage(xhr.status.toString(), description);
            }
        });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }

}

function dispalyDemographics(data) {
    if (data !== undefined && data.patient != null) {
        var patientAge = data.patient.age;
        var patientName = dicomViewer.changeNullToEmpty(data.patient.fullName.replace("^", ","));
        var patientSex = dicomViewer.changeNullToEmpty(data.patient.sex);
        var patientICN = dicomViewer.changeNullToEmpty(data.patient.iCN);
        var patientDispalyString = "";
        if (patientICN !== "" || patientSex !== "" || patientAge !== "") {
            patientDispalyString = patientICN + ", " + patientSex + " " + patientAge;
        }
        $("#pName").html("&nbsp<font color='#E8E8E8' size='2'>" + patientName + "</font>");
        document.getElementById("dob").style.fontSize = "11px"; //VAI-1316
        document.getElementById("dob").style.color = "#E8E8E8"; //VAI-1316
        document.getElementById("dob").textContent = patientDispalyString; //VAI-1316

        $("#pName").attr("title", patientName + " " + patientDispalyString);
        $("#dob").attr("title", patientName + " " + patientDispalyString);
        var helpFileUrl = baseViewerURL + "/VIX_Viewer_User_Guide"; //VAI-461
        $("#externalLinks").html("&nbsp<a class='pull-right' id='helpLinkDiv' onClick='gotoUrl( \"" + helpFileUrl + "\", 'New' )' ><img src='images/help.png' title='Help' style='width: 22px;height: 22px;margin-top: -23px;margin-right: 16px'></img></a>&nbsp<a class='pull-right' style='display: none;' id='externalLinksDiv'><img src='images/external-link.png' id='externalLinksImage' title='ExternalLinks' style='width: 22px;height: 22px;margin-top: -23px;margin-right: 7px' onClick='showExternalLinks()'></img><ul id='contextExternalLinkPanel' style='background: #363636;'></ul></a>");
        showExternalLinks(true);

        $("#contextExternalLinkPanel").kendoContextMenu({
            target: "#externalLinksImage",
            showOn: "click",
            open: function (e) {
                if ($(e.target).hasClass('k-state-disabled')) {
                    e.preventDefault();
                }
                $("#contextMenuThumbnailPanel").width(130);
            },
            close: function () {
                hideAnimationContainer();
            }
        });
    }
}

/**
 * Load the url with sepecified tab option
 * @param {Type} url 
 * @param {Type} isNewTab 
 */
function gotoUrl(url, display) {
    var contextMenu = $("#contextExternalLinkPanel").data("kendoContextMenu");
    contextMenu.close();
    if (display.toLowerCase() == "self") {
        var w = window.open(url, '_self');
        w.focus();
    } else if (display.toLowerCase() == "popup") {
        $('#aModelWinWithURL').modal('show');
        $("#aModelWinBody").html('');

        setTimeout(function () {
            $("#aModelWinBody").html('<iframe width="100%" height="900" frameborder="0" scrolling="no" allowtransparency="true" src="' + url + '"></iframe>');
        }, 3000);
    } else {
        var w = window.open(url, '_blank');
        w.focus();
    }
}

function closeModalWin() {
    $('#aModelWinWithURL').modal('hide');
}

function playCineImage(e, playState) {
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    if (seriesLayout === undefined) {
        // Avoid cine play on empty viewports
        return;
    }

    if (e.target && e.target[0]) {
        var target = e.target[0];
        if ($("#" + target.id).hasClass("k-state-disabled")) {
            return;
        }
    }

    if (e.id != "playButton") {
        changePlayDirection(e)
    } else {
        var direction = getPlayerDirection(e);
        var playerButtomImage = $("#playButton_wrapper img")[0].src;
        if (playState !== undefined) {
            if (playState) {
                dicomViewer.tools.runCineImage(direction);
                updatePlayIcon("play.png", "stop.png");
            } else {
                dicomViewer.tools.stopCineImage();
                updatePlayIcon("stop.png", "play.png");
                UpdateImageType();
            }
        } else {
            if (playerButtomImage.indexOf("play.png") > -1) {
                dicomViewer.tools.runCineImage(direction);
                if (e.target !== undefined) {
                    updatePlayIcon("play.png", "stop.png", true, e.target[0].id);
                } else {
                    updatePlayIcon("play.png", "stop.png");
                }
            } else if (playerButtomImage.indexOf("stop.png") > -1) {
                dicomViewer.tools.stopCineImage();
                UpdateImageType();

                if (e.target !== undefined) {
                    updatePlayIcon("stop.png", "play.png", true, e.target[0].id);
                } else {
                    updatePlayIcon("stop.png", "play.png");
                }
            }
            EnableDisableNextSeriesImage(seriesLayout);
        }
    }
}

/**
 * Enable disable the Next/Previous series ,and Next/Previous image and repeat series
 */
function EnableDisableNextSeriesImage(seriesLayout) {
    try {
        //check the multiframe or not
        var studyuid = seriesLayout.getStudyUid();
        var studyDetials = dicomViewer.getStudyDetails(studyuid);
        if ((studyDetials) && ((studyDetials.isDicom && studyDetials.modality != "CDA") ||
            (studyDetials.modality == "General" && seriesLayout.imageType == IMAGETYPE_JPEG))) {

            //Enable/Disable the 6000OverLay menu
            showAndHide6000OverlayMenu(seriesLayout);

            var repeatButtonImage;
            var imageSrc;
            var seriesCount = 0;
            var series = undefined;
            var activeSeriesIndex = 0;
            var activeImageIndex = 0;
            var totalImageorFrames = 0;
            var imageLayoutDimension = 1;
            var dimension = 0;

            var totalPages;
            var nextSeries;
            var previousSeries;
            var nextImage;
            var previousImage;
            var playButton;
            var isCineRun;

            if (seriesLayout.imageType !== IMAGETYPE_JPEG) {
                repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
                imageSrc = repeatButtonImage.src;
                isCineRun = dicomViewer.scroll.isCineRunning(seriesLayout.seriesLayoutId);
                seriesCount = studyDetials.series.seriesCount;
                imageLayoutDimension = seriesLayout.imageLayoutDimension;
                dimension = imageLayoutDimension.split("x");
                imageLayoutDimension = dimension[0] * dimension[1];

                nextSeries = "#nextSeries";
                previousSeries = "#previousSeries";
                nextImage = "#nextImage";
                previousImage = "#previousImage";

            } else {
                nextSeries = "#tNextSeries";
                previousSeries = "#tPreviousSeries";
                nextImage = "#tNextImage";
                previousImage = "#tPreviousImage";
                seriesCount = studyDetials.seriesCount;
            }
            var imagevalue = dicomViewer.Series.Image.getImage(studyuid, seriesLayout.seriesIndex, seriesLayout.getImageIndex());

            var previousSeriesModality;
            var nextSeriesModality;
            var currentSeriesModality;

            var previousIndex = seriesLayout.seriesIndex ? seriesLayout.seriesIndex - 1 : seriesLayout.seriesIndex;
            var series = !studyDetials.series ? (studyDetials[seriesLayout.seriesIndex] ? studyDetials : undefined) : studyDetials.series;

            if (series[previousIndex]) {
                previousSeriesModality = currentSeriesModality = series[previousIndex].modality;
            }
            if (series[seriesLayout.seriesIndex]) {
                currentSeriesModality = nextSeriesModality = series[seriesLayout.seriesIndex].modality;
            }
            if (series[previousIndex + 2]) {
                nextSeriesModality = series[previousIndex + 2].modality;
            }

            var isMultiframe = (studyDetials.modality == "ECG" && seriesLayout.imageType !== IMAGETYPE_RADECG) ? false : dicomViewer.thumbnail.isSeriesContainsMultiframe(studyuid, seriesLayout.seriesIndex);
            var imageAndFrameIndex = dicomViewer.scroll.getCurrentImageAndFrameIndex(false, seriesLayout);
            series = dicomViewer.Series.getSeries(studyuid, seriesLayout.seriesIndex);
            if (isMultiframe) {
                if (series != undefined && series != null) {
                    var count = 0;
                    seriesCount = series.imageCount + count;
                    activeSeriesIndex = seriesLayout.scrollData.imageIndex;
                    activeImageIndex = seriesLayout.scrollData.frameIndex;
                    if (imagevalue != undefined) {
                        totalImageorFrames = imagevalue.numberOfFrames;
                    }
                }
            } else {
                activeSeriesIndex = seriesLayout.seriesIndex;
                totalImageorFrames = dicomViewer.Series.getImageCount(studyuid, activeSeriesIndex);
                var imageIndex = imageAndFrameIndex[0];
                activeImageIndex = imageIndex;
            }
            var isCheckMixedModality = false;
            if (series) {
                if (((series.isDicom) && (series.modality == "ECG" || series.modality == "SR" ||
                    series.modality == "CDA")) || series.modality == "General") {
                    $("#playButton_wrapper").addClass("k-state-disabled");
                    $("#playButton").addClass("k-state-disabled");
                    $("#playButton_overflow, #playForward_overflow, #playBackward_overflow").addClass("k-state-disabled");
                    $("#repeteOption").addClass("k-state-disabled");
                    $("#repeteOption_overflow").hide();
                    repeatButtonImage = null;
                } else if (repeatButtonImage && (previousSeriesModality == currentSeriesModality && currentSeriesModality == nextSeriesModality)) {
                    $("#repeteOption").removeClass("k-state-disabled");
                    $("#repeteOption_overflow").show();
                }
            }

            if (seriesLayout.imageType == IMAGETYPE_JPEG) {
                if (isMultiframe) {
                    if (imageAndFrameIndex[1] == undefined) {
                        activeImageIndex = 0;
                    } else {
                        activeImageIndex = imageAndFrameIndex[1];
                    }
                    document.getElementById("totalPages").innerText = (activeImageIndex + 1) + " of " + totalImageorFrames;
                } else {
                    document.getElementById("totalPages").innerText = (activeImageIndex + 1) + " of " + totalImageorFrames;
                }
            }

            //if Repest series is enabled..
            if (repeatButtonImage && $("#playButton_wrapper img")[0].src.indexOf("stop.png") > -1 && imageSrc.indexOf("repeat.png") <= -1) {
                $(nextSeries).addClass("k-state-disabled");
                $(previousSeries).addClass("k-state-disabled");
                $(nextImage).addClass("k-state-disabled");
                $(previousImage).addClass("k-state-disabled");
                $(nextSeries + "_overflow").hide();
                $(previousSeries + "_overflow").hide();
                $(nextImage + "_overflow").hide();
                $(previousImage + "_overflow").hide();
                handlePageNavigation(true);
            } else {
                var seriesLayoutMaxId = isFullScreenEnabled ? dicomViewer.getCurrentSeriesLayoutIds() : dicomViewer.viewports.getSeriesLayoutMaxId();
                var rowColumnValue = seriesLayoutMaxId.split('_')[2];
                if (imageLayoutDimension > 1 && $("#playButton_wrapper img")[0].src.indexOf("stop.png") > -1 &&
                    rowColumnValue == "1x1") {
                    handlePageNavigation(true);
                } else {
                    handlePageNavigation();
                }

                // enable disable the Prev/Next series button
                if (seriesCount <= 1) {
                    $(nextSeries).addClass("k-state-disabled");
                    $(previousSeries).addClass("k-state-disabled");
                    $(nextSeries + "_overflow").hide();
                    $(previousSeries + "_overflow").hide();
                    if (repeatButtonImage) {
                        document.getElementById("repeteOption").style.visibility = "hidden";
                        document.getElementById("repeteOption_overflow").style.visibility = "hidden";
                    }
                } else {
                    if (repeatButtonImage && (previousSeriesModality == currentSeriesModality && currentSeriesModality == nextSeriesModality)) {
                        document.getElementById("repeteOption").style.visibility = "visible";
                        document.getElementById("repeteOption_overflow").style.visibility = "visible";
                        $("#repeteOption_overflow").show();
                    }
                    if (seriesCount == activeSeriesIndex + 1) {
                        $(nextSeries).addClass("k-state-disabled");
                        $(previousSeries).removeClass("k-state-disabled");
                        $(nextSeries + "_overflow").hide();
                        $(previousSeries + "_overflow").show();
                    } else {
                        $(nextSeries).removeClass("k-state-disabled");
                        $(previousSeries).removeClass("k-state-disabled");
                        $(nextSeries + "_overflow").show();
                        $(previousSeries + "_overflow").show();
                    }

                    if ((activeSeriesIndex == 0)) {
                        $(nextSeries).removeClass("k-state-disabled");
                        $(previousSeries).addClass("k-state-disabled");
                        $(nextSeries + "_overflow").show();
                        $(previousSeries + "_overflow").hide();
                    }
                }

                var containsECG = (previousSeriesModality == "ECG" || currentSeriesModality == "ECG" || nextSeriesModality == "ECG") ? true : false;

                //Enable/Disable the Next/Previous image button
                if (repeatButtonImage && (($("#playButton_wrapper img")[0].src.indexOf("stop.png") > -1) || isCineRun)) {
                    $(nextImage).addClass("k-state-disabled");
                    $(previousImage).addClass("k-state-disabled");
                    $(nextImage + "_overflow").hide();
                    $(previousImage + "_overflow").hide();
                    $("#playButton_wrapper").removeClass("k-state-disabled");
                    $("#playButton").removeClass("k-state-disabled");
                } else {
                    if (totalImageorFrames <= 1 || totalImageorFrames <= imageLayoutDimension) {
                        $(nextImage).addClass("k-state-disabled");
                        $(previousImage).addClass("k-state-disabled");
                        $(nextImage + "_overflow").hide();
                        $(previousImage + "_overflow").hide();

                        if (repeatButtonImage && imageSrc.indexOf("repeat.png") > -1) {
                            $("#playButton_wrapper").addClass("k-state-disabled");
                            $("#playButton").addClass("k-state-disabled");
                            $("#playButton_overflow, #playForward_overflow, #playBackward_overflow").addClass("k-state-disabled");
                        } else if (repeatButtonImage) {
                            if (!containsECG && ((totalImageorFrames > 1 && totalImageorFrames > imageLayoutDimension) || seriesCount > 1)) {
                                $("#playButton_wrapper").removeClass("k-state-disabled");
                                $("#playButton").removeClass("k-state-disabled");
                                $("#playButton_overflow, #playForward_overflow, #playBackward_overflow").removeClass("k-state-disabled");
                                $("#repeteOption").removeClass("k-state-disabled");
                                $("#repeteOption_overflow").show();
                            } else {
                                $("#playButton_wrapper").addClass("k-state-disabled");
                                $("#playButton").addClass("k-state-disabled");
                                $("#playButton_overflow, #playForward_overflow, #playBackward_overflow").addClass("k-state-disabled");
                            }
                        }
                    } else {
                        if (repeatButtonImage) {
                            $("#playButton_wrapper").removeClass("k-state-disabled");
                            $("#playButton").removeClass("k-state-disabled");
                            $("#repeteOption").removeClass("k-state-disabled");
                            $("#repeteOption_overflow").show();
                            $("#playButton_overflow, #playForward_overflow, #playBackward_overflow").removeClass("k-state-disabled");
                        }
                        if (totalImageorFrames <= activeImageIndex + imageLayoutDimension) {
                            $(nextImage).addClass("k-state-disabled");
                            $(previousImage).removeClass("k-state-disabled");
                            $(nextImage + "_overflow").hide();
                            $(previousImage + "_overflow").show();
                        } else {
                            $(nextImage).removeClass("k-state-disabled");
                            $(previousImage).removeClass("k-state-disabled");
                            $(nextImage + "_overflow").show();
                            $(previousImage + "_overflow").show();
                        }

                        if (activeImageIndex == 0) {
                            $(nextImage).removeClass("k-state-disabled");
                            $(previousImage).addClass("k-state-disabled");
                            $(nextImage + "_overflow").show();
                            $(previousImage + "_overflow").hide();
                        }
                    }
                }
            }
        }

        disableQATools();
    } catch (e) {}
}

function playRepeat() {
    var imageCount = 1;
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var studyUid = seriesLayout.getStudyUid();
    var seriesIndex = seriesLayout.getSeriesIndex();
    var imageIndex = seriesLayout.getImageIndex();
    var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
    var isSeriesMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
    var isMultiFrame = dicomViewer.thumbnail.isImageThumbnail(image);
    var repeteOption_overflow = $("#repeteOption_overflow");

    var repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
    var imageSrc = repeatButtonImage.src;

    if (isSeriesMultiFrame === true && isMultiFrame === true) {
        imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
    } else {
        imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
    }

    var repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
    var imageSrc = repeatButtonImage.src;
    var repateOptionButton = $("#repeteOption");
    if (imageSrc.indexOf("repeat.png") > -1) {
        repeatButtonImage.src = imageSrc.replace("repeat.png", "repeteActive.png");
        updateToolTip(repateOptionButton, "Repeat Series");
        updateImageOverflow(repeteOption_overflow, "images/repeat.png", "images/repeteActive.png", false);
        dicomViewer.scroll.setCinePlayBy("Study");
    } else {
        repeatButtonImage.src = imageSrc.replace("repeteActive.png", "repeat.png");
        updateToolTip(repateOptionButton, "Repeat Study");
        updateImageOverflow(repeteOption_overflow, "images/repeteActive.png", "images/repeat.png", true);
        dicomViewer.scroll.setCinePlayBy("Stack");

        if (imageCount == 1) {
            dicomViewer.tools.stopCineImage();
            updatePlayIcon("stop.png", "play.png", true, "playButton");
        }

        // To enable window level and invert on repeat stack mode when cine is running
        if (dicomViewer.scroll.isCineRunning(seriesLayout.seriesLayoutId)) {
            changeToolbarIcon($("#invertButton"), "invert.png", "invert.png", false);
            changeToolbarIcon($("#invertButton_overflow"), "invert.png", "invert.png", false);
            changeToolbarIcon($("#winL_wrapper"), "brightness.png", "brightness.png", false);
            changeToolbarIcon($("#winL"), "brightness.png", "brightness.png", false);
            updateImageOverflow($("#winL_overflow"), "images/brightness.png", "images/brightness.png", false);
            $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
        }
    }
    EnableDisableNextSeriesImage(seriesLayout);
}

function cineplayBy(playBy) {
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
    var imageSrc = repeatButtonImage.src;
    var repateOptionButton = $("#repeteOption");
    if (playBy === "Study") {
        repeatButtonImage.src = imageSrc.replace("repeat.png", "repeteActive.png");
        updateToolTip(repateOptionButton, "Repeat Series");
        dicomViewer.scroll.setCinePlayBy("Study");
    } else {
        repeatButtonImage.src = imageSrc.replace("repeteActive.png", "repeat.png");
        updateToolTip(repateOptionButton, "Repeat Study");
        dicomViewer.scroll.setCinePlayBy("Stack");
    }
    EnableDisableNextSeriesImage(seriesLayout);
}
function showPrintAndExport(show)
{
    // PDFs print/export using only the PDF Viewer. The Print and Export toolbar icons remain disabled and they are not in the context menu.
    // Embedded PDFs in DICOMs - see PDFs above.
    // TIFFs can print/export only after the PDF is ready. Context menu and toolbar icons are not enabled until that time. Called with show param = true.
    // DICOMs print/export from the context menu and toolbar icons.
    // JPEGs, PNGs, and BMP print/export from the context menu and toolbar icons. Called with show param = true.
    // RTFs, TXTs, DOCs - see PDFs above.
    // AVIs, CDAs, MOVs, MP4s (Audio and Video) do not print or export.
    //
    // In other words, types we:
    // Do NOT print/export with toolbar/context menu: IMAGETYPE_CDA, IMAGETYPE_BLOB, IMAGETYPE_PDF, IMAGETYPE_VIDEO, IMAGETYPE_AUDIO, IMAGETYPE_RADPDF
    // DO print/export (below): IMAGETYPE_RAD, IMAGETYPE_RADECHO, IMAGETYPE_RADSR, IMAGETYPE_RADECG
    // DO print/export (called with show param = true): IMAGETYPE_JPEG, IMAGETYPE_TIFF
    //
    var layout = dicomViewer.getActiveSeriesLayout();
    if (layout) {
        if (layout.imageType == IMAGETYPE_RAD || layout.imageType == IMAGETYPE_RADECHO || layout.imageType == IMAGETYPE_RADSR || layout.imageType == IMAGETYPE_RADECG)
            show = true;
    }
    if (show) {
        if (canPrint) {
            $("#context-print").show();
            $("#printButton").removeClass("k-state-disabled");
        }
        if (canExport) {
            $("#context-export").show();
            $("#exportButton").removeClass("k-state-disabled");
        }
    } else {
        $("#printButton").addClass("k-state-disabled");
        $("#context-print").hide();
        $("#exportButton").addClass("k-state-disabled");
        $("#context-export").hide();
    }
}
function updatePrintExportMessage(showMessage)
{
    if (canPrint || canExport) {
        var isPageReady = PdfRequest.arePrintAndExportReady;
        if (isPageReady = true) {
            if (showMessage) {
                $("#statusMsg").text("Print/Export:Ready");
                dicomViewer.measurement.showAndHideSplashWindow("show", "Print/Export:Ready", "dicomViewer");
            }
            showPrintAndExport(true);
        }
        else
            showPrintAndExport(false);
    } else 
        showPrintAndExport(false);
    
}

function showOrHideDicomMenu(flag, modality) {
    if (flag) {
        dicomViewer.link.updateLinkMenu();
        $("#context-copyAttributes").show();
        $("#context-ww_wc").show();
        $("#context-pan").show();
        $("#context-zoom").show();
        $("#context-length").show();
        $("#context-2dPoint").show();
        $("#context-angle").show();
        $("#context-hounsfield").hide();
        $("#context-length-calibration").show();
        //$("#context-volume").show();
        $("#context-MitralValve").show();
        $("#context-AorticValve").show();
        $("#context-trace").show();
        $("#context-annotation").show();
        $("#context-measurement").show();
        $("#context-MensuratedScale").show();
        if (modality === "US") {
            $("#context-ww_wc").hide();
            $("#context-length").show();
            $("#context-2dPoint").show();
            $("#context-length-calibration").hide();
            $("#context-MensuratedScale").hide();
            $("#context-angle").show();
            $("#context-trace").show();
            $("#context-MitralValve").show();
            $("#context-AorticValve").show();
        } else if (modality === "CT") {
            $("#context-hounsfield").show();
            $("#context-trace").hide();
            $("#context-MitralValve").hide();
            $("#context-AorticValve").hide();
        } else {
            if (modality != "CT" && modality != "US") {
                $("#context-ww_wc").hide();
            }
            $("#context-length").show();
            $("#context-length-calibration").show();
            $("#context-2dPoint").show();
            $("#context-angle").show();
            $("#context-trace").hide();
            $("#context-MitralValve").hide();
            $("#context-AorticValve").hide();
        }
        showPrintAndExport(false); //VAI-307
    } else {
        $("#context-windowlevel").hide();
        $("#context-ww_wc").hide();
        $("#context-pan").hide();
        $("#context-zoom").hide();
        $("#context-length").hide();
        $("#context-length-calibration").hide();
        $("#context-2dPoint").hide();
        $("#context-angle").hide();
        $("#context-hounsfield").hide();
        $("#context-annotation").hide();
        $("#context-MensuratedScale").hide();
        $("#context-trace").hide();
        $("#context-volume").hide();
        $("#context-MitralValve").hide();
        $("#context-AorticValve").hide();
        $("#context-measurement").hide();
        $("#context-link-menu").hide();
        $("#context-copyAttributes").hide();
        $("#context-qa-menu").hide();
        //hideAnimationContainer();
    }

    if (isColorImage()) {
        $("#context-RGBTool").show();
    } else {
        $("#context-RGBTool").hide();
    }
}

function showOrHideEcgMenue(flag) {
    if (flag) {
        $("#gridtype").show();
        $("#gridcolor").show();
        $("#leadformat").show();
        $("#gain").show();
        $("#signalthickness").show();
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageRender = seriesLayout.getImageRender("ecgData");
        var imageId = imageRender.getImageUid();
        var horizontalcaliper = dicomViewer.getHorizontalCaliper(imageId);
        var isShowCaliper = dicomViewer.isShowcaliper(imageId);
        var seriesLayoutId = seriesLayout.getSeriesLayoutId();
        var caliperStatus = dicomViewer.getCaliperStatus(seriesLayoutId);

        if (imageRender.isMedian === true) {
            $("#lf_averagecomplex").show();
        } else {
            $("#lf_averagecomplex").hide();
        }

        if (horizontalcaliper === undefined) {
            $("#drawcaliper").show();
            $("#context-showCaliper").hide()
            $("#context-hideCaliper").hide()
        } else if (caliperStatus === "visible") {
            $("#drawcaliper").hide();
            $("#context-showCaliper").hide();
            $("#context-hideCaliper").show();
        } else {
            $("#drawcaliper").hide();
            $("#context-hideCaliper").hide();
            $("#context-showCaliper").show();
        }
    } else {
        $("#gridtype").hide();
        $("#gridcolor").hide();
        $("#leadformat").hide();
        $("#gain").hide();
        $("#signalthickness").hide();
        $("#drawcaliper").hide();
        $("#context-showCaliper").hide()
        $("#context-hideCaliper").hide()
    }
}

function nextSeries() {
    dicomViewer.tools.moveSeries(true);
}

function previousSeries() {
    dicomViewer.tools.moveSeries(false);
}

function getPlayerDirection(e) {
    var playerOption = false;
    //Mozilla Firefox not supporting parent element in jquery
    var playerValue = document.getElementById("playForward").parentElement.style.background;
    if (playerValue.indexOf("rgb(134, 134, 150)") > -1) {
        playerOption = true;
    }
    return playerOption;
}

/**
 * Change the Cine player direction either forward or backward (by default it is forward).
 * @param {Type} e - Mouse event, initiating from the cine player tool bar (forward/backward)
 * to get the manually selected direction type.
 */
function changePlayDirection(e) {
    if (e === undefined) {
        return;
    }
    var playBackwardElement = $("#playBackward").parent();
    var playForwardElement = $("#playForward").parent();
    if (e.id === "playForward") {
        playBackwardElement.css("background", "");
        playForwardElement.css("background", "#868696");
    } else if (e.id === "playBackward") {
        playForwardElement.css("background", "");
        playBackwardElement.css("background", "#868696");
    }
    var imageSrc = $("#playButton_wrapper img")[0].src;
    var direction = getPlayerDirection(e);
    dicomViewer.scroll.setCineDirection(direction);
    if (imageSrc.indexOf("stop.png") > -1) {
        dicomViewer.tools.stopCineImage();
        dicomViewer.tools.runCineImage(direction);
    }
}

function getHeightOfThumbnails(element) {

    var heightOfStudyThumbnails = 0;
    element.each(function () {
        var elementId = this.id;
        if (elementId != "" && elementId != undefined) {
            heightOfStudyThumbnails = heightOfStudyThumbnails + $("#" + elementId).outerHeight();
        }
    });
    return heightOfStudyThumbnails;
}

function reloadViewPort() {
    isCineEnabled(true);
    var seriesLayoutId = dicomViewer.getActiveSeriesLayout().getSeriesLayoutId();
    if (defaultViewportInThumbnailViewHiddenMode !== undefined) {
        seriesLayoutId = defaultViewportInThumbnailViewHiddenMode;
        defaultViewportInThumbnailViewHiddenMode = undefined;
    }
    dicomViewer.thumbnail.setViewportProperty();
    var viewportElement = $('#viewport_View');
    var imageThumbnailViewElement = $("#imageThumbnail_View");
    //height of image thumbnail view
    var heightOfImageThumbnail = imageThumbnailViewElement.height();
    //first study level thumbnail 
    var studyThumbnailElement = imageThumbnailViewElement.children();
    //get the first study level thumbnail div id
    var firstStudyThumbnailDivId = studyThumbnailElement[0].id;
    var firstStudyThumbnailDivOuterWidth = studyThumbnailElement.children("div").outerWidth();
    var firstStudyThumbnailDivWidth = studyThumbnailElement.children("div").width();
    //Width of image thumbnail
    var imageThumnailWidth = studyThumbnailElement.width();
    if (imageThumnailWidth < 0) {
        imageThumbnailViewElement = $("#keyimageThumbnail_View");
        //height of image thumbnail view
        heightOfImageThumbnail = imageThumbnailViewElement.height();
        //first study level thumbnail 
        studyThumbnailElement = imageThumbnailViewElement.children();
        //Width of image thumbnail
        imageThumnailWidth = studyThumbnailElement.width();
        firstStudyThumbnailDivOuterWidth = studyThumbnailElement.children("div").outerWidth();
        firstStudyThumbnailDivWidth = studyThumbnailElement.children("div").width();
    }
    //width of the single thumbnail element(outer width help to calculate including borders)     
    var imageThumbnailWidth = studyThumbnailElement.children().children("div").outerWidth();
    //get the left padding value for the thumbnail image
    var paddingOfFirstThumbnail = $("#thumb_" + firstStudyThumbnailDivId).css("padding-left");
    paddingOfFirstThumbnail = parseInt(paddingOfFirstThumbnail.match(/\d+/)[0]);

    var leftandRightBorder = firstStudyThumbnailDivOuterWidth - firstStudyThumbnailDivWidth;

    //calulate the number of columns for thumbnails to display based on width we drag
    var numOfColumn = Math.floor(imageThumnailWidth / (imageThumbnailWidth));
    var heightOfStudyThumbnails = getHeightOfThumbnails(studyThumbnailElement);

    //width of img div
    var widthOfImgDiv = $("#img").outerWidth();
    // difference bettwen the width parent div(img) and child div(imageThumbnail_View) 
    var differnceOfBothDiv = (widthOfImgDiv - firstStudyThumbnailDivOuterWidth);

    if (numOfColumn > 1) {
        var widthToset = 0;
        if (heightOfStudyThumbnails > heightOfImageThumbnail) {
            widthToset = (imageThumbnailWidth * numOfColumn) + leftandRightBorder + paddingOfFirstThumbnail + differnceOfBothDiv + (numOfColumn * 5); //142+(104*(numOfColumn-1)) //(99 * numOfColumn)+21;
            myLayout.sizePane("west", widthToset);

            heightOfImageThumbnail = imageThumbnailViewElement.height();
            if (heightOfStudyThumbnails > heightOfImageThumbnail) {
                heightOfStudyThumbnails = getHeightOfThumbnails(studyThumbnailElement);
                if (!(heightOfStudyThumbnails > heightOfImageThumbnail)) {
                    differnceOfBothDiv = 11; //Math.abs(widthOfImgDiv - $("#"+firstStudyThumbnailDivId).width());
                    widthToset = (imageThumbnailWidth * numOfColumn) + leftandRightBorder + paddingOfFirstThumbnail + differnceOfBothDiv + (numOfColumn * 5);
                }
                myLayout.sizePane("west", widthToset + 10);
            }
        } else {
            widthToset = (imageThumbnailWidth * numOfColumn) + leftandRightBorder + paddingOfFirstThumbnail + differnceOfBothDiv + (numOfColumn * 5);
            myLayout.sizePane("west", widthToset + 10);
        }
    } else {
        var westPanelWidth = (isInternetExplorer() ? THUMBNAIL_PANEL_WIDTH + 10 : THUMBNAIL_PANEL_WIDTH);
        if (heightOfStudyThumbnails > heightOfImageThumbnail) {
            myLayout.sizePane("west", westPanelWidth);
        } else {
            myLayout.sizePane("west", westPanelWidth - 10);
        }
    }
    viewportElement.width("100%");
    viewportElement.height("100%");
    var splitedRowAndColumn = studyLayoutValue.split("x");
    var studyRow = splitedRowAndColumn[0];
    var studyColumn = splitedRowAndColumn[1];
    var obj = {
        id: studyLayoutValue
    };
    var tempLayOutmap = layoutMap;
    dicomViewer.tools.changeStudyLayoutFromTool(obj, isFullScreenEnabled, true);
    if (isFullScreenEnabled) {
        studyRow = studyColumn = 1;
    }
    layoutMap = tempLayOutmap;
    for (var i = 1; i <= studyRow; i++) {

        for (var j = 1; j <= studyColumn; j++) {
            var studyDiv = "studyViewer" + i + "x" + j;
            var rowCalValue = layoutMap[studyDiv];
            if (rowCalValue == undefined) {
                rowCalValue = "1x1";
            }
            var rcArray = rowCalValue.split("x");
            dicomViewer.tools.chanageWhileDrag(rcArray[0], rcArray[1], studyDiv, true);
        }
    }
    isCineEnabled(false);
    dicomViewer.changeSelection(seriesLayoutId);
}

$(window).bind("beforeunload", function () {
    dicomViewer.imageCache.clearCache();
});

var resizeTimer;
$(window).resize(function (evtArgs, isResizeRequired) {
    if (isMobileDevice()) {
        return;
    }

    //Maintain the visible dialog in the center of the screen
    autoRepositionVisibleDialogs();

    WINDOWWIDTH = $(this).innerWidth();
    WINDOWHEIGHT = $(this).innerHeight();
    isCineEnabled(true);
    BROWSER_ZOOM_LEVEL = window.devicePixelRatio;
    dumpConsoleLogs(LL_INFO, undefined, "window.resize", BROWSER_ZOOM_LEVEL);
    var windowHeight = $(this).innerHeight();
    var northPanHeight = $(".ui-layout-north").outerHeight();
    var southPanHeight = $(".ui-layout-south").outerHeight();
    var viewportElement = $('#viewport_View');
    var viewerElement = $("#viewer");
    var viewerHeight = windowHeight - (northPanHeight + southPanHeight);
    viewerElement.height(viewerHeight - 8);
    $("#viewportTable").height(viewerHeight - 8);
    viewerElement.width($(this).innerWidth() - $(".ui-layout-resizer-west")[0].getBoundingClientRect().right);
    viewportElement.width("100%");
    viewportElement.height("100%");

    $("#viewerVersionInfoModal").dialog({
        height: WINDOWHEIGHT * 0.6,
        width: WINDOWWIDTH * 0.8
    });
    $("#viewerVersionInfoModal").dialog("option", "position", "center");

    $("#dicomHeaderAttributes").dialog({
        height: WINDOWHEIGHT * 0.8,
        width: WINDOWWIDTH * 0.8
    });
    $("#dicomHeaderAttributes").dialog("option", "position", "center");

    //change the size & position of the dialog dynamically on resizing the window
    $("#imagingData").dialog({
        height: WINDOWHEIGHT * 0.8,
        width: WINDOWWIDTH * 0.8
    });
    $("#imagingData").dialog("option", "position", "center");

    var splitedRowAndColumn = studyLayoutValue.split("x");
    var studyRow = splitedRowAndColumn[0];
    var studyColumn = splitedRowAndColumn[1];
    if (!isFullScreenEnabled) {
        dicomViewer.tools.reOrderExistingStudyUids(true);
    }

    if (isFullScreenEnabled) {
        var activeViewPort = dicomViewer.getActiveSeriesLayout();
        dicomViewer.setStudyLayout(1, 1, activeViewPort.getStudyUid(), activeViewPort.SeriesIndex, true, undefined, undefined, true);
    } else {
        dicomViewer.setStudyLayout(studyRow, studyColumn, undefined, undefined, false, true);
    }
    isCineEnabled(false);

    if (isResizeRequired === undefined && isSessionCleared) {
        $("#preferencesButton").addClass("k-state-disabled");
        $("#studyLevel_wrapper").addClass("k-state-disabled");
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function () {
            document.getElementById("viewer").style.left = "0px";
            $("#viewer").width("100%");
            $("#tablestudyViewer1x1").width("95%");
            $(".ui-layout-resizer ").hide();
        }, 500);
    }
    showAndHideCloseIcon();
    removeKendoButtons();
    setTimeout(function () {
        showAndHidePlayButton(true);
    }, 300);
    showAndHideKendoTools();

});

function getStudyLayoutId(seriesLayoutId) {
    var index = seriesLayoutId.indexOf("studyViewer");
    var studyDiv = seriesLayoutId.substring(index, index + 14);
    return studyDiv;
}

function closeStudy(studyLayout) {
    var activeSeries = dicomViewer.getActiveSeriesLayout();
    if (activeSeries) {
        dicomViewer.getOrUpdateSeriesLayout(activeSeries.studyUid, 1, 1, true);
    }
    dicomViewer.viewports.deleteAndCreateNewViewport(studyLayout);
    layoutMap[studyLayout] = 1 + "x" + 1;
    dicomViewer.viewports.removeDuplicateViewportsByStudyLayout(studyLayout);
    dicomViewer.setSeriesLayout(undefined, 1, 1, 0, null, studyLayout);
    dicomViewer.removeSavedECGPreference();
    disableAllToolbarIcons();
    $('#viewport_View').css('cursor', 'default');
    document.getElementById(studyLayout + '_close').style.visibility = "hidden";
}

function changeImageLayout(val, divId) {
    var rowAndColume = val.split('x')
    dicomViewer.tools.changeImageLayout(rowAndColume[0], rowAndColume[1]);
    var element = document.getElementById(divId);
    element.value = val;
    if (val === "1x1") {
        showOrHidePageNavigation("hide");
    } else {
        showOrHidePageNavigation("show");
    }
}

function changeCustom(studyDivId) {
    customSeriesLayout = studyDivId;
    $('#dialog-form').dialog('open');
}

function openMessageInfo() {
    var messageInfoURL = dicomViewer.url.getMessageHistoryUrl();
    var messageInfo = "<iframe style='height:100%;width:100%;' src=" + messageInfoURL + "></iframe>"
    $("#messageHistory").html(messageInfo);
    $('#messageHistory').css({ "height": 420 + "px" });
}

function openHydraVersionInfo(hydraversion) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "openHydraVersionInfo ", "Start");

        var releaseHistoryURL = dicomViewer.url.getReleaseHistoryUrl();
        $.ajax({
                url: releaseHistoryURL,
                beforeSend: function (xhr) {
                    xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            })
            .done(function (data) {
                var text = JSON.parse(data);
                var htmlHistory = "<table width='100%'>";
                for (var i = 0; i < text.length; i++) {
                    var history = text[i];
                    var itemType = "";
                    htmlHistory += "<tr><td><table class='table' border='2px' border-style= solid><tr><td><table>";
                    if (history.type !== null & history.type !== undefined && history.type !== "") {
                        if (history.type == 0) {
                            itemType = "Version release";
                            htmlHistory += "<tr id='bold'><td>" + itemType + "</td></tr>";
                            htmlHistory += "<td></td><td></td>";

                            if (history.name !== null && history.name !== undefined && history.name !== "")
                                htmlHistory += "<tr id='bold'><td> <b>" + " Version " + history.name + "</b></td></tr>";

                            if (history.text !== null && history.text !== undefined && history.text !== "")
                                htmlHistory += "<tr id='bold'><td>" + history.text + "</td></tr>";

                            if (history.timeStamp !== null && history.timeStamp !== undefined && history.timeStamp !== "") {
                                var dateFormat = $.datepicker.formatDate('MM dd, yy', new Date(history.timeStamp));
                                if (dateFormat !== undefined) htmlHistory += "<tr id='bold'><td>Released " + dateFormat + "</td></tr>";
                            }

                        }
                        htmlHistory += "<tr><td id='height'></td></tr>";
                    }

                    htmlHistory += "<tr><td><table>";
                    if (history.items !== null & history.items !== undefined) {
                        for (var j = 0; j < history.items.length; j++) {
                            var subHistory = history.items[j];

                            if (subHistory.type !== null & subHistory.type !== undefined && subHistory.type !== "") {
                                if (subHistory.type == 1) itemType = "<tr id='subhistoryHeight'><td><span class='label label-success'>" + feature + "</span>&nbsp;&nbsp;";
                                else if (subHistory.type == 2) itemType = "<tr id='subhistoryHeight'><td><span class='label label-info'>" + improvement + "</span>&nbsp;&nbsp;";
                                else if (subHistory.type == 3) itemType = "<tr id='subhistoryHeight'><td><span class='label label-danger'>" + bug + "</span>&nbsp;&nbsp;";

                                htmlHistory += itemType;

                                if (subHistory.name !== null && subHistory.name !== undefined && subHistory.name !== "")
                                    htmlHistory += " Version " + subHistory.name + " ";

                                if (subHistory.text !== null && subHistory.text !== undefined && subHistory.text !== "")
                                    htmlHistory += subHistory.text + " ";

                                if (subHistory.timeStamp !== null && subHistory.timeStamp !== undefined && subHistory.timeStamp !== "") {
                                    dateFormat = $.datepicker.formatDate('MM dd, yy', new Date(subHistory.timeStamp));
                                    if (dateFormat !== undefined)
                                        htmlHistory += " On " + dateFormat + " ";
                                }
                                htmlHistory += "</td></tr>";
                            }
                        }
                        htmlHistory += "</table>";
                    }
                    htmlHistory += "</td></tr><tr><td></td></tr></table></td></tr></table>";
                }
                htmlHistory += "</td></tr></table>";

                $("#versionHistory").html(htmlHistory);
                $("#historyTabs").tabs();
                var messageInfoURL = dicomViewer.url.getMessageHistoryUrl();
                var messageInfo = "<iframe style='height:100%;width:100%;' src=" + messageInfoURL + "></iframe>"
                $("#messageHistory").html(messageInfo);
                $('#messageHistory').css({ "height": 420 + "px" });

                $('#viewerVersionInfoModal').dialog('open');
                dicomViewer.pauseCinePlay(1, true);

                dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));

            })
            .fail(function (data) {
                $('#viewerVersionInfoModal').dialog('open');
                dicomViewer.pauseCinePlay(1, true);
            })
            .error(function (xhr, status) {
                var description = xhr.statusText + " : Failed to open the hydra version information";
                sendViewerStatusMessage(xhr.status.toString(), description);
                dumpConsoleLogs(LL_ERROR, undefined, undefined, description);
            });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {}
}

/**
 * Get the display settings
 * @param {Type} modality - Specifies the modality
 */
function GetDisplaySettings(modality) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "GetDisplaySettings", "Start");

        var layoutPrefType = 'user';
        if ($("#displayUseDefault")[0]) {
            layoutPrefType = ($("#displayUseDefault")[0].checked ? 'SYS' : 'user');
        }

        var displaySettings = getDefaultDisplaySettings(modality);
        var settingsUrl = dicomViewer.getSettingsUrl(layoutPrefType);
        $.ajax({
                url: settingsUrl,
                async: false,
                cache: false,
                beforeSend: function (xhr) {
                    xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            })
            .done(function (data) {
                displaySettings = processAndGetDisplaySettings(data, modality);
            })
            .fail(function (data) {})
            .error(function (xhr, status) {
                var description = xhr.statusText + "\nDefault display settings are not configured for this modality:" + modality;
                sendViewerStatusMessage(xhr.status.toString(), description);
            });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
    return displaySettings;
}

/**
 * Get the default display settings
 * @param {Type} modality - Modality
 * @param {Type} displaySettings - Display settings
 */
function getDefaultDisplaySettings(modality) {
    var isECG = (modality === "ECG" ? true : false);
    var displaySettings = {
        Rows: 1,
        Columns: 1,
        ZoomMode: (isECG ? "2_zoom" : "1_zoom"),
        PresentationMode: "SCALE_TO_FIT",
        ZoomLevel: (isECG ? 2 : 1),
        IsECG: isECG
    };

    return displaySettings;
}

/**
 * Update the current study layout map 
 * @param {Type} displaySettings - Specifies the display settings
 */
function UpdateStudyLayoutMap(displaySettings, studyDiv) {
    try {
        if (displaySettings === undefined) {
            return;
        }

        if (!studyDiv) {
            studyDiv = getStudyLayoutId(dicomViewer.getActiveSeriesLayout().seriesLayoutId);
            if (studyDiv == undefined || studyDiv == "") {
                return;
            }
        }

        layoutMap[studyDiv] = displaySettings.Rows + "x" + displaySettings.Columns;
    } catch (e) {}
}

/**
 * Get the default study layout 
 * @param {Type} studyData - Study Data
 * @param {Type} rows - No of Rows 
 * @param {Type} columns - No Of Columns
 */
function getDefaultStudyLayout(data, rows, columns) {
    // Maintain the default values
    var layout = {
        Rows: rows,
        Columns: columns,
        OccupiedViewports: 1
    };

    try {
        // Check whether the study data is valid
        if (data === undefined || data == null) {
            return layout;
        }

        var totalStudyLayouts = 0;

        // Check the dicom images
        if (data.studies !== null) {
            totalStudyLayouts = data.studies.length;
        }

        // Check the non dicom images
        if (data.images !== null || data.blobs !== null) {
            totalStudyLayouts += 1;
            // Always maintain the study layout based on the dicom study
        }

        // Update the occupied viewports
        layout.OccupiedViewports = (totalStudyLayouts > 4 ? 4 : totalStudyLayouts);

        // Create the default the study layout
        if (totalStudyLayouts > 0) {
            if (totalStudyLayouts === 1) {
                layout.Rows = 1;
                layout.Columns = 1;
            } else if (totalStudyLayouts === 2) {
                layout.Rows = 1;
                layout.Columns = 2;
            } else if (totalStudyLayouts > 2) {
                layout.Rows = 2;
                layout.Columns = 2;
            }
        }

        return layout;
    } catch (e) {}

    return layout;
}

/**
 * Set the viewer cache size 
 */
function setCacheSize() {
    try {
        /**identify the mobile device or not 
         * if it is mobile device it change the cache size to 100 MB
         * if it is not mobile device it chanage the cache size to 600 MB
         */
        if (isMobileDevice()) {
            //100 MB in cache Array
            dicomViewer.imageCache.setCacheSize(true);
        } else {
            //600 MB in cache Array
            dicomViewer.imageCache.setCacheSize(false);
        }
    } catch (e) {}
}

/**
 * Get the selected the image series
 * @param {Type} study - Specifies the study
 * @param {Type} selectedImageUid - Specifies the selected image Uid
 */
function getSelectedImageSeries(study, selectedImageUid) {
    try {
        var seriesIndex = -1;
        var imageIndex = -1;
        var isImageFound = false;
        study.series.some(function (series, index) {
            seriesIndex = index;
            series.images.some(function (image, index) {
                imageIndex = index;
                if (image.imageUid == selectedImageUid) {
                    isImageFound = true;
                    return true;
                }

                // Break the loop
                if (isImageFound) {
                    return true;
                }
            });

            // Break the loop
            if (isImageFound) {
                return true;
            }
        });

        if (isImageFound) {
            return {
                SeriesIndex: seriesIndex,
                ImageIndex: imageIndex
            };
        }

        return undefined;
    } catch (e) {}

    return undefined;
}

/**
 * Preprocess study
 * @param {Type} data - Study data
 */
function preprocessStudy(data, contextId) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "preprocessStudy", "Start");

        var totalStudiesMap = new Map();

        // Preprocess dicom images
        var dicomStudy = [];
        if (data.studies !== null && data.studies !== undefined) {
            data.studies.forEach(function (entry) {
                entry.studyId = (!entry.studyId ? contextId : entry.studyId);
                entry.displaySettings = GetCacheDisplaySettings(data, entry.modality);
                entry.displaySettings.studyUid = entry.studyUid;
                entry.isXRefLineFound = false;
                entry.is6000OverLay = false;
                entry.imageUrns = {};
                entry.memoryLimit = 0;
                entry.isMemoryExceed = false;

                // Generate the duplicate study uid if it is already exists
                if (dicomViewer.getStudyDetails(entry.studyUid)) {
                    entry.studyUid = entry.studyUid + "-" + BasicUtil.GetV4Guid();
                }

                if (entry.series !== undefined) {
                    var keyImageSeries = undefined;
                    entry.series.seriesCount = 0;
                    entry.series.forEach(function (series) {
                        series.isDicom = true;
                        series.isDisplaySettingsApplied = false;
                        series.displaySettings = jQuery.extend(true, {}, entry.displaySettings);
                        series.hasMutiframeImages = false;
                        series.cacheData = {
                            memoryLimit: 0,
                            startIndex: 0,
                            endIndex: 0,
                            allowCache: !entry.isMemoryExceed,
                            isEnable: true,
                            isMemoryExceed: false
                        };

                        // Add the display settings in image level for multiframe images.
                        series.images.forEach(function (image) {
                            image.imageUrn = getImageUrn(image);
                            image.numberOfFrames = (invokerIsQA() ? 1 : image.numberOfFrames);
                            if (image.imageUrn === "" || image.imageUrn === null || image.imageUrn === undefined) {
                                entry.imageUrns[image.imageUid] = image.imageUid;
                            } else {
                                entry.imageUrns[image.imageUrn] = image.imageUid;
                            }

                            // Update the cache memory limit
                            if (series.cacheData.isEnable && !entry.isMemoryExceed) {
                                var memoryLimit = (image.frameSize * image.numberOfFrames);
                                entry.memoryLimit += memoryLimit;
                                if (dicomViewer.imageCache.isMemoryAvailable(entry.memoryLimit)) {
                                    series.cacheData.memoryLimit += memoryLimit;
                                    series.cacheData.endIndex += 1;
                                } else {
                                    entry.memoryLimit -= memoryLimit;
                                    entry.isMemoryExceed = true;
                                }
                            } else if (!entry.isMemoryExceed) {
                                series.cacheData.endIndex = series.images.length;
                            }

                            // Check whether each image as separate thumbnail
                            if (dicomViewer.thumbnail.isImageThumbnail(image)) {
                                image.isDicom = true;
                                image.isDisplaySettingsApplied = false;
                                image.displaySettings = jQuery.extend(true, {}, entry.displaySettings);

                                if (!invokerIsQA()) {
                                    image.isImageThumbnail = true;
                                    entry.hasMutiframeImages = true;
                                    series.hasMutiframeImages = true;
                                } else {
                                    if (image.imageType == IMAGETYPE_RADECHO) {
                                        image.imageType = IMAGETYPE_RAD;
                                    }
                                }
                            }

                            if (entry.isXRefLineFound != true && image.imagePlane != null && image.imagePlane != undefined) {
                                entry.isXRefLineFound = !invokerIsQA();
                            }
                        });
                        series.iskeyImageSeries = false;
                        if (keyImageSeries === undefined) {
                            keyImageSeries = JSON.parse(JSON.stringify(series));
                            keyImageSeries.seriesIndex = 0;
                            keyImageSeries.iskeyImageSeries = true;
                        }
                    });
                }

                // Check whether the study having multiframe multiseries and combine all the series to single series
                if (entry.hasMutiframeImages && entry.series.length > 1) {
                    var multiframeImageSeries = entry.series.filter(function (o) {
                        return o.hasMutiframeImages;
                    });
                    var singleImageSeries = entry.series.filter(function (o) {
                        return !o.hasMutiframeImages;
                    });
                    if (multiframeImageSeries && multiframeImageSeries.length > 1) {
                        entry.series = undefined;
                        multiframeImageSeries.forEach(function (series) {
                            if (!entry.series) {
                                entry.series = [];
                                entry.seriesCount = 1;
                                entry.series.seriesCount = 1;
                                entry.series.push(series);
                            } else {
                                var existingSeriesGroup = entry.series.filter(function (o) {
                                    return o.modality == series.modality;
                                })[0];
                                if (!existingSeriesGroup) {
                                    entry.seriesCount += 1;
                                    entry.series.seriesCount += 1;
                                    entry.series.push(series);
                                } else {
                                    series.images.forEach(function (image) {
                                        existingSeriesGroup.imageCount += 1;
                                        existingSeriesGroup.images.push(image);
                                    });
                                }
                            }
                        });

                        if (singleImageSeries && singleImageSeries.length > 0) {
                            singleImageSeries.forEach(function (series) {
                                entry.series.push(series);
                                entry.seriesCount += 1;
                            });
                        }
                    }
                } else {
                    entry.series.seriesCount = (entry.series).length;
                }

                //TODO: pushing dummy key image series. 
                /*if (keyImageSeries != undefined) {
                    entry.series.push(keyImageSeries);
                    // TODO : increment the seriescount
                    entry.seriesCount;
                }*/

                entry.contextId = contextId;
                entry.isDicom = true;
                dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                if (dicomStudy === undefined) {
                    dicomStudy = new Array();
                    dicomStudy.push(entry);
                    totalStudiesMap.set(STUDY_TYPE_DICOM, dicomStudy);
                } else {
                    dicomStudy.push(entry);
                }
            });
        }

        // Preprocess blobs
        var nonDicomImages = [];
        if (data.blobs !== null && data.blobs !== undefined) {
            nonDicomImages = data.blobs;
        }

        // Preprocess Images
        if (data.images !== null && data.images !== undefined) {
            if (nonDicomImages.length == 0) {
                nonDicomImages = data.images;
            } else {
                data.images.forEach(function (image) {
                    nonDicomImages.push(image);
                });
            }
        }

        // Preprocess non dicom images
        if (nonDicomImages !== null && nonDicomImages !== undefined && nonDicomImages.length > 0) {
            var nonDicomdisplaySettings = GetCacheDisplaySettings(data, "General");
            var nonDicomStudyUid = undefined;
            nonDicomImages.forEach(function (entry) {
                var nonDicomStudy = [];

                // Study Uid
                if (!nonDicomStudyUid) {
                    nonDicomStudyUid = entry.studyId
                    if (!nonDicomStudyUid) {
                        nonDicomStudyUid = contextId;
                    }
                    nonDicomStudyUid = dicomViewer.replaceSpecialsValues(nonDicomStudyUid);

                    // Generate the duplicate study uid if it is already exists
                    if (dicomViewer.getStudyDetails(nonDicomStudyUid)) {
                        nonDicomStudyUid = nonDicomStudyUid + "-" + BasicUtil.GetV4Guid();
                        nonDicomStudyUid = dicomViewer.replaceSpecialsValues(nonDicomStudyUid);
                    }
                }

                // Procedure
                var nonDicomProcedure = (!entry.studyDescription ? entry.description : entry.studyDescription);
                if (!nonDicomProcedure) {
                    nonDicomProcedure = contextId;
                }

                // Set the required property
                entry.studyId = (!entry.studyId ? contextId + "_General" : entry.studyId);
                entry.contextId = contextId;
                entry.imageCount = 1;
                entry.isDicom = false;
                entry.displaySettings = nonDicomdisplaySettings;
                entry.isDisplaySettingsApplied = false;
                entry.imageUrn = getImageUrn(entry);

                nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                if (dicomStudy !== undefined) {
                    var selectedStudy = undefined;

                    // Append the series with existing dicom study
                    if (selectedStudy !== undefined) {
                        nonDicomStudyUid = dicomViewer.replaceDotValue(selectedStudy.studyUid);
                        nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry, nonDicomProcedure, nonDicomdisplaySettings, data.patient);
                        nonDicomStudy.imageUrns = {};
                        nonDicomStudy.images = new Array();
                        nonDicomStudy.images.push(entry);
                        nonDicomStudy.imageUrns[entry.imageUrn] = entry.imageUid;
                        selectedStudy.series.push(nonDicomStudy);
                        selectedStudy.seriesCount += 1;
                    } else if (nonDicomStudy === undefined) {
                        nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry, nonDicomProcedure, nonDicomdisplaySettings, data.patient);
                        nonDicomStudy.imageUrns = {};
                        nonDicomStudy.imageUrns[entry.imageUrn] = entry.imageUid;
                        nonDicomStudy.push(entry);
                        totalStudiesMap.set(STUDY_TYPE_NON_DICOM, nonDicomStudy);
                    } else {
                        nonDicomStudy.imageUrns[entry.imageUrn] = entry.imageUid;
                        nonDicomStudy.push(entry);
                        nonDicomStudy.seriesCount += 1;
                    }
                } else if (nonDicomStudy === undefined) {
                    nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry, nonDicomProcedure, nonDicomdisplaySettings, data.patient);
                    nonDicomStudy.push(entry);
                    totalStudiesMap.set(STUDY_TYPE_NON_DICOM, nonDicomStudy);
                } else {
                    nonDicomStudy.push(entry);
                    nonDicomStudy.seriesCount += 1;
                }
            });
        }
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, "preprocessStudy", e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, "preprocessStudy", "End", (Date.now() - t0));
    }

    return totalStudiesMap;
}

/**
 * Create and get the non dicom study
 * @param {Type} studyUid - Specifies the study Uid
 * @param {Type} studyId - Specifies the non dicom image object
 * @param {Type} procedure - Specifies the study procedure
 * @param {Type} displaySettings - Specifies the non dicom display settings
 * @param {Type} patient - Specifies the patient information object
 */
function createAndGetNonDicomStudy(studyUid, image, procedure, displaySettings, patient) {
    try {
        var nonDicomStudy = new Array();
        nonDicomStudy.studyUid = studyUid;
        nonDicomStudy.procedure = procedure;
        nonDicomStudy.modality = "General"
        nonDicomStudy.seriesCount = 1;
        nonDicomStudy.isDicom = false;
        nonDicomStudy.displaySettings = displaySettings;
        nonDicomStudy.displaySettings.studyUid = studyUid;
        nonDicomStudy.isDisplaySettingsApplied = false;
        nonDicomStudy.studyId = image.studyId;
        nonDicomStudy.dateTime = image.studyDateTime;
        nonDicomStudy.description = (!image.description ? image.fileName : image.description);
        nonDicomStudy.imageCount = (!image.imageCount ? 1 : image.imageCount);
        nonDicomStudy.isGeneral = true;

        // Create the patient
        if (patient) {
            nonDicomStudy.patient = patient;
        } else {
            if (image.patientDescription) {
                var patient = new Object();
                patient.age = "";
                patient.dob = "";
                patient.fullName = image.patientDescription;
                patient.iCN = "";
                patient.sex = "";
                nonDicomStudy.patient = patient;
            }
        }

        return nonDicomStudy;
    } catch (e) {}

    return null;
}

/**
 * Get the session information
 * @param {Type} contextId - Spectify the context id
 * @param {Type} noOfContexts - Spectify the no of context id
 * @param {Type} contextIndex - Spectify the context index
 */
function getSession(contextId, noOfContexts, contextIdIndex) {
    var session = {
        Rows: 1,
        Columns: 1,
        IsAllViewportsOccupied: false,
        IsLayoutChangeRequired: false,
        SeriesLayoutId: undefined,
        ContextId: contextId,
        Url: dicomViewer.getNewSubpageUrlForContext("context", contextId),
        SeriesLayoutIds: new Array,
        IsStudyCacheRequired: (dicomViewer.imageCache.getCachePercentage() > 75 ? false : true),
        IsNewSession: isSessionCleared,
        IsStudyLayoutUpdationRequired: true
    };

    try {
        // Check whether the active view port is occupied
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout !== undefined) {
            if (seriesLayout.studyUid === undefined) {
                session.SeriesLayoutId = seriesLayout.getSeriesLayoutId();
                if (noOfContexts === 1) {
                    return session;
                } else {
                    session.SeriesLayoutIds.push(session.SeriesLayoutId);
                }
            }
        }

        // Get the unoccupied viewport
        var allViewports = dicomViewer.viewports.getAllViewports();
        if (allViewports !== null && allViewports !== undefined) {
            var unoccupiedViewPorts = [];
            var occupiedViewPorts = [];
            var occupiedViewPortIds = [];
            $.each(allViewports, function (key, value) {
                if (value.studyUid === undefined) {
                    unoccupiedViewPorts.push(value.seriesLayoutId);
                } else {
                    if (occupiedViewPorts.indexOf(value.studyUid) == -1) {
                        occupiedViewPorts.push(value.studyUid);
                        occupiedViewPortIds.push(value.seriesLayoutId);
                    }
                }
            });

            // Check whether the layout is valid or not 
            if (unoccupiedViewPorts !== null && unoccupiedViewPorts !== undefined && unoccupiedViewPorts.length > 0) {
                unoccupiedViewPorts.sort();
                session.SeriesLayoutId = unoccupiedViewPorts[0];
                if (noOfContexts === 1) {
                    return session;
                } else {
                    for (var index = 0; index < unoccupiedViewPorts.length; index++) {
                        if (session.SeriesLayoutIds.indexOf(unoccupiedViewPorts[index]) === -1) {
                            session.SeriesLayoutIds.push(unoccupiedViewPorts[index]);
                        }
                    }
                }
            }

            // Set the series layout id from unoccupied view ports
            if (session.SeriesLayoutIds.length >= noOfContexts) {
                session.SeriesLayoutId = session.SeriesLayoutIds[contextIdIndex];
                return session;
            }

            // Check whether the viewport is reached max layout
            var maxRows = parseInt(STUDY_LAYOUT_MAX_ROW);
            var maxColumns = parseInt(STUDY_LAYOUT_MAX_COLUMN);
            var totalViewports = unoccupiedViewPorts.length + occupiedViewPorts.length;
            if (totalViewports >= (maxRows * maxColumns)) {
                session.IsLayoutChangeRequired = false;
                session.IsAllViewportsOccupied = true;
                session.SeriesLayoutId = undefined;

                return session;
            }

            // Increase the view port count based on the no of contexts 
            if (noOfContexts !== undefined && noOfContexts > 0 && session.SeriesLayoutIds.length === 0) {
                totalViewports += noOfContexts - 1;
            } else {
                totalViewports = noOfContexts + session.SeriesLayoutIds.length;
            }

            //Add the remaining view ports
            var viewports = new Array();
            for (var rows = 1; rows <= maxRows; rows++) {
                for (var columns = 1; columns <= maxColumns; columns++) {
                    viewports.push("imageviewer_studyViewer" + rows + "x" + columns + "_1x1");
                }
            }

            for (var index = 0; index < viewports.length; index++) {
                var viewportId = viewports[index];
                if (session.SeriesLayoutIds.indexOf(viewportId) === -1 &&
                    occupiedViewPortIds.indexOf(viewportId) === -1) {
                    session.SeriesLayoutIds.push(viewportId);
                }
            }
            session.SeriesLayoutIds.sort();

            var rows = 0;
            var columns = 0;
            switch (totalViewports) {
                case 1:
                    {
                        rows = 1;
                        columns = 2;
                        break;
                    }

                case 2:
                case 3:
                    {
                        rows = totalViewports - 1;
                        columns = 3;
                        break;
                    }

                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                    {
                        rows = 3;
                        columns = 3;
                        break;
                    }
            }

            session.Rows = rows;
            session.Columns = columns;
            session.SeriesLayoutId = session.SeriesLayoutIds[0];
            session.IsAllViewportsOccupied = false;
            session.IsLayoutChangeRequired = (contextIdIndex === 0 ? true : false);
        }

        return session;
    } catch (e) {}

    return session;
}

/**
 * Dsplay the study
 * @param {Type} session - Specifies the study session information
 * @param {Type} study - Specifies the study
 */
function displayStudy(session, study) {
    try {
        var studyUid = study.studyUid;
        var thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_0_thumb";
        if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, 0)) {
            thumbnailId += "0";
        }

        // Check whether the layout change is required or not to accomodate newly added study to viewports
        if (session.IsLayoutChangeRequired == true) {
            dicomViewer.loadStudyInNextViewport(studyUid, study.displaySettings);
            UpdateStudyLayoutMap(study.displaySettings);
        } else if (session.IsAllViewportsOccupied == false) {

            var viewportId = session.SeriesLayoutId;
            var viewerId = viewportId.split("_");
            var viewportHeight = document.getElementById("table" + viewerId[1]).style.height;
            viewportHeight = viewportHeight.replace('px', '');
            document.getElementById("table" + viewerId[1]).style.height = (viewportHeight - 15) + "px";

            // Display the first series
            $(thumbnailId)[0].click();

            //Change the series layout
            if (study.displaySettings !== undefined && study.displaySettings !== null) {
                var rows = study.displaySettings.Rows;
                var columns = study.displaySettings.Columns;
                if (parseInt(rows) == 1 && parseInt(columns) == 1) {
                    // No need to change the series layout. By default it will maintain 1x1
                } else {
                    var studyDiv = getStudyLayoutId(dicomViewer.getActiveSeriesLayout().seriesLayoutId);
                    if (studyDiv !== undefined && studyDiv !== "") {
                        dicomViewer.tools.changeSeriesLayout(rows, columns, {
                            id: studyDiv
                        });
                    }
                }
            }
            if (dicomViewer.isDicomStudy(studyUid) && document.getElementById(viewportId + "_progress")) {
                var progressHeight = document.getElementById(viewportId + "_progress").style.top;
                progressHeight = progressHeight.replace('px', '');
                document.getElementById(viewportId + "_progress").style.top = (parseInt(progressHeight) + 15) + "px";
            }
        } else {
            dicomViewer.thumbnail.makeThumbnailVisible(thumbnailId);
        }
    } catch (e) {}
}

/**
 * Prepare the study to load
 * @param {Type} contextId - Specifies the context id
 */
function prepareStudy(contextId) {
    try {
        var url = dicomViewer.getNewSubpageUrlForContext("prepare", contextId) + "&_cacheBust=" + new Date().getMilliseconds(); //VAI-915
        var xhttp;
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xhttp.onreadystatechange = function () {
            if (xhttp.readyState == 4 && xhttp.status == 200) {
                //Success
            }
        };
        xhttp.open("POST", url, true);
        xhttp.send();
    } catch (e) {}
}

/**
 * Activate the study
 * @param {Type} contextId - Specifies the context Id
 */
function ActivateStudy(contextId) {
    try {
        ActivateStudySession(getSession(contextId, 1, 0));
    } catch (e) {}
}

/**
 * Activate the session
 * @param {Type} session - Specifies the context session
 */
function ActivateStudySession(session) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "ActivateStudySession ", "Start");

        var d = new Date();
        var n = d.getMilliseconds();
        var url = session.Url + "&_cacheBust=" + n;
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            async: false,
            success: function (data) {
                // Preprocess study
                var totalStudiesMap = preprocessStudy(data, session.ContextId);
                var studyUid = undefined;

                // Process studies
                if (totalStudiesMap.size > 0) {
                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        dicomStudy.forEach(function (study) {
                            if (studyUid === undefined) {
                                studyUid = study.studyUid;
                                return false;
                            }
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined && studyUid === undefined) {
                        var nonDicomStudyDetails = dicomViewer.getStudyDetails(nonDicomStudy.studyUid);
                        if (nonDicomStudyDetails !== undefined && nonDicomStudyDetails !== null) {
                            studyUid = nonDicomStudy.studyUid;
                        }
                    }
                }

                // Activate the first series of the study
                if (studyUid !== undefined) {
                    var thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_0_thumb";
                    if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, 0)) {
                        thumbnailId += "0";
                    }

                    $("#" + thumbnailId)[0].click();
                }

                // Send the viewer messgae to server
                var description = "Successfully loaded the context id: " + decodeURIComponent(session.ContextId);
                sendViewerStatusMessage("200", description);
            },
            error: function (xhr, status) {
                var description = xhr.statusText + "\nFailed to load the study with this session." + "\Context ID is:" + decodeURIComponent(session.ContextId);
                sendViewerStatusMessage(xhr.status.toString(), description);
            }
        });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
}

/**
 * Bring to front the DIV
 */
function bringToFront(divId, parentDivId) {
    try {
        if (divId === undefined) {
            return "Please provide the id of the div to bring to front";
        }

        var iFrameOuter = divId + "_outer";
        var iFrameCover = divId + "_cover";

        var isNewDiv = $("." + iFrameOuter);
        if (isNewDiv !== undefined && isNewDiv !== null) {
            if (isNewDiv.length === 1) {
                return;
            }
        }

        var width = $('#' + divId).width();
        var height = $('#' + divId).height();
        var style = " style='height:100%;width:100%'";

        if (width === 0 && height === 0 && parentDivId !== undefined) {
            width = $('#' + parentDivId).width();
            height = $('#' + parentDivId).height();
            style = " style='height:" + height + ";width:" + width + "'";
        }

        $('#' + divId).wrap("<div class='" + iFrameOuter + "'" + style + "></div>");
        $("." + iFrameOuter).append("<iframe src='about:blank' class='" + iFrameCover + "'" + style + ">");
        $("." + iFrameCover).css({
            'min-width': '100%',
            'min-height': '100%',
            'overflow': 'hidden',
            'position': 'absolute',
            'border': 'none',
            'left': 0,
            'top': 0,
            'z-index': -1
        });
    } catch (e) {}
}

/**
 * Bring to front the pdf components
 * @param {Type} seriesLayoutId - Specifies the series layout id
 */
function bringToFrontPdf(seriesLayoutId, imageType) {
    try {
        if (isInternetExplorer() !== true) {
            listeniFrames();
            return;
        }

        if (isEmbedPdfViewer(imageType) == true) {
            listeniFrames();
            return;
        }

        bringToFront("viewerVersionInfoModal");
        bringToFront("hpModal");
        bringToFront("addMoreHPModal");
        bringToFront("imagingData");
        bringToFront("dicomHeaderAttributes");
        bringToFront("EcgPreference");
        bringToFront("cinePreferenceModal");
        bringToFront("MeasurementPropertiesModal");
        bringToFront("lengthCalibrationModal");
        bringToFront("zoom-form");
        bringToFront("customWindowLevel");
        bringToFront("cachelistindicator");
        bringToFront("qalistindicator")
        bringToFront("dialog-form");
        bringToFront("tableDimmensions");
        bringToFront("PreferenceAlert");
        bringToFront("qaNeedsToReviw");

        // Series layout
        var studyDiv = getStudyLayoutId(seriesLayoutId);
        bringToFront("seriesDisplay" + studyDiv + "_custom");

        listeniFrames();
    } catch (e) {}
}

/**
 *clear cache for Non Dicom images
 */
function ClearNonDICOMCacheDetails(studyUid) {
    try {
        for (var key in nonDICOMCacheDetails) {
            if (key !== undefined && studyUid !== undefined) {
                if (nonDICOMCacheDetails[key] == studyUid) {
                    nonDICOMRenderedCount--;
                    delete nonDICOMCacheDetails[key];
                }
            }
        }

        $("#cachemanager_progress").trigger("image_cache_updated", dicomViewer.imageCache.getCacheInfo());
    } catch (e) {}
}

/**
 * iFrame event listener for pdf 
 */
function iFrameEventListener() {
    try {
        var activeElement = document.activeElement;
        if (activeElement !== null && activeElement !== undefined) {
            if (activeElement.id == 'pdfviewer1x1') {
                var activeElementSeriesLayoutId = activeElement.parentElement.parentElement.id;
                var activeSeriesLayoutId = undefined;
                var seriesLayout = dicomViewer.getActiveSeriesLayout();
                if (seriesLayout !== undefined) {
                    activeSeriesLayoutId = seriesLayout.getSeriesLayoutId();
                }

                // Select the view port
                if (activeElementSeriesLayoutId !== activeSeriesLayoutId) {
                    dicomViewer.changeSelection(activeElementSeriesLayoutId);
                }
            }
        }
    } catch (e) {}
}

/**
 * Return the current viewport studyUid
 * @param {Type} seriesLevelDivId - it specifies the viewport level div id
 */
function getMeasurementStudyUid(seriesLevelDivId) {
    var seriesLayout = dicomViewer.viewports.getViewport(seriesLevelDivId);
    if (seriesLayout !== undefined && seriesLayout !== null) {
        return seriesLayout.studyUid;
    }
    return undefined;
}

/**
 * 
 * To check device type
 */
function isMobileDevice() {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        return true;
    }
    return false;
}

/**
 * Maintain the visible dialog in the center of the screen
 */
$.ui.dialog.prototype.options.autoReposition = true;

function autoRepositionVisibleDialogs() {
    try {
        $(".ui-dialog-content:visible").each(function () {
            if ($(this).dialog('option', 'autoReposition')) {
                $(this).dialog('option', 'position', $(this).dialog('option', 'position'));
            }
        });
    } catch (e) {}
}

/**
 * Check whether the browser is IE
 */
function isInternetExplorer() {
    try {
        var sAgent = window.navigator.userAgent;
        if (sAgent.indexOf('MSIE') > 0) {
            return true;
        } else if (!!navigator.userAgent.match(/Trident\/7\./)) {
            return true;
        }
    } catch (e) {}

    return false;
}

/**
 * Get and update the loading spinner 
 * @param {Type} session - Specifies the study session
 * @param {Type} text - Specifies the spinner text
 */
function getAndUpdateSpinner(session, text) {
    try {
        var spinner = undefined;
        if (session.IsAllViewportsOccupied == false && session.SeriesLayoutId !== undefined) {
            var existingSpinner = dicomViewer.progress.getSpinner(session.SeriesLayoutId);
            if (existingSpinner !== undefined) {
                if (existingSpinner.el) {
                    var existingSpinnerDiv = $("#" + session.SeriesLayoutId + "_spinner");
                    if (existingSpinnerDiv.length === 1) {
                        existingSpinnerDiv.css("white-space", "pre");
                        existingSpinnerDiv.html(text);
                        return;
                    }
                }

                existingSpinner.stop();
                existingSpinner = undefined;
            }

            updateSpinnerLocation(session.SeriesLayoutId);
            spinner = dicomViewer.progress.updateSpinnerInnerText(session.SeriesLayoutId, text);
            dicomViewer.progress.putSpinner(session.SeriesLayoutId, spinner);

            return spinner;
        }
    } catch (e) {}

    return undefined;
}

/**
 * Update the loading spinner location
 * @param {Type} selected viewportId - Specifies the selected viewport id
 */
function updateSpinnerLocation(viewportId) {
    try {
        //updating the location of the spinner on the basis of div id
        var rowcolArray = viewportId.split("_");
        var colArray = rowcolArray[2].split("x");
        if (colArray[1] !== "1") {
            viewportId = rowcolArray[0] + "_" + rowcolArray[1] + "_" + "1x1";
        }

        var div = $("#" + viewportId);
        var offset = div.offset();
        var width = div.width();
        var height = div.height();
        var left = offset.left + width / 2;
        var top = offset.top + height / 2;

        //shifting left and top for making the spinner at centre of the viewport
        if (colArray[1] !== "1") {
            left = left - 30;
            top = top - 38;
        } else {
            left = left - 20;
        }
        //Need to reduce left as well as top value with thumbnailWidth and toolbar width respectively to display the spinner in the middle of given viewport
        var thumbnailWidth = $("#img").width();
        var toolbarHeaderHeight = $("#toolbarheader").height();
        var toolbarHeight = $("#toolbar").height();
        var toolbarArea = toolbarHeaderHeight + toolbarHeight;
        //Updating the spinner config top and left value
        dicomViewer.progress.setTopLeftValues(top - toolbarArea, left - thumbnailWidth);
    } catch (e) {}
}

/**
 * listen the iFrames to select the viewport
 * @param {Type}  
 */
var isiFrameDivListening = undefined;
var isResetiFrameDivListening = true;

function listeniFrames(isReset) {
    if (isReset) {
        window.removeEventListener('blur', iFrameEventListener);
        isiFrameDivListening = undefined;
        isResetiFrameDivListening = undefined;
        setTimeout(function () {
            isResetiFrameDivListening = true;
            listeniFrames();
        }, 3000);
    } else if (isResetiFrameDivListening) {
        if (isiFrameDivListening === true) {
            return;
        }

        // Listen the 'blur' event to receive the iframe click event
        window.removeEventListener('blur', iFrameEventListener);
        window.addEventListener('blur', iFrameEventListener);
        isiFrameDivListening = true;
    }
}

/**
 * Return true or false - to validate the image is color or not.
 */
function isColorImage() {
    try {
        var imageUid = undefined;
        var enableRGBTool = false;
        var layout = dicomViewer.getActiveSeriesLayout();

        var layout = dicomViewer.getActiveSeriesLayout();
        if (layout == null && layout === undefined) {
            return enableRGBTool;
        }

        var studyDetails = dicomViewer.getStudyDetails(layout.studyUid);
        isRGBToolEnabled = (studyDetails ? studyDetails.isDicom : false) ? isRGBToolEnabled : false;
        imageUid = layout.getDefaultRendererImageUid();
        if (imageUid === undefined && dicomViewer.isDicomSeries(layout.studyUid, layout.seriesIndex) !== true) {
            return enableRGBTool;
        }

        var dicominfo = dicomViewer.header.getDicomHeader(imageUid);
        if (dicominfo !== undefined) {
            if (isRGBToolEnabled && dicominfo.imageInfo.isColor) {
                enableRGBTool = true;
            }
        }
        return enableRGBTool;
    } catch (e) {}
    return false;
}

var isSessionCleared = false;
/**
 * To show / hide UI when removing last study or loading first study of session.
 * @param {bool}  
 */
function showOrClearSession(show) {
    var cacheIndicatorElement = $("#cacheIndicator");
    var imageThumbnailViewElement = $("#img");

    if (show) {
        if (showStudyCacheIndicator) {
            cacheIndicatorElement.show();
        }
        var leftPos = THUMBNAIL_PANEL_WIDTH + 6 + "px";
        document.getElementById("viewer").style.left = leftPos;
        imageThumbnailViewElement.show();
        $(".ui-layout-resizer ").show();
        //VAI-1316: TODO - Commented out for Fortify. Do we even use this? $(this).trigger("resize", isSessionCleared);

        var viewportHeight = document.getElementById("tablestudyViewer1x1").style.height;
        viewportHeight = viewportHeight.replace('px', '');
        document.getElementById("tablestudyViewer1x1").style.height = (parseInt(viewportHeight) + 15) + "px";

        $("#preferencesButton").removeClass("k-state-disabled");
        $("#studyLevel_wrapper").removeClass("k-state-disabled");
    } else {
        isSessionCleared = true;
        studyLayoutValue = "1x1";
        dicomViewer.tools.changeStudyLayout(1, 1, undefined, undefined);
        dicomViewer.viewports.removeAllViewports();
        if (showStudyCacheIndicator) {
            cacheIndicatorElement.hide();
        }
        imageThumbnailViewElement.hide();
        $(".ui-layout-resizer ").hide();
        document.getElementById("viewer").style.left = "0px";
        $("#viewer").width("100%");
        $("#tablestudyViewer1x1").width("95%");

        $("#pName").html("&nbsp<font color='#E8E8E8' size='2'>" + "" + "</font>");
        $("#dob").html("&nbsp<font color='#E8E8E8' size='1.5'>" + "" + "</font>");
        $("#pName").attr("title", "");
        $("#dob").attr("title", "");

        $("#preferencesButton").addClass("k-state-disabled");
        $("#studyLevel_wrapper").addClass("k-state-disabled");
    }
}

/**
 *Adjust the layout when removing the study 
 */
function adjustLayout() {
    try {
        var allViewports = dicomViewer.viewports.getAllViewports();
        var LoadedStudy = 0;

        var studyList = dicomViewer.getListOfStudyUid();
        if (studyList) {
            LoadedStudy = studyList.length;
        }

        var rows = 0;
        var columns = 0;
        switch (LoadedStudy) {
            case 1:
                {
                    rows = 1;
                    columns = 1;
                    break;
                }
            case 2:
                {
                    rows = 1;
                    columns = 2;
                    break;
                }
            case 3:
                {
                    rows = 1;
                    columns = 3;
                    break;
                }

            case 4:
                {
                    rows = 2;
                    columns = 2;
                    break;
                }
            case 5:
            case 6:
                {
                    rows = 2;
                    columns = 3;
                    break;
                }
            case 7:
            case 8:
            case 9:
                {
                    rows = 3;
                    columns = 3;
                    break;
                }
        }
        dicomViewer.tools.reOrderExistingStudyUids();
        dicomViewer.setStudyLayout(rows, columns);
        dicomViewer.tools.setSelectedStudyLayout(rows, columns);
        studyLayoutValue = rows + "x" + columns;
        removeUnoccupiedViewPorts();
    } catch (e) {}
}

/**
 * show and hide the close icon
 */
function showAndHideCloseIcon() {
    try {
        var allViewports = dicomViewer.viewports.getAllViewports();

        for (var key in allViewports) {
            var viewportTemp = allViewports[key];
            var visibility = viewportTemp.studyUid == undefined ? "hidden" : "visible";
            var studyViewerId = viewportTemp.seriesLayoutId.split("_")[1];
            document.getElementById(studyViewerId + "_close").style.visibility = visibility;
            visibility = viewportTemp.studyUid == undefined ? "none" : "block";
            document.getElementById("seriesDisplay" + studyViewerId).style.display = visibility;
        }
    } catch (e) {}
}

/**
 * Get the user DUZ
 */
function getUserDuz() {
    try {
        if (!userPreferences) {
            return -1;
        }

        return parseInt(userPreferences.id);
    } catch (e) {}

    return -1;
}

/**
 * Update the user preferences 
 */
var userPreferences = undefined;

function updateUserPreferences() {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "updateUserPreferences ", "Start");

        var userDetailsUrl = dicomViewer.getUserDetailsUrl();
        $.ajax({
                url: userDetailsUrl,
                cache: false,
                async: false
            })
            .done(function (data) {
                if (data) {
                    userPreferences = data;
                    canPrint = (data.canPrint !== undefined ? data.canPrint : true);
                    canExport = canPrint;
                }
            })
            .fail(function (data) {
                sendViewerStatusMessage("500", "Failed to get the user information from server");
            })
            .error(function (xhr, status) {
                var description = xhr.statusText + "\nFailed to get the user information from server";
                sendViewerStatusMessage(xhr.status.toString(), description);
            });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }

}

/**
 * Update the prefences 
 */
function updatePreferences() {
    updateUserAnnotationPreferences();
    updateUserPreferences();
    updateFeatureFlags();
}

/**
 * Show and hide the 6000Overlay menu
 * @param {Type} seriesLayout  - it specifies the active series layout
 */
function showAndHide6000OverlayMenu(seriesLayout) {
    try {
        var studyDetails = dicomViewer.getStudyDetails(seriesLayout.studyUid);
        if (studyDetails.is6000OverLay) {
            $("#showHideOverlay6000").show();
            $("#showHideOverlay6000_overflow").show();
        } else {
            $("#showHideOverlay6000").hide();
            $("#showHideOverlay6000_overflow").hide();
        }
    } catch (e) {}
}

/**
 * 
 * update the image print reasons
 */
function updatePrintImageReasons() {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "updatePrintImageReasons", "Start");

        $("#reasonForPrintImage").empty();
        $.ajax({
                url: dicomViewer.getPrintReasonsUrl(),
                cache: false,
                async: true
            })
            .done(function (data) {
                if (data == undefined || data == null) {
                    return;
                }

                var reasons = "";
                data.forEach(function (reason) {
                    reasons += "<option value='" + reason + "'>" + reason + "</option>";
                });

                $("#reasonForPrintImage").html(reasons);

                dumpConsoleLogs(LL_INFO, undefined, "updatePrintImageReasons", "End", (Date.now() - t0));
            })
            .fail(function (data) {})
            .error(function (xhr, status) {
                var deescription = xhr.statusText + "\nFailed to update print image reason";
                dumpConsoleLogs(LL_ERROR, undefined, "updatePrintImageReasons", deescription);
            });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, "updatePrintImageReasons", e.message);
    } finally {

    }
}

/**
 * 
 * Update the feature flags
 */
function updateFeatureFlags() {
    try {
        isPState = false;
        isVerifySignature = false;
        isShowLogs = false;
        isReformatContentDateTime = false;

        var flags = BasicUtil.getUrlParameter("Flags");
        if (flags) {
            flags = flags.toUpperCase();

            if (flags.indexOf("PSTATE") !== -1) {
                isPState = true;
            }

            if (flags.indexOf("ESIGNATURE") !== -1) {
                isVerifySignature = true;
            }

            if (!isShowLogs && flags.indexOf("LOG") !== -1) {
                isShowLogs = true;
            }
        }

        var FContentDateTime = BasicUtil.getUrlParameter("FContentDateTime");
        if (FContentDateTime) {
            FContentDateTime = FContentDateTime.toUpperCase();

            if (FContentDateTime.indexOf("TRUE") !== -1) {
                isReformatContentDateTime = true;
            }
        }
    } catch (e) {}
}

/**
 * Get the image urn
 * @param {Type} fileName - Specifies the file name
 */
function getImageUrn(image) {
    try {
        var imageTokens = image.fileName.split("&");
        if (imageTokens.length > 0) {
            var imageUrn = imageTokens[0].split("=");
            if (imageUrn.length > 1) {
                return imageUrn[1];
            }
        }
    } catch (e) {}

    return "";
}

/**
 * Remove the unoccupied viewport
 */
function removeUnoccupiedViewPorts() {
    try {
        var allViewports = dicomViewer.viewports.getAllViewports();
        if (allViewports !== null && allViewports !== undefined) {
            $.each(allViewports, function (key, value) {
                if (value.studyUid === undefined) {
                    dicomViewer.viewports.removeViewport(key);
                }
            });
        }
    } catch (e) {}
}

/**
 * Show and hide play button and overflow button
 */
function showAndHidePlayButton(isTimeOut) {
    try {
        if (isTimeOut) {
            if ($("#prefMenu").is(':visible')) {
                showOrHidePrefMenu("hide");
                showOrHidePrefMenu("show");
            } else {
                showOrHidePrefMenu("show");
                showOrHidePrefMenu("hide");
            }
            if (!$(".resp-accordion").is(':visible')) {
                $('.resp-tab-item.resp-tab-active').click();
            }
        }
    } catch (e) {}
}

/**
 * Show external links in dropdown list
 * @param {Type} checkLink 
 */
function showExternalLinks(checkLink) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "showExternalLinks ", "Start");

        var url = baseViewerURL + "/extLinks";
        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            async: false,
            success: function (data) {
                if (data.length > 0) {
                    $.each(data, function (index, item) {
                        if (!checkLink) {
                            var isMenuItemExist = document.getElementById("externalLink" + index) ? true : false;
                            if (isMenuItemExist) {
                                return;
                            }
                            var child = createExternalLinkMenuItem(index, item);
                            child.appendTo("#contextExternalLinkPanel");
                        } else if (item.Type !== 1) {
                            if (!invokerIsQA()) {
                                document.getElementById("externalLinksDiv").style.display = "block";
                                document.getElementById("helpLinkDiv").style.display = "none";
                            } else {
                                $('#externalLinks').hide();
                            }
                        }
                    });
                } else {
                    $('#externalLinks').hide();
                }
            },
            error: function (xhr, status) {
                var description = xhr.statusText + " : Failed to get external links";
                sendViewerStatusMessage(xhr.status.toString(), description);
                dumpConsoleLogs(LL_ERROR, undefined, undefined, description);
            }
        });
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
    } finally {
        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
    }
}

/**
 * Create context menu items with available external link
 * @param {Type} index 
 * @param {Type} item 
 */
function createExternalLinkMenuItem(index, item) {
    try {
        var li = $("<li id=\"externalLink" + index + "\"style='margin-top: 5px;'>");
        var logo = item.type === 1 ? "images/help.png" : "images/general-link.png";
        var path = window.location.origin + "/" + item.path + window.location.search;

        li.append("<img src='" + logo + "' style='width: 16px;height: 16px; margin-left: 2px; margin-right: 5px'></img><a href=\"#\" style=\"font-size: 12px; color: white; margin-left: 2px; margin-right: 5px\" onclick='gotoUrl( \"" + path + "\", \"" + item.display + "\" )' >" + item.name + "</a>");
        li.append($("</li>"));
        return li;
    } catch (e) {}

    return undefined;
}

/**
 * Handles page navigation
 * @param {Type} isCineRunning 
 */
function handlePageNavigation(isCineRunning) {
    try {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout === undefined || seriesLayout === null) {
            return;
        }

        var selectedStudyUid = seriesLayout.getStudyUid();
        if (isCineRunning || selectedStudyUid === undefined || selectedStudyUid === null ||
            (seriesLayout.seriesIndex == undefined && seriesLayout.imageType == undefined)) {
            showOrHidePageNavigation("hide");
        } else {
            var selectedSeriesIndex = seriesLayout.getSeriesIndex();
            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(selectedStudyUid, selectedSeriesIndex);
            var seriescount = dicomViewer.Study.getSeriesCount(selectedStudyUid);
            var imagecount = dicomViewer.Series.getImageCount(selectedStudyUid, selectedSeriesIndex);
            var seriesLayoutMaxId = isFullScreenEnabled ? dicomViewer.getCurrentSeriesLayoutIds() : dicomViewer.viewports.getSeriesLayoutMaxId();
            var selectedImageIndex = seriesLayout.getImageIndex();
            var framecount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(selectedStudyUid, selectedSeriesIndex, selectedImageIndex));
            if (seriesLayoutMaxId !== undefined) {
                var selectedIndex = undefined;
                var rowColumnValue = seriesLayoutMaxId.split('_')[2];
                var imageLayoutDim = seriesLayout.getImageLayoutDimension();
                if (isMultiFrame) {
                    if (rowColumnValue === "1x1") {
                        if (imageLayoutDim !== "1x1") {
                            if (framecount <= 1) {
                                showOrHidePageNavigation("hide");
                            } else {
                                selectedIndex = seriesLayout.scrollData.frameIndex;
                                checkBoundaryCondition("frame", imageLayoutDim, framecount, selectedIndex);
                            }
                        } else {
                            showOrHidePageNavigation("hide");
                        }
                    } else if (imagecount <= 1) {
                        showOrHidePageNavigation("hide");
                    } else {
                        selectedIndex = seriesLayout.scrollData.imageIndex;
                        checkBoundaryCondition("image", rowColumnValue, imagecount, selectedIndex);
                    }
                } else if (rowColumnValue === "1x1") {
                    if (imageLayoutDim !== "1x1") {
                        selectedIndex = seriesLayout.scrollData.imageIndex;
                        checkBoundaryCondition("image", imageLayoutDim, imagecount, selectedIndex);
                    } else {
                        showOrHidePageNavigation("hide");
                    }
                } else {
                    if (seriescount <= 1) {
                        showOrHidePageNavigation("hide");
                    } else {
                        selectedIndex = selectedSeriesIndex;
                        checkBoundaryCondition("series", rowColumnValue, seriescount, selectedIndex);
                    }
                }
            }
        }
    }
    catch(e) {}
}

/**
 * Check for First and Last page conditions
 * @param {Type}
 */
function checkBoundaryCondition(navigationType, layout, totalCount, selectedIndex) {
    var rowCol = layout.split('x');
    var count = rowCol[0] * rowCol[1];

    var viewportPos = 0;
    if (navigationType == "series" && navigationType == "series") {
        viewportPos = getViewportPosition(layout);
        showOrHidePageNavigation("show", navigationType);
        diff = count - viewportPos;

        if ((viewportPos - (selectedIndex + 1) < 0) && (selectedIndex + diff + 1) < totalCount) {
            showOrHidePageNavigation("show", navigationType);
        } else if (selectedIndex + diff + 1 < totalCount) {
            showOrHidePageNavigation("first");
        } else if (((selectedIndex + 1) - viewportPos) > 0) {
            showOrHidePageNavigation("last");
        } else {
            showOrHidePageNavigation("hide");
        }
    } else {
        if (count < totalCount) {
            showOrHidePageNavigation("show", navigationType);
            if (selectedIndex - count < 0) {
                showOrHidePageNavigation("first");
            } else if ((totalCount - 1 - selectedIndex) < count) {
                showOrHidePageNavigation("last");
            }
        } else {
            showOrHidePageNavigation("hide");
        }
    }
}

function getViewportPosition(layout) {
    try {
        var viewportPos = 0;
        var activeSeries = dicomViewer.getActiveSeriesLayout();
        if (activeSeries) {
            var x = layout.split("x");
            var aLayout = activeSeries.seriesLayoutId;
            aLayout = aLayout.split("_");
            aLayout = aLayout[aLayout.length - 1];
            if (aLayout) {
                var val = aLayout.split("x")
                var val1 = val[0];
                var val2 = val[1];

                if (x[1] == 1) {
                    viewportPos = parseInt(val1);
                } else if (x[0] == 3 && x[1] == 2 && !val1 == 1) {
                    if (val1 == 2) {
                        viewportPos = parseInt(val1) + parseInt(val2);
                    } else {
                        viewportPos = parseInt(val1) + parseInt(val2) + 1;
                    }
                } else if (val1 == 1) {
                    viewportPos = parseInt(val1) * parseInt(val2);
                } else {
                    viewportPos = parseInt(val2) + parseInt(x[1]);
                }
                return viewportPos;
            }
        }
    } catch (e) {
        return 0;
    }
}

/**
 * Find series or image index range in the selected layout
 * @param {Type}
 */
function findIndexRange(navigationType) {
    try {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var seriesLayouts = dicomViewer.viewports.getAllViewports();
        if (isFullScreenEnabled) {
            seriesLayouts = {};
            seriesLayouts[activeSeriesLayout.seriesLayoutId] = activeSeriesLayout;
        }

        var indexArrays = new Array();
        if (seriesLayouts !== null && seriesLayouts !== undefined) {
            $.each(seriesLayouts, function (key, value) {
                if (value.studyUid && activeSeriesLayout.studyUid) {
                    if (value.studyUid == activeSeriesLayout.studyUid) {
                        if (navigationType === "image" || navigationType === "frame") {
                            var addDuplicate = true;
                            var imageLayout = value.getImageLayoutDimension().split("x");
                            for (var i = 0; i < parseInt(imageLayout[0]); i++) {
                                for (var j = 0; j < parseInt(imageLayout[1]); j++) {
                                    renderer = value.getImageRender(value.seriesLayoutId + "ImageLevel" + i + "x" + j);
                                    if (renderer) {
                                        var index = -1;
                                        if (navigationType === "frame") {
                                            index = parseInt(renderer.anUIDs.split('*')[1]);
                                        } else {
                                            index = renderer.imageIndex;
                                        }

                                        if (indexArrays.indexOf(index) == -1 || addDuplicate) {
                                            indexArrays.push(index);
                                        }
                                        addDuplicate = false;
                                    }
                                }
                            }
                        } else if (navigationType === "series") {
                            indexArrays.push(value.getSeriesIndex());
                        }
                    }
                }
            });
        }
        return indexArrays;
    } catch (e) {}

    return undefined;
}

/**
 * Show or hide page navigation controls
 */
function showOrHidePageNavigation(display, navigationType) {
    if (isFullScreenEnabled) {
        display = (navigationType === "image" || navigationType === "frame" || navigationType === undefined) ? display : "hide";
    }
    if (display == "show") {
        $("#pageNavigationTool").show();
        $("#pageFiledSet").show();
        $("#pPreviousPage").removeClass("k-state-disabled");
        $("#pPreviousPage_overflow").removeClass("k-state-disabled");
        $("#pNextPage").removeClass("k-state-disabled");
        $("#pNextPage_overflow").removeClass("k-state-disabled");
    } else if (display == "hide") {
        $("#pageNavigationTool").hide();
        $("#pageFiledSet").hide();
    } else if (display == "last") {
        $("#pPreviousPage").removeClass("k-state-disabled");
        $("#pPreviousPage_overflow").removeClass("k-state-disabled");
        $("#pNextPage").addClass("k-state-disabled");
        $("#pNextPage_overflow").addClass("k-state-disabled");
    } else if (display == "first") {
        $("#pPreviousPage").addClass("k-state-disabled");
        $("#pPreviousPage_overflow").addClass("k-state-disabled");
        $("#pNextPage").removeClass("k-state-disabled");
        $("#pNextPage_overflow").removeClass("k-state-disabled");
    }
}

/**
 * dump the logs in console
 */
function dumpConsoleLogs(logType, headerMessage, methodName, logMessage, timeElapsed, isAsync, skipConsole) {
    try {
        if (!dicomViewer.logUtility.isLogLevelEnabled(logType)) {
            return;
        }
        if (headerMessage) {
            headerMessage = "\n************************************ \
                                  \n" + headerMessage + "\n \
                                  ************************************";
            var logParam = {
                level: logType,
                type: "header",
                message: headerMessage
            }
            dicomViewer.logUtility.writeLog(logParam);
        }
        if (methodName) {
            var logParam = {
                level: logType,
                message: "Method : " + methodName.toUpperCase()
            }
            dicomViewer.logUtility.writeLog(logParam, true);
        }
        if (logMessage) {
            var duration = (timeElapsed) ? ("\n \t\tTime Elapsed : " + timeElapsed + "ms") : "";
            logMessage = (logMessage + duration);
            var logParam = {
                level: logType,
                message: logMessage
            }
            dicomViewer.logUtility.writeLog(logParam, isAsync, skipConsole);
        }
    } catch (e) {}
}

/**
 * Get the display settings
 * @param {Type} modality - Specify the modality
 */
function GetCacheDisplaySettings(data, modality) {
    try {
        if (invokerIsQA()) {
            return getDefaultDisplaySettings(modality);
        }

        var displayPref = BasicUtil.getUrlParameter('PrefOption');
        if (!displayPref) {
            return GetDisplaySettings(modality);
        }

        if (!data.displayPref || data.displayPref === "[]") {
            return getDefaultDisplaySettings(modality);
        }

        return processAndGetDisplaySettings(data.displayPref, modality);
    } catch (e) {}
}

/**
 * Process and get the display settings
 * @param {Type} data - Specifies the display settings
 * @param {Type} modality - Specifies the modality
 */
function processAndGetDisplaySettings(data, modality) {
    var displaySettings = getDefaultDisplaySettings(modality);

    try {
        var displaySettingsArray = JSON.parse(data).preference;
        if (Object.prototype.toString.call(displaySettingsArray) == '[object Object]') {
            displaySettingsArray = Object.keys(displaySettingsArray).map(function (key) {
                return displaySettingsArray[key];
            });
        }

        if (displaySettingsArray == null || displaySettingsArray.length == 0) {
            return displaySettings;
        }

        // Show or hide the embed pdf viewer 
        var generalSettings = displaySettingsArray.filter(function (obj) {
            return (obj.modality == "General");
        })[0];

        var selectedZoomMode = undefined;
        if (generalSettings != undefined) {
            if (generalSettings.useEmbedPdfViewer != undefined) {
                embedPdfViewer.isGenreal = true;
                if (generalSettings.useEmbedPdfViewer == "false") {
                    embedPdfViewer.isGenreal = false;
                    selectedZoomMode = generalSettings.zoomMode;
                }
            } else {
                embedPdfViewer.isGenreal = true;
            }
        }

        var selectedDisplaySettings = displaySettingsArray.filter(function (obj) {
            return (obj.modality == modality);
        })[0];

        if (selectedDisplaySettings != undefined) {
            if (modality == "ECG") {
                embedPdfViewer.isECGPdf = selectedDisplaySettings.useEmbedPdfViewer == "false" ? false : true;
                selectedZoomMode = selectedDisplaySettings.zoomMode;
            }

            var zoomMode = displaySettings.ZoomMode;
            var presentationMode = displaySettings.PresentationMode;
            var zoomLevel = displaySettings.ZoomLevel;
            var isECG = displaySettings.IsECG;
            var zoomModeOption = (selectedZoomMode != undefined) ? selectedZoomMode : selectedDisplaySettings.zoomMode;

            if (zoomModeOption !== undefined) {
                switch (zoomModeOption) {
                    case "Fit-to-window":
                        zoomLevel = 1;
                        break;
                    case "Fit-width-to-window":
                        zoomLevel = 2;
                        break;
                    case "Fit-height-to-window":
                        zoomLevel = 3;
                        break;
                    default:
                        presentationMode = "MAGNIFY";
                        zoomLevel = 0;
                        break;
                }
            }

            displaySettings = {
                Rows: selectedDisplaySettings.rows,
                Columns: selectedDisplaySettings.columns,
                ZoomMode: zoomMode,
                PresentationMode: presentationMode,
                ZoomLevel: zoomLevel,
                IsECG: isECG
            };

            return displaySettings;
        }
    } catch (e) {}

    return displaySettings;
}

/**
 * Checks whether the input object is empty or not
 * @param {Type} obj 
 */
function isEmptyObject(obj) {

    // Speed up calls to hasOwnProperty
    var hasOwnProperty = Object.prototype.hasOwnProperty;

    // null and undefined are "empty"
    if (obj == null) return true;

    // Assume if it has a length property with a non-zero value
    // that that property is correct.
    if (obj.length > 0) return false;
    if (obj.length === 0) return true;

    // If it isn't an object at this point
    // it is empty, but it can't be anything *but* empty
    // Is it empty?  Depends on your application.
    if (typeof obj !== "object") return true;

    // Otherwise, does it have any properties of its own?
    // Note that this doesn't handle
    // toString and valueOf enumeration bugs in IE < 9
    for (var key in obj) {
        if (hasOwnProperty.call(obj, key)) return false;
    }

    return true;
}

function showOrHidePrefMenu(event) {
    var width = null;
    var isIE = isInternetExplorer();
    if (event == "show") {
        $("#prefMenu").show();
        $("#collapsePrefMenu").show();
        $("#showPrefMenu").hide();
        $('.col-sm-9').css('width', '0');

        width = $("#content_View").width() - $("#prefMenu").width() - 30;
        if (width < 100) {
            width = $("#content_View").width();
        }
        $('.col-sm-9').css('width', width);
        //$('.pageHeader').hide();
        hideAccordionTabs();
        $('.resp-tab-item.resp-tab-active').click();
    } else if (event == "hide") {
        $("#prefMenu").hide();
        $("#collapsePrefMenu").hide();
        $("#showPrefMenu").show();
        $('.col-sm-9').css('width', (isIE ? '100%' : '-webkit-fill-available'));
        //$('.pageHeader').show();
        hideAccordionTabs();
    }
}

/**
 * Update the preference loading status
 * @param {Type} preference - Specifies the preference type
 * @param {Type} type - Specifies the preference load type
 * @param {Type} preferenceData - Specifies the preference data
 * @param {Type} isUpdate - Specifies the flag to update the preference data to server
 */
var preferenceLoadingStatus = [];

function updatePreferenceLoadingStatus(preference, type, preferenceData, isUpdate) {
    try {
        var preferencekey = preference + "_" + type;
        var preferenceDispText = preference + " " + type.toLowerCase();
        var loadingStatus = {};
        if (!preferenceLoadingStatus[preferencekey]) {
            loadingStatus = {
                status: (isUpdate ? " Sending " : " Fetching ") + preferenceDispText + " preferences",
                canDisplay: true,
                isSuccess: true
            };
            preferenceLoadingStatus[preferencekey] = loadingStatus;
        } else {
            loadingStatus = preferenceLoadingStatus[preferencekey];
            loadingStatus.status = (isUpdate ? " Updated " : " Applied ") + preferenceDispText + " preferences";
            loadingStatus.canDisplay = false;
            if (!preferenceData) {
                loadingStatus.isSuccess = false;
                loadingStatus.status = " Failed to" + (isUpdate ? " update " : " fetch ") + preferenceDispText + " preferences. Restoring to default";
            }
        }

        if ($("#preferenceStatus")[0]) {
            $('#preferenceStatus_div').show();
            $("#preferenceStatus")[0].innerText = loadingStatus.status;
            setTimeout(function () {
                $('#preferenceStatus_div').hide();
                preferenceLoadingStatus = [];
            }, 2500);
        }

        switch (preference) {
            case "cine":
            case "ecg":
            case "annotation":
            case "layout":
            case "copyattributes":
            case "log":
                break;
            default:
                dumpConsoleLogs(LL_WARN, undefined, "updatePreferenceLoadingStatus", "Unsupported preference type: " + preference);
                break;
        }
    } catch (e) {}
}

function isEmbedPdfViewer(imageType) {
    if ((!embedPdfViewer.isGenreal && (imageType === IMAGETYPE_PDF || imageType === IMAGETYPE_TIFF)) ||
        (!embedPdfViewer.isECGPdf && imageType === IMAGETYPE_RADPDF)) {
        return true;
    }
    return false;
}

/**
 * Updated the lead type signals of ECG
 */
function updateEcgLeadSignal() {
    try {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout) {
            var layoutDivId = seriesLayout.getSeriesLayoutId();
            seriesLayout.leadValue["ledselection"] = $("#ledselection")[0].value;
            seriesLayout.leadValue["3x43one"] = $("#3x43one")[0].value;
            seriesLayout.leadValue["3x43two"] = $("#3x43two")[0].value;
            seriesLayout.leadValue["3x43three"] = $("#3x43three")[0].value;
            seriesLayout.leadValue["3x41Value"] = $("#3x41Value")[0].value;
            leadTypeObject[layoutDivId] = $.extend({}, leadTypeObject[layoutDivId], seriesLayout.leadValue);
        }
    } catch (e) {}
}

/**
 * create the worker queue for image cache
 * @param {Type} workerJob -  job details
 */

var workerQueues =
{
    isInitialized: false,
    priority: {
        maxNoOfQueue: 5,
        queueIncrementor: 0,
        workers: [],
        seriesIndex: undefined,
        imageIndex: undefined
    },
    background: {
        maxNoOfQueue: 5,
        queueIncrementor: 0,
        workers: []
    }
};

var PRIORITY_ACTIVE = 1;
var PRIORITY_VISIBLE = 2;
var PRIORITY_BACKGROUND = 3;

function doWorkerQueue(workerJob) {
    try {
        if (!workerQueues.isInitialized) {
            workerQueues.isInitialized = true;

            /* Background worker callback */
            var notifyBgTaskCallback = function () {
                workerQueues.background.workers.forEach(function (w) {
                    //w.resume();
                });
            };

            /* Priority queues */
            for (var index = 0; index < workerQueues.priority.maxNoOfQueue; index++) {
                workerQueues.priority.workers.push(new WorkerQueue("js/dicom/imageCacheWorker.js", notifyBgTaskCallback));
            }

            /* Background queues */
            for (var index = 0; index < workerQueues.background.maxNoOfQueue; index++) {
                workerQueues.background.workers.push(new WorkerQueue("js/dicom/imageCacheWorker.js"));
            }
        }

        var isPriority = (workerJob.priority == PRIORITY_ACTIVE && workerJob.type == "cache");
        var queue = (isPriority ? workerQueues.priority : workerQueues.background);
        var isResetQueue = !workerJob.isCineRunning && isPriority;
        if (isResetQueue) {
            if (queue.seriesIndex == undefined || queue.imageIndex == undefined) {
                isResetQueue = false;
                queue.seriesIndex = workerJob.seriesIndex;
                queue.imageIndex = workerJob.imageIndex;
            } else {
                isResetQueue = (workerJob.isMultiframe ? queue.imageIndex != workerJob.imageIndex : queue.seriesIndex != workerJob.seriesIndex);
            }
        }

        if (isResetQueue) {
            /* update the series index */
            queue.seriesIndex = workerJob.seriesIndex;
            queue.imageIndex = workerJob.imageIndex;

            /* pause the background queues */
            workerQueues.background.workers.forEach(function (w) {
                //w.pause();
                w.reset();
            });

            /* pause the priority queues */
            workerQueues.priority.workers.forEach(function (w) {
                //w.pause();
                w.reset();
            });

            dicomViewer.resetCache(workerJob.studyUid, workerJob.seriesIndex, workerJob.imageIndex);

            /* move the existing priority tasks to background queue */
            /*workerQueues.priority.workers.forEach(function(w) {
                var task = w.shiftTask();
                do {
                    if(task) {
                        if (workerQueues.background.queueIncrementor >= workerQueues.background.maxNoOfQueue) {
                            workerQueues.background.queueIncrementor = 0;
                        }
                        workerQueues.background.workers[queue.queueIncrementor++].push(task);
                        task = w.shiftTask();
                    }
                } while(task);
                w.resume();
                w.reset();
            });*/
        }

        if (queue.queueIncrementor >= queue.maxNoOfQueue) {
            queue.queueIncrementor = 0;
        }

        var workerQueue = queue.workers[queue.queueIncrementor++];
        var workerThread = new WorkerThread(workerJob);
        workerQueue.push(function () {
            return workerThread.processJob(workerQueue);
        });
    } catch (e) {}
}

/**
 * Scroll the page using mouse whell
 * @param {Type} event - MouseWheel event
 */
function onMouseWheel(event) {
    try {
        if (!event) {
            return;
        }

        var activeSeries = dicomViewer.getActiveSeriesLayout();

        if (!activeSeries) {
            return;
        }
        var elementId = activeSeries.seriesLayoutId;
        if (activeSeries.imageType == IMAGETYPE_CDA || activeSeries.imageType == IMAGETYPE_RADSR) {
            elementId = "SR" + elementId;
        }

        var element = document.getElementById(elementId);
        var scrollInc = 40;
        var scrollDown = event.wheelDelta < 0 || event.detail > 0;
        if (!scrollDown) { // Wheel up
            element.scrollTop = ((element.scrollTop - scrollInc) <= 0) ? 0 : element.scrollTop - scrollInc;
        } else { // Wheel down
            element.scrollTop = ((element.scrollTop + scrollInc) >= element.scrollHeight) ? element.scrollHeight : element.scrollTop + scrollInc;
        }
    } catch (e) {}
}

function UpdateImageType() {
    try {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (!seriesLayout) {
            return;
        }

        var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);

        var isSingleFrameUS = false;
        var imageCount = 0;
        var frameCount = 0;
        imageCount = dicomViewer.Series.getImageCount(seriesLayout.studyUid, seriesLayout.seriesIndex);
        frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
        imageCount = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex) ? frameCount : imageCount;

        if (!image) {
            return;
        }

        if (imageCount == 1) {
            isSingleFrameUS = true;
        }

        if (image.modality === "US" && isSingleFrameUS) {
            seriesLayout.setImageType(IMAGETYPE_RADECHO);
        } else {
            seriesLayout.setImageType(image.imageType);
        }
        dicomViewer.enableOrDisableTools(image.modality, seriesLayout);
    } catch (e) {}
}

/**
 * 
 * @param {Type} type - Specifies the request type
 * @param {Type} isThumbnail - flag to know the request from thumbnail
 */
function prepareQARequest(type, isThumbnail) {
    try {
        if (invokerIsQA()) {
            var data = {
                type: type,
                imageUrn: [],
                target: "QA"
            };

            var split = ["-", 1];
            if (type == QAType.deleteImage) {
                split = ["$$$", 0];
            }

            var imageUrns = [];
            var parent = isThumbnail ? "#imageThumbnail_View input:checked" : ".selected-thumbnail-view";
            $(parent).each(function () {
                var id = this.id.replace("chk", "thumb");
                var thumbData = $("#" + id)[0].data;
                var imageIEN = (thumbData.imageUrn).split(split[0])[split[1]];
                data.imageUrn.push(imageIEN);
                data.studyId = thumbData.studyId;
            });
            sendQaMessage(data);
        }
    } catch (e) {}
}

/**
 * Thumbnail check event fot study,series and image level
 * @param {Type} ev 
 */
function thumbnailCheckEvent(ev) {
    try {
        if (event.shiftKey) {
            if (!$(".selected-thumbnail-view")[0]) {
                return;
            }

            var selectedImageId = $(".selected-thumbnail-view")[0].id;
            if (!selectedImageId) {
                return;
            }

            var currentImageId = ev.id;
            currentImageId = currentImageId.replace("chk", "thumb");
            var selectedImageData = $("#" + selectedImageId)[0].data;
            var currentImageData = $("#" + currentImageId)[0].data;

            if (selectedImageData && currentImageData &&
                selectedImageData.studyId !== currentImageData.studyId) {
                document.getElementById(ev.id).checked = false;
                return;
            }
            var index1 = currentImageData.index;
            var index2 = selectedImageData.index;
            var isChangeSeries = false;
            var isAddIndex = true;
            if (index1 == 0 && index2 == 0 && selectedImageData.seriesIndex != undefined) {
                index1 = currentImageData.seriesIndex;
                index2 = selectedImageData.seriesIndex;
                isChangeSeries = true;
            } else if (selectedImageData.seriesIndex == undefined) {
                isAddIndex = false;
            }
            for (var index = Math.min(index1, index2); index <= Math.max(index1, index2); index++) {
                var seriesIndex = 0;
                var imageIndex = index;
                if (isChangeSeries) {
                    seriesIndex = index;
                    imageIndex = 0;
                } else if (!isAddIndex) {
                    seriesIndex = index;
                    imageIndex = "";
                }
                var thumbId = 'imageviewer_' + dicomViewer.replaceDotValue(currentImageData.studyUid) + "_" + seriesIndex + "_chk" + imageIndex;
                document.getElementById(thumbId).checked = ev.checked;
            }
        }
    } catch (e) {}
}

/**
 * 
 * @param {Type} type - Specifies the request type
 * @param {Type} isThumbnail - flag to know the request from thumbnail
 */
function disableQATools() {
    if (invokerIsQA()) {
        playerFiledSetElement.hide();
        $("#scoutLine").hide(); //cross reference line
        $("#scoutLine_overflow").hide(); //cross reference line
        document.getElementById("context-link-crossRefLineSelector").style.display = "none"
        $("#context-link-menu").hide();
        $("#repeteOption").hide();
        $("#repeteOption_overflow").hide();
    }
}

/**
 * Process QA request
 * @param {Type} data - Specifies the data
 */
function processQaRequest(data) {
    try {
        if (data && data.target == "Viewer") {
            switch (data.type) {
                case QAType.imageStatus:
                    {
                        requestStudyDetails();
                        break;
                    }

                case QAType.addStudy:
                    {
                        if (data.metaData) {
                            window.location.replace(data.metaData.Url);
                        }
                        break;
                    }

                default:
                    break;
            }
        } else {
            // Invalid target request
        }
    } catch (e) {}
}

/**
 * Update image status
 * @param {Type} data - Specifies the data
 */
function requestStudyDetails() {
    try {
        dicomViewer.measurement.showAndHideSplashWindow("show", "Updating image status...", "dicomViewer");
        $.ajax({
                type: 'GET',
                url: dicomViewer.geStudyDetailsUrl(),
                async: true,
                cache: false,
            })
            .success(function (data) {
                updateImageStatus(data);
            })
            .fail(function (data, textStatus, errorThrown) {
                dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to update the image status");
            })
            .error(function (data, status) {
                dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to update the image status");
            });
    } catch (e) {}
}

/**
 * Update the image status
 * @param {Type} data - Specifies the image status
 */
function updateImageStatus(data) {
    try {
        if (data) {
            var images = [];
            data.studies.forEach(function (study) {
                study.series.forEach(function (series) {
                    series.images.forEach(function (image) {
                        images[image.imageUrn] = image;
                        images.length += 1;
                    });
                });
            });

            if (images.length > 0) {
                var parent = "#imageThumbnail_View input[type=checkbox]";
                $(parent).each(function () {
                    var thumbData = $("#" + this.id.replace("chk", "thumb"))[0].data;
                    if (thumbData) {
                        var image = images[thumbData.imageUrn];
                        if (image) {
                            try {
                                $("#" + this.id.replace("chk", "title")).html(image.imageIEN + "<br/>" + image.imageStatus);
                                $("#" + this.id.replace("chk", "title")).attr("title", image.imageStatus);
                                $("#" + this.id.replace("chk", "title")).css('color', 'red').css('font-size', '10px').css('font-weight', 'bold');
                                var thumbId = this.id.replace("chk", "thumb");
                                $("#" + thumbId).attr("title", image.imageStatus);
                                $("#" + this.id.replace("chk", "row"))[0].style.marginTop = "-10px";
                                if (!$("#" + thumbId)[0].isUpdateHgt) {
                                    $("#" + thumbId)[0].style.height = parseInt($("#" + thumbId)[0].style.height) + 4 + "px"
                                    $("#" + thumbId)[0].isUpdateHgt = true;
                                }
                            } catch (e) {}
                        }
                    }
                });
            }
        }
    } catch (e) {}
}

function getRequestHeaders(studyUid, seriesIndex, imageUid) {
    var headers = [];
    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
    headers["cachelocator"] = dicomViewer.Series.Image.getImageFilePath(studyUid, seriesIndex, imageUid);
    return headers;
}

