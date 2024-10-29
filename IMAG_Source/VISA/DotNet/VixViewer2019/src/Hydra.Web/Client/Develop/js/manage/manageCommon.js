var numberOfWebWorkers = 0;
var numberOfThumbWebWorkers = 0;
var myLayout;
var WINDOWWIDTH = $(window).width();
var WINDOWHEIGHT = $(window).height();
var thumbnailHeight;
var thumbnailWidth;
var IMAGE_GROUPS = "imageGroups";
var imageCacheMap = new Map();
var dumpInConsole = false;
var THUMBNAIL_PANEL_MIN_WIDTH = (screen.width * 135) / 1280;
var THUMBNAIL_PANEL_MAX_WIDTH = 150;
var previous_NorthPanel_Width = 50;
var previous_NorthPanel_Height = 30;
var isDeleteEnabled = true;
var isSensitiveEnabled = true;
var selectedThumbnailRender;
var THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MIN_WIDTH;
if (THUMBNAIL_PANEL_WIDTH > THUMBNAIL_PANEL_MAX_WIDTH) {
    THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MAX_WIDTH;
}

var LL_TRACE = "Trace";
var LL_DEBUG = "Debug";
var LL_INFO = "Info";
var LL_WARN = "Warn";
var LL_ERROR = "Error";

var maxNoOfQueue = 10;
var queueIncrementor = 0;
var workerQueues = [];

/**
 * 
 */
function loadSpinner() {
    updateSpinner('dicomViewer', "Processing metadata...");
}


$(document).ready(function () {
    try {
        var viewportElement = $("#manage_ImageThumbnail_View");
        setSecurityToken();
        processStudyMetaData();
        appendCommonDlgs("#dicomViewer");
        updateImageDeleteReasons();
    } catch (e) {}
});

