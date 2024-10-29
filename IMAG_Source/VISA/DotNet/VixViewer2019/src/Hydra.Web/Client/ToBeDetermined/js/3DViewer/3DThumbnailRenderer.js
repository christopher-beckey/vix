/**
 * Create thumbnail images
 *  */
var dragThumbnailStudyUid;
function ThumbnailRenderer() {
    var thumbnailWidth = THUMBNAIL_PANEL_WIDTH-32;
    this.uid = guid();
    this.imageURL;
    this.metaInfo;
    this.renderWidget = document.createElement("canvas");
    this.renderWidget.width = thumbnailWidth;
    this.renderWidget.height = 105;
    this.renderWidget.setAttribute("id", "thumb" + this.uid);
    this.renderWidget.setAttribute("draggable", true);
    this.renderWidget.setAttribute("ondragstart", "doDrag(event)");
    this.touchEvent = false;
    this.gestureEvent = false;
    this.seriesIndex;
    this.selfReference = this;
    //this.imageUid;
	this.studyUid;
	this.imageUid;
};
var xPostion = 10;
var yPostion = 10;
var fillColour = "yellow";
var font = "bold 8pt Helvetica";

/**
 *@param imageUid
 *@param appendTo
 *@param seriesIndex
 *@param imageCountOfSeries
 *Create the thumbnail url and send request when the requeststatus is success
 *create the div for series thumbnail and draw the thumbnail image in canvas
 */
ThumbnailRenderer.prototype.createThumbnail = function (studyUid,imageUid, appendTo, seriesIndex, imageCountOfSeries) {
    this.seriesIndex = seriesIndex;
    this.imageUid = imageUid;
    this.imageCountOfSeries = imageCountOfSeries;
    document.getElementById(appendTo).appendChild(this.renderWidget);

    if(thumbnailWidth == undefined ) {
        thumbnailWidth = document.getElementById(appendTo).offsetWidth;
    }

    //Load image
	var urlParameters = dicomViewer.getThumbnailUrl(imageUid);
    var url = dicomViewer.url.getDicomImageURL(urlParameters);
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    var thumbnailRendererObject = this;
	var cacheIndicatorDisplay = "";
    request.send();
    
    request.onreadystatechange = function () {
        if (request.readyState == 4 && request.status == 200) {
            var image = dicomViewer.Series.Image.getImage(studyUid,seriesIndex, 0);
            var instanceNumber = "&nbsp";
            if (dicomViewer.thumbnail.isImageThumbnail(image)) {
                instanceNumber = image.instanceNumber;
            } else {
                instanceNumber = seriesIndex + 1;
            }
            var imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
            var modality = changeNullToEmpty(dicomViewer.Series.getModality(studyUid, seriesIndex));
            var seriesTimeId = image.imageUid + "seriesTime";
			if(modality == "") modality = "&nbsp";
            if(imageCount == "") imageCount = "&nbsp";
            if(instanceNumber == "") instanceNumber = "&nbsp";
            
            var datadiv = "";
            var imageFileId = undefined;
            var imageFileDescription = "";
            if(image.imageType === IMAGETYPE_JPEG || isBlob(image.imageType)) {
                imageFileId = seriesTimeId + "_" + instanceNumber;

              	datadiv  =  "<div class='row'>" +
                        	"<div id='" + imageFileId + "' class='col-xs-2'><font color='#D2F4EF'>" + imageFileDescription + "</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + imageCount + "</font></div>" 
							+ "</div>"
            }else{
              datadiv  = "<div class='row'>" +
                "<div class='col-xs-2'><font color='#D2F4EF'>" + modality + "</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + imageCount + "</font></div>" 
                  + "</div>"
            }
            var seriesDescText = getSeriesDescription(studyUid, seriesIndex);
            var seriesDesc = showSeriesDescription(studyUid, seriesIndex);
            $("#" + appendTo).prepend(seriesDesc);
            if(seriesDescText != undefined && seriesDescText != "")
                updateToolTip($("#" + appendTo ), seriesDescText, 'top');
            
            $("#" + appendTo).append(datadiv);
            if(image.imageType === IMAGETYPE_JPEG || isBlob(image.imageType)) {
                if(imageFileId != undefined && imageFileDescription != "") {
                    updateToolTip($("#" + imageFileId ), image.fileName, 'top');
                }
            }

            if(image.imageType == IMAGETYPE_JPEG || image.imageType == IMAGETYPE_RADPDF || image.imageType == IMAGETYPE_PDF || isBlob(image.imageType)){
                if(image.imageUid !== undefined && studyUid !== undefined){
                    if(nonDICOMCacheDetails[image.imageUid] == undefined) {
                        nonDICOMCacheDetails[image.imageUid] = studyUid;
                        nonDICOMRenderedCount++;
                    }else {
                        for(key in nonDICOMCacheDetails){
                            if(key !== image.imageUid){
                                nonDICOMCacheDetails[image.imageUid] = studyUid;
                                nonDICOMRenderedCount++;
                            }
                        }
                    }
                    updateThumbnailCacheIndication(image.imageUid, "green");
                }
            }

            if(thumbnailHeight == undefined){
                thumbnailHeight = document.getElementById(appendTo).offsetHeight;
            }

            thumbnailRendererObject.draw(studyUid, JSON.parse(request.responseText).imageData, appendTo);
            var lastDivId = $("#imageThumbnail_View div").last().parent().parent().attr('id');

            if(thumbnailHeight && thumbnailWidth) {
                document.getElementById(appendTo).style.height = thumbnailHeight +"px";
                document.getElementById(appendTo).style.width = thumbnailWidth + "px";
             }

            if(lastDivId === appendTo)
            {
                dicomViewer.resizeThumbnailPanel();
            }
        } else if (request.readyState == 4 && (request.status == 404 || request.status == 500)) {
            // If the requested thumbnail image is not loaded successfully, we just shown empty values to add thumbnail gap issue.
            var modality = "&nbsp";
            var seriesTimeId = "&nbsp";
            var imageCount = "&nbsp";
            var instanceNumber = "&nbsp";
            var datadiv = "<div class='row'>" +
                "<div class='col-xs-2'><font color='#D2F4EF'>" + modality + "</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + imageCount + "</font></div>" + "</div>"
            $("#" + appendTo).append(datadiv);
        }
    }
};

