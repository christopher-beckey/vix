//window.onload = loadStudy;
var viewerType = "3D";
var leadTypeObject = {};
// image would load first in the viewer

var layoutMap = {};

//use to create the webworker count for caching in imageloader.js
var numberOfWebWorkers = 0;

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
var pdfToolBarElement = null;
var tiffToolBarElement = null;
var cacheIndicatorElement = null;
var showStudyCacheIndicator = true;
var myDropDown = null;

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
var copyAttributePresentaion = undefined;
var isCopyAttribute = false;
var copyAttributeLayoutId = undefined;
var isRGBToolEnabled = false;

//To hold the custom/embeded pdf viewer
var isEmbedPdfViewer = true;

var STUDY_TYPE_DICOM = "dicom";
var STUDY_TYPE_NON_DICOM = "nonDicom";

// To hold the pixel spacing and unit type
var calibrated2DPixelSpacingMap = new Map();

var activeCalibratedImage;
var iconSize = 0;

/**
 * Study layout max rows and columns
 */
var STUDY_LAYOUT_MAX_ROW = "3";
var STUDY_LAYOUT_MAX_COLUMN = "3";

var isStudyRequested = false;
var numberOfRetryAttempts = 0;
//var isStudyCacheInProgress = false;
var numberOfCacheRetryAttempts = 0;
var ecgRenderedCount = 0;
var nonDICOMRenderedCount = 0;
var nonDICOMCacheDetails = {};
var defaultViewportInThumbnailViewHiddenMode = undefined;

var activeSeriesPDFData = undefined;
var isPDFActiveSeries = false;

var THUMBNAIL_PANEL_MIN_WIDTH = ((screen.width * 135) / 1280) < 135 ? 135 : (screen.width * 135) / 1280;
var THUMBNAIL_PANEL_MAX_WIDTH = 150;
var THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MIN_WIDTH;
if (THUMBNAIL_PANEL_WIDTH > THUMBNAIL_PANEL_MAX_WIDTH) {
    THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MAX_WIDTH;
}

// Holding the compressed image data based on this flag
var isCacheCompressedImageData = true;
var dumpInConsole = false;

//Current status for print option based on the user privilege
var isPrintOptionEnabled = true;

/**
 * 
 * Enable or Disable the PState
 */
var enablePState = undefined;
function isPStateEnabled() {
    try
    { 
        if(enablePState !== undefined) {
            return enablePState;
        }

        enablePState = false;
        var pstate = BasicUtil.getUrlParameter("Flags");
        if(pstate !== undefined && pstate !== null) {
            pstate = pstate.toLocaleLowerCase();
            if(pstate === "pstate") {
                enablePState = true;
            }
        }
    }
    catch(e)
    { }

    return enablePState;
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
            cineFlag = flag;
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
    /*var innerText = "0% cached. Please wait";
    var spinner = dicomViewer.progress.updateSpinnerInnerText('viewer', innerText);
    dicomViewer.progress.putSpinner('viewer', spinner);*/
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

function sendVolumeMeasurements(value) {
}

function sendMeasurement(anatomyCode, value) {
}

function getMeasurements() {
    var measurements = [];
    var mitralValve = {
        label: "Mitral Valve",
        items: []
    };
    //mitralValve.items[mitralValve.items.length] = { label: "Mitral Valve Annulus", shortLabel: "MV ANN", id: "mitralValve.annulus", type: 0, units: "cm" };
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
    //aorticValve.items[aorticValve.items.length] = { label: "Aortic Valve Annulus", shortLabel: "AV ANN", id: "aorticValve.annulus", type: 0, units: "cm" };
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
    var studyRow = 1
    var studyColumn = 1;
    var isStudyLayoutAvailable = false;

    var studyLayout = BasicUtil.getUrlParameter('studyLayout');
    if (studyLayout != undefined) {
        var studyRowColumArray = studyLayout.split("x");
        studyRow = studyRowColumArray[0];
        studyColumn = studyRowColumArray[1];
        isStudyLayoutAvailable = true;
    }
    $("#" + studyRow + "x" + studyColumn).css("background", "#868696");

    dicomViewer.security.setSecurityToken(BasicUtil.getUrlParameter("securityToken", "", true)); //VAI-915

    var isStudyStatusRequired = BasicUtil.getUrlParameter('skipStudyStatus');
    if (isStudyStatusRequired === true || isStudyStatusRequired === "true") {
        loadStudy();
    } else {
        var patientURL = dicomViewer.getDisplayContextUrl();
        cacheAllImagesFunction(studyRow, studyColumn, patientURL, viewportElement, isStudyLayoutAvailable);
    }
});

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
//        else {
//			console.log(status);
//			if(numberOfCacheRetryAttempts < 3){				
//				isStudyCacheInProgress = true;
//				numberOfCacheRetryAttempts++;
//			} else {
//				isStudyCacheInProgress = false;
//			}