function processStudyMetaData(selectedSeries) {
    var d = new Date();
    var n = d.getMilliseconds();
    var cachedUrl = dicomViewer.Metadata.Url() + "&_cacheBust=" + n;
    var xhttp;
    if (window.XMLHttpRequest) {
        xhttp = new XMLHttpRequest();
    } else {
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    showOrHideViewer(false);

    xhttp.onreadystatechange = function () {
        if (xhttp.readyState == 4 && xhttp.status == 200) {
            var data = JSON.parse(xhttp.responseText);
            if (data.imageGroups === undefined || data.imageGroups === null) {
                setTimeout(function () {
                    processStudyMetaData();
                }, 3000);
                return;
            }

            // Process meta data
            var imageGroupMap = preprocessMetaData(data, BasicUtil.getUrlParameter("ContextId"));
            if (imageGroupMap.size > 0) {
                var imageGroups = imageGroupMap.get(IMAGE_GROUPS);
                if (imageGroups !== null && imageGroups !== undefined) {
                    imageGroups.forEach(function (imageGroup) {
                        dicomViewer.setStudyDetails(imageGroup);
                    });
                }

                // Stop the spinner
                var spinner = dicomViewer.progress.getSpinner('dicomViewer');
                if (spinner !== undefined) {
                    spinner.stop();
                    spinner = undefined;

                    showOrHideViewer(true);
                }

                displayDemographics(data);
                dicomViewer.createLayout(1, 1, selectedSeries);
            }
        }
    };
    xhttp.open("GET", cachedUrl, true);
    xhttp.send();
}

function displayDemographics(data) {
    if (data !== undefined && data.patient != null) {
        var patientAge = changeNullToEmpty(data.patient.age);
        var patientName = changeNullToEmpty(data.patient.fullName.replace("^", ","));
        var patientSex = changeNullToEmpty(data.patient.sex);
        var patientICN = changeNullToEmpty(data.patient.iCN);
        var patientDispalyString = "";
        if (patientICN !== "" || patientSex !== "" || patientAge !== "") {
            if (patientSex == "" && patientAge == "") {
                patientDispalyString = patientICN;
            } else {
                patientDispalyString = patientICN + ", " + patientSex + " " + patientAge;
            }
        }
        //VAI-760
        document.getElementById("pName").textContent = patientName + " " + patientDispalyString;
        document.getElementById("pName").style.color = "#E8E8E8";
        document.getElementById("pName").style.fontSize = "small";

        setToolTip("pName", patientName + " " + patientDispalyString);
    }
}

function changeNullToEmpty(value) {
    if (value == undefined || value == null) {
        return "";
    }

    return value;
}

$(window).resize(function () {
    try {
        //Maintain the visible dialog in the center of the screen
        autoRepositionVisibleDialogs();

        WINDOWWIDTH = $(this).innerWidth();
        WINDOWHEIGHT = $(this).innerHeight();

        //calculate the panel size
        if (previous_NorthPanel_Height > 0 && previous_NorthPanel_Width > 0) {
            var northHeigth = ((WINDOWHEIGHT - 5) * previous_NorthPanel_Height) / 100;
            var westWidth = ((WINDOWWIDTH - 5) * previous_NorthPanel_Width) / 100;
            myLayout.sizePane("north", northHeigth);
            myLayout.sizePane("west", westWidth);
        }

        var studyUids = dicomViewer.getListOfStudyUid(false);
        for (var index = 1; index <= studyUids.length; index++) {
            $("#tablestudyViewer" + index + "x1").width(WINDOWWIDTH - 24);
        }

        $('#context-MarkDelete').hide();
        $('#context-MarkSensitive').hide();
        updateWindowPOs();
    } catch (e) {}

});

/**
 * Preprocess meta data
 * @param {Type} data - meta data
 */
function preprocessMetaData(data, contextId) {
    var imageGroupMap = new Map();

    try {
        // check access rights
        isDeleteEnabled = (data.canDelete !== undefined) && (data.canDelete === true);
        isSensitiveEnabled = (data.canEdit !== undefined) && (data.canEdit === true);

        if (isDeleteEnabled || isSensitiveEnabled) {
            $("#manage_toolbar").show();
        }

        // Preprocess image groups
        var imageGroup = [];
        if (data.imageGroups !== null && data.imageGroups !== undefined) {
            data.imageGroups.forEach(function (entry) {
                if (entry.groupType == 0) {
                    if (entry.imageGroups !== undefined) {
                        entry.imageGroups.forEach(function (series) {
                            series.images.forEach(function (image) {
                                image.isDicom = true;
                                image.isImageThumbnail = true;
                                image.caption = (image.caption === null ? "" : image.caption);
                            });
                        });
                    }
                    entry.studyUid = BasicUtil.GetV4Guid();
                    entry.contextId = contextId;
                    entry.isDicom = true;
                    imageGroup = imageGroupMap.get(IMAGE_GROUPS);
                    if (imageGroup === undefined) {
                        imageGroup = new Array();
                        imageGroup.push(entry);
                        imageGroupMap.set(IMAGE_GROUPS, imageGroup);
                    } else {
                        imageGroup.push(entry);
                    }
                }
            });
        }
    } catch (e) {}

    return imageGroupMap;
}

/**
 * Set the tooltip for the element
 * @param {Type} elementId - Specifies the element Id
 * @param {Type} content - Specifies the tooltip content
 */
function setToolTip(elementId, content) {
    try {
        $("#" + elementId).attr("title", content);
    } catch (e) {}
}

/**
 * Set the image data based on the image Uid
 * @param {Type} image - specifies the image object
 */
function setImageData(image) {
    try {
        if (image == null || image == undefined || image.imageUid == null || image.imageUid == undefined) {
            return;
        }

        var imageCache = imageCacheMap.get(image.imageUid);
        if (imageCache !== undefined) {
            imageCache.imageData = image.imageData;
        } else {
            imageCacheMap.set(image.imageUid, image);
        }
    } catch (e) {}
}

/**
 * Get the image data from the list based on the image Uid
 * @param {Type} imageUid - specifies the image Uid
 */
function getImageData(imageUid) {
    try {
        if (imageUid == null || imageUid == undefined) {
            return;
        }

        var imageCache = imageCacheMap.get(imageUid);
        if (imageCache !== undefined) {
            return imageCache.imageData;
        }
    } catch (e) {}

    return undefined;
}

/**
 * Set the image information based on the image Uid
 * @param {Type} image - specifies the image object
 */
function setImageInfo(image) {
    try {
        if (image == null || image == undefined || image.imageUid == null || image.imageUid == undefined) {
            return;
        }

        var imageCache = imageCacheMap.get(image.imageUid);
        if (imageCache !== undefined) {
            imageCache.imageInfo = image.imageInfo;
        } else {
            imageCacheMap.set(image.imageUid, image);
        }
    } catch (e) {}
}

/**
 * Get the image information based on the image Uid
 * @param {Type} imageUid - specifies the image Uid
 */
function getImageInfo(imageUid) {
    try {
        if (imageUid == null || imageUid == undefined) {
            return;
        }

        var imageCache = imageCacheMap.get(imageUid);
        if (imageCache !== undefined) {
            return imageCache.imageInfo;
        }
    } catch (e) {}

    return undefined;
}

/**
 * While resizing/reloading the resize layout this method will call
 */
function reloadViewPort() {
    updatePanel();
}

/**
 * Update the resize panel position
 */
function updatePanel() {
    try {
        var windowWidth = $(this).innerWidth();
        var windowHeight = $(this).innerHeight();
        var left = previous_NorthPanel_Width;
        var top = previous_NorthPanel_Height;
        var westPanel = document.getElementsByClassName("ui-layout-resizer-west-open")[0];

        if (westPanel !== undefined && westPanel !== null && westPanel.style !== null) {
            top = westPanel.style.top;
            top = parseInt(top.match(/-*[0-9]+/));
            top = Math.ceil((top / windowHeight) * 100);

            left = westPanel.style.left;
            left = parseInt(left.match(/-*[0-9]+/));
            left = Math.ceil((left / windowWidth) * 100);
        }

        previous_NorthPanel_Height = top;
        previous_NorthPanel_Width = left;
    } catch (e) {}
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
 * Reset the image data based on the image Uid
 * @param {Type} imageId - specifies the imageid
 */
function resetImageData(imageId) {
    try {
        if (imageCacheMap.has(imageId)) {
            imageCacheMap.set(imageId, undefined);
        }
    } catch (e) {}
}

/**
 * refresh the view page
 *@param {Type} selectedSeries - specifies the stuselectedSeriesdyUid
 * @param {Type} studyUid - specifies the studyUid
 */
function refresh(selectedSeries, studyUid) {
    try {
        workerQueues.isLocked = true;
        workerQueues.forEach(function (workerQueue) {
            workerQueue.reset();
        });
        workerQueues = [];
        workerQueues.isLocked = false;
        queueIncrementor = 0;

        imageCacheMap = new Map();
        dicomViewer.resetStudy();
        updateSpinner('dicomViewer', "Refreshing metadata...");
        processStudyMetaData(selectedSeries);
    } catch (e) {}
}

/**
 * Show or hide the viewer
 * @param {Type} isShow - Specifies the show flag
 */
function showOrHideViewer(isShow) {
    try {
        if (isShow) {
            $("#northlayout").show();
            $("#manage_viewer").show();
            $(".ui-layout-center").show();
        } else {
            $("#northlayout").hide();
            $("#manage_viewer").hide();
            $(".ui-layout-center").hide();
        }

        var display = (isShow ? "block" : "none");
        document.getElementsByClassName("ui-layout-resizer")[0].style.display = display;
        document.getElementsByClassName("ui-layout-resizer-north")[0].style.display = display;
        document.getElementsByClassName("ui-layout-resizer-west")[0].style.display = display;
    } catch (e) {}
}

/**
 * create the worker queue for image cache
 * @param {Type} workerJob -  job details
 */
function doWorkerQueue(workerJob) {
    try {
        if (workerQueues.isLocked) {
            return;
        }

        if (workerQueues.length <= maxNoOfQueue) {
            workerQueues.push(new WorkerQueue("../js/manage/manageCacheWorker.js"));
        }

        if (queueIncrementor >= maxNoOfQueue) {
            queueIncrementor = 0;
        }

        var workerQueue = workerQueues[queueIncrementor++];
        var managerWorkerThread = new WorkerThread(workerJob);
        workerQueue.push(function () {
            return managerWorkerThread.processJob(workerQueue)
        });
    } catch (e) {}
}

/**
 * update the spinner text
 * @param {Type} spinnerId - Specifies the spinner id
 * @param {Type} text - Specifies the text
 */
function updateSpinner(spinnerId, text) {
    try {
        var spinner = undefined;
        var existingSpinner = dicomViewer.progress.getSpinner(spinnerId);
        if (existingSpinner !== undefined) {
            if (existingSpinner.el) {
                var existingSpinnerDiv = $("#" + spinnerId + "_spinner");
                if (existingSpinnerDiv.length === 1) {
                    existingSpinnerDiv.css("white-space", "pre");
                    existingSpinnerDiv.html(text);
                    return;
                }
            }

            existingSpinner.stop();
            existingSpinner = undefined;
        }

        spinner = dicomViewer.progress.updateSpinnerInnerText(spinnerId, text);
        dicomViewer.progress.putSpinner(spinnerId, spinner);
    } catch (e) {}
}

/**
 * dump the logs in console
 */
function dumpConsoleLogs(logType, headerMessage, methodName, logMessage, timeElapsed, isAsync, skipConsole) {
    try {
        if (window.console) {
            console.log(logMessage);
        }
    } catch (e) {}
}

/**
 * Refresh the image thubnail panel
 */
function doRefresh(isDelete) {
    try {
        var checkedImages = getCheckedImages();
        if (checkedImages == undefined || checkedImages == null) {
            return;
        }

        var refreshData = checkedImages.refreshData;
        var imageIndex = isDelete ? 0 : $(".selected-image-thumbnail-view")[0].renderer.imageIndex;
        var seriesIndex = $(".selected-thumbnail-view")[0].renderer.seriesIndex;
        var selectedSeriesIndex = seriesIndex;
        var selectedSeriesData = refreshData.series.filter(
            function (o) {
                return o.seriesIndex === seriesIndex;
            }
        )[0];

        if (selectedSeriesData == undefined) {
            seriesIndex = 0;
        }

        if (isDelete) {
            seriesIndex = $("#" + $(".selected-thumbnail-view")[0].id + "_checkbox")[0].checked ? 0 : selectedSeriesIndex;
        }

        $('#splash-content').hide();
        refresh({
            seriesIndex: seriesIndex,
            imageIndex: imageIndex
        }, refreshData.studyUid);
    } catch (e) {}
}


/**
 * Get the checked images
 * @param {Type}  
 */
function getCheckedImages() {
    var checkedImageGroupData = {
        imageUrns: [],
        refreshData: {
            studyUid: undefined,
            series: [],
        }
    };

    try {
        var studyUids = dicomViewer.getListOfStudyUid(false);
        for (var index = 0; index < studyUids.length; index++) {
            var seriesIndex = 0;
            var thumbnailId = $(".selected-thumbnail-view")[0].id;
            var studyUid = studyUids[index];
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            var series = {
                series: []
            };
            checkedImageGroupData.refreshData[replaceSpecialsValues(studyUid)] = series;
            if (studyDetails.imageGroups.length == undefined || studyDetails.imageGroups.length == 0) {
                return undefined;
            }

            checkedImageGroupData.refreshData.studyUid = studyUid;
            studyDetails.imageGroups.forEach(function (series) {
                if (series.isDeleteSeries) {
                    seriesIndex++;
                    return true;
                }

                var imageIndex = 0;
                var seriesThumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb';
                var isSeriesChecked = document.getElementById(seriesThumbnailId + "_checkbox").checked;
                var imageCount = $("#" + seriesThumbnailId)[0].renderer.imageCount;
                var refreshSeriesData = {
                    seriesIndex: seriesIndex,
                    isDelete: isSeriesChecked,
                    imageUrns: []
                };
                if (!isSeriesChecked && !$("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                    seriesIndex++;
                    return true;
                }
                series.images.forEach(function (image) {
                    if (image.isDeleteImage) {
                        return true;
                    }

                    var imagethumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb' + imageIndex;
                    if (isSeriesChecked && !$("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                        checkedImageGroupData.imageUrns.push(image.imageId);
                    } else if ($("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                        if ($("#" + imagethumbnailId + "_checkbox").length > 0) {
                            var isChecked = document.getElementById(imagethumbnailId + "_checkbox").checked;
                            if (isChecked) {
                                checkedImageGroupData.imageUrns.push(image.imageId);
                                refreshSeriesData.imageUrns.push(image.imageId);
                            } else {
                                refreshSeriesData.isDelete = false;
                            }
                        }
                    }
                    imageIndex++;
                });

                // Check whether the whole series is selected or not
                if (!refreshSeriesData.isDelete && refreshSeriesData.imageUrns.length == imageCount) {
                    refreshSeriesData.isDelete = true;
                    refreshSeriesData.imageUrns = [];
                }

                checkedImageGroupData.refreshData[replaceSpecialsValues(studyUid)].series.push(refreshSeriesData);
                seriesIndex++;
            });
        }

        return checkedImageGroupData;
    } catch (e) {}

    return checkedImageGroupData;
}

/**
 * Replace all the special characters
 * @param {Type} value - Specifies the input
 */
function replaceSpecialsValues(value) {
    return value.replace(/[^A-Za-z0-9]/g, '');
}

/**
 * Get the first checked image
 */
function getFirstCheckedImage() {
    try {
        var studyUids = dicomViewer.getListOfStudyUid(false);
        var firstImage = undefined;
        for (var index = 0; index < studyUids.length; index++) {
            var seriesIndex = 0;
            var studyUid = studyUids[index];
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails.imageGroups.length == 0) {
                return firstImage;
            }

            studyDetails.imageGroups.every(function (series) {
                if (series.isDeleteSeries) {
                    seriesIndex++;
                    return true;
                }

                var imageIndex = 0;
                var seriesThumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb';
                var isSeriesChecked = document.getElementById(seriesThumbnailId + "_checkbox").checked;
                if (!isSeriesChecked && !$("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                    seriesIndex++;
                    return true;
                }

                series.images.every(function (image) {
                    if (image.isDeleteImage) {
                        return true;
                    }

                    var imagethumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb' + imageIndex;
                    if (isSeriesChecked && !$("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                        firstImage = {
                            study: studyDetails,
                            image: image
                        };
                    } else if ($("#" + seriesThumbnailId).hasClass('selected-thumbnail-view')) {
                        if ($("#" + imagethumbnailId + "_checkbox").length > 0) {
                            var isChecked = document.getElementById(imagethumbnailId + "_checkbox").checked;
                            if (isChecked) {
                                firstImage = {
                                    study: studyDetails,
                                    image: image
                                };
                            }
                        }
                    }
                    imageIndex++;

                    return (firstImage ? false : true);
                });
                seriesIndex++;

                return (firstImage ? false : true);
            });

            if (firstImage) {
                break;
            }
        }

        return firstImage;
    } catch (e) {}

    return undefined;
}

/**
 * show and hide the spalash window
 * @param {Type} messageType - Type of message
 * @param {Type} message - message content
 * @param {Type} studyViewer - study viewer viewportID
 */
function showAndHideSplashWindow(messageType, message, viewportId) {
    try {
        viewportId = "dicomViewer";
        if (messageType == "show") {
            $("#splash-window").show().center(viewportId);
            $("#splash-content")[0].innerHTML = "<img src = ../images/presentaionLoader.gif>  " + message + "";
            $("#splash-content").show();
        } else if (messageType == "success") {
            setTimeout(function () {
                $("#splash-content")[0].innerHTML = "" + message + "";
            }, 1000);
        } else {
            setTimeout(function () {
                $("#splash-content")[0].innerHTML = "" + message + "";
            }, 1000);
        }
    } catch (e) {}
    setTimeout(function () {
        $("#splash-window").fadeOut(1000);
    }, 4000);
}

$.fn.center = function (parentId) {
    this.css("position", "absolute");
    var topOffset = $("#" + parentId).offset().top
    var leftOffset = $("#" + parentId).offset().left
    var viewportHeight = ($("#" + parentId).height()) - 40;
    var viewportWidth = (($("#" + parentId).width()) - 300);
    this.css("top", ((viewportHeight) / 2 + topOffset) + "px");
    this.css("left", ((viewportWidth) / 2 + leftOffset) + "px");
    return this;
}