/**
 *@param imageUid
 *@param appendTo
 *@param seriesIndex
 *@param imageCountOfSeries
 *Create the thumbnail url and send request when the requeststatus is success
 *create the div for image thumbnail and draw the thumbnail image in canvas
 */
ThumbnailRenderer.prototype.createImageThumbnail = function (studyUid, imageUid, appendTo, seriesIndex, imageCountOfSeries) {
    this.seriesIndex = seriesIndex;
    this.imageUid = imageUid;
    this.imageCountOfSeries = imageCountOfSeries;
    document.getElementById(appendTo).appendChild(this.renderWidget);

    //Load image
    var urlParameters = dicomViewer.getThumbnailUrl(imageUid);
    var url = dicomViewer.url.getDicomImageURL(urlParameters);
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    var thumbnailRendererObject = this;
	var cacheIndicatorDisplay = "";
	if(dicomViewer.thumbnail.isShowCacheIndicatorOnThumbnail())
        cacheIndicatorDisplay = "block";
    else
       cacheIndicatorDisplay = "none";
    request.send();
    request.onreadystatechange = function () {
        if (request.readyState == 4 && request.status == 200) {
            var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageCountOfSeries - 1);
            var seriesTimeId = image.imageUid + "seriesTime";
            var modality = dicomViewer.Series.getModality(studyUid, seriesIndex);
            var instanceNumber = "&nbsp";
            var framecount = dicomViewer.Series.Image.getImageFrameCount(image);

            if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex)) {
                instanceNumber = image.instanceNumber;
            } else {
                instanceNumber = seriesIndex + 1;
            }

			if(modality == "") modality = "&nbsp";
            if(framecount == "") framecount = "&nbsp";
            if(instanceNumber == "") instanceNumber = "&nbsp";
            var datadiv = "<div class='row'>" +
                "<div class='col-xs-2'><font color='#D2F4EF'>" + modality  +"</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row' style='height:10px'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + framecount + "</font></div>" + "</div>";
            
            $("#" + appendTo).append(datadiv);
            
            //Show the series description in the thumbnail
            var seriesDescText = getSeriesDescription(studyUid, seriesIndex);
            var seriesDesc = showSeriesDescription(studyUid, seriesIndex);
            $("#" + appendTo).prepend(seriesDesc);
            if(seriesDescText != undefined && seriesDescText != "")
                updateToolTip($("#" + appendTo ), seriesDescText, 'top');

            if(thumbnailHeight == undefined) {
                thumbnailHeight = document.getElementById(appendTo).offsetHeight;
            }

            thumbnailRendererObject.draw(studyUid, JSON.parse(request.responseText).imageData, appendTo);
            var lastDivId = $("#imageThumbnail_View div").last().parent().parent().attr('id'); //document.getElementById("myList").lastChild

            if(thumbnailHeight && thumbnailWidth) {
                document.getElementById(appendTo).style.height = thumbnailHeight +"px";
                document.getElementById(appendTo).style.width = thumbnailWidth + "px";
             }

            if(lastDivId === appendTo)
            {
                dicomViewer.resizeThumbnailPanel();
            }
        } else if (request.readyState == 4 && (request.status == 404 || request.status == 500)) {
            // If the requested thumbnail image is not loaded successfully, we just shown empty values to add thumbnail gap issue.
            var modality = "&nbsp";
            var seriesTimeId = "&nbsp";
            var imageCount = "&nbsp";
            var instanceNumber = "&nbsp";
            var datadiv = "<div class='row'>" +
                "<div class='col-xs-2'><font color='#D2F4EF'>" + modality + "</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + imageCount + "</font></div>" + "</div></div>";
            $("#" + appendTo).append(datadiv);
        }
    }
};