//            if(xhttp.status == 500) {
//                var description = xhttp.statusText + "\nFailed to cache all the images and the context id is: " + BasicUtil.getUrlParameter("ContextId");
//                sendViewerStatusMessage(xhttp.status.toString(), description);
//            }
//        }
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
                        setTimeout(function(){ cacheAllImagesOfStudyForSession(session); }, 2000);
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

                // Process studies
                if (totalStudiesMap.size > 0) {
                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        dicomStudy.forEach(function (study) {
                            createOrAppendStudy(study, session);
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined) {
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
            }
        });
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
                    if (study.studyId === studyDetails.studyId) {
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
                dicomViewer.startCacheImages(study.studyUid, undefined, study);
            } else {
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
    var isStudyLayoutUpdationRequired = true; 
    for (var index = 0; index < contextIds.length; index++) {
        var session = getSession(contextIds[index], contextIds.length, index);

        // Reset the flags if the study cache is not required 
        if (!session.IsStudyCacheRequired) {
            session.IsLayoutChangeRequired = false;
            session.IsAllViewportsOccupied = true;
        }

        // Change the study layout based on the unoccupied view port
        if (session.IsLayoutChangeRequired) {
            studyLayoutValue = session.Rows + "x" + session.Columns;
            dicomViewer.tools.setSelectedStudyLayout(session.Rows, session.Columns);
            if (isStudyLayoutUpdationRequired) {
                isStudyLayoutUpdationRequired = false;
                dicomViewer.setStudyLayout(session.Rows, session.Columns);
            }
        }

        // Change the view port selection based on the occupied view port.
        if (session.IsAllViewportsOccupied == false) {
            dicomViewer.changeSelection(session.SeriesLayoutId);
        }

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

function removeStudyByContextID(contextID) {
    var url = dicomViewer.getNewSubpageUrlForContext("context", contextID);
  	$.ajax({
		url: url,
		type: 'GET',
		dataType: 'json',
		async: false,
		success: function(data) {
            // Preprocess study
            var totalStudiesMap = preprocessStudy(data, contextID);
            var isContextRemoved = false;

            // Process studies
            if(totalStudiesMap.size > 0) {
                 // Process dicom images
                var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                if(dicomStudy !== null && dicomStudy !== undefined) {
                    dicomStudy.forEach(function(study) {
                        if(study.modality == "ECG"){
                            study.series.forEach(function(series){
                             series.images.forEach(function(image){
                                 if(image.imageUid !== undefined){
                                     dicomViewer.ClearECGCacheDetails(image.imageUid);
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
                if(nonDicomStudy !== null && nonDicomStudy !== undefined) {

                    // Get the non dicom study details
                    var nonDicomStudyDetails = dicomViewer.getStudyDetails(nonDicomStudy.studyUid);
                    if(nonDicomStudyDetails !== undefined && nonDicomStudyDetails !== null) { 

                        // Process thumbnail renders
                        var thumbnails = dicomViewer.thumbnail.getAllThumbnails();
                        if(thumbnails !== undefined && thumbnails !== null) {

                            // Remove the thumbnails
                            var removedThumbnails = [];
                            nonDicomStudy.forEach(function(nonDicom) {
                                // Check the thumbnail render objects 
                                $.each(thumbnails, function(key, value) {
                                    if(value.imageUid === nonDicom.imageUid) {
                                        $("#" + key).remove();
                                        removedThumbnails.push(key);
                                        isContextRemoved = true;
                                    }
                                });

                                // Check the non dicom study
                                var seriesIndex = -1; 
                                nonDicomStudyDetails.forEach(function(series) {
                                    if(series.imageUid === nonDicom.imageUid) {
                                        seriesIndex = nonDicomStudyDetails.indexOf(series);
                                    }
                                });

                                // Remove the series
                                if(seriesIndex > -1) {
                                    nonDicomStudyDetails.splice(seriesIndex, 1);
                                    if(nonDicomStudyDetails.seriesCount > 0) {
                                        nonDicomStudyDetails.seriesCount -= 1;
                                    }
                                }
                            });

                            //Remove the study level layout for removed context
                            dicomViewer.RemoveStudyLevelLayout(nonDicomStudy.studyUid);

                            // Remove the thumbnail render objects
                            if(removedThumbnails !== undefined && removedThumbnails !== null) {
                                removedThumbnails.forEach(function(thumbnail) {
                                    delete thumbnails[thumbnail];
                                });
                            }

                            // Reorder the thubnail div id based on the removed thumbnails
                            if(removedThumbnails !== undefined && removedThumbnails !== null && nonDicomStudyDetails.length > 0) {
                                var presentThumbnails = {};
                                $.each(thumbnails, function(key, value) {
                                    if(value.studyUid === nonDicomStudy.studyUid) {
                                        presentThumbnails[key] = value;
                                    }
                                });

                                // Remove the present thumbnail object from the thumbnail array
                                if(presentThumbnails !== undefined && presentThumbnails !== null) {
                                    $.each(presentThumbnails, function(key, value) {
                                        delete thumbnails[key];
                                    });
                                }

                                // Create the new thumbnail id for the present rendered thumbnails.
                                var thumbnailIndex = 0;
                                $.each(presentThumbnails, function(key, value) {
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
                            if(nonDicomStudyDetails.length == 0) {
                                var studyUid = nonDicomStudy.studyUid;
                                $("#study_thumb_" + studyUid).remove();
                                $("#break_" + studyUid).remove();
                                dicomViewer.viewports.deleteViewportsByThumbnail(studyUid);		
                                dicomViewer.removeStudyDetails(studyUid);
                                ClearNonDICOMCacheDetails(studyUid);
                            } else if(isContextRemoved) {
                                // Show the first series
                                $("#" + "imageviewer_" + nonDicomStudy.studyUid +"_0_thumb")[0].click();
                            }
                        }
                    }
                }
            }

            // Send the viewer message to server
            var decodedContextID = decodeURIComponent(contextID);
            var description = "Successfully removed the context id: " + decodedContextID + " from the session: " + getSessionId();
            if(!isContextRemoved) {
                description = "The context id: " + decodedContextID + " is not in the viewer session: " + getSessionId();
            }
            adjustLayout();
            sendViewerStatusMessage("200", description);
        },
        error: function(xhr, status) {
            var description = xhr.statusText + "\nFailed to remove the context id: " + decodeURIComponent(contextID) + "\nThe context id is not in the current session.";
            sendViewerStatusMessage(xhr.status.toString(), description);
        }
	});     
}

function loadStudy() {

    /*var viewerHeight = $("#viewer").height();
		var toolBarHeight = 70;//$("#toolBar").height();
		var playerToolBarHeight = 41;$("#playerTool").height();
		var viewportHeight = viewerHeight - (toolBarHeight+playerToolBarHeight);
		$("#viewport_View").height(viewerHeight-2);*/


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
    $("#" + studyRow + "x" + studyColumn).css("background", "#868696");
    dicomViewer.security.setSecurityToken(BasicUtil.getUrlParameter('securityToken', "", true)); //VAI-915

    var patientURL = dicomViewer.getDisplayContextUrl();
    var url = patientURL;

    ajaxRequestFunction(studyRow, studyColumn, patientURL,viewportElement,isStudyLayoutAvailable);
	
    var parentElement = $("#playForward").parent().css("background", "#868696");
    displayHydraVersion();
}

function ajaxRequestFunction(studyRow, studyColumn,url, viewportElement,isStudyLayoutAvailable) {
		var d = new Date();
		var n = d.getMilliseconds();
		var cachedUrl = url+"&_cacheBust="+n;
		var xhttp;
			if (window.XMLHttpRequest) {
				xhttp = new XMLHttpRequest();				
			} else 
			{
				// code for IE6, IE5
				xhttp = new ActiveXObject("Microsoft.XMLHTTP");				
			}
			xhttp.onreadystatechange = function() {
			if (xhttp.readyState == 4 && xhttp.status == 200) {
				var data = JSON.parse(xhttp.responseText);                

                // Get the default study layout
                var layout;
                if(isStudyLayoutAvailable === false) {
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
					if (spinner0 !== undefined){
						spinner0.stop();
						spinner0 = undefined;
					}

					var spinner = dicomViewer.progress.updateSpinnerInnerText('viewer', innerText);
					dicomViewer.progress.putSpinner('viewer', spinner);

				    //if (data.status.totalImageCount > (data.status.imagesProcessed + data.status.imagesFailed)) {
					if ((data.status.statusCode == 1) || (data.status.statusCode == 2)) {
						isStudyRequested = true;
						setTimeout(function(){ ajaxRequestFunction(studyRow, studyColumn,url, viewportElement,true); }, 3000);						
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

                    // Process dicom images
                    var dicomStudy = totalStudiesMap.get(STUDY_TYPE_DICOM);
                    if (dicomStudy !== null && dicomStudy !== undefined) {
                        dicomStudy.forEach(function (study) {
                            dicomViewer.setStudyDetails(study);
                            dicomViewer.thumbnail.createThumbnail(study.studyUid);
                            dicomViewer.overlay.initOverlayConfig();
                            dicomViewer.overlay.initMeasurementsConfig();
                            dicomViewer.xRefLine.renderXRefLines(study);
                            dicomViewer.measurement.loadPState(study.studyUid);

                            // Stop the spinner
                            dicomViewer.progress.getSpinner('viewer').stop();
                            cacheFlag = false;

                            if(selectedImageUid !== null && selectedImageUid !== undefined){
                                var selectedImagePoistions = getSelectedDicomImagePositions(study, selectedImageUid);
                                if(selectedImagePoistions !== undefined && selectedImagePoistions !== null){
                                    // Decode the image URI
                                    var imageUid = decodeURIComponent(selectedImageUid);
                                    var seriesIndex = selectedImagePoistions.SeriesIndex;
                                    var imageIndex = selectedImagePoistions.ImageIndex;

                                    imageDisplayed = true;
                                    dispalyDemographics(study);
                                    dicomViewer.setStudyLayout(studyRow, studyColumn, study.studyUid, seriesIndex, imageIndex);
                                    dicomViewer.imageLoadFirst(study.studyUid, imageUid, seriesIndex, imageIndex);
                                }
                            }

                            // Cache the study
                            if (occupiedViewportsIncrementer < occupiedViewports) {
//                                dicomViewer.startCacheImages(study.studyUid, undefined, study);
                                if (occupiedViewportsIncrementer == 0) {
                                    firstStudy = study;
                                }
                                occupiedViewportsIncrementer++;
                            }

//                            var serieLayout = dicomViewer.getActiveSeriesLayout();
//                            if (serieLayout !== null) {
//                                if (serieLayout.imageType === IMAGETYPE_RAD) {
//                                    viewportElement.css('cursor', 'url(images/brightness.cur), auto');
//                                } else if (serieLayout.imageType === IMAGETYPE_RADECHO) {
//                                    dicomViewer.tools.doPan();
//                                }
//                            }

                            // Enable the overlay true at the time of study loading
                            dicomViewer.tools.setOverlay(true);
                        });
                    }

                    // Process non dicom images
                    var nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                    if (nonDicomStudy !== null && nonDicomStudy !== undefined) {
                        // Stop the spinner
                        dicomViewer.progress.getSpinner('viewer').stop();

                        dicomViewer.setStudyDetails(nonDicomStudy);
                        dicomViewer.thumbnail.createThumbnail(nonDicomStudy.studyUid);
                        dicomViewer.measurement.loadPState(nonDicomStudy.studyUid);

                        // Cache the study
                        if (occupiedViewportsIncrementer < occupiedViewports) {
//                            dicomViewer.startCacheImages(nonDicomStudy.studyUid, undefined, nonDicomStudy);
                        }
                    }

                    // Display the images
                    if (!imageDisplayed) {
                        if(firstStudy === undefined && nonDicomStudy !== undefined) {
                            firstStudy = nonDicomStudy;
                        }

                        dispalyDemographics(firstStudy);
                        studyLayoutValue = studyRow + "x" + studyColumn;
//                      dicomViewer.setStudyLayout(studyRow, studyColumn, undefined, undefined, undefined, undefined, firstStudy.displaySettings);
                        UpdateStudyLayoutMap(firstStudy.displaySettings);
//                      dicomViewer.changeSelection("imageviewer_studyViewer1x1_1x1");
                        imageDisplayed = true;
                    }
                }

                // Update the preferences
                updatePreferences();
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
        };
        xhttp.open("GET", cachedUrl, true);
        xhttp.send();
}

//Display the hydra version in the browser
function displayHydraVersion() {
    try {
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
        console.log(e.message);
    } finally {
    }

}

function dispalyDemographics(data) {
    if (data !== undefined && data.patient != null) {
        var patientAge = data.patient.age;
        var patientName = changeNullToEmpty(data.patient.fullName.replace("^", ","));
        var patientSex = changeNullToEmpty(data.patient.sex);
        var patientICN = changeNullToEmpty(data.patient.iCN);
        var patientDispalyString = "";
        if (patientICN !== "" || patientSex !== "" || patientAge !== "") {
            patientDispalyString = patientICN + ", " + patientSex + " " + patientAge;
        }

        $("#pName").attr("title", patientName + " " + patientDispalyString);
        $("#dob").attr("title", patientName + " " + patientDispalyString);
    }
}

function changeNullToEmpty(value) {
    if (value == undefined || value == null) {
        return "";
    }
    return value;
}

function playCineImage(e, playState) {
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var studyUid = seriesLayout.getStudyUid();
    var seriesIndex = seriesLayout.getSeriesIndex();
    var imageIndex = seriesLayout.getImageIndex();
    if (studyUid === undefined && seriesIndex === undefined && imageIndex === undefined) {
        // Avoid cine play on empty viewports
        return;
    }
    var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
    var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
    if (isMultiFrame === true) {
        imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
    } else {
        imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
    }
    if (imageCount <= 1 && !dicomViewer.scroll.isToPlayStudy(seriesLayout.seriesLayoutId)) {
        return;
    }    
    if (e.id != "playButton") {
        changePlayDirection(e)
    } else {
        var direction = getPlayerDirection(e);
        var playerButtomImage = $("#playButton_wrapper img")[0].src;
        if (playState !== undefined) {
            if (playState) {
                dicomViewer.tools.runCineImage(direction);
//                updatePlayIcon("play.png", "stop.png");
            } else {
                dicomViewer.tools.stopCineImage();
//                updatePlayIcon("stop.png", "play.png");
            }
        } else {
            if (playerButtomImage.indexOf("play.png") > -1) {
                dicomViewer.tools.runCineImage(direction);
                if (e.target !== undefined) {
//                   updatePlayIcon("play.png", "stop.png", true,e.target[0].id); 
                } else {
//                    updatePlayIcon("play.png", "stop.png");
                }
            } else if (playerButtomImage.indexOf("stop.png") > -1) {
                dicomViewer.tools.stopCineImage();
                if (e.target !== undefined) {
//                   updatePlayIcon("stop.png", "play.png", true,e.target[0].id);
                } else {
//                    updatePlayIcon("stop.png", "play.png");
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
        if ((studyDetials.isDicom && studyDetials.modality != "ECG" && studyDetials.modality != "SR" && studyDetials.modality != "CDA") ||
            (studyDetials.modality == "General" && seriesLayout.imageType == IMAGETYPE_JPEG)) {

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

            if (seriesLayout.imageType !== IMAGETYPE_JPEG) {
                repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
                imageSrc = repeatButtonImage.src;
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
            var isMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyuid, seriesLayout.seriesIndex);
            var imageAndFrameIndex = dicomViewer.scroll.getCurrentImageAndFrameIndex(false, seriesLayout);

            if (isMultiframe) {
                series = dicomViewer.Series.getSeries(studyuid,0);
                if (series != undefined && series != null) {
                    seriesCount = series.imageCount;
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

            if (seriesLayout.imageType == IMAGETYPE_JPEG) {
                document.getElementById("totalPages").innerText = (activeImageIndex + 1) + " of " + totalImageorFrames;
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
                } else {
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
                    if (repeatButtonImage) {
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

                //Enable/Disable the Next/Previous image button
                if (repeatButtonImage && $("#playButton_wrapper img")[0].src.indexOf("stop.png") > -1) {
                    $(nextImage).addClass("k-state-disabled");
                    $(previousImage).addClass("k-state-disabled");
                    $(nextImage + "_overflow").hide();
                    $(previousImage + "_overflow").hide();
                    $("#playButton_wrapper").removeClass("k-state-disabled");
                    $("#playButton").removeClass("k-state-disabled");
                } else if(totalImageorFrames <= 1 || totalImageorFrames <= imageLayoutDimension ) {
                        $(nextImage).addClass("k-state-disabled");
                        $(previousImage).addClass("k-state-disabled");
                        $(nextImage + "_overflow").hide();
                        $(previousImage + "_overflow").hide();
                        if(repeatButtonImage) {
                            $("#playButton_wrapper").addClass("k-state-disabled");
                            $("#playButton").addClass("k-state-disabled");
                            $("#playButton_overflow").hide();
                            $("#playForward_overflow").hide();
                            $("#playBackward_overflow").hide();
                            $("#repeteOption").addClass("k-state-disabled");
                            $("#repeteOption_overflow").hide();
                        }
                    } else {
                        if (repeatButtonImage) {
                            $("#playButton_wrapper").removeClass("k-state-disabled");
                            $("#playButton").removeClass("k-state-disabled");
                            $("#playButton_overflow").show();
                            $("#playForward_overflow").show();
                            $("#playBackward_overflow").show();
                            $("#repeteOption").removeClass("k-state-disabled");
                            $("#repeteOption_overflow").show();
                            $("#playButton_wrapper").show();
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
        catch(e){}
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
    if (isSeriesMultiFrame === true && isMultiFrame === true) {
        imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
    } else {
        imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
    }
    if(imageCount > 1)
    {
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
        }
        EnableDisableNextSeriesImage(seriesLayout);
    }
}

function cineplayBy(playBy) {
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
        if (modality === "US") {
            $("#context-ww_wc").hide();
            $("#context-length").show();
            $("#context-2dPoint").show();
            $("#context-length-calibration").hide();
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
        $("#context-trace").hide();
        $("#context-volume").hide();
        $("#context-MitralValve").hide();
        $("#context-AorticValve").hide();
        $("#context-measurement").hide();
        $("#context-link-menu").hide();
        $("#context-copyAttributes").hide();
    }
    //VAI-307
    if (isPrintOptionEnabled) {
      showPrintAndExport(true);
    } else {
      showPrintAndExport(false);
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
    //write your own logic
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
    var widthOfLayout = $(".ui-layout-resizer-west-open").width();
    //var imageThumnailWidth = $("#img").outerWidth() + widthOfLayout;
    var windowHeight = $(this).innerHeight();
    var northPanHeight = $(".ui-layout-north").outerHeight();
    var southPanHeight = $(".ui-layout-south").outerHeight();
    var thumbnailWidth = 6
    if (widthOfLayout != null) {
        thumbnailWidth = $("#img").outerWidth() + widthOfLayout; //$(".ui-layout-west").outerWidth();
    }
    var viewportElement = $('#viewport_View');
    var viewerElement = $("#viewer");
    viewportElement.width("100%");
    viewportElement.height("100%");

    var viewerHeight = windowHeight - (northPanHeight + southPanHeight);
    viewerElement.height(viewerHeight - 8);
    $("#viewportTable").height(viewerHeight - 8);
    viewerElement.width($(this).innerWidth() - (thumbnailWidth + 6));

    $("#viewerVersionInfoModal" ).dialog({ height: WINDOWHEIGHT * 0.6, width: WINDOWWIDTH * 0.8 });
    $("#viewerVersionInfoModal").dialog("option", "position", "center");
    $("#dicomHeaderAttributes").dialog({height: WINDOWHEIGHT * 0.8, width: WINDOWWIDTH * 0.8 });
    $("#dicomHeaderAttributes").dialog("option", "position", "center");

    //change the size & position of the dialog dynamically on resizing the window
    $("#imagingData").dialog({height: WINDOWHEIGHT * 0.8, width: WINDOWWIDTH * 0.8 });
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
        $("#EcgAndtemplateButton_wrapper").addClass("k-state-disabled");
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

});

function getStudyLayoutId(seriesLayoutId) {
    var index = seriesLayoutId.indexOf("studyViewer");
    var studyDiv = seriesLayoutId.substring(index, index + 14);
    return studyDiv;
}

function closeStudy(studyLayout) {
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
}

function changeCustom(studyDivId) {
    customSeriesLayout = studyDivId;
    $('#dialog-form').dialog('open');
}

function openMessageInfo() {
    var messageInfoURL = dicomViewer.url.getMessageHistoryUrl();
    var messageInfo = "<iframe style='height:100%;width:100%;' src=" + messageInfoURL + "></iframe>"
    $("#messageHistory").html(messageInfo);
    $('#messageHistory').css({"height":420 + "px"} );
}

function openHydraVersionInfo(hydraversion)
{
    var releaseHistoryURL = dicomViewer.url.getReleaseHistoryUrl();
    $.ajax({
        url: releaseHistoryURL,
        beforeSend: function(xhr) {
            xhr.overrideMimeType("text/plain; charset=x-user-defined");
        }
    })
        .done(function(data) {
            var text = JSON.parse(data);
            var htmlHistory = "<table width='100%'>";
            for (var i = 0; i < text.length ; i++) { 
                var history = text[i];
                var itemType = "";
                htmlHistory += "<tr><td><table class='table' border='2px' border-style= solid><tr><td><table>";
                if(history.type !== null & history.type !== undefined && history.type !== "")
                {
                    if(history.type == 0) {
                        itemType = "Version release";
                        htmlHistory += "<tr id='bold'><td>"+ itemType + "</td></tr>";
                        htmlHistory += "<td></td><td></td>"; 
                        
                        if(history.name !== null && history.name !== undefined  && history.name !== "")
                            htmlHistory +="<tr id='bold'><td> <b>" + " Version "+history.name+"</b></td></tr>";
                        
                        if(history.text !== null && history.text !== undefined   && history.text !== "")
                            htmlHistory += "<tr id='bold'><td>"+history.text+"</td></tr>";
                        
                        if(history.timeStamp !== null && history.timeStamp !== undefined && history.timeStamp !== "") {
                            var dateFormat = $.datepicker.formatDate('MM dd, yy', new Date(history.timeStamp));
                            if(dateFormat!== undefined) htmlHistory += "<tr id='bold'><td>Released "+dateFormat+"</td></tr>";
                        }
                           
                    }
                    htmlHistory += "<tr><td id='height'></td></tr>";
                }
              
                htmlHistory += "<tr><td><table>";
                if(history.items !== null & history.items !== undefined)
                {
                    for (var j = 0; j < history.items.length ; j++)
                    { 
                        var subHistory = history.items[j];
                        
                        if(subHistory.type !== null & subHistory.type !== undefined && subHistory.type !== "")
                        {
                            if(subHistory.type == 1)itemType = "<tr id='subhistoryHeight'><td><span class='label label-success'>" + feature+"</span>&nbsp;&nbsp;";
                            else if(subHistory.type == 2)itemType = "<tr id='subhistoryHeight'><td><span class='label label-info'>" + improvement + "</span>&nbsp;&nbsp;";
                            else if(subHistory.type == 3)itemType = "<tr id='subhistoryHeight'><td><span class='label label-danger'>" +bug+"</span>&nbsp;&nbsp;";
                            
                            htmlHistory += itemType ;                          

                            if(subHistory.name !== null && subHistory.name !== undefined  && subHistory.name !== "")
                                htmlHistory += " Version " +subHistory.name+" ";

                            if(subHistory.text !== null && subHistory.text !== undefined && subHistory.text !== "")
                                htmlHistory += subHistory.text+" ";

                            if(subHistory.timeStamp !== null && subHistory.timeStamp !== undefined  && subHistory.timeStamp !== ""){
                                dateFormat = $.datepicker.formatDate('MM dd, yy', new Date(subHistory.timeStamp));
                                if(dateFormat!== undefined)  
                                    htmlHistory += " On " +dateFormat+" ";
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
            $('#messageHistory').css({"height":420 + "px"} );

            $('#viewerVersionInfoModal').dialog('open');
//            dicomViewer.pauseCinePlay(1,true);

            })
            .fail(function (data) {
                $('#viewerVersionInfoModal').dialog('open');
//            dicomViewer.pauseCinePlay(1,true);
            })
            .error(function (xhr, status) {
                var description = xhr.statusText + " : Failed to open the hydra version information";
                sendViewerStatusMessage(xhr.status.toString(), description);
        });
}

/**
 * Get the display settings
 * @param {Type} modality - Specifies the modality
 */
function GetDisplaySettings(modality)
{
    var displaySettings = getDefaultDisplaySettings(modality);

    try
    {
        var settingsUrl = dicomViewer.getSettingsUrl();
        $.ajax({
            url: settingsUrl,
            async: false,
            cache: false, 
            beforeSend: function(xhr) {
                xhr.overrideMimeType("text/plain; charset=x-user-defined");
            }
        })
        .done(function(data) {
            //var displaySettingsArray = eval('(' + JSON.parse(data) + ')');
            var displaySettingsArray = JSON.parse(data);
            if(displaySettingsArray == null || displaySettingsArray.length == 0){
                return displaySettings;
            }

            // Show or hide the embed pdf viewer 
            var generalSettings = displaySettingsArray.filter(function (obj) {
                return (obj.Modality == "General");
            })[0];

            if(generalSettings != undefined) {
                if(generalSettings.isEmbedPDFViewer != undefined ) {
                    isEmbedPdfViewer = (generalSettings.isEmbedPDFViewer == "false" ? false : true);
                 } else {
                    isEmbedPdfViewer = true;
                }
            }

            var selectedDisplaySettings = displaySettingsArray.filter(function (obj) {
                return (obj.Modality == modality);
            })[0];

            if(selectedDisplaySettings != undefined) {
                var zoomMode = displaySettings.ZoomMode;
                var presentationMode = displaySettings.PresentationMode;
                var zoomLevel = displaySettings.ZoomLevel;
                var isECG = displaySettings.IsECG;
                var zoomModeOption = $("#zoomModeValues").find("[value='" + selectedDisplaySettings.ZoomMode + "']");
                if(zoomModeOption !== undefined) {
                    zoomMode = zoomModeOption.attr("id");
                    if(zoomMode === "0_zoom") {
                        presentationMode = "MAGNIFY";
                    }
                }

                // Parse the zoom level id
                var zoomLevelId = zoomMode.split('_');
                if(zoomLevelId !== undefined && zoomLevelId !== null && zoomLevelId.length === 2) {
                    zoomLevel = parseInt(zoomLevelId[0]);
                }

                displaySettings = {
                    Rows: selectedDisplaySettings.Rows,
                    Columns: selectedDisplaySettings.Columns,
                    ZoomMode: zoomMode,
                    PresentationMode : presentationMode,
                    ZoomLevel : zoomLevel,
                    IsECG : isECG
                };

                return displaySettings;
            }
        })
        .fail(function(data) {
        })
        .error(function(xhr, status) {
            var description = xhr.statusText + "\nDefault display settings are not configured for this modality:" + modality;
            sendViewerStatusMessage(xhr.status.toString(), description);
        });
    }
    catch(e){}

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
function UpdateStudyLayoutMap(displaySettings){
    try {
        if (displaySettings === undefined) {
            return;
        }

        var studyDiv =  getStudyLayoutId(dicomViewer.getActiveSeriesLayout().seriesLayoutId);
        if (studyDiv == undefined || studyDiv == "") {
            return;
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
 * Get the selected the dicom image positions
 * @param {Type} study - Specifies the study
 * @param {Type} selectedUid - Specifies the selected image Uid
 */
function getSelectedDicomImagePositions(study, selectedUid) {
    try
    {
        // Check whether the study data is valid
        if(study === undefined || study == null){
            return undefined;
        }

        if(selectedUid === undefined || selectedUid === null){
            return undefined;
        }

        var seriesIncrementer = 0;
        var imageIncrementer = 0;
        var isImageFound = false; 
        if (study.series !== null && study.series !== undefined){
            seriesIncrementer = 0;
            study.series.forEach(function(series){
                if (series.images !== null && series.images !== undefined){
                    imageIncrementer = 0;
                    series.images.forEach(function(image){
                        if(image.imageUid == selectedUid){
                            isImageFound = true;
                            return true; 
                        }

                        // Break the loop
                        if(isImageFound){
                            return true;
                        }

                        // Increment the image index
                        imageIncrementer++;
                    });
                }

                // Break the loop
                if (isImageFound) {
                    return true;
                }

                // Increment the series index
                seriesIncrementer++;
            });
        }

        if (isImageFound) {
            var imagePosition = {
                SeriesIndex: seriesIncrementer,
                ImageIndex: imageIncrementer,
            }
            return imagePosition;
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
    var totalStudiesMap = new Map();

    try {
        // Preprocess dicom images
        var dicomStudy = [];
        if (data.studies !== null && data.studies !== undefined) {
            data.studies.forEach(function(entry) {
                entry.displaySettings = GetDisplaySettings(entry.modality);
                entry.isXRefLineFound = false;
                entry.is6000OverLay = false;
                if (entry.series !== undefined) {
                    entry.series.seriesCount = 0;
                    entry.series.forEach(function (series) {
                        series.isDicom = true;
                        series.isDisplaySettingsApplied = false;
                        series.displaySettings = jQuery.extend(true, {}, entry.displaySettings);

                        // Add the display settings in image level for multiframe images.
                        series.images.forEach(function (image) {
                            if (dicomViewer.thumbnail.isImageThumbnail(image) === true) {
                                image.isDicom = true;
                                image.isDisplaySettingsApplied = false;
                                image.displaySettings = jQuery.extend(true, {}, entry.displaySettings);
                                image.isImageThumbnail = true;
                            }
                            if (entry.isXRefLineFound != true && image.imagePlane != null && image.imagePlane != undefined) {
                                entry.isXRefLineFound = true ;
                            }
                        });
                    });
                }

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
                entry.series.seriesCount = (entry.series).length;
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
            var nonDicomdisplaySettings = GetDisplaySettings("General");
            nonDicomImages.forEach(function (entry) {
                var nonDicomStudy = [];

                // Studu Uid
                var nonDicomStudyUid = entry.studyId;
                if (nonDicomStudyUid === undefined || nonDicomStudyUid === null) {
                    nonDicomStudyUid = contextId;
                }
                nonDicomStudyUid = dicomViewer.replaceSpecialsValues(nonDicomStudyUid);

                // Procedure
                var nonDicomProcedure = entry.studyDescription;
                if (nonDicomProcedure === undefined || nonDicomProcedure === null) {
                    nonDicomProcedure = contextId;
                }

                // Set the required property
                entry.contextId = contextId;
                entry.imageCount = 1;
                entry.isDicom = false;
                entry.displaySettings = nonDicomdisplaySettings;
                entry.isDisplaySettingsApplied = false;

                nonDicomStudy = totalStudiesMap.get(STUDY_TYPE_NON_DICOM);
                if (dicomStudy !== undefined) {
                    var selectedStudy = undefined;
                    dicomStudy.forEach(function(study) {
                        if (study.studyId.toLowerCase() === entry.studyId.toLowerCase()) {
                            selectedStudy = study;
                            return false;
                        }
                    });

                    // Append the series with existing dicom study
                    if (selectedStudy !== undefined) {
                        nonDicomStudyUid = dicomViewer.replaceDotValue(selectedStudy.studyUid);
                        nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry,nonDicomProcedure, nonDicomdisplaySettings);
                        nonDicomStudy.images = new Array();
                        nonDicomStudy.images.push(entry);
                        selectedStudy.series.push(nonDicomStudy);
                        selectedStudy.seriesCount += 1;
                    } else if (nonDicomStudy === undefined) {
                        nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry, nonDicomProcedure, nonDicomdisplaySettings);
                        nonDicomStudy.push(entry);
                        totalStudiesMap.set(STUDY_TYPE_NON_DICOM, nonDicomStudy);
                    } else {
                        nonDicomStudy.push(entry);
                        nonDicomStudy.seriesCount += 1;
                    }
                } else if (nonDicomStudy === undefined) {
                    nonDicomStudy = createAndGetNonDicomStudy(nonDicomStudyUid, entry, nonDicomProcedure, nonDicomdisplaySettings);
                    nonDicomStudy.push(entry);
                    totalStudiesMap.set(STUDY_TYPE_NON_DICOM, nonDicomStudy);
                } else {
                    nonDicomStudy.push(entry);
                    nonDicomStudy.seriesCount += 1;
                }
            });
        }
    }
    catch(e) {}

    return totalStudiesMap;
}

/**
 * Create and get the non dicom study
 * @param {Type} studyUid - Specifies the study Uid
 * @param {Type} studyId - Specifies the non dicom image object
 * @param {Type} procedure - Specifies the study procedure
 * @param {Type} displaySettings - Specifies the non dicom display settings
 */
function createAndGetNonDicomStudy(studyUid, image, procedure, displaySettings) {
    try {
        var nonDicomStudy = new Array();
        nonDicomStudy.studyUid = studyUid;
        nonDicomStudy.procedure = procedure;
        nonDicomStudy.modality = "General"
        nonDicomStudy.seriesCount = 1;
        nonDicomStudy.isDicom = false;
        nonDicomStudy.displaySettings = displaySettings;
        nonDicomStudy.isDisplaySettingsApplied = false;
        nonDicomStudy.studyId = image.studyId;
        nonDicomStudy.dateTime = image.studyDateTime;

        // Create the patient
        if (image.patientDescription !== undefined && image.patientDescription !== null) {
            var patient = new Object();
            patient.age = "";
            patient.dob = "";
            patient.fullName = image.patientDescription;
            patient.iCN = "";
            patient.sex = "";
            nonDicomStudy.patient = patient;
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
        IsNewSession: isSessionCleared
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
    }
    catch(e) {}
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
function bringToFrontPdf(seriesLayoutId) {
    try {
        if (isInternetExplorer() !== true) {
            listeniFrames();
            return;
        }

        if (isEmbedPdfViewer !== true) {
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
        bringToFront("MeasurementPreferenceModal");
        bringToFront("lengthCalibrationModal");
        bringToFront("zoom-form");
        bringToFront("customWindowLevel");
        bringToFront("cachelistindicator");
        bringToFront("dialog-form");

        // Study layout
        for (var rows = 1; rows <= STUDY_LAYOUT_MAX_ROW; rows++) {
            for (var columns = 1; columns <= STUDY_LAYOUT_MAX_COLUMN; columns++) {
                bringToFront(rows + "x" + columns);
            }
        }

        // Series layout
        var studyDiv = getStudyLayoutId(seriesLayoutId);
        for (var rows = 1; rows <= 2; rows++) {
            for (var columns = 1; columns <= 2; columns++) {
                bringToFront("seriesDisplay" + studyDiv + "_" + rows + "x" + columns);
            }
        }
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

//        $("#cachemanager_progress").trigger("image_cache_updated",  dicomViewer.imageCache.getCacheInfo());
    } catch(e) {}
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

            spinner = dicomViewer.progress.updateSpinnerInnerText(session.SeriesLayoutId, text);
            dicomViewer.progress.putSpinner(session.SeriesLayoutId, spinner);

            return spinner;
        }
    } catch(e) {}

    return undefined;
}

/**
 * listen the iFrames to select the viewport
 * @param {Type}  
 */
var isiFrameDivListening = undefined;
function listeniFrames() {
    if (isiFrameDivListening === true) {
        return;
    }

    // Listen the 'blur' event to receive the iframe click event
    window.removeEventListener('blur', iFrameEventListener);
    window.addEventListener('blur', iFrameEventListener);
    isiFrameDivListening = true;
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
        $(this).trigger("resize", isSessionCleared);

        var viewportHeight = document.getElementById("tablestudyViewer1x1").style.height;
        viewportHeight = viewportHeight.replace('px', '');
        document.getElementById("tablestudyViewer1x1").style.height = (parseInt(viewportHeight) + 15) + "px";

        $("#EcgAndtemplateButton_wrapper").removeClass("k-state-disabled");
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

        $("#EcgAndtemplateButton_wrapper").addClass("k-state-disabled");
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
    } catch(e) {}
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
var loginUserDUZ = -1;
function getAndUpdateUserPreferences() {
    try {
        if (loginUserDUZ !== -1) {
            return loginUserDUZ;
        }

        var userDetailsUrl = dicomViewer.getUserDetailsUrl();
        $.ajax({
                url: userDetailsUrl,
                cache: false,
                async: false
        })
        .done(function (data) {
            if (data == undefined || data == null) {
                return loginUserDUZ;
            }

            loginUserDUZ = parseInt(data.id);
            isPrintOptionEnabled = (data.canPrint !== undefined ? data.canPrint : true);
        })
        .fail(function (data) {
            sendViewerStatusMessage("500", "Failed to get the user information from server");
        })
        .error(function (xhr, status) {
            var description = xhr.statusText + "\nFailed to get the user information from server";
            sendViewerStatusMessage(xhr.status.toString(), description);
        });
    } catch(e) {}

    return loginUserDUZ;
}

/**
 * Update the measurement preference
 */ 
function updateMeasurementPreference() {
    try
    {
        $.ajax
        (
            {
                url: dicomViewer.getMeasurementPrefUrl(),
                cache: false,
                async : false
            }
        )
        .done(function(data) {
            if(data) {
                var style = JSON.parse(data)[0];
                var measurementStyle =
                {
                    lineColor : (style.lineColor ? style.lineColor : "#00FFFF"),
                    lineWidth : (style.lineWidth ? style.lineWidth : 1),
                    textColor: (style.textColor ? style.textColor : "#00FFFF"),
                    isBold: (style.isBold ? style.isBold : false),
                    isItalic: (style.isItalic ? style.isItalic : false),
                    fontName: (style.fontName ? style.fontName : "Arial"),
                    fontSize: (style.fontSize ? style.fontSize : 12)
                };

                dicomViewer.measurement.draw.setMeasurementStyle(measurementStyle);
            }
        })
        .fail(function(data) {
        })
        .error(function(xhr, status) {
            var description = xhr.statusText + "\nFailed to load the settings from server";
            sendViewerStatusMessage(xhr.status.toString(), description);
        });
    } catch(e) {}
}

/**
 * Update the preferences 
 */ 
function updatePreferences() {
    updateMeasurementPreference();
}

/**
 * Show and hide the 6000Overlay menu
 * @param {Type} seriesLayout  - it specifies the active series layout
 */ 
function showAndHide6000OverlayMenu(seriesLayout) {
    try
    {
        var studyDetails = dicomViewer.getStudyDetails(seriesLayout.studyUid);
        if(studyDetails.is6000OverLay) {
            $("#showHideOverlay6000").show();
            $("#showHideOverlay6000_overflow").show();
        } else {
            $("#showHideOverlay6000").hide();
            $("#showHideOverlay6000_overflow").hide();
        }
    } catch(e) {}
}
