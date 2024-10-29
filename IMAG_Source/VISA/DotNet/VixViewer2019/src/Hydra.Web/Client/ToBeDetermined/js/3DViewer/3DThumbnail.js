/**
 * Thumbnail creator
 */
var dicomViewer = (function(dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    var thumbnailProcessing = [];
    var thumbnails = {};
//    var showCacheIndicatorOnThumbnail = false;
    /**
     *Create the thumbnail based on the image level or series level
     */
    function createThumbnail(studyUid) {
        createOrAppendThumbnail(studyUid, 0, true);
    }
    /**
     *@param image
     *@param modality
     *Based on the modality it ill return true(US,CR,ES,DX,XA) or false
     */
    function isImageThumbnail(image, checkOnModality) {
        if(image !== undefined && image !== null) {
            if(image.numberOfFrames !== undefined && image.numberOfFrames !== null) {
                if(image.numberOfFrames > 1) {
                    return true;
                } else {
                    if (image.modality === "US" ||
                        image.modality === "CR" ||
                        image.modality === "ES" ||
                        image.modality === "DX" ||
                        image.modality === "XA" ||
                        image.modality === "ECG" ||
                        image.modality === "XC" ||
                        image.modality === "OP") {
                        return true;
                    }
                }
            } else {
                if (image.modality === "US" ||
                    image.modality === "CR" ||
                    image.modality === "ES" ||
                    image.modality === "DX" ||
                    image.modality === "XA" ||
                    image.modality === "ECG" ||
                    image.modality === "XC" ||
                    image.modality === "OP") {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Check whether the cine can run or not
     * @param {Type} image 
     */ 
    function canRunCine(image) {
        if(image !== undefined && image !== null) {
            if(image.numberOfFrames !== undefined && image.numberOfFrames !== null) {
                if(image.numberOfFrames > 1) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     *@param image
     *@param modality
     *Based on the modality it ill return true(US,CR,DR,DX,XA) or false
     */
    function isSeriesContainsMultiframe(studyUid,seriesIndex) {
        var numberOfImages = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
        for(var imageIndex = 0; imageIndex < numberOfImages; imageIndex++)
        {
            var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
            if(isImageThumbnail(image,false)) return true;
        }
        return false;
    }
    /**
     *@param seriesIndex
     *@param numberOfimages
     *@param imageThumbDiv
     *Using the seriesIndex, numberOfimages, imageThumbDiv create the image thumbnails
     */
    function createImageThumbail(studyUid, seriesIndex, numberOfimages, imageThumbDiv) {
        for (var i = 0; i < numberOfimages; i++) {
            var thumbnailId = 'imageviewer_' + dicomViewer.replaceDotValue(studyUid) + "_" + seriesIndex + '_thumb' + i
            var thumbnailString = '<div id="' + thumbnailId + '" style="clear:right; width:auto;background:black;margin-right: 5px; margin-bottom: 5px; " class="default-thumbnail-view col-xs-12" onclick="loadImage(event)"></div>';
            $("#thumb_" + imageThumbDiv).append(thumbnailString);
            var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, i);
            /*$("#" +imageThumbDiv).append(thumbnailString);*/
            var imageUid = dicomViewer.Series.Image.getImageUid(image);
            var thumb = new ThumbnailRenderer();
            thumb.createImageThumbnail(studyUid, imageUid, thumbnailId, seriesIndex, i + 1);
            thumb.setStudyUid(studyUid);
            addThumbnails(thumbnailId, thumb);

            if(thumbnailWidth == undefined ) {
                thumbnailWidth = document.getElementById(thumbnailId).offsetWidth;
            }
        }
    }
    /**
     *@param selectedSeriesIndex
     *Based on the thumbnail div id select the thumbnail(display green border to thumbnail)
     */
    function selectThumbnail(selectedSeriesIndex) {
        removeSelctedThumbnail();
        var seriesLayout = dicomViewer.getActiveSeriesLayout()
        var thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(seriesLayout.studyUid) + "_" + selectedSeriesIndex + "_thumb";
        if (!$(thumbnailId).hasClass('selected-thumbnail-view')) {
            $(thumbnailId).removeClass(
                'default-thumbnail-view').addClass('selected-thumbnail-view');
            makeThumbnailVisible(thumbnailId);
        }
    }

    /**
     *@param alertThumbnailSelection
     *Based on the thumbnail div id disselect the thumbnail(display red border to thumbnail)
     */
    function alertThumbnailSelection(thumbnailId) {
        removeSelctedThumbnail();
        if (!$("#"+thumbnailId).hasClass('alert-thumbnail-view')) {
            $("#"+thumbnailId).removeClass(
            'default-thumbnail-view').addClass('alert-thumbnail-view');
        }
    }

    /**
     *@param thumbnailId
     *@param thumbnail
     *Uing the thumbnail div id as key storing the thumbnail render object as value in the thumbnails
     */
    function addThumbnails(thumbnailId, thumbnail) {
        if (thumbnailId === undefined) {
            throw "thumbnailId should not be null/undefined";
        }
        if (thumbnail === undefined) {
            throw "thumbnail should not be null/undefined";
        }
        thumbnails[thumbnailId] = thumbnail;
    }
    /**
     *@param selectedSeriesIndex
     *@param imageIndex
     *Based on the thumbnail div id select the thumbnail(display green border to thumbnail) for image level thumbnails
     */
    function selectImageThumbnail(selectedSeriesIndex, imageIndex) {        
        var sereiesLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = sereiesLayout.studyUid;
        removeSelctedThumbnail();
        var thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (selectedSeriesIndex) + "_thumb";
        if (!$(thumbnailId).hasClass('selected-thumbnail-view')) {
            var element = document.getElementById(thumbnailId);
            if (element == null || element == undefined) {
                thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (selectedSeriesIndex) + "_thumb" + (imageIndex);
            }

            //document.getElementById(thumbnailId).className = "selected-thumbnail-view"

            $("#" + thumbnailId).removeClass(
                'default-thumbnail-view').addClass('selected-thumbnail-view');

            makeThumbnailVisible(thumbnailId);
        }
    }
    /**
     *@param thumbnailId
     *Get the thumbnail render boject based on the thumnail id
     */
    function getThumbnail(thumbnailId) {
        if (thumbnailId === undefined) {
            throw "thumbnailId should not be null/undefined";
        }
        return thumbnails[thumbnailId];
    }
    
     /**    
     *Get the thumbnails render boject
     */
    function getAllThumbnails() {
        return thumbnails;
    }

    function removeSelctedThumbnail() {
        $(".selected-thumbnail-view").removeClass('selected-thumbnail-view')
            .addClass('default-thumbnail-view');
        $(".alert-thumbnail-view").removeClass('alert-thumbnail-view')
            .addClass('default-thumbnail-view');
    }

    /**
     * Calculate the currently selected thumbnail position whether the whole thumbnail is visible to the user.
     * Auto scroll the thumbnail if the thumbnail is not fully visible to the user.
     */
    function makeThumbnailVisible(elementId) {

        var element = document.getElementById(elementId);
        if (element === null) {
            return;
        }

        // Get the scrollbar height and calculate the bottom
        var docViewTop = $(window).scrollTop();
        var docViewBottom = docViewTop + $(window).height();

        // Get the selected thumbnail and get height and calculate the bottom
        var elementTop = $(element).offset().top;
        var elementBottom = elementTop + $(element).height();

        // Check whether the selected thumbnail is aligned in fully visible area.
        var isFullyVisible = (docViewTop <= elementTop) && (docViewBottom >= elementBottom);

        // If the thumbnail is fully visible then we do not need to scroll the view. So simply return if it is true.
        if (isFullyVisible) {
            return;
        }

        // Get the align orientation. If the thumbnail is aligned near to top then the scroll will be fit with topside.
        // Otherwise will choose to align at bottom of the scrollbar.
        var isTopAlign = (docViewTop - elementTop) > (elementBottom - docViewBottom);
        element.scrollIntoView(isTopAlign);
    }

    function replaceDotValue(value) {
        return value.replace(/\./g, '');
    }

    /**
     * Replace all the special characters
     * @param {Type} value - Specifies the input
     */ 
    function replaceSpecialsValues(value) {
        return value.replace(/[^A-Za-z0-9]/g, '');
    }

    function resizeThumbnailPanel() {
        //To resize the thumbnail panel based the scrool panel
        var imageThumbnailViewElement = $("#imageThumbnail_View");
        //height of image thumbnail view
        var heightOfImageThumbnail = imageThumbnailViewElement.height();
        //first study level thumbnail 
        var studyThumbnailElement = imageThumbnailViewElement.children();
        var heightOfStudyThumbnails = 0;
        studyThumbnailElement.each(function() {
            var elementId = this.id;
            if (elementId != "" && elementId != undefined) {
                heightOfStudyThumbnails = heightOfStudyThumbnails + $("#" + elementId).outerHeight();
            }
        });

        if (heightOfStudyThumbnails < heightOfImageThumbnail) {
            myLayout = $('body').layout({
                west__minSize: (THUMBNAIL_PANEL_WIDTH - 10)
            });
            var widthOfThumbnailPanel = $("#img").outerWidth();
            myLayout.sizePane("west", THUMBNAIL_PANEL_WIDTH - 10);
            if (widthOfThumbnailPanel != (THUMBNAIL_PANEL_WIDTH - 10))
                reloadViewPort();
        } else {
            myLayout.sizePane("west", THUMBNAIL_PANEL_WIDTH);
        }

    }

    /**
     * set the viewport series index,frame index,image index to an array
     */ 
    function setViewportProperty() {
        thumbnailProcessing= [];
        var pushValues;
        var allViewports = dicomViewer.viewports.getAllViewports();
        $.each(allViewports, function(key, value) {
            if(value.studyUid !== undefined) {
                pushValues = value.seriesLayoutId + "|" + value.seriesIndex + "|" +
                             value.scrollData.imageIndex + "|" + value.scrollData.frameIndex + "|" + 
                             value.imageLayoutDimension;
                thumbnailProcessing.push(pushValues);
            }
        });
    }

    /**
     * return the current viewport properties
     * @param {Type} seriesLayoutId - specifies the viewport id
     */ 
    function getViewportProperty(seriesLayoutId) {
        if(thumbnailProcessing != null || thumbnailProcessing != undefined) {
            for(var i=0;i<thumbnailProcessing.length;i++) {
                if(thumbnailProcessing[i].split("|")[0] == seriesLayoutId) {
                    return thumbnailProcessing[i];
                }
            }
        }
        return null;
    }

    /**
     * Show or Hide the entire thumbnail panel on Double-Click(hiding)/Click(showing)
     */ 
    function closeThumbnailPanel() {
        isCineEnabled(true);
        var obj = {
            id: "studyViewer1x1"
        }
        var viewportElement = $('#viewport_View');
        viewportElement.width("100%");
        viewportElement.height("100%");

        var seriesLayoutId = undefined;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if(seriesLayout !== undefined) {
            seriesLayoutId = seriesLayout.getSeriesLayoutId();
        }

        setViewportProperty();

        //Updating the Cine manager with the selected viewport study id on the basis of the Cine player state
        var splitedRowAndColumn = studyLayoutValue.split("x");
        var studyRow = splitedRowAndColumn[0];
        var studyColumn = splitedRowAndColumn[1];
        for (var i = 1; i <= studyRow; i++) {
            for (var j = 1; j <= studyColumn; j++) {
                var studyDiv = "studyViewer" + i + "x" + j;
                var rowCalValue = layoutMap[studyDiv];
                if (rowCalValue == undefined) {
                    rowCalValue = "1x1";
                }
                var rcArray = rowCalValue.split("x");
                dicomViewer.tools.chanageWhileDrag(rcArray[0], rcArray[1], studyDiv,true);
            }
        }
        
        isCineEnabled(false);

        // Maintain the previous selection
        if(seriesLayoutId !== undefined) {
            dicomViewer.changeSelection(seriesLayoutId);
        }
    }

    /**
     * Remove the thumbnail context's 
     */ 
    function removeThumbnailContext(studyUid) {
        try
        {
            var studyDetials = dicomViewer.getStudyDetails(studyUid);            
            if(studyDetials !== null && studyDetials !== undefined) {
                if(!studyDetials.isDicom) {
                    studyDetials.forEach(function(nonDicom) {
                        if(nonDicom !== null && nonDicom !== undefined){
                            removeContextId(nonDicom.contextId);
                        }
                     });
                } else {
                    removeContextId(studyDetials.contextId);
                }
            }
        }
        catch(e)
        { }
    }

    /**
     * Create or append the thumbanail
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} seriesStartingIndex - Specifies the starting series index to create the thumbnails.
     * @param {Type} isNewThumbnailPanel - Specifies the flag to create or append the thumbnail panel.
     */ 
    function createOrAppendThumbnail(studyUid, seriesStartingIndex, isNewThumbnailPanel) {
        try
        {
            var studyThumbDivId = "study_thumb_" + replaceDotValue(studyUid);
            var studyThumbnailDiv = "<div id=" + studyThumbDivId + " style='border: 3px solid rgba(92, 93, 100, 0.59);background: rgba(152, 153, 158, 0.59);" + "overflow-x: hidden;overflow-y: hidden;'/><br id=break_" + replaceDotValue(studyUid) + ">";
            var studyDetials = dicomViewer.getStudyDetails(studyUid);
            var studyInfoDiv = "";
            var studyTime = "";
            if(studyDetials.dateTime !== null && studyDetials.dateTime !== undefined) {
                studyTime = studyDetials.dateTime.replace("T", "@")
            }

            if (!studyDetials.isDicom) {
                studyInfoDiv = "<table style='width:100%;'>" + "<tr>" + "<td>" + "<div title='" + studyDetials.procedure + "'  id='studyInfo_" + studyUid + "' style='color:white;padding-left:4px'>" + studyDetials.procedure + "<br>" + studyTime + "<br>" + "</div>" + "</td>" + "<td>" + "<span  title='close' style='padding-bottom: 8px;' onclick=dicomViewer.thumbnail.closeThumbnail('" + studyUid + "')><img src='../images/close.png' style='width: 8px;'></img> </span>" + "</td>" + "</tr>" + "</table>"
            } else {
                studyInfoDiv = "<table style='width:100%;'>" + "<tr>" + "<td>" + "<div title='" + studyDetials.procedure + "' id='studyInfo_" + studyUid + "' style='color:white;padding-left:4px'>" + studyDetials.procedure + "<br>" + studyDetials.dicomStudyId + "<br>" + studyTime + "</div>" + "</td>" + "<td>" + "<span title='close' style='padding-bottom: 8px;' onclick=dicomViewer.thumbnail.closeThumbnail('" + studyUid + "')><img src='../images/close.png' style='width: 8px;'></img> </span>" + "</td>" + "</tr>" + "</table>"
            }

            // Create the new thumbnail panel
            isNewThumbnailPanel = (isNewThumbnailPanel === undefined ? true : isNewThumbnailPanel);
            if(isNewThumbnailPanel) {
                $("#imageThumbnail_View").append(studyThumbnailDiv);
                $("#" + studyThumbDivId).append(studyInfoDiv);
                $("#" + studyThumbDivId).append("<div id=thumb_" + studyThumbDivId + " style='padding-top: 4px;padding-left: 4px;'/>");
            }

            // Create the thumbnails
            var numberOfSeries = dicomViewer.Study.getSeriesCount(studyUid);
            for (var seriesIndex = seriesStartingIndex; seriesIndex < numberOfSeries; seriesIndex++) {
                var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, 0);
                var imageUid = dicomViewer.Series.Image.getImageUid(image);

                // Generate the thumbnail id
                var thumbnailId = 'imageviewer_' + replaceDotValue(studyUid) + "_" + seriesIndex + '_thumb'
                var thumbnailString = '<div id="' + thumbnailId + '" style="clear:right; width:auto;background:black; margin-right: 5px; margin-bottom: 5px; " onclick="loadImage(event)" class="default-thumbnail-view col-xs-12"></div>';

                if (!isBlob(image.imageType)) {
                    var modality = dicomViewer.Series.getModality(studyUid, seriesIndex);
                    var numberOfImage = dicomViewer.Series.getImageCount(studyUid, seriesIndex)
                    var isImageThumbnails = isSeriesContainsMultiframe(studyUid, seriesIndex);
                    if (isImageThumbnails) {
                        createImageThumbail(studyUid, seriesIndex, numberOfImage, studyThumbDivId);
                    } else {
                        $("#thumb_" + studyThumbDivId).append(thumbnailString);
                        var thumb = new ThumbnailRenderer();
                        thumb.setStudyUid(studyUid);
                        thumb.createThumbnail(studyUid, imageUid, thumbnailId, seriesIndex);
                        addThumbnails(thumbnailId, thumb);
                    }
                } else {
                    $("#thumb_" + studyThumbDivId).append(thumbnailString);
                    var thumb = new ThumbnailRenderer();
                    thumb.setStudyUid(studyUid);
                    thumb.createThumbnail(studyUid, imageUid, thumbnailId, seriesIndex);
                    addThumbnails(thumbnailId, thumb);
                }
            }
        }
        catch(e)
        { }
    }

    //This function used to close the specific study level thumbnails
    function closeThumbnail(studyUid) {
        var numberOfStudies = dicomViewer.getListOfStudyUid().length;
        var repacedStudyUid = dicomViewer.replaceDotValue(studyUid);
        $("#study_thumb_" + repacedStudyUid).remove();
        $("#break_" + repacedStudyUid).remove();
        dicomViewer.viewports.deleteViewportsByThumbnail(repacedStudyUid);

            // Remove the context from the display context
            removeThumbnailContext(studyUid);

        dicomViewer.removeStudyDetails(studyUid);

        if (numberOfStudies == 1) {
            showOrClearSession(false);
        } else if(numberOfStudies > 1) {
            adjustLayout();
        }
    }

//    function setShowCacheIndicatorOnThumbnail() {
//        if(showCacheIndicatorOnThumbnail === true) showCacheIndicatorOnThumbnail = false;
//        else showCacheIndicatorOnThumbnail = true;
//    }
//     function isShowCacheIndicatorOnThumbnail() {
//        return showCacheIndicatorOnThumbnail;
//    }
    dicomViewer.thumbnail = {
        createThumbnail: createThumbnail,
        selectThumbnail: selectThumbnail,
        alertThumbnailSelection: alertThumbnailSelection,
        selectImageThumbnail: selectImageThumbnail,
		removeSelctedThumbnail: removeSelctedThumbnail,
        getThumbnail: getThumbnail,
        getAllThumbnails : getAllThumbnails,
        isImageThumbnail: isImageThumbnail,
        makeThumbnailVisible: makeThumbnailVisible,
        closeThumbnail: closeThumbnail,
        closeThumbnailPanel: closeThumbnailPanel,
//        setShowCacheIndicatorOnThumbnail : setShowCacheIndicatorOnThumbnail,
//        isShowCacheIndicatorOnThumbnail : isShowCacheIndicatorOnThumbnail,
        isSeriesContainsMultiframe : isSeriesContainsMultiframe,
        removeThumbnailContext : removeThumbnailContext,
        createOrAppendThumbnail : createOrAppendThumbnail,
        getViewportProperty : getViewportProperty,
        setViewportProperty : setViewportProperty,
        canRunCine  : canRunCine
    };
    dicomViewer.resizeThumbnailPanel = resizeThumbnailPanel;
    dicomViewer.replaceDotValue = replaceDotValue;
    dicomViewer.replaceSpecialsValues = replaceSpecialsValues;

    return dicomViewer;
}(dicomViewer));