/**
 *@param dataURL
 *Using the dataURL(contaions the url path of thumbnail image) display thumbnail image
 */
ThumbnailRenderer.prototype.draw = function (studyUid, dataURL, thumbnailId) {

    var context = this.renderWidget.getContext("2d");
    var imageCount = dicomViewer.Series.getImageCount(studyUid,this.seriesIndex);
    //For shifting the thumbnail image at the center (movement along x-axis)
    var widthMultiplier = ($("#"+thumbnailId).width())/100;
    // load image from data url
    var imageObj = new Image();
    imageObj.onload = function () {
        context.translate(50 * widthMultiplier, 50);
        var scale = Math.min(100 / this.width, 100 / this.height);
        context.scale(scale, scale);
        context.drawImage(this, -this.width / 2, -this.height / 2);
        context.fillStyle = fillColour;
        context.font = font;
        var lastDivId = $("#imageThumbnail_View div").last().parent().parent().attr('id');
        if(lastDivId === thumbnailId) {
            //dicomViewer.resizeThumbnailPanel();
        }
    };
    imageObj.src = dataURL;
};
ThumbnailRenderer.prototype.setStudyUid = function (studyUid) {
	this.studyUid = studyUid;
}
ThumbnailRenderer.prototype.getStudyUid = function () {
	return this.studyUid;
}
/*
 * loadSeries : to load the series from thumbnail to current viewport using
 * touch double tab
 */
var touchCount = 0;
var elementId = null;

function loadSeries(ev) {
    ev.preventDefault();
    var thumbnailId = $('#' + ev.target.id).parent().attr('id');
    var thumbnailRenderer = dicomViewer.thumbnail.getThumbnail(thumbnailId);
    loadImageInViewer(thumbnailRenderer);
}

/**
 *@param ev
 *Using ev get the thumbnail div id and get the thumbnail render object and set values to the MouseEvent
 */
function doDrag(ev) {
    var thumbnailRenderer = dicomViewer.thumbnail.getThumbnail($('#' + ev.target.id).parent().attr('id'));
	dragThumbnailStudyUid = thumbnailRenderer.getStudyUid();
	var dragThumDetails = "text";
	ev.dataTransfer.setData(dragThumDetails, ev.target.id);
}

