/**
 * Thumbnail creator
 */
var dicomViewer = (function (dicomViewer) {
    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var imageDispIndex = 0;

    /**
     * Check/uncheck the study level
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} isChecked - Specifies the check value
     */
    function checkStudy(studyUid, isChecked) {
        try {
            if (studyUid == undefined) {
                return;
            }
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails.imageGroups.length == undefined || studyDetails.imageGroups.length == 0) {
                return;
            }

            $('#imageviewer_' + replaceSpecialsValues(studyUid) + "_checkbox")[0].checked = isChecked;
            for (var seriesIndex in studyDetails.imageGroups) {
                checkSeries(studyUid, seriesIndex, isChecked);
            }
        } catch (e) {}
    }

    /**
     * Check/uncheck the series level
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} seriesIndex - Specifies the series index
     * @param {Type} isChecked - Specifies the check value
     */
    function checkSeries(studyUid, seriesIndex, isChecked) {
        try {
            if (studyUid == undefined || seriesIndex == undefined) {
                return;
            }

            var thumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb';
            document.getElementById(thumbnailId + "_checkbox").checked = isChecked;
            if ($("#" + thumbnailId).hasClass('selected-thumbnail-view')) {
                checkImages(studyUid, seriesIndex, isChecked);
            }
        } catch (e) {}
    }

    /**
     * Check/uncheck the images based on the series
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} seriesIndex - Specifies the series index
     * @param {Type} isChecked - Specifies the check value
     */
    function checkImages(studyUid, seriesIndex, isChecked) {
        try {
            if (studyUid == undefined || seriesIndex == undefined) {
                return;
            }

            var imageIndex = 0;
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails.groupType == 0) {
                if (studyDetails.imageGroups !== undefined) {
                    if (studyDetails.imageGroups[seriesIndex].images == null || studyDetails.imageGroups[seriesIndex].images.length == 0) {
                        return;
                    }
                    studyDetails.imageGroups[seriesIndex].images.forEach(function (image) {
                        var thumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb' + imageIndex;
                        document.getElementById(thumbnailId + "_checkbox").checked = isChecked;
                        imageIndex++;
                    });
                }
            }
        } catch (e) {}
    }

    /**
     * Create the thumbanail
     * @param {Type} studyUid - Specifies the study Uid
     */
    function create(studyUid, selectedSeries, layoutId) {
        try {
            var height = 180;
            var studyUids = dicomViewer.getListOfStudyUid();
            var margin = 7 + "px";
            var bottomHeight;

            var selectedSeriesIndex = (selectedSeries !== undefined) ? selectedSeries.seriesIndex : 0;
            var selectedImageIndex = (selectedSeries !== undefined) ? selectedSeries.imageIndex : 0;

            if (studyUids.length > 1) {
                margin = 0 + "px";
            }
            var thumbHeight = height;
            bottomHeight = studyUids.length * 3;

            if (studyUids.length > 4) {
                thumbHeight = studyUids.length + (height / studyUids.length) - (bottomHeight) + "px";
            } else {
                thumbHeight = (height / studyUids.length) - (bottomHeight) + "px";
            }

            document.getElementById(layoutId).style.height = height + "px";
            var studyThumbDivId = "series_group_thumb_" + replaceSpecialsValues(studyUid);
            var studyThumbnailDiv = "<div id=" + studyThumbDivId + " class='series_thumb_list' style='overflow:auto;width: 100%;height:100%;border: 3px solid rgba(92, 93, 100, 0.59);border-color: #808080;background:black;" + "overflow-x: scroll;'/><br id=break_" + replaceSpecialsValues(studyUid) + ">";
            var studyDetails = dicomViewer.getStudyDetails(studyUid);

            var studyInfoDiv = "<table style='width:100%;'>" + "<tr>";
            if (isDeleteEnabled || isSensitiveEnabled) {
                studyInfoDiv += "<td style='width:15px;padding-left:5px' align='left'><input type='checkbox' id='imageviewer_" + replaceSpecialsValues(studyUid) + "_checkbox' onclick='thumbnailCheckEvent(event,this)'; ></td>";
            }
            studyInfoDiv += "<td><div id='studyInfo_" + studyUid + "' style='color:white;padding-left:4px'>" + studyDetails.caption + "<br></div></td></tr></table>"

            // Create the new thumbnail panel
            $("#" + layoutId + "ImageLevel0x0").append(studyThumbnailDiv);
            $("#" + studyThumbDivId).append(studyInfoDiv);
            $("#" + studyThumbDivId).append("<div id=series_thumb_" + studyThumbDivId + " style='padding-top: 4px;padding-left: 4px;'/>");

            // Create the image group thumbnail div
            $("#manage_viewer").append("<div id=image_thumb_image_group_thumb_" + selectedSeriesIndex + "_" + replaceSpecialsValues(studyUid) + " class='image-container' style='padding-top: 4px;padding-left: 4px;'/>");

            setToolTip("studyInfo_" + studyUid, studyDetails.caption);

            var seriesIndex = 0;
            // Display the list of series which are presented in the study
            if (studyDetails.groupType == 0) {
                if (studyDetails.imageGroups !== undefined) {
                    studyDetails.imageGroups.forEach(function (series) {
                        // Generate the thumbnail id
                        var thumbnailId = 'imageviewer_' + replaceSpecialsValues(studyUid) + "_" + seriesIndex + '_thumb';
                        var thumbnailString = '<div id="' + thumbnailId + '" style="clear:right; width:auto;background:black; margin-right: 5px; margin-bottom: 3px; " onclick="loadSeries(event)" class="default-thumbnail-view col-xs-12"></div>';
                        $("#series_thumb_" + studyThumbDivId).append(thumbnailString);
                        var thumb = new ThumbnailRenderer();
                        $("#" + thumbnailId)[0].renderer = thumb;
                        thumb.createThumbnail({
                            studyUid: studyUid,
                            imageUid: BasicUtil.GetV4Guid(),
                            parent: thumbnailId,
                            seriesIndex: seriesIndex,
                            imageCountOfSeries: 0,
                            imageIndex: 0,
                            image: series,
                            imageCount: studyDetails.imageGroups[seriesIndex].images.length,
                            isImage: false,
                            seriesCount: studyDetails.imageGroups.length,
                            imageLoaded: false,
                            cachedImage: 0
                        });

                        seriesIndex++;
                    });
                }
            }

            // Load the selected series
            var selectedSeries = $("#imageviewer_" + replaceSpecialsValues(studyUid) + "_" + selectedSeriesIndex + "_thumb")[0];
            selectedSeries.renderer.defaultImage = selectedImageIndex;
            selectedSeries.click();

            // load all the series
            var i = 0;
            for (i = 0; i < studyDetails.imageGroups.length; i++) {
                if (selectedSeriesIndex !== i) {
                    var selectedSeriesId = "imageviewer_" + replaceSpecialsValues(studyUid) + "_" + i + "_thumb";
                    dicomViewer.thumbnail.selectSeries(selectedSeriesId, true);
                }
            }

            // Disable the image options
            $("#image_Delete").addClass("k-state-disabled");
            $("#image_Controlled").addClass("k-state-disabled");
            $("#image_Edit").addClass("k-state-disabled");
        } catch (e) {}
    }

    /**
     * 
     * @param {Type} studyUid 
     * @param {Type} seriesIndex 
     * @param {Type} imageIndex 
     */
    function displayInformation(studyUid, seriesIndex, imageIndex) {
        if (imageDispIndex == 0) {
            displayImageInfo(studyUid, seriesIndex, imageIndex);
            imageDispIndex++;
        }
    }

    /**
     * Display the image information
     * @param {Type} studyUid - Specifies the studyUid
     * @param {Type} seriesIndex - Specifies the series index
     * @param {Type} imageIndex - Specifies the image index
     */
    function displayImageInfo(studyUid, seriesIndex, imageIndex) {
        try {
            if (imageIndex == undefined) {
                $("#imageInfo").empty();
                return;
            }

            $("#imageInfo").empty();
            $("#imageInfo").html("<center>Fetching image information...</center>");

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === null || studyDetails === undefined) {
                return;
            }

            var imageGroups = studyDetails.imageGroups;
            if (imageGroups === null || imageGroups === undefined) {
                return;
            }

            var imageGroup = imageGroups[seriesIndex];
            if (imageGroup === null || imageGroup === undefined) {
                return;
            }

            var images = imageGroup.images;
            if (images === null || images === undefined) {
                return;
            }

            var image = images[imageIndex];
            if (image === null) {
                return;
            }

            var imageInfo = getImageInfo(image.imageId);
            if (imageInfo != undefined && imageInfo != null) {
                $("#imageInfo").empty();
                $("#imageInfo").html(imageInfo);
                return;
            }

            // Get the metada image information
            $.ajax({
                    url: dicomViewer.Metadata.ImageInfoUrl(image.imageId),
                    cache: false,
                    async: true
                })
                .done(function (data) {
                    if (data == undefined || data == null) {
                        return;
                    }
                    setImageInfo({
                        imageUid: image.imageId,
                        imageInfo: data
                    });

                    $("#imageInfo").empty();
                    $("#imageInfo").html(data);
                })
                .fail(function (data) {
                    $("#imageInfo").empty();
                    $("#imageInfo").html("Failed to get the image information");
                })
                .error(function (xhr, status) {
                    $("#imageInfo").empty();
                    $("#imageInfo").html(xhr.statusText + "\nFailed to get the image information");
                });
        } catch (e) {}
    }

    function createImageThumbnail(studyUid, seriesIndex, isLoadSeriesAuto) {
        try {
            if (!isLoadSeriesAuto) {
                clearLoadedThumbnail(studyUid, seriesIndex);
            }
            var imageIndex = 0;
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            // Display the list of images which are presented in the respective series
            if (studyDetails.groupType == 0) {
                if (studyDetails.imageGroups !== undefined) {
                    if (studyDetails.imageGroups[seriesIndex].images == null || studyDetails.imageGroups[seriesIndex].images.length == 0) {
                        return;
                    }
                    var replacedStudyUid = replaceSpecialsValues(studyUid);
                    var imageCount = $('#imageviewer_' + replacedStudyUid + "_" + seriesIndex + '_thumb')[0].renderer.imageCount;
                    var style = '" style="clear:right; width:auto;background:black; margin-right: 5px; margin-bottom: 5px; display: inline-block;" oncontextmenu="showThumbnailContextMenu(event)"; onclick="loadImage(event)" class="default-thumbnail-view col-xs-12"></div>';
                    studyDetails.imageGroups[seriesIndex].images.forEach(function (image) {
                        // Generate the thumbnail id
                        var thumbnailId = 'imageviewer_' + replacedStudyUid + "_" + seriesIndex + '_thumb' + imageIndex;
                        var thumbnailString = '<div id="' + thumbnailId + style;
                        var imageGroupId = "image_thumb_image_group_thumb_" + seriesIndex + "_" + replacedStudyUid;
                        if (!document.getElementById(imageGroupId)) {
                            $("#manage_viewer").append("<div id='" + imageGroupId + "' class='image-container' style='padding-top: 4px;padding-left: 4px; display:none'/>");
                        }
                        if (!document.getElementById(thumbnailId)) {
                            $("#" + imageGroupId).append(thumbnailString);


                            var imageUID = image.imageId;
                            if (imageUID === null || imageUID === undefined) {
                                imageUID = BasicUtil.GetV4Guid();
                            }

                            var thumb = new ThumbnailRenderer();
                            $("#" + thumbnailId)[0].renderer = thumb;
                            thumb.createThumbnail({
                                studyUid: studyUid,
                                imageUid: imageUID,
                                parent: thumbnailId,
                                seriesIndex: seriesIndex,
                                imageCountOfSeries: imageIndex,
                                imageIndex: imageIndex,
                                image: image,
                                imageCount: imageCount,
                                isImage: true,
                                isLoadSeriesAuto: isLoadSeriesAuto,
                                imageLoaded: false
                            });
                            imageIndex++;
                        }
                    });
                }
            }
        } catch (e) {}
    }

    /**
     * 
     * @param {Type} studyUid 
     */
    function clearLoadedThumbnail(studyUid, seriesIndex) {
        try {
            var previousId = document.getElementsByClassName("selected-image-thumbnail-view");
            if (previousId.length) {
                previousId = previousId[0].parentElement.id;
                document.getElementById(previousId).style.display = "none";
            }
            var divId = 'image_thumb_image_group_thumb_' + seriesIndex + "_" + replaceSpecialsValues(studyUid);
            document.getElementById(divId).style.display = "block";
            document.getElementById(divId).style.visibility = "visible";
        } catch (e) {}
    }

    /**
     * Show the splash window in center position
     * @param {Type} viewportId - specifies the view port id for the splash window
     */
    $.fn.center = function (viewportId) {
        this.css("position", "absolute");
        var topOffset = $("#" + viewportId).offset().top
        var leftOffset = $("#" + viewportId).offset().left
        var viewportHeight = ($("#" + viewportId).height()) - 40;
        var viewportWidth = (($("#" + viewportId).width()) - 300);
        this.css("top", ((viewportHeight) / 2 + topOffset) + "px");
        this.css("left", ((viewportWidth) / 2 + leftOffset) + "px");
        return this;
    }

    /**
     * 
     * @param {Type} obj 
     */
    function startWorkerToDownloadThumbnail(obj) {
        try {
            if (obj.response != "Failure") {
                var seriesTimeId = "&nbsp";
                var datadiv = "";
                var imageFileId = undefined;
                var imageFileDescription = "";
                var imageData = JSON.parse(obj.response).imageData;
                updateProgressBar(obj);
                setImageData({
                    imageUid: obj.imageUid,
                    imageData: imageData
                });
                obj.thumbRendererObject.draw(obj.studyUid, imageData, obj.appendTo);
            } else if (obj.response == "Failure") {
                // If the requested thumbnail image is not loaded successfully, we just shown empty values to add thumbnail gap issue.
                var modality = "&nbsp";
                var seriesTimeId = "&nbsp";
                var imageCount = "&nbsp";
                var instanceNumber = "&nbsp";
                var datadiv = "<div class='row'>" +
                    "<div class='col-xs-2'><font color='#D2F4EF'>" + modality + "</font></div>" + "<div class='col-xs-2 col-xs-offset-4'><font color='#D2F4EF'>" + instanceNumber + "</font></div></div><div class='row'>" + "<div class='col-xs-2'><font color='#D2F4EF'>" + imageCount + "</font></div>";
                $("#" + obj.appendTo).append(datadiv);
            }

        } catch (e) {}
    }

    /**
     * Show the series description
     * @param {Type} data - specifies the data
     * @param {Type} thumbnailId - specifies the thumbnailId
     */
    function showSeriesDescription(thumbnailData) {
        var thumbnailId = thumbnailData.parent;
        var description = (thumbnailData.isImage) ? thumbnailData.image.description : thumbnailData.image.caption;
        if (description === undefined || description === null) {
            description = "";
        }

        var defaultWidth = "100%";
        if (isDeleteEnabled || isSensitiveEnabled) {
            defaultWidth = "70%";
        }
        var imageIndex = thumbnailData.isImage ? thumbnailData.imageIndex : "";
        var seriesDescriptionId = "imageviewer_" + replaceSpecialsValues(thumbnailData.studyUid) + "_" + (thumbnailData.seriesIndex) + "_seriesDesc" + imageIndex;
        var seriesDescID = "";
        if (!document.getElementById(seriesDescriptionId)) {
            seriesDescID = "<div id='" + seriesDescriptionId + "' text align='top'><div title='" + description + "' style='width:" + defaultWidth + ";white-space: nowrap;overflow: hidden;text-overflow: ellipsis;color:#D2F4EF;padding-left:2px;display:inline-block;'>" + description + "</div>";

            if (isDeleteEnabled || isSensitiveEnabled) {
                seriesDescID += "<input type='checkbox' id='" + thumbnailId + "_checkbox' onclick='thumbnailCheckEvent(event,this)'; style='width:30%;padding-right:3px;display:inline-block;'>";
            }

            seriesDescID += "</div>";
        }

        if (!thumbnailData.isImage) {
            var progressBarId = thumbnailId + "_progress"
            seriesDescID += "<div id='" + progressBarId + "' style='width:0%; height:3px; background-color:#808080; margin-bottom:3px'/>";
        }

        return seriesDescID;
    }

    /**
     * select the image
     * @param {Type} thumbnailId - Specifies the thumbnail id
     */
    function selectImage(thumbnailId) {
        try {
            var renderer = $("#" + thumbnailId)[0].renderer;
            if (renderer === undefined || renderer === null) {
                return;
            }

            // remove the existing selection
            $(".selected-image-thumbnail-view").removeClass('selected-image-thumbnail-view').addClass('default-image-thumbnail-view');
            $(".alert-image-thumbnail-view").removeClass('alert-image-thumbnail-view').addClass('default-image-thumbnail-view');

            // Select the image
            if (!$("#" + thumbnailId).hasClass('selected-image-thumbnail-view')) {
                var element = document.getElementById(thumbnailId);
                if (element != null || element != undefined) {
                    $("#" + thumbnailId).removeClass('default-image-thumbnail-view').addClass('selected-image-thumbnail-view');
                }

                $("#" + thumbnailId).addClass('selected-image-thumbnail-view');
            }

            // Display the image info
            displayImageInfo(renderer.studyUid, renderer.seriesIndex, renderer.imageIndex);
        } catch (e) {}
    }

    /**
     * Check or uncheck the image thumbnail based on the shift key selection
     * @param {Type} selectedThumbnailID - selected image thumbnail Id
     */
    function checkImagesByRange(selectedThumbnailID) {
        try {
            var thumbnailId = $(".selected-image-thumbnail-view")[0].id;
            var isChecked = document.getElementById(selectedThumbnailID + "_checkbox").checked;
            var ThumbnailRender = $("#" + thumbnailId)[0].renderer;
            var imageIndex = ThumbnailRender.imageIndex;
            var currentIndex = $("#" + selectedThumbnailID)[0].renderer.imageIndex;
            for (var index = Math.min(imageIndex, currentIndex); index <= Math.max(imageIndex, currentIndex); index++) {
                var thumbId = 'imageviewer_' + replaceSpecialsValues(ThumbnailRender.studyUid) + "_" + ThumbnailRender.seriesIndex + '_thumb' + index;
                document.getElementById(thumbId + "_checkbox").checked = isChecked;
            }
        } catch (e) {}
    }

    /**
     * Check or uncheck the series thumbnail based on the shift key selection
     * @param {Type} selectedThumbnailId - selected series thumbnail Id
     */
    function checkSeriesByRange(selectedThumbnailId) {
        try {
            var thumbnailId = $(".selected-thumbnail-view")[0].id;
            var isChecked = document.getElementById(selectedThumbnailId + "_checkbox").checked;
            var thumbnailRender = $("#" + thumbnailId)[0].renderer;
            var seriesIndex = thumbnailRender.seriesIndex;
            var currentSeriesIndex = $("#" + selectedThumbnailId)[0].renderer.seriesIndex;
            for (var index = Math.min(seriesIndex, currentSeriesIndex); index <= Math.max(seriesIndex, currentSeriesIndex); index++) {
                var thumbId = 'imageviewer_' + replaceSpecialsValues(thumbnailRender.studyUid) + "_" + index + '_thumb';
                document.getElementById(thumbId + "_checkbox").checked = isChecked;
            }
            checkSeries(thumbnailRender.getStudyUid(), thumbnailRender.seriesIndex, isChecked);
        } catch (e) {}
    }

    /**
     * 
     * @param {Type} selectedThumbnailId 
     * @param {Type} isSeries 
     */
    function checkSeriesOrImages(selectedThumbnailId, isSeries, ev) {
        if (ev.shiftKey) {
            if (isSeries) {
                checkSeriesByRange(selectedThumbnailId);
            } else {
                checkImagesByRange(selectedThumbnailId);
            }
        } else {
            var thumbnailRender = $("#" + selectedThumbnailId)[0].renderer;
            var isChecked = document.getElementById(selectedThumbnailId + "_checkbox").checked
            if (isSeries) {
                checkSeries(thumbnailRender.studyUid, thumbnailRender.seriesIndex, isChecked);
            }
        }
    }

    /**
     * select the Series
     * @param {Type} thumbnailId - Specifies the thumbnail id
     */
    function selectSeries(thumbnailId, isLoadSeriesAuto) {
        try {
            var renderer = $("#" + thumbnailId)[0].renderer;
            if (renderer === undefined || renderer === null) {
                return;
            }

            if (isLoadSeriesAuto) {
                dicomViewer.thumbnail.createImageThumbnail(renderer.studyUid, renderer.seriesIndex, isLoadSeriesAuto);
            } else {
                // remove the existing selection
                $(".selected-thumbnail-view").removeClass('selected-thumbnail-view').addClass('default-thumbnail-view');
                $(".alert-thumbnail-view").removeClass('alert-thumbnail-view').addClass('default-thumbnail-view');

                // Select the Series
                if (!$("#" + thumbnailId).hasClass('selected-thumbnail-view')) {
                    var element = document.getElementById(thumbnailId);
                    if (element != null || element != undefined) {
                        $("#" + thumbnailId).removeClass('default-thumbnail-view').addClass('selected-thumbnail-view');
                        dicomViewer.thumbnail.createImageThumbnail(renderer.studyUid, renderer.seriesIndex);
                        var isChecked = document.getElementById(thumbnailId + "_checkbox").checked;
                        checkSeries(renderer.getStudyUid(), renderer.seriesIndex, isChecked);

                        var selectedThumbnailId = thumbnailId + "0";
                        if (renderer.defaultImage) {
                            selectedThumbnailId = thumbnailId + renderer.defaultImage;
                            makeThumbnailVisible(selectedThumbnailId);
                            renderer.defaultImage = undefined;
                        }
                        selectedThumbnailRender = renderer;
                        selectImage(selectedThumbnailId);
                    }

                    $("#" + thumbnailId).addClass('selected-thumbnail-view');
                    enableOrDisableImageOptions();
                }
            }
        } catch (e) {}
    }

    /**
     * select or deselect the image groups
     * @param {Type} e - Specifies the event
     */
    function selectOrDeselectImageGroups(e) {
        var innerText = e.target[0].innerText;
        var isSelected = (innerText.indexOf("Select") != -1 ? true : false);

        switch (e.id) {
            case "selectAll_Study":
                checkAllStudy(isSelected);
                innerText = "All Study";
                break;

            case "selectAll_Series":
                checkSingleOrAllSeries(false, isSelected);
                innerText = "All Series";
                break;

            case "selectAll_Image":
                checkSingleOrAllSeries(true, isSelected);
                innerText = "All Images";
                break;
        }

        e.target[0].innerText = (isSelected ? "Deselect " : "Select ") + innerText;
        enableOrDisableImageOptions();
    }

    /**
     * Check the studies
     */
    function checkAllStudy(isSelected) {
        try {
            var studyUids = dicomViewer.getListOfStudyUid(false);
            studyUids.forEach(function (studyUid) {
                checkStudy(studyUid, isSelected);
            });
        } catch (e) {}
    }

    /**
     * check or single series
     * @param {Type} isSingleSeries  - Specifies the flag for single series
     * @param {Type} isSelected  - Specifies the flag for selected
     */
    function checkSingleOrAllSeries(isSingleSeries, isSelected) {
        try {
            var thumbnailId = $(".selected-thumbnail-view")[0].id;
            var renderer = $("#" + thumbnailId)[0].renderer;
            if (renderer === undefined || renderer === null) {
                return;
            }

            var studyUids = dicomViewer.getListOfStudyUid(false);
            studyUids.forEach(function (studyUid) {
                if (renderer.getStudyUid() === studyUid) {
                    if (isSingleSeries) {
                        checkSeries(studyUid, renderer.seriesIndex, isSelected);
                    } else {
                        for (var index = 0; index < renderer.seriesCount; index++) {
                            checkSeries(studyUid, index, isSelected);
                        }
                    }
                }
            });
        } catch (e) {}
    }

    /**
     * 
     * Enable or disable the image options
     */
    function enableOrDisableImageOptions() {
        try {
            var checkedImages = getCheckedImages();
            if (checkedImages.imageUrns.length == 0) {
                resetImageOptions(checkedImages);
            } else {
                updateSeriesOrImageOptions(checkedImages);
            }
        } catch (e) {}
    }

    /**
     * Reset the image options 
     */
    function resetImageOptions(checkedImages) {
        try {
            $("#image_Delete").addClass("k-state-disabled");
            $("#image_Controlled").addClass("k-state-disabled");
            $("#image_Edit").addClass("k-state-disabled");
            $("#selectAll_Series").removeClass("k-state-disabled");
            $("#selectAll_Image").removeClass("k-state-disabled");
            $("#selectAll_Study").removeClass("k-state-disabled");
            $("#selectAll_Image")[0].innerText = "Select All Images";
            $("#selectAll_Series")[0].innerText = "Select All Series";
            $("#selectAll_Study")[0].innerText = "Select All Study";

            // Uncheck the study check box

            var selectedSeries;
            if (selectedThumbnailRender) {
                var studyUid = selectedThumbnailRender.studyUid;
                var seriesIndex = selectedThumbnailRender.seriesIndex;
                selectedSeries = $("#imageviewer_" + replaceSpecialsValues(studyUid) + "_" + seriesIndex + "_thumb")[0].renderer;
            } else {
                selectedSeries = $("#" + $(".selected-thumbnail-view")[0].id)[0].renderer;
            }

            if (selectedSeries !== undefined) {
                $('#imageviewer_' + replaceSpecialsValues(selectedSeries.studyUid) + "_checkbox")[0].checked = false;
            }

            checkDefaultSeries(false);
        } catch (e) {}
    }

    /**
     * Update the series or image options
     * @param {Type} checkedImages - Specifes the checked series/images
     */
    function updateSeriesOrImageOptions(checkedImages) {
        try {
            if (isDeleteEnabled) {
                $("#image_Delete").removeClass("k-state-disabled");
            }

            if (isSensitiveEnabled) {
                $("#image_Controlled").removeClass("k-state-disabled");

                if (checkedImages.imageUrns.length > 1) {
                    $("#image_Edit").addClass("k-state-disabled");
                } else {
                    $("#image_Edit").removeClass("k-state-disabled");
                }
            }

            $("#selectAll_Study").removeClass("k-state-disabled");

            var selectedSeries;
            if (selectedThumbnailRender) {
                var studyUid = selectedThumbnailRender.studyUid;
                var seriesIndex = selectedThumbnailRender.seriesIndex;
                selectedSeries = $("#imageviewer_" + replaceSpecialsValues(studyUid) + "_" + seriesIndex + "_thumb")[0].renderer;
            } else {
                selectedSeries = $("#" + $(".selected-thumbnail-view")[0].id)[0].renderer;
            }

            var selectedSeriesData = checkedImages.refreshData[replaceSpecialsValues(selectedSeries.studyUid)].series.filter(
                function (o) {
                    return o.isDelete == true;
                }
            );

            var isAllSeriesSelected = false;
            if (selectedSeriesData !== undefined) {
                if (selectedSeriesData.length == selectedSeries.seriesCount) {
                    isAllSeriesSelected = true;
                }
            }

            $('#imageviewer_' + replaceSpecialsValues(selectedSeries.studyUid) + "_checkbox")[0].checked = isAllSeriesSelected;
            if (isAllSeriesSelected) {
                $("#selectAll_Study")[0].innerText = "Deselect All Study";
                $("#selectAll_Series").addClass("k-state-disabled");
                $("#selectAll_Image").addClass("k-state-disabled");
                checkDefaultSeries(true);
            } else {
                $("#selectAll_Series").removeClass("k-state-disabled");
                $("#selectAll_Image").removeClass("k-state-disabled");
                $("#selectAll_Study")[0].innerText = "Select All Study";
                $("#selectAll_Series")[0].innerText = "Select All Series";

                selectedSeriesData = checkedImages.refreshData[replaceSpecialsValues(selectedSeries.studyUid)].series.filter(
                    function (o) {
                        return o.seriesIndex === selectedSeries.seriesIndex;
                    }
                )[0];

                if (selectedSeriesData !== undefined) {
                    $('#imageviewer_' + replaceSpecialsValues(selectedSeries.studyUid) + "_" + selectedSeries.seriesIndex + "_thumb_checkbox")[0].checked = selectedSeriesData.isDelete;
                    $("#selectAll_Image")[0].innerText = (selectedSeriesData.isDelete ? "Deselect All Images" : "Select All Images");
                } else {
                    $("#selectAll_Image")[0].innerText = "Select All Images";
                }
            }
        } catch (e) {}
    }

    /**
     * Check the default series
     */
    function checkDefaultSeries(isChecked) {
        try {
            var selectedSeries = selectedThumbnailRender;
            if (selectedSeries !== undefined) {
                checkSeries(selectedSeries.studyUid, selectedSeries.seriesIndex, isChecked);
            }
        } catch (e) {}
    }

    /**
     * Calculate the currently selected thumbnail position whether the whole thumbnail is visible to the user.
     * Auto scroll the thumbnail if the thumbnail is not fully visible to the user.
     */
    function makeThumbnailVisible(elementId) {
        try {
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
        } catch (e) {}
    }

    /**
     * Updated the cached image progress bar
     * @param {Type} thumbnail - Specifies the loaded image object
     */
    function updateProgressBar(thumbnail) {
        if (thumbnail.thumbRendererObject.isImage) {
            var seriesID = "imageviewer_" + replaceSpecialsValues(thumbnail.studyUid) + "_" + thumbnail.thumbRendererObject.seriesIndex + "_thumb";
            var cachedImageCount = ++document.getElementById(seriesID).renderer.cachedImage;
            var width = ((cachedImageCount / thumbnail.thumbRendererObject.imageCount) * 100);
            document.getElementById(seriesID + "_progress").style.width = (width > 100) ? "100%" : width + "%";
        }
    }

    dicomViewer.thumbnail = {
        create: create,
        createImageThumbnail: createImageThumbnail,
        startWorkerToDownloadThumbnail: startWorkerToDownloadThumbnail,
        displayInformation: displayInformation,
        showSeriesDescription: showSeriesDescription,
        checkStudy: checkStudy,
        checkSeries: checkSeries,
        selectImage: selectImage,
        selectSeries: selectSeries,
        selectOrDeselectImageGroups: selectOrDeselectImageGroups,
        checkSeriesOrImages: checkSeriesOrImages,
        enableOrDisableImageOptions: enableOrDisableImageOptions
    };

    return dicomViewer;
}(dicomViewer));
