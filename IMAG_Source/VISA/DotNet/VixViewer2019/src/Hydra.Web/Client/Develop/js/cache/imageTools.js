var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    var isFirstTimeImageLoad = true;
    var overlayVisibleStatus = false;
    var scoutLineVisibleStatus = true;
    var is6000Overlay = true;
    var annotationAndMeasurementVisibleStatus = true;
    var refreshCineManager = [];
    var refreshCineManagerFullScreen = [];

    var flagFor2dLengthCalibration = false;
    var isLengthCalibrating = false;

    var isMenusratedScaleVisible = false;

    function getFlagFor2dLengthCalibration() {
        return flagFor2dLengthCalibration;
    }

    function updateStudyLayoutSelection(value) {

    }

    function updateWindowLevelSettings(presetIndex) {
        presetIndex = parseInt(presetIndex);
        $("#1").parent().css("background", "");
        $("#2").parent().css("background", "");
        $("#3").parent().css("background", "");
        $("#4").parent().css("background", "");
        $("#5").parent().css("background", "");
        $("#6").parent().css("background", "");
        $("#7").parent().css("background", "");
        $("#1_ww_wcContextMenu").css("background", "");
        $("#2_ww_wcContextMenu").css("background", "");
        $("#3_ww_wcContextMenu").css("background", "");
        $("#4_ww_wcContextMenu").css("background", "");
        $("#5_ww_wcContextMenu").css("background", "");
        $("#6_ww_wcContextMenu").css("background", "");
        $("#7_ww_wcContextMenu").css("background", "");

        switch (presetIndex) {
            case 1:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 2:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 3:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 4:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 5:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 6:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;
            case 7:
                $("#" + presetIndex).parent().css("background", "#868696");
                $("#" + presetIndex + "_ww_wcContextMenu").css("background", "#868696");
                break;

            default:
                $("#1").parent().css("background", "");
                $("#2").parent().css("background", "");
                $("#3").parent().css("background", "");
                $("#4").parent().css("background", "");
                $("#5").parent().css("background", "");
                $("#6").parent().css("background", "");
                $("#7").parent().css("background", "");
                break;
        }

        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        seriesLayout.preferenceInfo.setWindowLevelSettings(presetIndex);
    }

    /**
     * Change the background color for the selected zoom menu (i.e making it selected)
     * @param {Type} id - id of the zoom type element  
     */
    function updateZoomLevelSettings(id) {
        resetZoomTool();
        var zoomType = parseInt(id.split("_")[0]);
        //whether it is custom zoom or not (-1 means custom)
        if (zoomType !== -1) {
            $("#" + id + "ContextMenu").css("background", "#868696");
            $("#" + id).parent().css("background", "#868696");
        } else {
            id = "6_zoom";
            $("#" + id + "ContextMenu").css("background", "#868696");
            $("#" + id).parent().css("background", "#868696");
        }
    }


    function isOverlayVisible() {
        return overlayVisibleStatus;
    }

    function isScoutLineVisible() {
        return scoutLineVisibleStatus;
    }

    function changePreset(presetIndex) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        updateWindowLevelSettings(presetIndex);
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLayoutId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLayoutId);
            if (imageRender)
                imageRender.applyPreset(presetIndex);
        });
    }

    function invert() {
        var cineRunning = false;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (dicomViewer.scroll.isCineRunning(seriesLayout.getSeriesLayoutId())) cineRunning = true;
        if (cineRunning) stopCineImage(undefined)
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLayoutId = $(this).attr('id');

            var imageRender = seriesLayout.getImageRender(imageLayoutId);
            if (imageRender) {
                dumpConsoleLogs(LL_DEBUG, undefined, "invert", "Applying invert to Image Layout id : " + imageLayoutId);
                imageRender.invert();
            }
        });
        if (cineRunning) {
            dicomViewer.startCine();
            updatePlayIcon("play.png", "stop.png");
        }
    }

    function rotate() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (isEmbedPdfViewer(seriesLayout.imageType)) {
            dicomViewer.rotate();
            return;
        }

        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLayoutId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLayoutId);
            if (imageRender)
                imageRender.rotate(90);
        });
    }

    function revert() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();

        if (isEmbedPdfViewer(seriesLayout.imageType)) {
            dicomViewer.revert();
        } else if (seriesLayout.imageType == IMAGETYPE_RADECG) {
            if ($("#3x41Value")[0]) {
                $("#3x41Value")[0].isRevert = true;
            }
            dicomViewer.Refresh();
        } else {
            //dicomViewer.setimageCanvasOfViewPort(seriesLayout.getSeriesLayoutId());
            if (seriesLayout.imageType == IMAGETYPE_JPEG && PdfRequest.RequestList.length > 1)//VAI-307
                location.reload();
            
            seriesLayout.setFrameIndex(0);
            $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                var imageLayoutId = $(this).attr('id');
                var imageRender = seriesLayout.getImageRender(imageLayoutId);
                if (imageRender !== undefined) {
                    imageRender.revert(imageRender.getCurrentUIDs(), imageRender.getSeriesIndex());
                    imageRender.getPresentation().sharpen = 0;
                }
            });
            changePreset("1");
            setZoomLevel(1);
        }
        RevertRGBTool();
    }

    /**
     * Reverting the RGBTool
     */
    function RevertRGBTool() {
        var isColor = isColorImage();
        if (isColor === true) {
            rgbColor(0);
        }
    }

    function doOverLay() {
        overlayVisibleStatus = !overlayVisibleStatus;
        var allViewports = dicomViewer.viewports.getAllViewports();
        for (var key in allViewports) {
            var viewportTemp = allViewports[key];
            $("#" + viewportTemp.getSeriesLayoutId() + " div").each(function () {
                var imageLayoutId = $(this).attr('id');
                var imageRender = viewportTemp.getImageRender(imageLayoutId);
                if (imageRender) {
                    imageRender.showOrHideOverlay(overlayVisibleStatus);
                }
            });
        }
    }

    /**
     * Enable disable the scout line depends on the menu selection
     */
    function doScoutLine() {
        scoutLineVisibleStatus = !scoutLineVisibleStatus;
        var allViewports = dicomViewer.viewports.getAllViewports();
        var activeviewport = dicomViewer.getActiveSeriesLayout();

        if (!activeviewport) {
            return;
        }

        for (var key in allViewports) {
            var viewportTemp = allViewports[key];
            viewportTemp.refreshViewports(activeviewport);
        }
    }

    function setOverlay(overlayVisible) {
        overlayVisibleStatus = overlayVisible;
    }

    function changeStudyLayout(row, column, isBackup, isResize) {
        isCineEnabled(true);
        if (layoutMap == undefined || layoutMap == null) {
            layoutMap = {};
        }
        setSelectedStudyLayout(row, column);
        var activeViewport = dicomViewer.getActiveSeriesLayout();
        if (isFullScreenEnabled) {
            dicomViewer.setStudyLayout(1, 1, activeViewport.getStudyUid(), activeViewport.seriesIndex, true);
        } else {
            dicomViewer.setStudyLayout(row, column, activeViewport.getStudyUid(), activeViewport.seriesIndex, isBackup, isResize);
        }
        dicomViewer.changeSelection("imageviewer_studyViewer1x1_1x1");
        activeSeriesPDFData = undefined;
        isPDFActiveSeries = false;
        var activeViewport = dicomViewer.getActiveSeriesLayout();

        if (activeViewport != null && activeViewport !== undefined && isEmbedPdfViewer(activeViewport.imageType)) {
            dicomViewer.updatePaging(activeViewport.seriesLayoutId);
        }
    }

    function changeSeriesLayout(row, column, studyLayout, page) {
        isCineEnabled(true);
        studyDiv = studyLayout === undefined ? page.id : studyLayout.id;
        layoutRow = row;
        layoutColumn = column;
        if (row === undefined || row === 0) {
            row = 1;
        }
        if (column === undefined || column === 0) {
            column = 1;
        }

        // If the user changes the series level layout when the fullscreen mode is ON we set it to OFF to handle the zoom, invert and other overlay properly for all the images.
        if (row > 1 || column > 1) {
            if (isFullScreenEnabled) {
                isFullScreenEnabled = false;
            }
        }
        var newSeriesLayout = dicomViewer.viewports.getViewport("imageviewer_" + studyDiv + "_1x1");
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var selectedLayoutId = seriesLayout.seriesLayoutId;
        var seriesLayoutMaxId = dicomViewer.viewports.getSeriesLayoutMaxId();
        if (seriesLayoutMaxId != undefined) {
            var rowColumnValue = seriesLayoutMaxId.split('_')[2];
        }
        var viewportNumber = 0;
        if (rowColumnValue != undefined) {
            viewportNumber = dicomViewer.viewports.getViewportNumber(parseInt(rowColumnValue.split('x')[0]), parseInt(rowColumnValue.split('x')[1]), selectedLayoutId.split('_')[2]);
        }
        var imageAndSeriesIndex = getOrSetReArrangedSeriesPositions(row, column, undefined, page);
        layoutMap[studyDiv] = row + "x" + column;
        if (seriesLayout.studyUid === newSeriesLayout.studyUid)
            dicomViewer.setSeriesLayout(seriesLayout.studyUid, row, column, imageAndSeriesIndex, null, studyDiv);
        else
            dicomViewer.setSeriesLayout(newSeriesLayout.studyUid, row, column, 0, null, studyDiv);
        isCineEnabled(false);

        dicomViewer.setReArrangedSeriesPositions(undefined);
        if (seriesLayout !== undefined && seriesLayout !== null) {
            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex);
            //If there is any duplicate viewport in the series level layout then updating the series layout on the basis of the vieport number 
            if (dicomViewer.viewports.isDuplicateViewport(isMultiFrame, isMultiFrame ? seriesLayout.scrollData.imageIndex : seriesLayout.seriesIndex)) {
                var viewport = dicomViewer.viewports.getSelectedViewport(studyDiv, row, column, viewportNumber);
                if (viewport != undefined || viewport != null) {
                    seriesLayout = viewport;
                }
            }
            dicomViewer.changeSelection(seriesLayout.seriesLayoutId);
            if (page) {
                EnableDisableNextSeriesImage(dicomViewer.getActiveSeriesLayout());
            }
        }
        changeIconSize();
    }

    function chanageWhileDrag(row, column, studyDiv, isThumbnailClick) {
        layoutRow = row;
        layoutColumn = column;
        if (row === undefined || row === 0) {
            row = 1;
        }

        var layoutId = "imageviewer_" + studyDiv + "_1x1" /*(row) + "x" + (column)*/ ;
        var viewport = dicomViewer.viewports.getViewport(layoutId);

        if (column === undefined || column === 0) {
            column = 1;
        }

        layoutMap[studyDiv] = row + "x" + column;
        var imagecanvasValue = dicomViewer.getimageCanvasOfViewPort(layoutId);
        var seriesIndex = 0;
        if (imagecanvasValue != undefined) {
            seriesIndex = imagecanvasValue.seriesIndex;
        }
        if (layoutId === "imageviewer_studyViewer1x1_1x1" && isFullScreenEnabled === false) {
            seriesIndex = seriesIndexBackup;
        }
        if (isFullScreenEnabled) {
            dicomViewer.setSeriesLayout(viewport.studyUid, 1, 1, seriesIndex, null, studyDiv, false, undefined, isThumbnailClick);
        } else {
            dicomViewer.setSeriesLayout(viewport.studyUid, row, column, seriesIndex, null, studyDiv, false, undefined, isThumbnailClick);
        }
    }

    /**
     *Change the image layout by changing the no of images in the active viewport for the selected series
     *Possible image layouts - {1x1, 1x2, 2x1, 2x2}
     *@param {Integer} row - Total no of rows in image layout
     *@param {Integer} column - Total no of columns in image layout
     */
    function changeImageLayout(row, column, divId, page) {
        $("#playButton").removeClass("k-state-disabled"); //enable the playbutton if it is disabled
        nextslideindex = 0;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        seriesLayout.setImageLayoutDimension(row + "x" + column);
        var totalImageLevelLayout = row * column;
        var imageIndex = seriesLayout.getImageIndex();
        var frameIndex = seriesLayout.getFrameIndex();
        //For getting the total image count for the selected series of active study
        var imageSeries = dicomViewer.Series.getSeries(seriesLayout.studyUid, seriesLayout.seriesIndex);
        // Checking whether the image level layout changes to like 1 x 2, 2 x 1, 2 x 2
        if (totalImageLevelLayout > 1) {
            var studyUid = seriesLayout.getStudyUid();
            var imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesLayout.seriesIndex, imageIndex);
            seriesLayout.imageType = imageValue.imageType;
            if (imageValue != undefined) {
                // Checking whether the respective image is multiframe or not
                var isMultiframe = dicomViewer.thumbnail.isImageThumbnail(imageValue);
                var imageAndFrameIndex = isMultiframe ? seriesLayout.getFrameIndex() : seriesLayout.getImageIndex();
                var totalImageCount = isMultiframe ? dicomViewer.Series.Image.getImageFrameCount(imageValue) : seriesLayout.getImageCount();

                // Following calculation to display an images or frames to selected image level layout based on thier availability 
                var difference = totalImageCount - imageAndFrameIndex;
                if ((totalImageCount < 4 || totalImageCount === undefined) &&
                    (totalImageLevelLayout === 4 || totalImageLevelLayout > 4)) {
                    imageAndFrameIndex = 0;
                } else if ((totalImageCount < 4 || totalImageCount === undefined &&
                        totalImageLevelLayout < 4) && imageAndFrameIndex > 0) {
                    imageAndFrameIndex--;
                } else if (imageAndFrameIndex + 1 === totalImageCount || difference < totalImageLevelLayout) {
                    imageAndFrameIndex = imageAndFrameIndex - (totalImageLevelLayout - difference);
                }

                imageIndex = isMultiframe ? seriesLayout.getImageIndex() : imageAndFrameIndex;
                frameIndex = !isMultiframe ? seriesLayout.getFrameIndex() : imageAndFrameIndex;
                if (!isMultiframe) {
                    //Stop the cine and disable the play button when the image count for the active series is < 4 and the image layout is 2x2
                    if (imageSeries.imageCount < 4 && seriesLayout.imageLayoutDimension == "2x2") {
                        dicomViewer.tools.stopCineImage();
                        updatePlayIcon("stop.png", "play.png", false, "#playButton");
                        $("#playButton").addClass("k-state-disabled");
                    }
                }
            }
        }
        if (divId !== undefined) {
            dicomViewer.setImageLevelLayout(seriesLayout.studyUid, row, column, seriesLayout.getSeriesLayoutId(), seriesLayout, seriesLayout.getSeriesIndex(), imageIndex, frameIndex);
        } else if (page != undefined) {
            if (page.isMultiFrame) {
                dicomViewer.setImageLevelLayout(seriesLayout.studyUid, row, column, seriesLayout.getSeriesLayoutId(), seriesLayout, page.seriesIndex, page.imageIndex, page.first);
                seriesLayout.setImageIndex(page.imageIndex);
                seriesLayout.setFrameIndex(page.first);
            } else {
                dicomViewer.setImageLevelLayout(seriesLayout.studyUid, row, column, seriesLayout.getSeriesLayoutId(), seriesLayout, page.seriesIndex, page.first, seriesLayout.getFrameIndex());
            }
        }
        if (dicomViewer.scroll.isCineRunning(seriesLayout.getSeriesLayoutId())) {
            var modality = dicomViewer.Series.getModality(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex());
            showOrHideInCineRunning(modality, true);
        }
        EnableDisableNextSeriesImage(seriesLayout);
    }

    function showDicomHeader() {
        var returnString = "";
        var imageRender;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var layoutId = seriesLayout.getSeriesLayoutId();
        $("#" + layoutId + " div").each(function () {
            var imageLevelId = $(this).attr('id');

            if (seriesLayout.imageType === IMAGETYPE_RADSR) {
                imageRender = seriesLayout.getImageRender("srReport")
                returnString = dicomViewer.header.getDicomHeaderValues(seriesLayout.studyUid, seriesLayout.seriesIndex, imageRender.imageUid);
            } else if (seriesLayout.imageType === IMAGETYPE_RADECG) {
                imageRender = seriesLayout.getImageRender("ecgData")
                returnString = dicomViewer.header.getDicomHeaderValues(seriesLayout.studyUid, seriesLayout.seriesIndex, imageRender.imageUid);
            } else {
                imageRender = seriesLayout.getImageRender(imageLevelId);
            }
            if (imageRender != undefined) {

                var imagePromiseObj = imageRender.imagePromise;
                if (imagePromiseObj != undefined) {
                    var dicomObjct;
                    imagePromiseObj.then(function (image) {
                        dicomObjct = image;
                        returnString = dicomViewer.header.getDicomHeaderValues(seriesLayout.studyUid, seriesLayout.seriesIndex, dicomObjct.imageUid);
                        var innerHTMLString = "<tr><th>Group</th><th>Element</th><th>Description</th><th>VR</th><th align='left'>Value</th></tr>";
                        for (var i = 0; i < returnString.length; i++) {
                            var tagString = returnString[i].tag.replace("(", "").replace(")", "").split(",");
                            if (tagString[0] === "0010" && tagString[1] === "0010") {
                                innerHTMLString += '<tr><td>' + tagString[0] + '</td><td>' + tagString[1] + '</td><td>' +
                                    returnString[i].tagDescription + '</td><td>' + returnString[i].vrType +
                                    '</td><td>' + returnString[i].tagValue.replace(/\^/gi, ' ') + '</td></tr>';
                            } else {
                                innerHTMLString += '<tr><td>' + tagString[0] + '</td><td>' + tagString[1] + '</td><td>' +
                                    returnString[i].tagDescription + '</td><td>' + returnString[i].vrType +
                                    '</td><td>' + returnString[i].tagValue + '</td></tr>';
                            }
                        }
                        $("#dicomHeader").html(innerHTMLString);
                        $("#dicomHeaderAttributes").dialog('open');
                        dicomViewer.pauseCinePlay(1, true);
                        return false;
                    });

                } else {
                    returnString = dicomViewer.header.getDicomHeaderValues(seriesLayout.studyUid, seriesLayout.seriesIndex, imageRender.imageUid);
                    var innerHTMLString = "<tr><th>Group</th><th>Element</th><th>Description</th><th>VR</th><th align='left'>Value</th></tr>";
                    for (var i = 0; i < returnString.length; i++) {
                        var tagString = returnString[i].tag.replace("(", "").replace(")", "").split(",");
                        if (tagString[0] === "0010" && tagString[1] === "0010") {
                            innerHTMLString += '<tr><td>' + tagString[0] + '</td><td>' + tagString[1] + '</td><td>' +
                                returnString[i].tagDescription + '</td><td>' + returnString[i].vrType +
                                '</td><td>' + returnString[i].tagValue.replace(/\^/gi, ' ') + '</td></tr>';
                        } else {
                            innerHTMLString += '<tr><td>' + tagString[0] + '</td><td>' + tagString[1] + '</td><td>' +
                                returnString[i].tagDescription + '</td><td>' + returnString[i].vrType +
                                '</td><td>' + returnString[i].tagValue + '</td></tr>';
                        }
                    }
                    $("#dicomHeader").html(innerHTMLString);
                    $("#dicomHeaderAttributes").dialog('open');
                    dicomViewer.pauseCinePlay(1, true);
                    return false;
                }
            }
        });

    }

    function showImageData() {
        var imageRender;
        var imageLevelId;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout.imageType === IMAGETYPE_VIDEO || seriesLayout.imageType === IMAGETYPE_AUDIO ||
            seriesLayout.imageType === IMAGETYPE_RADECG || seriesLayout.imageType === IMAGETYPE_RADSR ||
            seriesLayout.imageType === IMAGETYPE_CDA) {
            if (seriesLayout.imageType === IMAGETYPE_RADECG) {
                imageLevelId = "ecgData";
            } else if (seriesLayout.imageType === IMAGETYPE_RADSR || seriesLayout.imageType === IMAGETYPE_CDA) {
                imageLevelId = "srReport";
            } else {
                imageLevelId = seriesLayout.imageType;
            }
            imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender != undefined) {
                displayImageData(seriesLayout, imageRender.imageUid);
                return true;
            }
        } else {
            var layoutId = seriesLayout.getSeriesLayoutId();
            $("#" + layoutId + " div").each(function () {
                imageLevelId = $(this).attr('id');
                imageRender = (seriesLayout.getImageRender(imageLevelId) == undefined) ?
                    seriesLayout.getImageRender(imageLevelId.split("_")[0]) : seriesLayout.getImageRender(imageLevelId);

                if (imageRender != undefined) {
                    var imagePromiseObj = imageRender.imagePromise;
                    if (imagePromiseObj != undefined) {
                        var dicomObjct;
                        imagePromiseObj.then(function (image) {
                            dicomObjct = image;
                            displayImageData(seriesLayout, dicomObjct.imageUid);
                            return false;
                        });
                    } else {
                        displayImageData(seriesLayout, imageRender.imageUid);
                        return false;
                    }
                }
            });
        }
    }

    /**
     * Display the image data window.
     * @param {Type} seriesLayout - specifies the series layout
     * @param {Type} imageUid - specifies the image uid
     */
    function displayImageData(seriesLayout, imageUid) {
        if (imageUid == undefined) {
            return;
        }

        var def = dicomViewer.header.getMetadata(seriesLayout.studyUid, seriesLayout.seriesIndex, imageUid);
        def.done(function (metadata) {
            $("#imageMetadata").html(metadata);
        });
        $("#imagingData").dialog('open');
        dicomViewer.pauseCinePlay(1, true);
    }

    function setDicomOverLayFalse(seriesLayout) {
        var layoutId = seriesLayout.getSeriesLayoutId();

        $("#" + layoutId + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                imageRender.showOrHideOverlay(overlayVisibleStatus);
            }
        });
    }

    function doWindowLevel(e) {
        var actvieSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageTypeOrModality = actvieSeriesLayout ? actvieSeriesLayout.imageType : undefined;
        if (imageTypeOrModality == IMAGETYPE_JPEG || imageTypeOrModality == IMAGETYPE_RADECHO ||
            imageTypeOrModality == "US") {
            doBrightnessContrast(e);
            return;
        }

        if (e != undefined && e.id == "7") {
            customWindowLevel(e.id);
        } else if (e == "7") {
            customWindowLevel(e);
        } else if (e != undefined && e.id != "winL") {
            if (e.id != undefined) {
                dicomViewer.tools.changePreset(e.id);
            } else {
                dicomViewer.tools.changePreset(e);
            }
        } else {
            applyWindowLevel();
        }
    }

    function doSharpen(e) {
        resetMenu();
        $("#context-sharpen").css("background", "#868696");
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
        $('#viewport_View').css('cursor', 'url(images/sharpen.cur), auto');
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getSharpenTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function applyWindowLevel() {
        resetMenu();
        $("#context-windowlevel").css("background", "#868696");
        $("#context-ww_wc").css("background", "#868696");
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
        $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getWindowTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function doPan() {
        resetMenu();
        $("#context-pan").css("background", "#868696");
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
        $('#viewport_View').css('cursor', 'url(images/pan.cur), auto');
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getPanTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function doZoom(e) {
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();

        resetMenu();

        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (!isEmbedPdfViewer(seriesLayout.imageType)) {
            if ((seriesLayout.imageType !== IMAGETYPE_RADSR) && (seriesLayout.imageType !== IMAGETYPE_RADECG)) {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getZoomTool());
                $('#viewport_View').css('cursor', 'url(images/zoom.cur), auto');
            }
        }

        if (e === "6_zoom" || (e.id != undefined && e.id === "6_zoom")) {
            var customZoomID = e;
            if (e.id != undefined)
                customZoomID = e.id;

            changeZoomCustom(customZoomID);
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            seriesLayout.preferenceInfo.setZoomLevelSettings(parseInt(customZoomID));
        } else if (e.id != undefined && e.id !== "zoomButton") {
            var value = e.id.split("_")
            dicomViewer.tools.setZoomLevel(parseInt(value[0]));
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            seriesLayout.preferenceInfo.setZoomLevelSettings(e.id);
        } else if (e.id == "zoomButton") {
            resetZoomTool();
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            seriesLayout.preferenceInfo.setZoomLevelSettings(e.id);
        }
        refreshImage();
    }

    function do2DLengthMeasurement() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function doAngleMeasurement() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getAngleMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function do2DPointMeasurement() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function getTraceMeasureTool() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getTraceMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function getVolumeMeasureTool() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getVolumeMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function getMitralMeanGradientMeasureTool() {
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getMitralMeanGradientMeasureTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    function changeStudyLayoutFromTool(type, isBackup, isResize) {
        if (isResize === undefined || isResize === true) {
            reOrderExistingStudyUids();
        }
        isCineEnabled(true);
        studyLayoutValue = type.id;
        isFullScreenEnabled = isBackup ? isBackup : false;
        var colAndRow = type.id.split("x");
        changeStudyLayout(colAndRow[0], colAndRow[1], isBackup, isResize);
    }
    /**
     *Reset the Context and toolbar menus
     **/
    function resetMenu(isShowKendo) {

        if (!isShowKendo) {
            removeKendoButtons();
            previouseSelectdTool = undefined;
        }

        //context menus
        $("#context-pan").css("background", "");
        $("#context-sharpen").css("background", "");
        $("#context-windowlevel").css("background", "");
        $("#context-ww_wc").css("background", "");
        $("#context-length").css("background", "");
        $("#context-2dPoint").css("background", "");
        $("#context-trace").css("background", "");
        $("#context-volume").css("background", "");
        $("#context-length-calibration").css("background", "");
        $("#context-angle").css("background", "");
        $("#context-hounsfield").css("background", "");
        $("#context-cacheIndicator").css("background", "");
        $("#context-hounsfield-ellipse").css("background", "");
        $("#context-hounsfield-rectangle").css("background", "");
        $("#context-text").css("background", "");
        $("#context-line").css("background", "");
        $("#context-arrow").css("background", "");
        $("#context-ellipse").css("background", "");
        $("#context-rectangle").css("background", "");
        $("#context-freehand").css("background", "");
        $("#measurement104").css("background", "");
        $("#measurement102").css("background", "");
        $("#measurement106").css("background", "");
        $("#measurement101").css("background", "");
        $("#measurement103").css("background", "");
        $("#measurement107").css("background", "");
        $("#measurement108").css("background", "");
        //Toolbar menus
        $("#0_measurement").css("background", "");
        $("#1_measurement").css("background", "");
        $("#2_measurement").css("background", "");
        $("#3_measurement").css("background", "");
        $("#6_measurement").css("background", "");
        $("#7_measurement").css("background", "");
        $("#14_measurement").css("background", "");
        $("#8_text").css("background", "");
        $("#9_line").css("background", "");
        $("#10_arrow").css("background", "");
        $("#11_ellipse").css("background", "");
        $("#12_rectangle").css("background", "");
        $("#13_freehand").css("background", "");
        $("#angle_measurement").css("background", "");
        $("#15_pen").css("background", "");
        $("#context-pen").css("background", "");
    }

    /**
     * Reset the Zoom Tool button background color for context and Toolbar menus
     */
    function resetZoomTool() {
        //Toolbar menus
        $("#0_zoom").parent().css("background", "");
        $("#1_zoom").parent().css("background", "");
        $("#2_zoom").parent().css("background", "");
        $("#3_zoom").parent().css("background", "");
        $("#4_zoom").parent().css("background", "");
        $("#5_zoom").parent().css("background", "");
        $("#6_zoom").parent().css("background", "");
        //Context menus
        $("#0_zoomContextMenu").css("background", "");
        $("#1_zoomContextMenu").css("background", "");
        $("#2_zoomContextMenu").css("background", "");
        $("#3_zoomContextMenu").css("background", "");
        $("#6_zoomContextMenu").css("background", "");
        $("#zoomInSR").css("background", "");
        $("#zoomOutSR").css("background", "");
    }

    /**
     * Complete the incompleted previously draw shape while selecting any of the Measurement/Annotation tool
     */
    function completeShape() {
        var tool = dicomViewer.mouseTools.getActiveTool();
        var toolName = dicomViewer.mouseTools.getToolName();
        if (toolName === "mitralMeanGradientMeasurement" || toolName === "traceMeasurement" ||
            toolName === "angleMeasurement") {
            tool.hanleDoubleClick();
        }
    }

    function do2DMeasurement(type, id, units) {
        resetMenu(true);
        completeShape();
        if (type.id != undefined) {
            type = type.id.split("_")[0];
        } else if (type != 4) {
            dicomViewer.measurement.draw.setMeasurementType(type, id, units);
        }
        dicomViewer.mouseTools.setPreviousTool(dicomViewer.mouseTools.getActiveTool());
        dicomViewer.mouseTools.setCursor(dicomViewer.mouseTools.getToolCursor(1));
        if (type == 0) {
            isLengthCalibrating = false;
            if (isCaliberEnabled()) {
                isLengthCalibrating = true;
                calibrationToolId = "0";
                LineMeasurement.prototype.setMeasurementSubType("2DLength");
                setCalibrationActiveTool();
            } else {
                calibrationToolId = undefined;
                flagFor2dLengthCalibration = false;
                LineMeasurement.prototype.setMeasurementSubType();
                if (id == "mitralRegurgitationLength") {
                    $("#measurement102").css("background", "#868696");
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(1));
                } else if (id == "aorticRegurgitationLength") {
                    $("#measurement106").css("background", "#868696");
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(2));
                } else if (id == "mitralValveAnteriorLeafletThickness") {
                    $("#measurement101").css("background", "#868696");
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(3));
                } else {
                    $("#context-length").css("background", "#868696");
                    $("#0_measurement").css("background", "#868696");
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(0, "2DLength"));
                    LineMeasurement.prototype.setMeasurementSubType("2DLength");
                }
            }
        } else if (type == 1) {

            if (id == "mitralRegurgitationPeakVelocity") {
                $("#measurement103").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(1));
            } else if (id == "aorticRegurgitationPeakVelocity") {
                $("#measurement107").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(2));
            } else if (id == "aorticStenosisPeakVelocity") {
                $("#measurement108").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(3));
            } else {
                $("#context-2dPoint").css("background", "#868696");
                $("#1_measurement").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(0));
            }
        } else if (type == 2) {
            $("#context-trace").css("background", "#868696");
            $("#2_measurement").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getTraceMeasureTool());
        } else if (type == 3) {
            $("#context-volume").css("background", "#868696");
            $("#3_measurement").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getVolumeMeasureTool());
        } else if (type == "angle") {
            $("#context-angle").css("background", "#868696");
            $("#angle_measurement").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getAngleMeasureTool());
        } else if (type == 6) {
            setLengthCalibrationFlag(false);
            setCalibrationActiveTool();
            LineMeasurement.prototype.setMeasurementSubType();
        } else if (type == 4) {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            var imageRender = seriesLayout.imageRenders;
            for (var key in imageRender) {
                var render = imageRender[key];
                var frameIndex = render.anUIDs.split("*")[1];
                dicomViewer.measurement.removeAllMeasurements(render.imageUid, frameIndex, render);
                var tool = dicomViewer.mouseTools.getActiveTool();
                if (tool != undefined && tool != null) {
                    SetMenuSelectionColor(tool.ToolType);
                }
            }
            dicomViewer.measurement.setDataToDelete();
        } else if (type == 5) {
            $("#measurement104").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getMitralMeanGradientMeasureTool(0, "mitral"));
            MitralMeanGradientMeasurement.prototype.setMeasurementSubType("mitral");
        } else if (type == 7 || type == 14) {
            isLengthCalibrating = false;
            if (isCaliberEnabled()) {
                isLengthCalibrating = true;
                if (type == 7) {
                    calibrationToolId = "7";
                    EllipseMeasurement.prototype.setMeasurementSubType("hounsfield");
                } else {
                    calibrationToolId = "14";
                    RectangleMeasurement.prototype.setMeasurementSubType("hounsfield");
                }
                setCalibrationActiveTool();
            } else if (type == 7) {
                calibrationToolId = undefined;
                $("#context-hounsfield-ellipse").css("background", "#868696");
                $("#7_measurement").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getEllipseMeasureTool(0, "hounsfield"));
                EllipseMeasurement.prototype.setMeasurementSubType("hounsfield");
            } else if (type == 14) {
                calibrationToolId = undefined;
                $("#context-hounsfield-rectangle").css("background", "#868696");
                $("#14_measurement").css("background", "#868696");
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool(0, "hounsfield"));
                RectangleMeasurement.prototype.setMeasurementSubType("hounsfield");
            }

        } else if (type == 8) {
            $("#context-text").css("background", "#868696");
            $("#8_text").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool(2, "text"));
            RectangleMeasurement.prototype.setMeasurementSubType("text");
        } else if (type == 9) {
            flagFor2dLengthCalibration = false;
            $("#context-line").css("background", "#868696");
            $("#9_line").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(4, "2DLine"));
            LineMeasurement.prototype.setMeasurementSubType("2DLine");
        } else if (type == 10) {
            flagFor2dLengthCalibration = false;
            $("#context-arrow").css("background", "#868696");
            $("#10_arrow").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(5, "Arrow"));
            LineMeasurement.prototype.setMeasurementSubType("Arrow");
        } else if (type == 11) {
            $("#context-ellipse").css("background", "#868696");
            $("#11_ellipse").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getEllipseMeasureTool(1, "ellipse"));
            EllipseMeasurement.prototype.setMeasurementSubType("ellipse");
        } else if (type == 12) {
            $("#context-rectangle").css("background", "#868696");
            $("#12_rectangle").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool(1));
            RectangleMeasurement.prototype.setMeasurementSubType("rectangle");
        } else if (type == 13) {
            $("#context-freehand").css("background", "#868696");
            $("#13_freehand").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getMitralMeanGradientMeasureTool(1, "freehand"));
            MitralMeanGradientMeasurement.prototype.setMeasurementSubType("freehand");
        } else if (type == 15) {
            $("#context-pen").css("background", "#868696");
            $("#15_pen").css("background", "#868696");
            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getPenTool());
            PenTool.prototype.setMeasurementSubType("pen");
        }
        // refresh image so that US regions appear
        refreshImage();
    }

    /**
     *Reset RGB toolbar menus
     **/
    function resetRGBMenu() {
        //context menus
        $("#0_rgbAllContextMenu").css("background", "");
        $("#1_rgbRedContextMenu").css("background", "");
        $("#2_rgbGreenContextMenu").css("background", "");
        $("#3_rgbBlueContextMenu").css("background", "");

        //Toolbar menus
        $("#0_rgbAll").css("background", "");
        $("#1_rgbRed").css("background", "");
        $("#2_rgbGreen").css("background", "");
        $("#3_rgbBlue").css("background", "");

        //Overflow menus
        $("#RGBButton_overflow").css("background", "");
        $("#0_rgbAll_overflow").css("background", "");
        $("#1_rgbRed_overflow").css("background", "");
        $("#2_rgbGreen_overflow").css("background", "");
        $("#3_rgbBlue_overflow").css("background", "");

    }

    function rgbColor(e, isApplied) {
        var rgbColorId = "0";
        resetRGBMenu();
        if (e.id != undefined && e != undefined) {
            rgbColorId = e.id.split("_")[0];
        } else {
            rgbColorId = e;
        }

        if (rgbColorId == 1) {
            $("#1_rgbRedContextMenu").css("background", "#868696");
            $("#1_rgbRed").css("background", "#868696");
        } else if (rgbColorId == 2) {
            $("#2_rgbGreenContextMenu").css("background", "#868696");
            $("#2_rgbGreen").css("background", "#868696");
        } else if (rgbColorId == 3) {
            $("#3_rgbBlueContextMenu").css("background", "#868696");
            $("#3_rgbBlue").css("background", "#868696");
        } else {
            $("#0_rgbAllContextMenu").css("background", "#868696");
            $("#0_rgbAll").css("background", "#868696");
        }

        if (isApplied) {
            return;
        }

        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                imageRender.applyRGB(parseInt(rgbColorId));
            }
        });

    }

    function moveToPreviousImage() {
        //Move to previous frame/image 
        dicomViewer.scroll.moveToNextOrPreviousImage(false);
        var serieLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = serieLayout.getStudyUid();
        var firstImageFrame = $("#" + serieLayout.getSeriesLayoutId() + " div:first").attr("id");
        var imageRender = serieLayout.getImageRender(firstImageFrame);
        var currentImageIndex = null;
        var currentFrameIndex = null;
        if (imageRender != undefined) {
            var anUIDs = imageRender.anUIDs;
            var resultArray = anUIDs.split("*");
            currentFrameIndex = parseInt(resultArray[1]);
            currentImageIndex = imageRender.imageIndex;
        }
        serieLayout.setImageIndex(currentImageIndex);
        serieLayout.setFrameIndex(currentFrameIndex);
        EnableDisableNextSeriesImage(serieLayout);
    }

    function moveToNextImage() {
        //Move to next from frame/image
        dicomViewer.scroll.moveToNextOrPreviousImage(true);
        var serieLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = serieLayout.getStudyUid();
        var firstImageFrame = $("#" + serieLayout.getSeriesLayoutId() + " div:first").attr("id");
        var imageRender = serieLayout.getImageRender(firstImageFrame);
        var currentImageIndex = null;
        var currentFrameIndex = null;
        if (imageRender != undefined) {
            var anUIDs = imageRender.anUIDs;
            var resultArray = anUIDs.split("*");
            currentFrameIndex = parseInt(resultArray[1]);
            currentImageIndex = imageRender.imageIndex;
        }
        serieLayout.setImageIndex(currentImageIndex);
        serieLayout.setFrameIndex(currentFrameIndex);
        EnableDisableNextSeriesImage(serieLayout);

    }

    function runCineImage(direction) {
        //Run images in cine mode
        dicomViewer.scroll.runCineImage(direction);
    }

    function stopCineImage(direction) {
        //Stop images in cine mode
        dicomViewer.scroll.stopCineImage(direction);
    }

    function doHorizontalFilp() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (isEmbedPdfViewer(seriesLayout.imageType)) {
            dicomViewer.flip(true);
            return;
        }

        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                imageRender.doHorizontalFlip();
            }
        });
    }

    function doVerticalFilp() {
        resetMenu();
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (isEmbedPdfViewer(seriesLayout.imageType)) {
            dicomViewer.flip(false);
            return;
        }

        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                imageRender.doVerticalFilp();
            }
        });
    }

    function setZoomLevel(level) {
        resetZoomTool();
        var id = level + "_zoom";
        if (id === "4_zoom" || id === "5_zoom") {
            //SR Zoom tool
            dicomViewer.zoomSR(id);
        } else {
            $("#" + id + "ContextMenu").css("background", "#868696");
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            if (seriesLayout.ecgZoomLevelSettings !== seriesLayout.preferenceInfo.zoomLevelSetting) {
                seriesLayout.ecgZoomLevelSettings = seriesLayout.preferenceInfo.zoomLevelSetting;
                if (level == 6) {
                    id = seriesLayout.ecgZoomLevelSettings;
                }
            }
            seriesLayout.preferenceInfo.setZoomLevelSettings(id);

            $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                var imageLevelId = $(this).attr('id');
                if (seriesLayout && (seriesLayout.imageType === IMAGETYPE_PDF ||
                        seriesLayout.imageType === IMAGETYPE_TIFF ||
                        seriesLayout.imageType === IMAGETYPE_RADPDF)) {
                    if (imageLevelId == undefined || imageLevelId.indexOf("imagePdfDiv") == -1) {
                        return true;
                    }
                    var zoomFactor;
                    if (isNaN(level)) {
                        zoomFactor = (parseFloat(level.split("-")[1])) / 100;
                        level = 4;
                    }
                    dicomViewer.setPdfZoom(level, zoomFactor);
                } else {
                    if (seriesLayout.imageType === IMAGETYPE_RADECG) {
                        imageLevelId = "ecgData";
                        var splitArray = seriesLayout.ecgZoomLevelSettings.toString().split("_");
                        if (splitArray[0] == 6 && splitArray.length > 1 && level == 6) {
                            level = splitArray[0] + "_" + splitArray[1];
                        }
                    } else if (seriesLayout.imageType === IMAGETYPE_CDA || seriesLayout.imageType === IMAGETYPE_RADSR) {
                        //HTML files
                        dicomViewer.zoomSR(level);
                        return false;
                    }
                    var imageRender = seriesLayout.getImageRender(imageLevelId);
                    if (imageRender) {
                        imageRender.setZoomLevel(level);
                        var customValue = 0;
                        var zoomLevel = level;
                        if ((level.toString()).indexOf("6_zoom") >= 0) {
                            customValue = parseInt(level.split("-")[1]);
                            zoomLevel = customValue > 0 ? 6 : 2;
                        }

                        var ecgZoomProperty = {
                            level: zoomLevel,
                            customValue: customValue
                        };
                        seriesLayout.ecgZoomProperty = ecgZoomProperty;
                    }
                }
            });
        }
        $("#" + id).parent().css("background", "#868696");
    }

    function refreshImage() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                imageRender.renderImage(false);
            }
        });
    }

    function moveSeries(incrementFlag) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = seriesLayout.getStudyUid();
        var activeSeriesIndex = parseInt(seriesLayout.seriesIndex);
        var sereisLayoutId = seriesLayout.getSeriesLayoutId();
        dicomViewer.setimageCanvasOfViewPort(sereisLayoutId);
        var numberOfSeries = dicomViewer.Study.getSeriesCount(studyUid);
        var imageAndFrameIndex = dicomViewer.scroll.getCurrentImageAndFrameIndex(incrementFlag, seriesLayout);
        var imageIndex = imageAndFrameIndex[0];
        var frameIndex = imageAndFrameIndex[1];
        var imageCount = dicomViewer.Series.getImageCount(studyUid, activeSeriesIndex);
        var muliFrameImageIndex;
        var seriesIndex;

        var imageValue = dicomViewer.Series.Image.getImage(studyUid, activeSeriesIndex, imageIndex);
        var framecount = 0;
        if (imageValue === undefined) return;
        framecount = dicomViewer.Series.Image.getImageFrameCount(imageValue);
        var isImageThumbnails = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, activeSeriesIndex)
        var thumbnailId;
        if (incrementFlag) {
            if (isImageThumbnails) {
                muliFrameImageIndex = parseInt(imageIndex) + 1;
                seriesIndex = activeSeriesIndex;
                if (muliFrameImageIndex >= imageCount) {
                    muliFrameImageIndex = 0;
                    seriesIndex = seriesIndex + 1;
                    if (numberOfSeries === seriesIndex)
                        return;
                    imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                }
            } else {
                muliFrameImageIndex = 0;
                seriesIndex = activeSeriesIndex + 1;
            }
            if (seriesIndex == numberOfSeries) {
                return;
            }
        } else {
            if (isImageThumbnails) {
                muliFrameImageIndex = parseInt(imageIndex) - 1;
                seriesIndex = activeSeriesIndex;
                if (muliFrameImageIndex < 0) {
                    seriesIndex = seriesIndex - 1;
                    if (seriesIndex === -1)
                        return;
                    imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                    muliFrameImageIndex = imageCount - 1;

                }
            } else {
                muliFrameImageIndex = 0;
                var studyDetials = dicomViewer.getStudyDetails(studyUid);
                if (studyDetials) {
                    var isMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, activeSeriesIndex - 1);
                    if (isMultiframe) {
                        var series = dicomViewer.Series.getSeries(studyUid, activeSeriesIndex - 1);
                        if (series) {
                            muliFrameImageIndex = (series.imageCount - 1) < 0 ? 0 : (series.imageCount - 1);
                        }
                    }
                }

                seriesIndex = activeSeriesIndex - 1;
            }

            if (seriesIndex < 0) {
                return;
            }
        }
        seriesLayout.setSeriesIndex(seriesIndex);
        imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, muliFrameImageIndex);
        framecount = 0;
        seriesLayout.imageType = imageValue.imageType;
        if (imageValue != undefined) framecount = dicomViewer.Series.Image.getImageFrameCount(imageValue);
        var studyDiv = getStudyLayoutId(seriesLayout.seriesLayoutId);
        var imageLayoutDisplayId = "imageDisplay" + studyDiv;
        //frame count is greater than one we displayin images based on the mulframe images in the same series
        if (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex)) {
            thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (seriesIndex) + "_thumb" + (muliFrameImageIndex);
            if (seriesLayout.imageType !== IMAGETYPE_JPEG) {
                document.getElementById(imageLayoutDisplayId).style.display = 'block';
            }
        } else {
            thumbnailId = "imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (seriesIndex) + "_thumb";
            imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
            if (imageCount > 1 && seriesLayout.imageType !== IMAGETYPE_JPEG)
                document.getElementById(imageLayoutDisplayId).style.display = 'block';
            else
                document.getElementById(imageLayoutDisplayId).style.display = 'none';
        }
        displayImage(seriesLayout, seriesIndex, muliFrameImageIndex, true);
        dicomViewer.setStudyToolBarTools(seriesLayout);
        var modality = dicomViewer.Series.getModality(seriesLayout.studyUid, seriesLayout.seriesIndex);
        if (modality == "CT") {
            updateKendoArrowButton($("#winL_wrapper"), false);
            dicomViewer.updatePreset(seriesLayout);
        }
        var thumbnailRenderer = dicomViewer.thumbnail.getThumbnail(thumbnailId);
        // If the thumbnail is available to renderer then return the method.
        if (thumbnailRenderer == undefined) {
            return;
        }
        if (thumbnailRenderer.imageCountOfSeries == undefined)
            thumbnailRenderer.imageCountOfSeries = 1;
        //Display the thumbnail selection based on next or previous buttons
        dicomViewer.thumbnail.selectImageThumbnail(thumbnailRenderer.seriesIndex, muliFrameImageIndex);
        dicomViewer.scroll.stopCineImage(undefined);

        if (dicomViewer.Series.Image.getImageFrameCount(imageValue) > 1) {
            dicomViewer.startCine();
            updatePlayIcon("play.png", "stop.png");
        } else {
            dicomViewer.scroll.stopCineImage(undefined);
            updatePlayIcon("stop.png", "play.png");
        }
        var imageLayout = seriesLayout.getImageLayoutDimension().split("x");
        dicomViewer.tools.changeImageLayout(parseInt(imageLayout[0]), parseInt(imageLayout[1]));

        //While manually moving to the next/previous series with the cine player, updating the toolbar buttons status
        var isCinePlay = dicomViewer.scroll.isCineRunning(seriesLayout.getSeriesLayoutId());
        showOrHideInCineRunning(modality, isCinePlay, isCinePlay);
        if (!isCinePlay) {
            dicomViewer.enableOrDisableTools(modality, seriesLayout);
        }
        EnableDisableNextSeriesImage(seriesLayout);
        dicomViewer.changeSelection(seriesLayout.seriesLayoutId);
        dicomViewer.setDefaultCursorType(modality, seriesLayout);
    }


    function displayImage(seriesLayout, seriesIndex, imageIndex, isMoveSeries) {
        var studyUid = seriesLayout.getStudyUid();
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        var imageUid = dicomViewer.Series.Image.getImageUid(image);
        var imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + 0);
        if (imagePromise === undefined) {
            //TODO cache
        }
        seriesLayout.setSeriesIndex(parseInt(seriesIndex));
        seriesLayout.setImageIndex(imageIndex);
        seriesLayout.setFrameIndex(0);
        seriesLayout.setImageCount(dicomViewer.Series.getImageCount(studyUid, seriesIndex));

        var playerButtonImage = $("#playButton_wrapper img")[0].src;
        if ((dicomViewer.scroll.isToPlayStudy(seriesLayout.seriesLayoutId)) && playerButtonImage.indexOf("stop.png") > -1) {
            dicomViewer.scroll.loadimages(seriesLayout, parseInt(seriesIndex), imageIndex, 0);
        } else {
            seriesLayout.removeAllImageRenders();
            var imageLayout = seriesLayout.getImageLayoutDimension().split("x");
            dicomViewer.setImageLevelLayout(studyUid, parseInt(imageLayout[0]), parseInt(imageLayout[1]), seriesLayout.seriesLayoutId, seriesLayout, seriesIndex, imageIndex, 0, isMoveSeries);
        }
    }

    function firstTimeImageLoad() {
        if (isFirstTimeImageLoad) {
            isFirstTimeImageLoad = false;
            return true;
        } else {
            return false;
        }
    }

    function lengthCalibration() {
        $("#lengthCalibrationAlert").html('');
        document.getElementById("unit").selectedIndex = 0;
        document.getElementById("calibrateLength").value = "";
        document.getElementById("applyToAllImages").checked = false;
        $("#lengthCalibrationAlert").removeClass('alert-danger');
        $("#lengthCalibrationModal").dialog({
            dialogClass: 'no-close'
        });
        $("#lengthCalibrationModal").dialog('open');
    }

    /**
     * Set the selected study layout
     * @param {Type} row - Specifies the rows
     * @param {Type} column - Specifies the columns
     * @param {Type} isWrapper - Specifies the overflow
     */
    function setSelectedStudyLayout(row, column, isWrapper) {
        try {
            // Remove selected table rows
            var applySelectedCell;
            for (var rows = 0; rows < 9; rows++) {
                applySelectedCell = $(".tableCell")[rows];
                $(applySelectedCell).removeClass("selectedCell");
            }

            // Apply selected table row and columns
            var cInc = 0;
            for (var rows = 0; rows < row; rows++) {
                for (var columns = 0; columns < column; columns++) {
                    applySelectedCell = $(".tableCell")[cInc + columns];
                    $(applySelectedCell).addClass("selectedCell");
                }
                cInc += 3;
            }
            // Display row and column text
            var studyId = row + " x " + column;
            $('#tableDimmensions').html(studyId);
        } catch (e) {}
    }

    /**
     * Reorder the exising study Uid to maintain the visibile study in the new study layout
     */
    function reOrderExistingStudyUids(isResize) {
        try {
            // Reset the existing reordered studyUids
            dicomViewer.setReOrderedStudyUids(undefined, true);

            var allViewports = dicomViewer.viewports.getAllViewports();
            if (allViewports === null || allViewports === undefined) {
                return;
            }

            var seriesLayouts = [];
            $.each(allViewports, function (key, value) {
                if (value.studyUid !== undefined || isResize) {
                    seriesLayouts.push(value.seriesLayoutId);
                }
            });

            // Sorting the series layout id
            var existinngStudyUids = [];
            if (seriesLayouts.length > 0) {
                seriesLayouts.sort();
                seriesLayouts.forEach(function (viewportId) {
                    var viewport = dicomViewer.viewports.getViewport(viewportId);
                    if (viewport != null && viewport != undefined) {
                        if (viewport.studyUid !== undefined || isResize) {
                            if (existinngStudyUids.indexOf(viewport.studyUid) === -1) {
                                existinngStudyUids.push(viewport.studyUid);
                            }
                        }
                    } else if (isResize) {
                        if (existinngStudyUids.indexOf(viewport.studyUid) === -1) {
                            existinngStudyUids.push(viewport.studyUid);
                        }
                    }
                });
            }

            if (existinngStudyUids.length == 0) {
                dicomViewer.setReOrderedStudyUids(undefined, true);
            }

            var studyUids = dicomViewer.getListOfStudyUid();
            if (studyUids !== undefined && studyUids !== null) {
                studyUids.forEach(function (studyUid) {
                    if (existinngStudyUids.indexOf(studyUid) == -1) {
                        existinngStudyUids.push(studyUid);
                    }
                });
            }

            dicomViewer.setReOrderedStudyUids(existinngStudyUids, false);
        } catch (e) {}
    }

    /**
     * Get or Set the rearranged series positions
     * @param {Type} row - Specifies the Row
     * @param {Type} column - Specifies the Column
     */
    function getOrSetReArrangedSeriesPositions(row, column, isDoubleClick, page) {
        try {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            var seriesIndex = seriesLayout.getSeriesIndex();
            var imageIndex = seriesLayout.scrollData.imageIndex;
            var totalSeriesLevelLayout = row * column;
            var imageValue = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesIndex, 0);
            var seriesCount = dicomViewer.Study.getSeriesCount(seriesLayout.studyUid);
            var imageCount = dicomViewer.Series.getImageCount(seriesLayout.studyUid, seriesIndex);
            var isMultiframe = dicomViewer.thumbnail.isImageThumbnail(imageValue);
            var imageAndSeriesIndex = isMultiframe ? imageIndex : seriesIndex;
            var imageOrSeriesCount = isMultiframe ? imageCount : seriesCount;

            // Initialize the rearranged series position values
            var selectThumbnailImageIndex = seriesLayout.scrollData.imageIndex;
            var actualSeriesIndex = imageAndSeriesIndex;
            var multiFrameImageIndex = 0;

            // Validate and assign the image or series index
            if (totalSeriesLevelLayout > 1) {
                var totalViewports = totalSeriesLevelLayout + imageAndSeriesIndex;
                if (totalViewports >= imageOrSeriesCount) {
                    imageAndSeriesIndex = (totalSeriesLevelLayout > imageOrSeriesCount ? 0 : imageOrSeriesCount - totalSeriesLevelLayout);
                }
            }

            if (isMultiframe == true) {
                multiFrameImageIndex = imageAndSeriesIndex;
            }

            // For mixed modality study, if one of the series is multiframe and while changing the series level layout by selecting other modality series, moving to the last image for the previous multiframe series
            var series = dicomViewer.Series.getSeries(seriesLayout.studyUid, seriesIndex, 0);
            if (seriesLayout.getSeriesIndex() > imageAndSeriesIndex && !series.iskeyImageSeries) {
                //Checking if the previous series is multiframe or not
                var newImage = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, imageAndSeriesIndex, 0);
                var isImageThumbnail = dicomViewer.thumbnail.isImageThumbnail(newImage);
                if (isImageThumbnail) {
                    //Moving to the last image for the multiframe series
                    var imageOrSeries = dicomViewer.Series.getSeries(seriesLayout.studyUid, seriesIndex);
                    multiFrameImageIndex = imageOrSeries.imageCount - 1;
                    if (totalSeriesLevelLayout > 3) {
                        if (multiFrameImageIndex >= totalSeriesLevelLayout - 1) {
                            multiFrameImageIndex++;
                            multiFrameImageIndex = multiFrameImageIndex - (totalSeriesLevelLayout - 1);
                        }
                    }
                }
            }

            // Set the rearranged series positions
            dicomViewer.setReArrangedSeriesPositions({
                multiFrameImageIndex: multiFrameImageIndex,
                actualSeriesIndex: actualSeriesIndex,
                selectThumbnailImageIndex: selectThumbnailImageIndex,
                isViewPortDoubleClicked: isDoubleClick,
                pageView: page
            });

            return (isMultiframe ? seriesIndex : imageAndSeriesIndex);
        } catch (e) {}

        return undefined;
    }

    /**
     * To Change the text of context menu item of study cache indicator
     *  
     */
    function cacheIndicator() {
        resetMenu();
        showStudyCacheIndicator = !showStudyCacheIndicator;
        showCacheIndicator();

        if (showStudyCacheIndicator) {
            $(".cacheindicator").text("Hide Cache Indicator");
        } else {
            $(".cacheindicator").text("Show Cache Indicator");
        }
    }

    /**
     * Need to check calibration values is present in the current image
     *  
     */
    function isCaliberEnabled(render) {
        var studyUid;
        var seriesIndex;
        var imageIndex;
        var frameIndex;
        var imageUid;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (render && seriesLayout) {
            studyUid = seriesLayout.getStudyUid();
            seriesIndex = render.seriesIndex
            imageIndex = render.imageIndex
            frameIndex = (render.anUIDs).split("*")[1];
            imageUid = render.imageUid;
        } else if (seriesLayout) {
            studyUid = seriesLayout.getStudyUid();
            seriesIndex = seriesLayout.seriesIndex
            imageIndex = seriesLayout.getImageIndex()
            frameIndex = seriesLayout.scrollData.frameIndex
            var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
            imageUid = dicomViewer.Series.Image.getImageUid(image);
        }

        if (studyUid != undefined && imageUid != undefined) {
            var calibratedValues = getUnitMeasurementMap(studyUid + "|" + seriesIndex + "|" + imageIndex + "|" + frameIndex);
            var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
            if (dicomHeader.imageInfo.measurement) {
                if (dicomHeader.imageInfo.measurement.pixelSpacing != null && dicomHeader.imageInfo.measurement.pixelSpacing != undefined) {
                    if (dicomHeader.imageInfo.measurement.pixelSpacing.row <= 0 && calibratedValues == null) {
                        return true;
                    }
                }
            } else if ((calibratedValues == null) && (dicomHeader.imageInfo == undefined || dicomHeader.imageInfo.measurement == undefined ||
                    dicomHeader.imageInfo.measurement == null)) {
                return true;
            }
        }
        return false;
    }

    /**
     * To set the calibration tool as activeTool
     *  
     */
    function setCalibrationActiveTool() {
        resetMenu();
        $("#context-length-calibration").css("background", "#868696");
        $("#6_measurement").css("background", "#868696");
        flagFor2dLengthCalibration = true;
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthCalibrationTool());
    }

    /**
     * To get the length calibration flag
     *  
     */
    function getLengthCalibrationFlag() {
        return isLengthCalibrating;
    }

    /**
     * To set the length calibration flag
     *  
     */
    function setLengthCalibrationFlag(flag) {
        isLengthCalibrating = flag;
    }

    function doDefault() {
        resetMenu();
        $('#viewport_View').css('cursor', 'default');
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();

        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getDefaultTool());
        // refresh image so that US regions appear
        refreshImage();
    }

    /**
     * To set the context menu and too bar measurement item selection
     *  
     */
    function SetMenuSelectionColor(toolName) {
        var cursorObj = document.getElementById('viewport_View');
        var cursorName;
        if (cursorObj != undefined && cursorObj != null) {
            cursorName = cursorObj.style.cursor;
        }
        if (toolName == "lineMeasurement") {
            if (cursorName.indexOf("images/calibrate.cur") > 0) {
                $("#context-length-calibration").css("background", "#868696");
                $("#6_measurement").css("background", "#868696");
            } else if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotatearrow") {
                $("#context-arrow").css("background", "#868696");
                $("#10_arrow").css("background", "#868696");
            } else if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotateline") {
                $("#context-line").css("background", "#868696");
                $("#9_line").css("background", "#868696");
            } else {
                $("#context-length").css("background", "#868696");
                $("#0_measurement").css("background", "#868696");
            }
        } else if (toolName == "pointMeasurement") {
            $("#context-2dPoint").css("background", "#868696");
            $("#1_measurement").css("background", "#868696");
        } else if (toolName == "traceMeasurement" || toolName == "mitralMeanGradientMeasurement") {
            if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotatefreehand") {
                $("#context-freehand").css("background", "#868696");
                $("#13_freehand").css("background", "#868696");
            } else {
                $("#context-trace").css("background", "#868696");
                $("#2_measurement").css("background", "#868696");
            }
        } else if (toolName == "volumeMeasurement") {
            $("#context-volume").css("background", "#868696");
            $("#3_measurement").css("background", "#868696");
        } else if (toolName == "angleMeasurement") {
            $("#context-angle").css("background", "#868696");
            $("#angle_measurement").css("background", "#868696");
        } else if (toolName == "ellipseMeasurement") {
            if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotateellipse") {
                $("#context-ellipse").css("background", "#868696");
                $("#11_ellipse").css("background", "#868696");
            } else {
                $("#context-hounsfield-ellipse").css("background", "#868696");
                $("#7_measurement").css("background", "#868696");
            }
        } else if (toolName == "rectangleMeasurement") {
            if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotaterectangle") {
                $("#context-rectangle").css("background", "#868696");
                $("#12_rectangle").css("background", "#868696");
            } else if (cursorName && cursorName.split("/")[1].split(".")[0] == "annotatetext") {
                $("#context-text").css("background", "#868696");
                $("#8_text").css("background", "#868696");
            } else {
                $("#context-hounsfield-rectangle").css("background", "#868696");
                $("#14_measurement").css("background", "#868696");
            }
        }
    }

    /**
     * To set the auto window level
     *  
     */
    function doWindowLevelROI(e) {
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
        $('#viewport_View').css('cursor', 'url(images/AutoWindowLevel.cur), auto');
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getWindowToolROI());

        // refresh image so that US regions appear
        refreshImage();
    }

    /**
     * 
     * Print
     */
    function doPrint() {
        doPrintLayout(false);
    }

    /**
     * Print
     */
    function doExport() {
        doPrintLayout(true);
    }

    /**
     * Print
     * @param {Type} isExport - Specifies theflag to export
     */
    var printOrExportWnd = null;

    function printLayout(isExport) {
        try {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            if (seriesLayout === undefined || seriesLayout === null) {
                return;
            }
            //VAI-307
            var tiffImage = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, 0); //Based on the first image frame page 0
            if (tiffImage.cacheLocator.includes("Tiff;")) {
                var isPageReady = PdfRequest.arePrintAndExportReady;
                if (!isPageReady) {
                    if(PdfRequest.findRequestStatus(tiffImage.imageUid) == PdfRequest.Status.complete)
                        isPageReady = true;
                }
                if (isPageReady)
                {
                    if (isExport) exportPdfDoc();
                    else printPdfDoc();
                    return;
                }
                return; 
              }

            var isEcg = seriesLayout.imageType === IMAGETYPE_RADECG ? true : false;
            var isPdf = (isEmbedPdfViewer(seriesLayout.imageType)) ? true : false;

            var imageRender = isEcg ? seriesLayout.getImageRender("ecgData") :
                seriesLayout.getImageRender(getClickedViewportId());

            if (isEcg) {
                imageRender = seriesLayout.getImageRender("ecgData");
            } else if (isPdf) {
                imageRender = seriesLayout.getImageRender("pdfData");
            } else {
                imageRender = seriesLayout.getImageRender(getClickedViewportId()) ?
                    seriesLayout.getImageRender(getClickedViewportId()) :
                    seriesLayout.getImageRender(seriesLayout.seriesLayoutId + "ImageLevel0x0");
            }

            var series = dicomViewer.Series.getSeries(seriesLayout.studyUid, seriesLayout.seriesIndex);
            if (series === null || series === undefined) {
                return;
            }

            var description = series.description;
            if (description === undefined || description === null) {
                description = "";
            }

            var printOption = $("#PrintZoomOptions").val();
            printOption = parseInt(printOption);
            var imageDataUrl = undefined;
            var isHtml = false;
            var fontSize = 12.75;

            var printContent = '<!DOCTYPE html>';
            printContent += '<head><title>';
            printContent += (isExport ? "Export" : "Print") + " image - " + description;
            printContent += '</title></head>';
            printContent += '<body>';

            if (imageRender) {

                if (isEcg) {
                    imageDataUrl = imageRender.PrepareECGPrint(printOption)
                    if (!imageDataUrl) {
                        dumpConsoleLogs(LL_ERROR, undefined, "printLayout", "Failed to print the image/report.\nPrint content is empty.");
                        return;
                    }

                    var ecgDivId = document.getElementById("ecgDataDiv_" + seriesLayout.seriesLayoutId);
                    if (isExport) {
                        exportEcg(ecgDivId, printContent, imageDataUrl, imageRender, printOption);
                        return;
                    }

                    if (printOption == 1) {
                        fontSize = fontSize * parseFloat(imageRender.tempEcgScale);
                    }

                    printContent += "<div style=font-size:" + fontSize + "px>" + ecgDivId.innerHTML + "</div>";
                    printContent += '<img src="' + imageDataUrl + '">';

                } else if (isPdf) {
                    var printImageIndex = $("#printLayoutModal")[0].printImageIndex;
                    var imageDataUrls = [];
                    $("#printLayoutModal")[0].imageData = {
                        imageDataUrls: [],
                        count: 0
                    };

                    for (var index = 0; index < printImageIndex.length; index++) {
                        var printData = {
                            isExport: isExport,
                            printContent: printContent,
                            totalPages: printImageIndex.length,
                            printOption: printOption,
                            printStaus: true
                        };

                        imageDataUrl = imageRender.preparePdfPrint(printData, printImageIndex[index], function (canvas, printData) {
                            printPdfCallback(canvas, printData)
                        });
                    }

                } else {
                    var printImageIndex = $("#printLayoutModal")[0].printImageIndex;
                    var imageDataUrls = [];
                    var ActiveImage = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);

                    //get the imagecanves
                    for (var index = 0; index < printImageIndex.length; index++) {
                        var isMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex);
                        var isValid = false;
                        var imageIndex = printImageIndex[index] - 1;
                        if (isMultiframe && ActiveImage.numberOfFrames > 1) {
                            imageIndex = seriesLayout.getImageIndex();
                            isValid = true;
                        }

                        var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, imageIndex);
                        if (!image) {
                            continue;
                        }
                        var frameIndex = isMultiframe ? printImageIndex[index] - 1 : 0;
                        imageIndex = isMultiframe ? seriesLayout.scrollData.imageIndex : printImageIndex[index] - 1;


                        var imageCanvasData;
                        var imageUid = image.imageUid;
                        if (isValid) {
                            var requestData = {
                                studyUid: seriesLayout.studyUid,
                                seriesIndex: seriesLayout.seriesIndex,
                                imageIndex: imageIndex,
                                frameIndex: frameIndex,
                                imageUid: imageUid,
                                imageType: seriesLayout.imageType,
                                layoutId: seriesLayout.seriesLayoutId
                            };

                            var loadImageDeferred = dicomViewer.getImage(requestData);
                            loadImageDeferred.done(function (imageCanvas) {
                                var logMessage = "Frame Number => " + imageCanvas.frameNumber + "\n \
                                                  Series Index => " + seriesLayout.seriesIndex + "\n \
                                                  ImageUid => " + imageCanvas.imageUid + "\n \
                                                  ImageIndex => " + imageIndex;
                                dumpConsoleLogs(LL_INFO, undefined, "printLayout", logMessage);
                                imageCanvasData = imageCanvas;
                                var deferred = $.Deferred();
                                deferred.resolve(imageCanvas);
                            });
                        } else {
                            var imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + (0));

                            if (!imagePromise) {
                                continue;
                            }

                            imagePromise.then(function (image) {
                                imageCanvasData = image;
                            });
                        }

                        var presentation = imageRender.presentationState ? imageRender.presentationState : imageCanvasData.presentation;

                        if (imageCanvasData) {
                            var imageCanvas = document.createElement("canvas");

                            var dicominfo = imageCanvasData.dicominfo;
                            if ((dicominfo.imageInfo.numberOfFrames > 1 && dicominfo.imageInfo.modality === "US") || dicominfo.imageInfo.imageType === IMAGETYPE_JPEG) {
                                imageCanvas = imageCanvasData.imageData;
                            } else {
                                dicomViewer.updateImage(imageCanvas, imageCanvasData, presentation);
                            }
                            imageCanvas.imageCanvasData = imageCanvasData;
                            imageDataUrl = imageRender.prepareLayoutPrint(printOption, imageCanvas);
                            imageDataUrls.push(imageDataUrl);
                        }
                    }

                    if (!imageDataUrls.length) {
                        dumpConsoleLogs(LL_ERROR, undefined, "printLayout", "Failed to print the image/report.\nPrint content is empty.");
                        return;
                    }

                    var imageLayoutDimension = seriesLayout.imageLayoutDimension;
                    var dimension = imageLayoutDimension.split("x");
                    var rows = dimension[0];
                    var columns = dimension[1];

                    //set the layout
                    if (imageDataUrls.length !== rows * columns) {
                        var index = imageDataUrls.length > 9 ? 9 : imageDataUrls.length;
                        switch (index) {
                            case 1:
                                {
                                    rows = 1;columns = 1;
                                    break;
                                }
                            case 2:
                                {
                                    rows = 1;columns = 2;
                                    break;
                                }
                            case 3:
                                {
                                    rows = 1;columns = 3;
                                    break;
                                }
                            case 4:
                                {
                                    rows = 2;columns = 2;
                                    break;
                                }
                            case 5:
                            case 6:
                                {
                                    rows = 2;columns = 3;
                                    break;
                                }
                            case 7:
                            case 8:
                            case 9:
                                {
                                    rows = 3;columns = 3;
                                    break;
                                }
                            default:
                                {
                                    rows = 0;columns = 0;
                                    break;
                                    return;
                                }
                        }
                    }

                    printContent += '<table>'
                    var index = 0;
                    for (var row = 0; row < rows; row++) {
                        printContent += '<tr>'
                        for (var col = 0; col < columns; col++) {
                            printContent += '<td><img src="' + imageDataUrls[index++] + '"></td>'
                        }
                        printContent += '</tr>'
                    }
                    printContent += '</table>'

                }
            } else {
                if ($("#" + seriesLayout.seriesLayoutId)[0].isHtml) {
                    var htmlId = $("#" + seriesLayout.seriesLayoutId)[0].HtmlId;
                    imageDataUrl = document.getElementById(htmlId).innerHTML;
                    isHtml = true;
                    if (printOption == 1) {
                        fontSize = parseFloat($("#" + htmlId).css("font-size"));
                    }

                    if (!imageDataUrl) {
                        dumpConsoleLogs(LL_ERROR, undefined, "printLayout", "Failed to print the image/report.\nPrint content is empty.");
                        return;
                    }
                    if (isExport) {
                        exportHtml($("#" + seriesLayout.seriesLayoutId), printContent);
                        return;
                    }
                    printContent += "<div style=font-size:" + fontSize + "px>" + imageDataUrl + "</div>";
                }
            }

            printContent += '</body>';
            printContent += '</html>';

            var printDialog = printOrExportWnd;
            if (!printDialog) {
                printDialog = window.open('', 'Print', '');
            }

            if (!isPdf) {
                printDialog.document.open();
                printDialog.document.write(printContent);
                printDialog.document.close();

                if (isExport) {
                    return;
                }

                if (isInternetExplorer()) {
                    printDialog.focus();
                    printDialog.print();
                    printDialog.close();
                    return;
                }

                printDialog.window.setTimeout(function () {
                    printDialog.focus();

                    if (printDialog.onafterprint === null) {
                        printDialog.onafterprint = function () {
                            printDialog.close();
                        };
                    }
                    printDialog.print();

                    if (printDialog.onafterprint === undefined) {
                        printDialog.window.setTimeout(function () {
                            printDialog.close();
                        }, 3000);
                    }
                }, 200);
            }
        } catch (e) {}
    }

    function printPdfCallback(printCanvas, printData) {
        try {
            var imageDataUrl;
            if (printCanvas && printCanvas.canvas) {
                imageDataUrl = printCanvas.canvas.toDataURL('image/jpeg', 1.0);
            }

            if (imageDataUrl) {
                $("#printLayoutModal")[0].imageData.imageDataUrls.push(imageDataUrl);
            }

            if (++$("#printLayoutModal")[0].imageData.count !== printData.totalPages) {
                return;
            }

            var imageDataUrls = $("#printLayoutModal")[0].imageData.imageDataUrls;
            var printContent = printData.printContent;

            if (!imageDataUrls.length) {
                dumpConsoleLogs(LL_ERROR, undefined, "printLayout", "Failed to print the image/report.\nPrint content is empty.");
                return;
            }

            printContent += '<table>'
            var index = 0;
            for (var row = 0; row < imageDataUrls.length; row++) {
                printContent += '<tr>'
                for (var col = 0; col < 1; col++) {
                    printContent += '<td><img src="' + imageDataUrls[index++] + '"></td>'
                }
                printContent += '</tr>'
            }
            printContent += '</table>'

            printContent += '</body>';
            printContent += '</html>';

            var printDialog = printOrExportWnd;
            if (!printDialog) {
                printDialog = window.open('', 'Print', '');
            }

            printDialog.document.open();
            printDialog.document.write(printContent);
            printDialog.document.close();

            if (printData.isExport) {
                return;
            }

            if (isInternetExplorer()) {
                printDialog.focus();
                printDialog.print();
                printDialog.close();
                return;
            }

            printDialog.window.setTimeout(function () {
                printDialog.focus();

                if (printDialog.onafterprint === null) {
                    printDialog.onafterprint = function () {
                        printDialog.close();
                    };
                }
                printDialog.print();

                if (printDialog.onafterprint === undefined) {
                    printDialog.window.setTimeout(function () {
                        printDialog.close();
                    }, 3000);
                }
            }, 200);
        } catch (e) {}
    }

    /**
     * To Change the text of context menu item for link tool
     *
     */
    function linkSeries() {
        resetMenu();

        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();

        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getLinkTool());
        if (dicomViewer.link.isSeriesLinked()) {
            var img = document.getElementById('linkButton').children[0];
            img.src = 'images/link.png';
            updateToolTip($("#linkButton"), "Link");
            dicomViewer.link.unLinkSeries();
            $('#viewport_View').css('cursor', 'default');
        } else {
            $('#viewport_View').css('cursor', 'url(images/link.cur), auto');
            dicomViewer.link.linkSeries();
        }

        // refresh image so that US regions appear
        refreshImage();
    }

    function doXRefLineSelection() {
        try {
            dicomViewer.measurement.setDataToDelete();
            var tool = dicomViewer.mouseTools.getActiveTool();
            tool.hanleDoubleClick();

            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getXRefLineSelectionTool());
            refreshImage();
        } catch (e) {}
    }

    /**
     *Copy the presenation property 
     */
    function doCopyAttributes() {
        try {
            dicomViewer.measurement.setDataToDelete();
            var tool = dicomViewer.mouseTools.getActiveTool();
            tool.hanleDoubleClick();
            var activeSeries = dicomViewer.getActiveSeriesLayout();
            if (activeSeries == undefined || activeSeries == null) {
                return;
            }

            var imageLayoutId = undefined;
            $("#" + activeSeries.getSeriesLayoutId() + " div").each(function () {
                imageLayoutId = $(this).attr('id');
            });

            if (imageLayoutId == undefined || imageLayoutId == null) {
                return;
            }

            if (activeSeries.imageLayoutDimension !== "1x1") {
                imageLayoutId = activeSeries.seriesLayoutId + "ImageLevel0x0";
            }

            var copyAttributesData = activeSeries.getImageRender(imageLayoutId);
            var tool = dicomViewer.mouseTools.getCopyAttributesTool();
            tool.setCopyAttributesData({
                sourceId: activeSeries.getSeriesLayoutId(),
                data: copyAttributesData,
                studyUid: activeSeries.studyUid,
                imageType: activeSeries.imageType
            });
            dicomViewer.mouseTools.setActiveTool(tool);
        } catch (e) {}
    }

    /**
     * Show/Hide the annotations/measurements
     */
    function doShowHideAnnotationAndMeasurement() {
        try {
            annotationAndMeasurementVisibleStatus = !annotationAndMeasurementVisibleStatus
            annotationAndMeasurementVisibleStatus ? $("#4_measurement").show() : $("#4_measurement").hide();
            var menuInnerText = annotationAndMeasurementVisibleStatus ? "Hide Annotation / Measurement" : "Show Annotation / Measurement";
            document.getElementById("showHideAnnotaionAndMesurement").innerText = menuInnerText;
            document.getElementById("showHideAnnotaionAndMesurement_overflow").innerText = menuInnerText;
            var allViewports = dicomViewer.viewports.getAllViewports();

            for (var key in allViewports) {
                var viewportTemp = allViewports[key];
                $("#" + viewportTemp.getSeriesLayoutId() + " div").each(function () {
                    var imageLayoutId = $(this).attr('id');
                    var imageRender = viewportTemp.getImageRender(imageLayoutId);
                    if (imageRender) {
                        imageRender.drawDicomImage();
                    }
                });
            }
        } catch (e) {}
    }

    /**
     * set the show/hide measurement and annotation flag 
     */
    function isShowAnnotationandMeasurement() {
        return annotationAndMeasurementVisibleStatus;
    }

    /**
     * Get the 6000 overlay visibility flag
     */
    function is6000OverlayVisible() {
        return is6000Overlay;
    }

    /**
     * Show/Hide the 6000 overlay
     */
    function doOverLay6000() {
        is6000Overlay = !is6000Overlay;
        var menuInnerText = (is6000Overlay ? "Hide" : "Show") + " Overlay 6000";
        document.getElementById("showHideOverlay6000").innerText = menuInnerText;
        document.getElementById("showHideOverlay6000_overflow").innerText = menuInnerText;
        var allViewports = dicomViewer.viewports.getAllViewports();
        for (var key in allViewports) {
            var viewportTemp = allViewports[key];
            $("#" + viewportTemp.getSeriesLayoutId() + " div").each(function () {
                var imageLayoutId = $(this).attr('id');
                var imageRender = viewportTemp.getImageRender(imageLayoutId);
                if (imageRender) {
                    imageRender.renderImage(false);
                }
            });
        }
    }

    /**
     * Do Print or Export image/Report 
     * @param {Type} option - Specifies the option
     * @param {Type} isVerified - Specifies the flag to verified
     * @param {Type} isExport - Specifies the flag to export
     */
    function doPrintOrExport(isVerified, isExport, printReason) {
        try {
            if (isVerified) {
                $("#printImageWindow").data("IsExport", isExport);
                $('#printImageWindow').data("callback", function (signature, reason, isExport) {
                    if (hasExportOrPrintPrivilege(reason)) {
                        //VAI-307
                        var seriesLayout = dicomViewer.getActiveSeriesLayout();
                        var tiffImage = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, 0); //Based on the first image frame page
                        if (tiffImage.cacheLocator.includes("Tiff;") == false) {
                            CreateAndWriteDummyPrintOrExportContent(isExport);
                        }

                        if (iseSignatureValidated(signature)) {
                            printLayout(isExport);
                        } else {
                            updatePrintStatus("Failed to verify the eSignature");
                            $("#alert-printImage").show();
                            $("#alert-printImage").removeClass('alert-info').addClass('alert-danger');
                            $("#alert-printImage").html('Failed to verify the eSignature');
                            $("#printLayoutModal").dialog("open");
                            $("#printImageWindow").dialog("open");
                            $("#reasonForPrintImage").val(reason);
                        }
                    } else {
                        updatePrintStatus("Failed to verify the " + (isExport ? "export" : "print") + " image access");
                    }
                });
                $('#printImageWindow').dialog('option', 'title', (isExport ? "Export" : "Print"));
                $("#printImageWindow").dialog("open");
            } else if (printReason) {
                doVerifyAndExport(printReason, isExport);
            } else {
                printLayout(isExport);
            }
        } catch (e) {}
    }

    /**
     * update the print/export status
     */
    function updatePrintStatus(reason) {
        try {
            printOrExportWnd.document.getElementById("printExportStatus").innerHTML = reason;
            printOrExportWnd.window.setTimeout(function () {
                printOrExportWnd.close();
                printOrExportWnd = null;
            }, 1000)
        } catch (e) {}
    }

    /**
     * Create the dummy print or export status
     */
    function CreateAndWriteDummyPrintOrExportContent(isExport) {
        try {
            if (printOrExportWnd) {
                printOrExportWnd.close();
                printOrExportWnd = null;
            }

            var printContent = '<!DOCTYPE html>';
            printContent += '<head><title>';
            printContent += (isExport ? "Exporting" : "Printing") + " Image";
            printContent += '</title></head>';
            printContent += '<body>';
            printContent += "<div id=printExportStatus style='background:black;color:white;text-align:center;font-size:larger;height:95vh;line-height:95vh'>" + (isExport ? "Exporting" : "Printing") + " Image..." + "</div>";
            printContent += '</body>';
            printContent += '</html>';
            printOrExportWnd = window.open('', '_blank', '');
            printOrExportWnd.document.open();
            printOrExportWnd.document.write(printContent);
            printOrExportWnd.document.close();

            // Watch the window close
            var timer = setInterval(function () {
                if (printOrExportWnd && printOrExportWnd.closed) {
                    clearInterval(timer);
                    printOrExportWnd = null;
                }
            }, 1000);
        } catch (e) {}
    }

    /**
     * 
     * @param {Type} reason - Specifies the export reason
     * @param {Type} option - Spectifies the export option
     * @param {Type} isExport - Specify the flag to export
     */
    function doVerifyAndExport(reason, isExport) {
        try {
            var t0 = Date.now();
            dumpConsoleLogs(LL_INFO, undefined, "doVerifyAndExport ", "Start");
            if (hasExportOrPrintPrivilege(reason)) {
                printLayout(isExport)
            }
        } catch (e) {
            dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to verify the print image access");
            dumpConsoleLogs(LL_ERROR, undefined, "doVerifyAndExport", e.message);
        } finally {
            dumpConsoleLogs(LL_INFO, undefined, "doVerifyAndExport ", "End", (Date.now() - t0));
        }
    }

    /**
     * Verify the eSignature
     * @param {Type} signature - Specifies the digital signature
     */
    function iseSignatureValidated(signature) {

        try {
            var t0 = Date.now();
            dumpConsoleLogs(LL_INFO, undefined, "printOrExportImages ", "Start");

            dicomViewer.measurement.showAndHideSplashWindow("show", "Verifying eSignature...", "dicomViewer");
            var iseSignatureValid = false;
            $.ajax({
                    type: 'GET',
                    url: dicomViewer.Metadata.eSignatureUrl(signature),
                    data: "",
                    async: false
                })
                .success(function (data) {
                    iseSignatureValid = true;
                })
                .fail(function (data, textStatus, errorThrown) {
                    dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to verify the eSignature");
                })
                .error(function (data, status) {
                    dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to verify the eSignature");
                });

            return iseSignatureValid;
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
        } finally {
            dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
        }

        return false;
    }

    /**
     * Check whether print privilege is there or not for the given print reason
     * @param {Type} reason - Specify the print reason
     */
    function hasExportOrPrintPrivilege(reason) {
        try {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            if (seriesLayout === undefined || seriesLayout === null) {
                return false;
            }

            var seriesIndex = undefined;
            var imageIndex = undefined;
            if ($("#" + seriesLayout.seriesLayoutId)[0].isHtml) {
                seriesIndex = seriesLayout.seriesIndex;
                imageIndex = 0;
            } else {

                if (isEmbedPdfViewer(seriesLayout.imageType)) {
                    imageRender = seriesLayout.getImageRender("pdfData");
                } else {
                    imageRender = seriesLayout.imageType === IMAGETYPE_RADECG ? seriesLayout.getImageRender("ecgData") : seriesLayout.getImageRender(getClickedViewportId());
                }

                if (imageRender === undefined || imageRender === null) {
                    return false;
                }

                seriesIndex = imageRender.seriesIndex;
                imageIndex = imageRender.imageIndex;
            }

            var imageUrn = dicomViewer.Series.Image.getImageUrn(seriesLayout.studyUid, seriesIndex, imageIndex);
            if (!imageUrn) {
                dumpConsoleLogs(LL_ERROR, undefined, "hasExportOrPrintPrivilege", "Failed to get imageUrn");
                return false;
            }

            var hasExportOrPrintPrivilege = false;
            dicomViewer.measurement.showAndHideSplashWindow("show", "Verifying print image access...", "dicomViewer");
            $.ajax({
                    type: 'GET',
                    url: dicomViewer.getLogExportUrl(),
                    data: {
                        reason: reason,
                        imageUrn: imageUrn
                    },
                    async: false
                })
                .success(function (data) {
                    hasExportOrPrintPrivilege = true;
                })
                .fail(function (data, textStatus, errorThrown) {
                    dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to verify the print image access");
                })
                .error(function (data, status) {
                    dicomViewer.measurement.showAndHideSplashWindow("error", "Failed to verify the print image access");
                });

            return hasExportOrPrintPrivilege;
        } catch (e) {}

        return false;
    }

    /**
     * Export the Html elemtents using html to canvas method
     * @param {Type} divId - specifies the div id
     * @param {Type} printContent - specifies the print content
     */
    function exportHtml(divId, printContent) {
        try {
            html2canvas(divId, {
                onrendered: function (canvas) {
                    printContent += '<img src="' + canvas.toDataURL('image/jpeg', 1.0) + '">';
                    printContent += '</body>';
                    printContent += '</html>';
                    var printDialog = printOrExportWnd;
                    if (!printDialog) {
                        printDialog = window.open('', 'Print', '');
                    }
                    printDialog.document.open();
                    printDialog.document.write(printContent);
                    printDialog.document.close();
                }
            });
        } catch (e) {}
    }

    /**
     * Export the Ecg image using html to canvas method
     * @param {Type} ecgDivId - specifies the ecg div id
     * @param {Type} printContent - specifies the print content
     * @param {Type} imageDataUrl - specifies the image data Url
     * @param {Type} imageRender - specifies the image render object
     * @param {Type} printOption - specifies the print option
     */
    function exportEcg(ecgDivId, printContent, imageDataUrl, imageRender, printOption) {
        try {
            html2canvas(ecgDivId, {
                onrendered: function (canvas) {
                    var printCanvas = document.createElement("canvas");
                    var ecgDataId = $("#imageEcgCanvas" + imageRender.seriesLevelDivId);
                    var scaleValue = 1;
                    if (printOption == 1) {
                        scaleValue = parseFloat(imageRender.tempEcgScale);
                    }

                    var ecgDataWidth = imageRender.ecgData.width * scaleValue;
                    var ecgDataHeight = imageRender.ecgData.height * scaleValue;
                    printCanvas.width = ecgDivId.clientWidth > ecgDataWidth ? ecgDivId.clientWidth : ecgDataWidth;
                    printCanvas.height = ecgDivId.clientHeight + ecgDataHeight;
                    var printContext = printCanvas.getContext('2d');
                    printContext.clearRect(0, 0, printCanvas.width, printCanvas.height);
                    printContext.fillStyle = 'white';
                    printContext.fillRect(0, 0, printCanvas.width, printCanvas.height);
                    printContext.save();
                    var ecgDivObj = new Image();
                    var ecgDataObj = new Image();
                    ecgDivObj.src = canvas.toDataURL('image/jpeg', 1.0);
                    ecgDivObj.onload = function () {
                        printContext.drawImage(ecgDivObj, 0, 0);
                        ecgDataObj.src = imageDataUrl;
                        ecgDataObj.onload = function () {
                            printContext.drawImage(ecgDataObj, 0, ecgDivId.clientHeight);
                            printContext.restore();
                            printContent += '<img src="' + printCanvas.toDataURL('image/jpeg', 1.0) + '">';
                            printContent += '</body>';
                            printContent += '</html>';
                            var printDialog = printOrExportWnd;
                            if (!printDialog) {
                                printDialog = window.open('', 'Print', '');
                            }
                            printDialog.document.open();
                            printDialog.document.write(printContent);
                            printDialog.document.close();
                        }
                    };
                }
            });
        } catch (e) {}
    }

    /**
     * Returns the current mouse cursor type/name
     */
    function getCursorType() {
        try {
            var cursorObj = document.getElementById('viewport_View');
            var cursorName;
            if (cursorObj != undefined && cursorObj != null) {
                cursorName = cursorObj.style.cursor;
            }

            if (cursorName != null && cursorName != undefined) {
                cursorName = ((cursorName = cursorName.split("/")[1]) == undefined) ? "default" : cursorName.split(".")[0];
            }

            return cursorName;
        } catch (e) {}
    }

    /**
     * draw the mensurated scale
     */
    function doMenusratedScale() {
        try {
            isMenusratedScaleVisible = !isMenusratedScaleVisible;
            var menuInnerText = (isMenusratedScaleVisible ? "Hide" : "Show") + " Mensurated Scale";
            document.getElementById("context-MensuratedScale").innerText = menuInnerText;
            document.getElementById("showHideMensuratedScale").innerText = menuInnerText;
            document.getElementById("showHideMensuratedScale_overflow").innerText = menuInnerText;
            var allViewports = dicomViewer.viewports.getAllViewports();
            for (var key in allViewports) {
                var viewportTemp = allViewports[key];
                $("#" + viewportTemp.getSeriesLayoutId() + " div").each(function () {
                    var imageLayoutId = $(this).attr('id');
                    var imageRender = viewportTemp.getImageRender(imageLayoutId);
                    if (imageRender) {
                        imageRender.showOrHideOverlay(isMenusratedScaleVisible, viewportTemp.studyUid);
                    }
                });
            }
        } catch (e) {}
    }

    /**
     * return the menusurated scale value
     */
    function isVisibleMensuratedScale() {
        try {
            return isMenusratedScaleVisible;
        } catch (e) {}
    }

    /**
     * Moves to previous page
     * @param {Type}
     */
    function movePreviousPage() {
        doPageNavigation("prev");
    }

    /**
     * Moves to next page
     * @param {Type}
     */
    function moveNextPage() {
        doPageNavigation("next");
    }

    /**
     * Do the page navigation
     * @param {Type} type - Specidy the navigation type 
     */
    function doPageNavigation(type) {
        try {
            var navigation = getNavigationType(type);
            if (navigation.indexArrays !== null && navigation.indexArrays !== undefined) {
                var length = navigation.indexArrays.length;
                var firstIndex = navigation.indexArrays[0];
                var lastIndex = navigation.indexArrays[length - 1];
                if (navigation.isOrderUdpated === false) {
                    if (type === "next") {
                        var diff = navigation.totalCount - lastIndex - 1;
                        if (diff <= length) {
                            firstIndex = navigation.totalCount - length;
                            lastIndex = navigation.totalCount - 1;
                        } else {
                            firstIndex += length;
                            lastIndex += length;
                        }
                    } else {
                        if (firstIndex < length) {
                            firstIndex = 0;
                            lastIndex = length - 1;
                        } else {
                            firstIndex -= length;
                            lastIndex -= length;
                        }
                    }
                }

                changePageLayout(navigation, firstIndex, lastIndex);
                postPageNavigation((type === "next" ? lastIndex : firstIndex), navigation.totalCount);
            }
        } catch (e) {}
    }

    /**
     * Navigate through pages
     */
    function changePageLayout(navigation, firstIndex, lastIndex) {
        try {
            var page = {
                type: navigation.type,
                first: firstIndex,
                last: lastIndex,
                id: navigation.studyLayout,
                seriesIndex: navigation.seriesIndex,
                imageIndex: navigation.imageIndex,
                isMultiFrame: navigation.isMultiFrame
            };
            var rowCol = navigation.layout.split('x');
            if (navigation.type === "series") {
                changeSeriesLayout(rowCol[0], rowCol[1], undefined, page);
            } else if (navigation.type === "image" || navigation.type === "frame") {
                changeImageLayout(rowCol[0], rowCol[1], undefined, page);
            }

            // Select the thumbnail
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            var seriesIndex = seriesLayout.getSeriesIndex();
            var imageIndex = seriesLayout.scrollData.imageIndex;

            dicomViewer.thumbnail.selectImageThumbnail(seriesIndex, imageIndex);
        } catch (e) {}
    }

    /**
     * Enable/Disable controls after page navigation
     * @param {Type}
     */
    function postPageNavigation(index, totalCount) {
        if (index == 0) {
            showOrHidePageNavigation("first");
        } else if (index == totalCount - 1) {
            showOrHidePageNavigation("last");
        } else {
            showOrHidePageNavigation("show");
        }
    }

    /**
     * Get parameters for performing page navigation
     */
    function getNavigationType(direction) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout === undefined || seriesLayout === null) {
            return;
        }

        var selectedStudyUid = seriesLayout.getStudyUid();
        var selectedSeriesIndex = seriesLayout.getSeriesIndex();
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(selectedStudyUid, selectedSeriesIndex);
        var seriesLayoutMaxId = isFullScreenEnabled ? dicomViewer.getCurrentSeriesLayoutIds() : dicomViewer.viewports.getSeriesLayoutMaxId();
        var seriescount = dicomViewer.Study.getSeriesCount(selectedStudyUid);
        var imagecount = dicomViewer.Series.getImageCount(selectedStudyUid, selectedSeriesIndex);
        var selectedImageIndex = seriesLayout.getImageIndex();
        var framecount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(selectedStudyUid, selectedSeriesIndex, selectedImageIndex));
        if (seriesLayoutMaxId !== undefined) {
            var rowColumnValue = seriesLayoutMaxId.split('_')[2];
            var imageLayoutDim = seriesLayout.getImageLayoutDimension();
            var studyLayoutId = getStudyLayoutId(seriesLayout.seriesLayoutId);
            var type, range, layout, totalCount;
            if (isMultiFrame) {
                if (rowColumnValue === "1x1") {
                    type = "image";
                    range = "frame";
                    layout = imageLayoutDim;
                    totalCount = framecount;
                } else {
                    type = "series";
                    range = "image";
                    layout = rowColumnValue;
                    totalCount = imagecount;
                }
            } else if (rowColumnValue === "1x1") {
                type = "image";
                range = "image";
                layout = imageLayoutDim;
                totalCount = imagecount;
                imageIndex = -1;
            } else {
                type = "series";
                range = "series";
                layout = rowColumnValue;
                totalCount = seriescount;
                imageIndex = -1;
            }
            var imageIndex = range === "frame" ? selectedImageIndex : -1;
            var navigation = {
                type: type,
                indexArrays: findIndexRange(range),
                totalCount: totalCount,
                layout: layout,
                studyLayout: studyLayoutId,
                seriesIndex: selectedSeriesIndex,
                imageIndex: imageIndex,
                isMultiFrame: isMultiFrame,
                isOrderUdpated: false
            };
            if (navigation.type === "series") {
                var index = isMultiFrame ? selectedImageIndex : selectedSeriesIndex;
                var viewportOrder = checkViewportOrder(navigation.indexArrays, navigation.indexArrays.length, index, navigation.totalCount, direction);
                navigation.indexArrays = viewportOrder.indexArrays;
                navigation.isOrderUdpated = viewportOrder.isOrderUdpated;
            }

            return navigation;
        }
    }

    /**
     * Check whether the viewports are in proper order
     * @param {Type} indexArrays 
     */
    function checkViewportOrder(indexArrays, length, selectedIndex, limit, direction) {
        var startIndex = -1;
        var endIndex = -1;
        var isOrderUdpated = false;

        var isOutOfOrder = false;
        for (var i = 0; i < indexArrays.length - 1; i++) {
            if (Math.abs(indexArrays[i + 1] - indexArrays[i]) > 1) {
                isOutOfOrder = true;
                break;
            }
        }

        if (isOutOfOrder) {
            indexArrays = [];
            if (direction === "prev") {
                startIndex = selectedIndex - length;
                endIndex = selectedIndex - 1;
                if (startIndex < 0) {
                    startIndex++;
                    endIndex++;
                }
            } else if (direction === "next") {
                startIndex = selectedIndex + 1;
                endIndex = selectedIndex + length;
                if (endIndex == limit) {
                    startIndex--;
                    endIndex--;
                }
            }
            for (startIndex; startIndex <= endIndex; startIndex++) {
                indexArrays.push(startIndex);
            }
            isOrderUdpated = true;
            return {
                indexArrays: indexArrays,
                isOrderUdpated: isOrderUdpated
            };
        }
        return {
            indexArrays: indexArrays,
            isOrderUdpated: isOrderUdpated
        };
    }



    /**
     * 
     */
    function doBrightnessContrast(e) {
        resetMenu();
        dicomViewer.measurement.setDataToDelete();
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
        $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getBrightnessContrastTool());

        // refresh image so that US regions appear
        refreshImage();
    }

    /**
     * Shows measurement properties
     * @param {Type}  
     */
    function showMeasurementProperties() {
        $("#MeasurementPropertiesModal").dialog('open');
    }

    /**
     * Shows user preferences
     * @param {Type}  
     */
    function showUserPreferences() {
        $("#content_View").find('.resp-tab-active').removeClass('resp-tab-active').css({
            'background-color': '#363636',
            'border-color': 'none'
        });
        $("#settingPreference").modal();
    }

    function printPdf(doc) {//VAI-307
        var objFra = document.createElement('iframe');// Create an IFrame.
        objFra.style.visibility = 'hidden';
        objFra.src = doc;
        document.body.appendChild(objFra);
        objFra.contentWindow.focus();
        objFra.contentWindow.print();
    }

    function buildPdfPath( imageUid )//VAI-307
    {
        var foundPath = true;
        var PdfLink = document.getElementById("pdfExportImageLnk").href;
        var i = PdfLink.indexOf("/files/pdffiles/");
        if (i <= 0)foundPath = false;
        var j = PdfLink.indexOf("_PRT.pdf");
        if (j <= 0) foundPath = false;
        if (!foundPath) {
            PdfLink = PdfRequest.findRequestPdfPath(imageUid);
            if (PdfLink == undefined) return;
       }

        var result = PdfLink.substring(i + 16, j);
        i = result.indexOf("_") + 1;
        if (i <= 0)
            return;

        result = result.substring(i);
        result = PdfLink.replace(result, imageUid);  
        document.getElementById("pdfExportImageLnk").href = result;
    }

    function printPdfDoc()//VAI-307
    {
        printPdf(document.getElementById('pdfExportImageLnk').href);
    }

    function exportPdfDoc()//VAI-307
    {
        document.getElementById('pdfExportImageLnk').click();
    }

    /**
     * 
     * Print
     */
    function doPrintLayout(isExport) {

        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        $("#PrintLayoutOptions").val(seriesLayout.imageLayoutDimension);

        var imageLayoutDimension = seriesLayout.imageLayoutDimension;
        var dimension = imageLayoutDimension.split("x");
        imageLayoutDimension = dimension[0] * dimension[1];

        var displayText;
        var isMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex);

        var count = 0
        var pdfRender;
        var pdfData;
        if (isEmbedPdfViewer(seriesLayout.imageType)) {
            pdfRender = seriesLayout.getImageRender("pdfData");
            if (pdfRender) {
                pdfData = pdfRender.pdfData;
            }
        }

        //VAI-307
        var tiffImage = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, 0); //Based on the first image frame page 0
        if (tiffImage.cacheLocator.includes("Tiff;")) {
            var isPageReady = PdfRequest.arePrintAndExportReady;
            var imagevalue = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.getImageIndex());
            if (PdfRequest.arePrintAndExportReady == true) {
                isPageReady = true;
            } else {
                if (PdfRequest.findRequestStatus(imagevalue.imageUid) == PdfRequest.Status.complete)
                    isPageReady = true;
            }

            if (isPageReady){
                var isSignature = isSignatureEnabled();
                buildPdfPath(imagevalue.imageUid);
                dicomViewer.tools.doPrintOrExport(isSignature, isExport);
                return;
            }
            return; 
        }


        if (isMultiframe) {
            var imagevalue = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.getImageIndex());

            if (imagevalue) {
                count = imagevalue.numberOfFrames;
            }
        } else {
            count = dicomViewer.Series.getImageCount(seriesLayout.studyUid, seriesLayout.seriesIndex);
        }

        count = pdfData ? pdfData.pageCount : count;
        $("#PrintImage_Range").addClass("k-state-disabled");
        document.getElementById('PrintImage_Range').readOnly = true;

        $("#printLayoutModal")[0].printRangeMax = 1;
        $("#imageRangeLabel").hide();
        if (count !== undefined && count > 1) {
            $("#printLayoutModal")[0].printRangeMax = count;
            var countStart = 1;
            if (!pdfData) {
                $("#imageRangeLabel").show();
                $("#PrintImage_Range").removeClass("k-state-disabled");
                document.getElementById('PrintImage_Range').readOnly = false;
            }
            $("#imageRangeLabel").text("[ " + countStart + " to " + (count) + " ]");
        }

        if (seriesLayout.imageType == IMAGETYPE_RADECG) {
            var imageRender = seriesLayout.getImageRender("ecgData");
            if (imageRender) {
                var imageIndex = imageRender.imageIndex;
                displayText = (displayText == undefined) ? (parseInt(imageIndex) + 1) : displayText + ", " + (parseInt(imageIndex) + 1);
            }
        } else if ($("#" + seriesLayout.seriesLayoutId)[0].isHtml) {
            displayText = 1;
        } else if (pdfData) {
            displayText = pdfData.currentPageNumber;
        } else {
            $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                var imageLayoutId = $(this).attr('id');
                var imageRender = seriesLayout.getImageRender(imageLayoutId);
                if (imageRender) {
                    var imageIndex;
                    if (isMultiframe && count > 1) {
                        var aUIDs = imageRender.anUIDs.split("*");
                        imageIndex = aUIDs[1];
                    } else {
                        imageIndex = imageRender.imageIndex;
                    }
                    displayText = (displayText == undefined) ? (parseInt(imageIndex) + 1) : displayText + ", " + (parseInt(imageIndex) + 1);
                }
            });
        }

        $('#printLayoutModal').dialog('option', 'title', (isExport ? "Export layout" : "Print layout"));
        var innerText = $("#printLayoutModalDiv")[0].innerHTML;
        var findWord = "print Options";
        var replaceStrig = "export Options";

        if (!isExport) {
            findWord = "export Options";
            replaceStrig = "print Options";
        }
        $("#printLayoutModalDiv")[0].innerHTML = innerText.replace(new RegExp(findWord, "g"), replaceStrig);
        $("#printLayoutModal").data("isExport", isExport);
        $("#PrintImage_Range").val(displayText);
        $("#printLayoutModal").dialog('open');
    }

    /**
     * Set the zool tool background color
     * @param {*} level 
     */
    function setZoomBGColor(level) {
        resetZoomTool();
        $("#" + level + "_zoom").parent().css("background", "#868696");
        if (level == 4) {
            $("#zoomInSR").css("background", "#868696");
        } else if (level == 5) {
            $("#zoomOutSR").css("background", "#868696");
        } else {
            $("#" + level + "_zoomContextMenu").css("background", "#868696");
        }
    }

    dicomViewer.tools = {
        firstTimeImageLoad: firstTimeImageLoad,
        doZoom: doZoom,
        doPan: doPan,
        do2DLengthMeasurement: do2DLengthMeasurement,
        do2DPointMeasurement: do2DPointMeasurement,
        doAngleMeasurement: doAngleMeasurement,
        do2DMeasurement: do2DMeasurement,
        doWindowLevel: doWindowLevel,
        setDicomOverLayFalse: setDicomOverLayFalse,
        showDicomHeader: showDicomHeader,
        showImageData: showImageData,
        changeImageLayout: changeImageLayout,
        changeSeriesLayout: changeSeriesLayout,
        changeStudyLayout: changeStudyLayout,
        doOverLay: doOverLay,
        doScoutLine: doScoutLine,
        revert: revert,
        rotate: rotate,
        invert: invert,
        doHorizontalFilp: doHorizontalFilp,
        doVerticalFilp: doVerticalFilp,
        changePreset: changePreset,
        moveToPreviousImage: moveToPreviousImage,
        moveToNextImage: moveToNextImage,
        runCineImage: runCineImage,
        stopCineImage: stopCineImage,
        moveSeries: moveSeries,
        setZoomLevel: setZoomLevel,
        updateWindowLevelSettings: updateWindowLevelSettings,
        isOverlayVisible: isOverlayVisible,
        isScoutLineVisible: isScoutLineVisible,
        setOverlay: setOverlay,
        chanageWhileDrag: chanageWhileDrag,
        changeStudyLayoutFromTool: changeStudyLayoutFromTool,
        updateZoomLevelSettings: updateZoomLevelSettings,
        getFlagFor2dLengthCalibration: getFlagFor2dLengthCalibration,
        lengthCalibration: lengthCalibration,
        setSelectedStudyLayout: setSelectedStudyLayout,
        reOrderExistingStudyUids: reOrderExistingStudyUids,
        getOrSetReArrangedSeriesPositions: getOrSetReArrangedSeriesPositions,
        applyWindowLevel: applyWindowLevel,
        cacheIndicator: cacheIndicator,
        rgbColor: rgbColor,
        resetRGBMenu: resetRGBMenu,
        isCaliberEnabled: isCaliberEnabled,
        setCalibrationActiveTool: setCalibrationActiveTool,
        getLengthCalibrationFlag: getLengthCalibrationFlag,
        setLengthCalibrationFlag: setLengthCalibrationFlag,
        doDefault: doDefault,
        SetMenuSelectionColor: SetMenuSelectionColor,
        doWindowLevelROI: doWindowLevelROI,
        doPrint: doPrint,
        linkSeries: linkSeries,
        doXRefLineSelection: doXRefLineSelection,
        doCopyAttributes: doCopyAttributes,
        doShowHideAnnotationAndMeasurement: doShowHideAnnotationAndMeasurement,
        isShowAnnotationandMeasurement: isShowAnnotationandMeasurement,
        doOverLay6000: doOverLay6000,
        is6000OverlayVisible: is6000OverlayVisible,
        doPrintOrExport: doPrintOrExport,
        doExport: doExport,
        doSharpen: doSharpen,
        getCursorType: getCursorType,
        doMenusratedScale: doMenusratedScale,
        isVisibleMensuratedScale: isVisibleMensuratedScale,
        movePreviousPage: movePreviousPage,
        moveNextPage: moveNextPage,
        doBrightnessContrast: doBrightnessContrast,
        showMeasurementProperties: showMeasurementProperties,
        showUserPreferences: showUserPreferences,
        resetZoomTool: resetZoomTool,
        printLayout: printLayout,
        printPdfCallback: printPdfCallback,
        setZoomBGColor: setZoomBGColor
    };

    return dicomViewer;

}(dicomViewer));