function loadImage(ev) {
    var thumbnailId = ev.currentTarget.id;
    var thumbnailRenderer = dicomViewer.thumbnail.getThumbnail(thumbnailId);
    loadImageInViewer(thumbnailRenderer, thumbnailId);
}
function loadImageInViewer(thumbnailRenderer, thumbnailId) {
    
	if(thumbnailRenderer.imageCountOfSeries === undefined) thumbnailRenderer.imageCountOfSeries = 1;

    // Get the series layout
    var seriesLayout = getAndSelectLayout(thumbnailRenderer.studyUid);
    var isViewportHeightUpdate = false;
     if(seriesLayout.studyUid == undefined || seriesLayout.setStudyUid == null) {
        isViewportHeightUpdate = true;
    }
    if((seriesLayout.studyUid !== undefined || seriesLayout.studyUid != null) &&thumbnailRenderer.studyUid != seriesLayout.studyUid)
    {
        dicomViewer.thumbnail.alertThumbnailSelection(thumbnailId);
        return;
    } else if(!IsSameStudy(thumbnailRenderer.studyUid)) {
        dicomViewer.thumbnail.alertThumbnailSelection(thumbnailId);
        return;
    }
    var studyUid = thumbnailRenderer.getStudyUid();
    var currentSeriesLayoutId = seriesLayout.seriesLayoutId;
    var imageIndex = undefined;
    if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, thumbnailRenderer.seriesIndex)) {
        imageIndex = parseInt( dicomViewer.Series.Image.getImageIndex(studyUid, thumbnailRenderer.seriesIndex, thumbnailRenderer.imageUid));
    }
    else {
        imageIndex = getImageIndexBySeriesIndex(studyUid, thumbnailRenderer.seriesIndex);
    }

    // Allow to load the new/same series 
    if(seriesLayout.seriesIndex === undefined && imageIndex !== undefined) {
        imageIndex = undefined;
    }

    var viewport = dicomViewer.viewports.getViewportByImageIndex(studyUid, thumbnailRenderer.seriesIndex, imageIndex);

    // Check whether the active viewport and selected series view port id is same
    if(isFullScreenEnabled == true && viewport !== undefined && seriesLayout !== undefined) {
        if(getStudyLayoutId(viewport.seriesLayoutId) === getStudyLayoutId(seriesLayout.seriesLayoutId)) {
            viewport = undefined;
        }
    }

    var checkViewport = true;
    if(viewport === undefined && imageIndex !== -1) {
        checkViewport = dicomViewer.viewports.checkVewportAvailable(currentSeriesLayoutId, studyUid);
        if(!checkViewport) {
            return;
        }
        seriesLayout.setStudyUid(studyUid);
        if(isViewportHeightUpdate) {
            var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, thumbnailRenderer.seriesIndex, 0);
            viewportHeight(seriesLayout.seriesLayoutId,image.imageType);
        }
        dicomViewer.loadImageFromThumbnail(thumbnailRenderer.seriesIndex, thumbnailRenderer.imageCountOfSeries);
        if(isViewportHeightUpdate && dicomViewer.isDicomStudy(seriesLayout.studyUid) && document.getElementById(seriesLayout.seriesLayoutId+"_progress")) {
            var progressHeight = document.getElementById(seriesLayout.seriesLayoutId+"_progress").style.top;
            progressHeight = progressHeight.replace('px','');
            document.getElementById(seriesLayout.seriesLayoutId+"_progress").style.top = (parseInt(progressHeight)+15) + "px" ;
            var viewportId = (seriesLayout.seriesLayoutId).split("_")[1];
            dicomViewer.createSaveAndLoadPStateGUI("saveAndLoad_"+viewportId, seriesLayout.studyUid, viewportId);
        }

    }else if(viewport === undefined && imageIndex === -1){
		seriesLayout.setStudyUid(studyUid);
		dicomViewer.setActiveSeriesLayout(seriesLayout);
		dicomViewer.loadImageFromThumbnail(thumbnailRenderer.seriesIndex, thumbnailRenderer.imageCountOfSeries);
	}else if(viewport !== undefined && seriesLayout.studyUid === undefined) {
		seriesLayout.setStudyUid(studyUid);
		dicomViewer.setActiveSeriesLayout(seriesLayout);
		dicomViewer.loadImageFromThumbnail(thumbnailRenderer.seriesIndex, thumbnailRenderer.imageCountOfSeries);
	}else {
        dicomViewer.changeSelection(viewport.seriesLayoutId);
    }
    if(myDropDown !== null) myDropDown.wrapper.hide();
     var image = dicomViewer.Series.Image.getImage(thumbnailRenderer.studyUid,thumbnailRenderer.seriesIndex, thumbnailRenderer.imageCountOfSeries-1);
    if (dicomViewer.thumbnail.canRunCine(image)) {
        dicomViewer.startCine();
    } else {
        dicomViewer.scroll.stopCineImage(undefined);
    }
    
    //Toggling the state of the Next and Previous Image/Series Button on mouse wheel click
    EnableDisableNextSeriesImage(seriesLayout);
}

function getImageIndexBySeriesIndex(studyUid, seriesIndex) {
    var allViewports = dicomViewer.viewports.getAllViewports();
    if(allViewports === null || allViewports === undefined) {
        return;
    }

    var imageIndex = undefined;
    $.each(allViewports, function(key, value) {
        if(value.studyUid === studyUid && value.seriesIndex === seriesIndex) {
            imageIndex = value.scrollData.imageIndex;
            return false;
        }
    });

    return imageIndex;
}

function updateThumbnailCacheIndication(imageUid, color){
    var progressDiv;
    if(color === "green")
        progressDiv= "<img id='test' style='width:20px;'  src='../images/download-complete.png' />";
    else if(color === "yellow")
        progressDiv= "<img id='test' style='width:20px;'  src='../images/download-inprogress.png' />";
    else
       progressDiv= "";
    $("#"+imageUid+"seriesTime").html(progressDiv);
}

function  showSeriesDescription(studyUid, seriesIndex){
    var seriesDesc = getSeriesDescription(studyUid, seriesIndex); 
    if(seriesDesc === undefined || seriesDesc === null) 
        seriesDesc = "";
    else if(seriesDesc.length > 16){
        seriesDesc = seriesDesc.substring(0, 15);
    }
    var seriesDescID = "<div text align='top'><div ><font color='white'>" +seriesDesc+ "</font></div></div>";
    
    return seriesDescID;
}

function getSeriesDescription(studyUid, seriesIndex){
    return dicomViewer.Series.getSeriesDescription(studyUid, seriesIndex);
}

/**
 * Get the series layout id
 * @param {Type} studyUid - Study Uid
 */ 
function getSeriesLayoutId(studyUid) {
    try
    {
        if(studyUid === null || studyUid === undefined) {
            return undefined;
        }

        var allViewports = dicomViewer.viewports.getAllViewports();
        if(allViewports === null || allViewports === undefined) {
            return undefined;
        }

        // Get the matched series layout id
        var seriesLayoutId = undefined;
        $.each(allViewports, function(key, value) {
            if(value.studyUid === studyUid) {
                seriesLayoutId = value.seriesLayoutId;
                return false;
            }
        });

        // Get the unoccupied viewport 
        if(seriesLayoutId === undefined) {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            if(seriesLayout === undefined) {
                return undefined;
            }

            // Check whether active view port is occupied
            if(seriesLayout.studyUid === undefined) {
                return seriesLayout.getSeriesLayoutId();
            }

            // Get the first unoccupied viewport
            var seriesLayouts = [];
            $.each(allViewports, function(key, value) {
                if(value.studyUid === undefined) {
                    seriesLayouts.push(value.seriesLayoutId);
                }
            });

            // Check whether the layout is valid or not 
            if(seriesLayouts === null || seriesLayouts === undefined) {
                return undefined;
            }

            // Sort the layout values to load the selected study in the first unoccupied viewport
            if(seriesLayouts.length > 0) {
                seriesLayouts.sort();
                seriesLayoutId = seriesLayouts[0];
            }
        }

        return seriesLayoutId;
    }
    catch(e)
    { }

    return undefined;
}

/**
 * Get and select the layout
 * @param {Type} studyUid - Study Uid
 */ 
function getAndSelectLayout(studyUid) {
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    
    try
    {
        // Check whether the active and selected study Uid is same.
        if(seriesLayout.studyUid === studyUid) {
            return seriesLayout;
        }

        // Get the series layout Id
        var seriesLayoutId = getSeriesLayoutId(studyUid);
        if(seriesLayoutId === undefined) {
            return seriesLayout;
        }

        // Check whether both layout are same.
        if(seriesLayoutId === seriesLayout.getSeriesLayoutId()) {
            return seriesLayout;
        }

        // Change the layout selection
        if(!dicomViewer.IsFullScreenMode()) {
            dicomViewer.changeSelection(seriesLayoutId);
            seriesLayout = dicomViewer.getActiveSeriesLayout();
        }

        return seriesLayout;
    }
    catch(e)
    {
    }

    return seriesLayout;
}

/**
 * Check whether the study is same in 1x1 study layout
 * @param {Type} studyUid - Specifies the study Uid
 */ 
function IsSameStudy(studyUid) {
    if(dicomViewer.IsFullScreenMode()) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if(seriesLayout !== undefined && seriesLayout.studyUid !== undefined) {
            if(seriesLayout.studyUid === studyUid) {
                return true;
            }
        } else if(seriesLayout.studyUid === undefined) {
            // Allow to load the study because the active view port is empty
            return true;
        }

        return false;
    }

    return true;
}