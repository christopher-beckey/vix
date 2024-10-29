/**
 * New node file
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var CINERUN = 0;
    var CINEPAUSE = 1;
    var imageIndexNumber = 0;

    var studyLevelMap = [];

    var cineManager = {}; // Manage the cine opterations

    var previousStudyLayout = "";

    var previousSaveAndLoadToolLayout = "";

    var currentLayOutId = "";

    var fullScreenCineManager = {};
    var resizeCineManager = {};
    var repeatCineManager = {};

    var seriesLayoutMap = new Map();
    var columnSize = 1;

    var viewportHeaderWidth;

    var preferenceList = ["gridtype", "gridcolor", "leadformat", "gain", "signalthickness"];

    //contain viewport div id as key and imageCanvas as value 
    var imageCanvasOfViewPorts = {};
    var imageCanvasOfBackupViewPorts = {};
    var allViewportsTemp = undefined;
    var activeSeriesLayoutTemp = undefined;
    var currentSeriesLayoutIds = undefined;

    var viewHeight = 0;
    var activeSeriesLayout = null; //For mouse tools like ww/wc , pan and zoom

    var playStudy = false; // if it is true play whole study in cine, if false play single image set in cine
    var tempHeight = 0;
    var multiFrameImageIndex = 0;
    var selectThumbnailImageIndex = undefined;
    var actualSeriesIndex = 0;
    var isViewPortDoubleClicked = false;
    var pageView = undefined;
    var repeatSeriesIndex = -1;
    var repeatImageIndex = -1;

    function createViewport(row, column, studyLayoutId, studyUid) {
        var imageLayoutMenu = null;
        var viewportString = '<table id=table' + studyLayoutId + ' style="width:100%;height:100%;">';
        for (var i = 0; i < row; i++) {
            viewportString += '<tr style="height:' + (100 / row) + '%;">';
            var clear = "clear:both;";
            for (var int2 = 0; int2 < column; int2++) {
                viewportString += '<td style="width:' + (100 / column) + '%;height:' + (100 / row) + '%;padding-left:5px;">';
                viewportString += '<div id="imageviewer_' + studyLayoutId + "_" + (i + 1) + 'x' + (int2 + 1) + '"style="width:100%;height:100%;float:left;background-color:black;position:relative' + clear + '"  class="disableSelection" tabindex="0">';
                clear = "";
                viewportString += '</td>';
            }
            viewportString += '</tr>';
        }
        viewportString += '</table>';
        if (studyLayoutId != undefined) {
            var studyLayoutElement = $("#" + studyLayoutId);
            studyLayoutElement.empty();
            var studyInformationdiv = "studyInfo" + studyLayoutId;
            var studyUidAndDateTime = "studyUidDateTime" + studyLayoutId;
            var seriesLayoutMenu = "menuSL" + studyLayoutId;
            var imageLayoutMenu = "menuIL" + studyLayoutId;
            var saveAnnotationsButton = "saveButton_" + studyLayoutId;
            var saveAnnotationsMenu = "saveMenuSL" + studyLayoutId;
            var loadAnnotationsButton = "loadButton_" + studyLayoutId;
            var loadAnnotationsMenu = "loadMenuIL" + studyLayoutId;
            var imageLayoutDisplayId = "imageDisplay" + studyLayoutId;
            var seriesLayoutDisplayId = "seriesDisplay" + studyLayoutId;
            var tableWidth = $("#viewportTable").width();
            viewportHeaderWidth = (tableWidth / columnSize) - 215;
            var imageLevelSelectionId = "imageLevelSelection_" + studyLayoutId;
            var seriesLevelSelectionId = "seriesLevelSelection_" + studyLayoutId;
            var tableid = "table_" + studyLayoutId;
            var viewportToolbarId = "saveAndLoad_" + studyLayoutId;
            var saveId = "save_" + studyLayoutId;
            var editAndSaveId = "editAndSave_" + studyLayoutId;
            if (viewportHeaderWidth < 10) {
                viewportHeaderWidth = 10;
            }

            var studyInformation = "<table id=table" + studyInformationdiv + " style='width:99%;cursor: default;/*background:rgba(152, 153, 158, 0.59);*/'>" +
                "<tr>" +
                "<td id=" + tableid + " style ='width:" + viewportHeaderWidth + "px'>" +
                "<div id=" + studyInformationdiv + " style='color: white;padding-left: 5px;width: " + viewportHeaderWidth + "px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis'></div>" +
                "<div id=" + studyUidAndDateTime + " style='color: white;padding-left: 5px;font-size:10px;width: " + viewportHeaderWidth + "px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis'></div>" +
                "</td>" +
                "<td id=" + viewportToolbarId + " align='left' style='display:none;background: transparent;width: 65px;height:32px'></td>" +
                "<td align='right' style='width: 62px;'>" +
                "<div id=" + imageLayoutDisplayId + " style='display:none;'>" +
                "<ul id=" + imageLayoutMenu + " style='width: 60px;background: transparent; border-color: transparent;'>" +
                "<li >" +
                '<img src="images/imageLevel.png" id=' + imageLevelSelectionId + '>' +
                "<ul>" +
                "<li onclick='dicomViewer.tools.changeImageLayout(1,1," + studyLayoutId + ")'><img src='images/1x1.png'></li>" +
                "<li onclick='dicomViewer.tools.changeImageLayout(1,2," + studyLayoutId + ")'><img src='images/1x2.png'></li>" +
                "<li onclick='dicomViewer.tools.changeImageLayout(2,1," + studyLayoutId + ")'><img src='images/2x1.png'></li>" +
                "<li onclick='dicomViewer.tools.changeImageLayout(2,2," + studyLayoutId + ")'><img src='images/2x2.png'></li>" +
                "</ul>" +
                "</li>" +
                "</ul>" +
                "</div>" +
                "</td>" +
                "<td align='right' style='width: 62px;'>" +
                "<div id=" + seriesLayoutDisplayId + " style='display:none;'>" +
                "<ul id='" + seriesLayoutMenu + "'style='width: 60px;background: transparent; border-color: transparent;'>" +
                "<li>" +
                "<img src='images/2x2.png' id=" + seriesLevelSelectionId + ">" +
                "<ul>" +
                "<li id = '" + seriesLayoutDisplayId + "_1x1' onclick='dicomViewer.tools.changeSeriesLayout(1,1," + studyLayoutId + ")'><img src='images/1x1.png'></li>" +
                "<li id = '" + seriesLayoutDisplayId + "_1x2' onclick='dicomViewer.tools.changeSeriesLayout(1,2," + studyLayoutId + ")'><img src='images/1x2.png'></li>" +
                "<li id = '" + seriesLayoutDisplayId + "_2x1' onclick='dicomViewer.tools.changeSeriesLayout(2,1," + studyLayoutId + ")'><img src='images/2x1.png'></li>" +
                "<li id = '" + seriesLayoutDisplayId + "_2x2' onclick='dicomViewer.tools.changeSeriesLayout(2,2," + studyLayoutId + ")'><img src='images/2x2.png'></li>" +
                "<li id = '" + seriesLayoutDisplayId + "_custom' onclick='changeCustom(" + studyLayoutId + ")'>Custom</li>" +
                "</ul>" +
                "</li>" +
                "</ul>" +
                "</div>" +
                "</td>" +
                "<td align='right' style='width: 12px;'>" +
                "<span id='" + studyLayoutId + "_close' title='close' style='padding-right: 5px;visibility:hidden' onclick=closeStudy('" + studyLayoutId + "')><img src='images/close.png' style='width: 12px;'></span>" +
                "</td>" +
                "</tr>" +
                "</table>"

            studyLayoutElement.append(studyInformation);
            if (studyUid !== undefined) {
                document.getElementById(imageLayoutDisplayId).style.display = 'block';
                document.getElementById(seriesLayoutDisplayId).style.display = 'block';
                document.getElementById(viewportToolbarId).style.display = 'block';
            } else if (studyUid == undefined) {
                document.getElementById(viewportToolbarId).style.display = 'none';
            }
            $("#" + seriesLayoutMenu).kendoMenu();
            $("#" + imageLayoutMenu).kendoMenu();
            studyUid == undefined ? "" : ((studyUid == null) ? "" : createSaveAndLoadPStateGUI(viewportToolbarId, studyUid, studyLayoutId));

            updateToolTip($("#" + imageLayoutMenu), "Image Level Layout", "top");
            updateToolTip($("#" + seriesLayoutMenu), "Series Level Layout", "top");
            $(".k-item").css("border-color", "transparent");
            studyLayoutElement.append(viewportString);
            var heightOfStudyInfo = $("#table" + studyInformationdiv).outerHeight();
            var heightOfStudyLayout = studyLayoutElement.height();
            if (studyLayoutId === "studyViewer1x1") {
                tempHeight = heightOfStudyLayout;
            } else {
                heightOfStudyLayout = tempHeight;
                studyLayoutElement.height(tempHeight);
            }

            var width = document.getElementById(imageLevelSelectionId).clientWidth;
            var width2 = document.getElementById(seriesLevelSelectionId).clientWidth;

            if (width && width2) {
                if (width2 > 30)
                    setIconSize(width2 - 6);
                else
                    setIconSize(width2);
            }
            changeIconSize(studyLayoutId);
            viewHeight = (heightOfStudyLayout - heightOfStudyInfo);
            var evenRow = studyLayoutElement.parent().closest('tr').css('border-top-width');
            if (evenRow !== "0px") {
                viewHeight = (heightOfStudyLayout - heightOfStudyInfo) - 2;
            }

            $("#table" + studyLayoutId).height(viewHeight - 3 /*(heightOfStudyLayout-heightOfStudyInfo)-3*/ );
        } else {
            $("#viewport_View").html(viewportString);
        }
        var tableWidth = studyLayoutElement.width();
        $("#table" + studyLayoutId).width(tableWidth - 5);
        $("#menuIL" + studyLayoutId).children().addClass("k-state-disabled");
    }

    function createStudyViewport(row, column) {
        columnSize = column;
        studyLevelMap = new Array();
        $("#viewport_View").empty();
        var viewportString = '<table id="viewportTable" style="width:100%;height:100%;">';
        for (var i = 0; i < row; i++) {
            viewportString += '<tr style="height:' + (100 / row) + '%">';
            var clear = "clear:both;";
            for (var int2 = 0; int2 < column; int2++) {
                viewportString += '<td style="width:' + (100 / column) + '%;height:' + (100 / row) + '%;">';
                studyLevelMap.push('studyViewer' + (i + 1) + 'x' + (int2 + 1));
                viewportString += '<div id="studyViewer' + (i + 1) + 'x' + (int2 + 1) + '"style="width:100%;height:100%;float:left;' + clear + '"  class="disableSelection" tabindex="0"></div>';
                clear = "";
                viewportString += '</td>';
            }
            viewportString += '</tr>';
        }
        viewportString += '</table>';
        $("#viewport_View").html(viewportString);
        var tableWidth = $("#viewportTable").width();
        $("#viewportTable").height($("#viewport_View").height());
        $("#viewportTable tr:nth-child(even)").css("border-top", "2px solid black");
        $("#viewportTable td:nth-child(even)").css("border-left", "2px solid black");
        $("#viewportTable tr:nth-child(odd)").css("border-top", "2px solid black");
        $("#viewportTable td:nth-child(odd)").css("border-left", "2px solid black");
    }

    function loadStudyInNextViewport(studyUid, displaySettings) {
        var seriesIndex = 0;
        var studyUids = dicomViewer.getListOfStudyUid();
        var listOfStudy = studyUids.length - 1;
        if ((studyUid !== undefined) && (listOfStudy <= 3)) {
            var array = studyLevelMap;
            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
            if (!isMultiFrame && getimageCanvasOfViewPort("imageviewer_" + array[listOfStudy] + "_" + 1 + "x" + 1) != undefined) {
                seriesIndex = getimageCanvasOfViewPort("imageviewer_" + array[listOfStudy] + "_" + 1 + "x" + 1).seriesIndex;
                imageIndexNumber = getimageCanvasOfViewPort("imageviewer_" + array[listOfStudy] + "_" + 1 + "x" + 1).imageIndex;
            } else {
                seriesIndex = 0;
            }

            // Apply the display settings
            var seriesLayoutRows = 1;
            var seriesLayoutColumns = 1;
            if (displaySettings !== undefined) {
                seriesLayoutRows = parseInt(displaySettings.Rows);
                seriesLayoutColumns = parseInt(displaySettings.Columns);
            }

            setSeriesLayout(studyUid, seriesLayoutRows, seriesLayoutColumns, seriesIndex,
                undefined, array[listOfStudy], undefined, true);
        }
    }

    function refreshStudyLayout() {
        var seriesIndex = 0;
        var row = 1;
        var column = 1;
        var studyUids = dicomViewer.getListOfStudyUid();
        var array = studyUids.length;
        if (studyUids !== undefined) {
            if (array === 2) column = 2;
            if (array === 3) row = 2;

            createStudyViewport(row, column);
            for (var index = 0; index < array; index++) {
                var studyUid = studyUids[index];
                var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
                if (!isMultiFrame && getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1) != undefined) {
                    seriesIndex = getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1).seriesIndex;
                    imageIndexNumber = getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1).imageIndex;
                } else {
                    seriesIndex = 0;
                }
                setSeriesLayout(studyUid, 1, 1, seriesIndex, undefined, studyLevelMap[index], undefined);
            }
        }
    }

    function setStudyLayout(row, column, selectedStudyUid, seriesIndex, isBackup, isResize, displaySettings, isFullScreenResize) {
        seriesIndex = (seriesIndex ? seriesIndex : 0);
        row = (row ? row : 1);
        column = (column ? column : 1);

        // Create viewport
        createStudyViewport(row, column);

        var array = studyLevelMap;
        var studyUids = dicomViewer.getListOfStudyUid(isResize);
        for (var index = 0; index < array.length; index++) {
            var studyUid = undefined;
            if (selectedStudyUid && array.length == 1) {
                studyUid = selectedStudyUid;
            } else {
                studyUid = studyUids[index];
            }

            // get and set the series layout settings by study
            var seriesLayout = {
                Rows: 1,
                Columns: 1
            };
            if (displaySettings) {
                if (Object.prototype.toString.call(displaySettings) == '[object Array]') {
                    var studyDisplaySettings = displaySettings.filter(function (o) {
                        return o.studyUid === studyUid;
                    })[0];
                    if (studyDisplaySettings) {
                        seriesLayout.Rows = parseInt(studyDisplaySettings.Rows);
                        seriesLayout.Columns = parseInt(studyDisplaySettings.Columns);
                    }
                } else {
                    seriesLayout.Rows = parseInt(displaySettings.Rows);
                    seriesLayout.Columns = parseInt(displaySettings.Columns);
                }
            }

            seriesLayout = getOrUpdateSeriesLayout(studyUid, seriesLayout.Rows, seriesLayout.Columns, false);

            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
            if (!isMultiFrame && getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1) != undefined) {
                seriesIndex = getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1).seriesIndex;
                imageIndexNumber = getimageCanvasOfViewPort("imageviewer_" + array[index] + "_" + 1 + "x" + 1).imageIndex;
            } else {
                seriesIndex = seriesIndex ? seriesIndex :  0;
            }

            if (studyUid === undefined) {
                setSeriesLayout(studyUid, 1, 1, seriesIndex, isBackup, array[index], isResize, false);
            } else {
                setSeriesLayout(studyUid, seriesLayout.Rows, seriesLayout.Columns, seriesIndex, isBackup, array[index], isResize, false, undefined, isFullScreenResize);
            }
        }

        // Remove the duplicate view ports
        RemoveDuplicateViewports();
    }

    /**
     * Remove the duplicate view ports
     */
    function RemoveDuplicateViewports() {
        try {
            if (isFullScreenEnabled == true) {
                return;
            }

            var allViewports = dicomViewer.viewports.getAllViewports();
            if (allViewports === null || allViewports === undefined) {
                return;
            }

            // Parse the view ports
            $.each(allViewports, function (key, value) {
                if (value.studyUid !== undefined) {
                    // Remove the view port
                    var studyViewportId = getStudyLayoutId(value.seriesLayoutId);
                    if (studyLevelMap.indexOf(studyViewportId) == -1) {
                        dicomViewer.viewports.removeViewportsByStudyLayout(studyViewportId);
                        dicomViewer.removeimageCanvasOfAllViewPorts(studyViewportId);
                    }
                }
            });
        } catch (e) {}
    }

    /**
     * Check whether the study is in full screen mode
     */
    function IsFullScreenMode() {
        var currentStudyLayout = studyLayoutValue.split("x");
        var rows = currentStudyLayout[0];
        var columns = currentStudyLayout[1];
        if ((parseInt(rows) == 1 && parseInt(columns) == 1) || isFullScreenEnabled) {
            return true;
        }

        return false;
    }

    /**
     * Get or update the series layout for the study
     * @param {Type} studyUid - Study Uid
     * @param {Type} rows - Rows
     * @param {Type} columns - Columns
     * @param {Type} isUpdate - Update or Get flag
     */
    function getOrUpdateSeriesLayout(studyUid, rows, columns, isUpdate) {
        // Maintain the default values
        var layout = {
            Rows: rows,
            Columns: columns
        };

        try {
            if ((studyUid === undefined && !isUpdate) || isFullScreenEnabled) {
                return layout;
            }

            // Remove the key
            if (isUpdate) {
                if (seriesLayoutMap.has(studyUid)) {
                    layout = seriesLayoutMap.get(studyUid);
                    layout.Rows = rows;
                    layout.Columns = columns;
                } else {
                    // Set the layout
                    if (studyUid != undefined) {
                        seriesLayoutMap.set(studyUid, layout);
                    }
                }

                return layout;
            }

            // Get the layout
            layout = seriesLayoutMap.get(studyUid);
            if (layout === undefined) {
                layout = {
                    Rows: rows,
                    Columns: columns
                };

                // Set the layout 
                seriesLayoutMap.set(studyUid, layout);
            }

            return layout;
        } catch (e) {}

        return layout;
    }

    /**
     * Cheking whether the given study is multi-modality or not.
     * @param {Type} studyUid - Study Uid
     * @param {Type} seriesIndex - new series index
     */
    function isMixedModality(studyUid, seriesIndex) {
        var activeSeriesIndex = dicomViewer.getActiveSeriesLayout().seriesIndex;
        if (activeSeriesIndex !== undefined) {
            var activeModality = dicomViewer.Series.getModality(studyUid, activeSeriesIndex);
            var newModality = dicomViewer.Series.getSeries(studyUid, seriesIndex).modality;
            if (activeModality !== newModality) {
                return true;
            }
        }
        return false;
    }

    /* Load the dicom images in viewports*/
    function setSeriesLayout(studyUid, row, column, seriesIndexValue,
        isBackup, studyViewportId, isResize, isSeriesLayoutUpdationRequired, isThumbnailClick, isFullScreenResize) {
        if (row === undefined || column === undefined) {
            row = 1;
            column = 1;
        }
        var backupLayoutId = "";
        if (isResize === undefined || isResize === false) {
            if (isBackup === undefined || isBackup === null) {

                // Update the series layout
                if (isSeriesLayoutUpdationRequired == true) {
                    getOrUpdateSeriesLayout(studyUid, row, column, false);
                } else if (isSeriesLayoutUpdationRequired === undefined) {
                    getOrUpdateSeriesLayout(studyUid, row, column, true);
                }

                var viewports = dicomViewer.viewports.getAllViewports();
                for (var key in viewports) {
                    if (dicomViewer.getimageCanvasOfViewPort(key) !== undefined) {
                        var canvasTemp = Object.create(dicomViewer.getimageCanvasOfViewPort(key));
                        dicomViewer.setimageCanvasOfBackupViewPort(key, canvasTemp);
                    }
                }

                for (var key in cineManager) {
                    var studyLayoutId = key.split("_")[1];
                    if (studyViewportId == studyLayoutId) {
                        resizeCineManager[key] = JSON.parse(JSON.stringify(cineManager[key]));
                        clearInterval(cineManager[key].timer);
                        delete cineManager[key];
                    }
                }

                if (pageView !== undefined && pageView !== null) {
                    dicomViewer.viewports.getBackupImageLayouts(studyViewportId, row, column);
                }

                dicomViewer.viewports.backupViewableViewportsBySeriesIndex(studyViewportId);
                dicomViewer.viewports.removeViewportsByStudyLayout(studyViewportId);
                dicomViewer.removeimageCanvasOfAllViewPorts(studyViewportId);
                dicomViewer.viewports.addSeriesLayoutMaxId("imageviewer_" + studyViewportId + "_" + row + "x" + column, studyViewportId);
                dicomViewer.measurement.setMeasurementBroken(false);
            }
        } else if (dicomViewer.getActiveSeriesLayout() !== null && dicomViewer.getActiveSeriesLayout() !== undefined) {
            backupLayoutId = dicomViewer.getActiveSeriesLayout().getSeriesLayoutId();
        }

        createViewport(row, column, studyViewportId, studyUid);

        var seriesIndex = 0;
        if (seriesIndexValue != undefined) {
            seriesIndex = seriesIndexValue;
        }
        var imageIndex = 0;
        var frameIndex = 0;
        var imageLayout = "";
        var layoutId = "";
        var duplicateSeriesIndex = 0;
        if (isResize === undefined || isResize === false) {
            if (studyUid !== undefined) {
                if (seriesIndexValue === undefined) {
                    if (dicomViewer.getActiveSeriesLayout() != undefined) {
                        seriesIndex = dicomViewer.getActiveSeriesLayout().getSeriesIndex();
                        imageIndex = dicomViewer.getActiveSeriesLayout().getImageIndex();
                    }
                    if (seriesIndex === undefined) seriesIndex = 0;
                    if (imageIndex === undefined) imageIndex = 0;
                } else {
                    seriesIndex = seriesIndexValue;
                    if (dicomViewer.getActiveSeriesLayout() === undefined || dicomViewer.getActiveSeriesLayout() === null) {
                        imageIndex = 0;
                    } else {
                        //While changing the series layout, if any mixed modality(multiframe should be there) then getting the image index from the global common variable
                        if (isMixedModality(studyUid, seriesIndex)) {
                            imageIndex = multiFrameImageIndex;
                        } else {
                            imageIndex = dicomViewer.getActiveSeriesLayout().getImageIndex();
                        }
                        if (imageIndex === undefined) imageIndex = 0;
                        if (studyUid !== undefined) {
                            var imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                            if (!dicomViewer.thumbnail.isImageThumbnail(imageValue)) {
                                imageIndex = 0;
                            }
                        }
                    }
                }
            }

            if (pageView !== undefined && pageView !== null) {
                if (pageView.type === "series") {
                    if (pageView.isMultiFrame) {
                        seriesIndex = pageView.seriesIndex;
                        imageIndex = pageView.first;
                    } else {
                        seriesIndex = pageView.first;
                        imageIndex = 0;
                    }

                } else if (pageView.type === "image") {
                    seriesIndex = pageView.seriesIndex;
                    imageIndex = pageView.first;
                }
            } else if (actualSeriesIndex == imageIndex) {
                /* assign multiFrameImageIndex value to imageIndex to provide the
                starting point when changing the layout */
                imageIndex = multiFrameImageIndex;
            }

            currentSeriesLayoutIds = "imageviewer_" + studyViewportId + "_" + row + "x" + column;
            if (isBackup !== undefined && isBackup !== null && studyUid !== undefined) {
                layoutId = "imageviewer_" + studyViewportId + "_" + (1) + "x" + (1);
                if (isBackup === true && isFullScreenResize !== true) {
                    currentLayOutId = getActiveSeriesLayout().getSeriesLayoutId();
                    if (currentLayOutId !== layoutId) {
                        viewport = dicomViewer.viewports.getViewport(layoutId).copy();
                        if (viewport !== undefined) {
                            dicomViewer.viewports.removeViewport(layoutId)
                            dicomViewer.viewports.addBackupViewport(layoutId, viewport.copy());

                            viewport = dicomViewer.viewports.getViewport(currentLayOutId).copy();
                            dicomViewer.viewports.removeViewport(currentLayOutId)
                            dicomViewer.viewports.addBackupViewport(currentLayOutId, viewport.copy());
                            viewport.seriesLayoutId = layoutId;
                            dicomViewer.viewports.addViewport(layoutId, viewport);

                            var tmpCanvas = dicomViewer.getimageCanvasOfViewPort(layoutId);
                            if (tmpCanvas !== undefined) {
                                var canvasTemp = Object.create(tmpCanvas);
                                dicomViewer.setimageCanvasOfBackupViewPort(layoutId, canvasTemp);
                                dicomViewer.removeimageCanvasOfViewPort(layoutId);
                            }
                            tmpCanvas = dicomViewer.getimageCanvasOfViewPort(currentLayOutId);
                            if (tmpCanvas !== undefined) {
                                var canvasTemp = Object.create(tmpCanvas);
                                dicomViewer.setimageCanvasOfBackupViewPort(currentLayOutId, canvasTemp);
                                dicomViewer.setimageCanvasOfViewPort(layoutId, Object.create(canvasTemp));
                                dicomViewer.removeimageCanvasOfViewPort(currentLayOutId);
                            }

                            if (cineManager[layoutId] !== undefined) {
                                fullScreenCineManager[layoutId] = JSON.parse(JSON.stringify(cineManager[layoutId]));
                                clearInterval(cineManager[layoutId].timer);
                                delete cineManager[layoutId];
                            }
                            if (cineManager[currentLayOutId] !== undefined) {
                                cineManager[layoutId] = JSON.parse(JSON.stringify(cineManager[currentLayOutId]));
                                clearInterval(cineManager[layoutId].timer);
                                delete cineManager[currentLayOutId];
                            }
                        }
                    }
                } else if (currentLayOutId !== layoutId && isFullScreenResize !== true) {
                    var backupviewport = dicomViewer.viewports.getViewport(layoutId).copy();
                    if (backupviewport !== undefined && currentLayOutId !== "imageviewer_studyViewer1x1_1x1" && currentLayOutId !== "") {
                        backupviewport.updateImageRendersTo(backupviewport.seriesLayoutId, currentLayOutId);
                        backupviewport.seriesLayoutId = currentLayOutId;
                        dicomViewer.viewports.addViewport(currentLayOutId, backupviewport.copy());
                        dicomViewer.viewports.removeBackupViewport(currentLayOutId);

                        backupviewport = dicomViewer.viewports.getBackupViewport(layoutId);
                        if (backupviewport !== undefined) {
                            dicomViewer.viewports.addViewport(layoutId, backupviewport.copy());
                            dicomViewer.viewports.removeBackupViewport(layoutId);
                        } else {
                            backupviewport = dicomViewer.viewports.getViewport(layoutId).copy();
                            dicomViewer.viewports.addViewport(layoutId, backupviewport.copy());
                            dicomViewer.viewports.removeBackupViewport(layoutId);
                        }
                        dicomViewer.viewports.addViewport(layoutId, backupviewport.copy());
                        dicomViewer.viewports.removeBackupViewport(layoutId);

                        var tmpCanvas = dicomViewer.getimageCanvasOfViewPort(layoutId);
                        if (tmpCanvas !== undefined) {
                            var canvasTemp = Object.create(tmpCanvas);
                            dicomViewer.removeimageCanvasOfBackupViewPort(currentLayOutId);
                            dicomViewer.setimageCanvasOfViewPort(currentLayOutId, canvasTemp);
                        }
                        tmpCanvas = dicomViewer.getimageCanvasOfBackupViewPort(layoutId);
                        if (tmpCanvas !== undefined) {
                            var canvasTemp = Object.create(tmpCanvas);
                            dicomViewer.removeimageCanvasOfBackupViewPort(layoutId);
                            dicomViewer.setimageCanvasOfViewPort(layoutId, canvasTemp);
                        }

                        if (cineManager[layoutId] !== undefined) {
                            cineManager[currentLayOutId] = JSON.parse(JSON.stringify(cineManager[layoutId]));
                            if (studyLayoutValue !== "1x1" && currentLayOutId !== undefined && currentLayOutId !== "") {
                                if (cineManager[currentLayOutId] !== undefined) {
                                    if (cineManager[currentLayOutId].playStudy !== undefined) {
                                        repeatCineManager[currentLayOutId] = JSON.parse(JSON.stringify(cineManager[currentLayOutId]));
                                    }
                                }
                            }
                        } else {
                            delete cineManager[currentLayOutId];
                        }
                        delete cineManager[layoutId];

                        if (fullScreenCineManager[layoutId] !== undefined) {
                            cineManager[layoutId] = JSON.parse(JSON.stringify(fullScreenCineManager[layoutId]));
                        } else {
                            delete cineManager[layoutId];
                        }
                        delete fullScreenCineManager[currentLayOutId];
                        delete fullScreenCineManager[layoutId];
                        backupLayoutId = currentLayOutId;
                        currentLayOutId = "";
                    }
                } else if (currentLayOutId == layoutId && isFullScreenResize !== true) {
                    if (cineManager[layoutId] !== undefined) {
                        cineManager[currentLayOutId] = JSON.parse(JSON.stringify(cineManager[layoutId]));
                        if (studyLayoutValue !== "1x1" && currentLayOutId !== undefined && currentLayOutId !== "") {
                            if (cineManager[currentLayOutId] !== undefined) {
                                if (cineManager[currentLayOutId].playStudy !== undefined) {
                                    repeatCineManager[currentLayOutId] = JSON.parse(JSON.stringify(cineManager[currentLayOutId]));
                                }
                            }
                        }
                    }
                }
            }
        }
        var viewportProperty = undefined;
        var pageViewportIndex = 0;
        for (var i = 0; i < row; i++) {
            for (var int2 = 0; int2 < column; int2++) {
                layoutId = "imageviewer_" + studyViewportId + "_" + (i + 1) + "x" + (int2 + 1);
                var imageLayoutDimension = undefined;
                if (isThumbnailClick) {
                    viewportProperty = dicomViewer.thumbnail.getViewportProperty(layoutId);
                    if (viewportProperty != null) {
                        seriesIndex = viewportProperty.split("|")[1];
                        imageIndex = viewportProperty.split("|")[2];
                        frameIndex = viewportProperty.split("|")[3];
                        imageLayoutDimension = viewportProperty.split("|")[4];
                    } else {
                        isThumbnailClick = false;
                    }
                }
                var imageValue = undefined;
                if (duplicateSeriesIndex == 0) {
                    imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                }


                if (backupLayoutId === "") backupLayoutId = layoutId;
                var viewport = dicomViewer.viewports.getViewport(layoutId);
                if (viewport !== undefined && viewport !== null) {
                    if (viewport.studyUid === undefined && studyViewportId !== undefined) {
                        var imageLayoutDisplayId = "imageDisplay" + studyViewportId;
                        document.getElementById(imageLayoutDisplayId).style.display = 'none';

                        var viewportToolbarId = "SaveAndLoad_" + studyViewportId;
                        if (document.getElementById(viewportToolbarId) !== null && document.getElementById(viewportToolbarId) !== undefined) {
                            document.getElementById(viewportToolbarId).style.display = 'none';
                        }
                    }
                }

                if (imageValue !== undefined && viewport === undefined || viewport === null) {
                    var isImageThumbnail = dicomViewer.thumbnail.isImageThumbnail(imageValue);
                    if (isImageThumbnail) {
                        viewport = dicomViewer.viewports.getBackupViewportBySeriesIndex(studyUid + "_" + imageIndex);
                        dicomViewer.viewports.removeBackupViewportBySeriesIndex(studyUid + "_" + imageIndex);
                    } else {
                        viewport = dicomViewer.viewports.getBackupViewportBySeriesIndex(studyUid + "_" + seriesIndex);
                        dicomViewer.viewports.removeBackupViewportBySeriesIndex(studyUid + "_" + seriesIndex);
                    }
                    if (viewport !== undefined && viewport !== null) {
                        if (dicomViewer.getimageCanvasOfBackupViewPort(viewport.seriesLayoutId) != undefined) {
                            canvasTemp = Object.create(dicomViewer.getimageCanvasOfBackupViewPort(viewport.seriesLayoutId));
                            dicomViewer.removeimageCanvasOfBackupViewPort(viewport.seriesLayoutId);
                            dicomViewer.setimageCanvasOfViewPort(layoutId, canvasTemp);
                        }
                        if (resizeCineManager[viewport.seriesLayoutId] !== undefined)
                            cineManager[layoutId] = JSON.parse(JSON.stringify(resizeCineManager[viewport.seriesLayoutId]));
                        viewport.seriesLayoutId = layoutId;
                        dicomViewer.viewports.addViewport(viewport.seriesLayoutId, viewport);
                    }
                }

                if (imageValue == undefined && (viewport == undefined || viewport == null) && studyUid != undefined) {
                    var layout = dicomViewer.viewports.getDuplicateViewportByIndex(duplicateSeriesIndex, layoutId.split('_')[1]);
                    if (layout != undefined && layout != null) {
                        seriesIndex = layout.getSeriesIndex();
                        imageIndex = layout.getImageIndex();
                        frameIndex = layout.getFrameIndex();
                        imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                    }
                    duplicateSeriesIndex++;
                }

                if (viewport != undefined && viewport != null && pageView != null && pageView != undefined && isBackup === null) {
                    viewport.setImageLayoutDimension(dicomViewer.viewports.getViewportImageLayout(viewport.seriesIndex, pageViewportIndex++));
                }

                if (viewport === undefined || viewport === null) {
                    viewport = new SeriesLevelLayout(layoutId);
                    viewport.setStudyUid(studyUid);
                    viewport.seriesLayoutId = layoutId;
                    if (imageValue !== undefined) {
                        viewport.setSeriesIndex(seriesIndex);
                        viewport.setImageIndex(imageIndex);
                        viewport.setFrameIndex(frameIndex);
                    } else {
                        viewport.setSeriesIndex(undefined);
                        viewport.setImageIndex(undefined);
                        viewport.setFrameIndex(undefined);
                    }
                    var imageLayout = "1x1";
                    if (viewport != undefined && viewport != null && pageView != null && pageView != undefined && isBackup === null) {
                        imageLayout = dicomViewer.viewports.getViewportImageLayout(seriesIndex, pageViewportIndex++);
                    }

                    viewport.setImageLayoutDimension(imageLayout);
                    dicomViewer.viewports.addViewport(viewport.seriesLayoutId, viewport);
                }
                if (isThumbnailClick) {
                    viewport.imageLayoutDimension = imageLayoutDimension;
                }
                imageLayout = viewport.getImageLayoutDimension().split("x");
                // Initialize the ECG preference details.
                var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
                var preferenceInfo;
                if (activeSeriesLayout && activeSeriesLayout.preferenceInfo) {
                    preferenceInfo = activeSeriesLayout.preferenceInfo;
                } else {
                    preferenceInfo = new PreferenceInfo();
                    preferenceInfo.init();
                }

                viewport.setPreferenceInfo(preferenceInfo);
                ApplyDisplaySettings(studyUid, preferenceInfo, seriesIndex);
                var isSeriesHasMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
                if (isSeriesHasMultiFrame == true) {
                    setImageLevelLayout(studyUid, parseInt(imageLayout[0]), parseInt(imageLayout[1]), layoutId, viewport, viewport.seriesIndex, viewport.scrollData.imageIndex, viewport.scrollData.frameIndex, true);
                } else {
                    setImageLevelLayout(studyUid, parseInt(imageLayout[0]), parseInt(imageLayout[1]), layoutId, viewport, viewport.seriesIndex, 0, viewport.scrollData.frameIndex, true);
                }
                if (imageValue !== undefined) {
                    $("#" + layoutId).mousedown(selectViewport);
                    $("#" + layoutId).mouseover(focusActiveLayout);
                    $("#" + layoutId).keydown(keyToMoveNextOrPreviousImage);
                }
                $("#" + layoutId).bind('mousewheel DOMMouseScroll', scroll);
                $("#" + layoutId).on("dragover", allowDrop);
                $("#" + layoutId).on("drop", seriesDrop);
                $("#" + layoutId).click(selectViewport);
                if (studyUid !== undefined && imageValue !== undefined) {
                    seriesIndex = viewport.getSeriesIndex();
                    imageIndex = viewport.getImageIndex();
                    frameIndex = viewport.getFrameIndex();
                    if (studyUid !== undefined && seriesIndex !== undefined && imageIndex !== undefined) {
                        var imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                        if ((dicomViewer.thumbnail.isImageThumbnail(imageValue) ||
                                dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex)) && imageCount >= 1) {
                            var frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex));
                            viewport.progressbar.updateImagePosition(frameCount, frameIndex);
                            frameIndex = 0;
                            if (imageIndex < imageCount - 1 || isSeriesHasMultiFrame) {
                                imageIndex++;
                            } else {
                                //If it is the last image of the series then moving to the next series with first image
                                imageIndex = 0;
                                seriesIndex++;
                            }
                        } else {
                            viewport.progressbar.updateImagePosition(imageCount, imageIndex);
                            imageIndex = 0;
                            frameIndex = 0;
                            seriesIndex++;
                        }
                    }

                    if (duplicateSeriesIndex > 0) {
                        seriesIndex = dicomViewer.Study.getSeriesCount(studyUid) + duplicateSeriesIndex;
                    }
                }

            }
        }

        if (pageView != undefined && pageView != null && isBackup === null) {
            dicomViewer.viewports.deleteViewportImageLayouts();
        }

        if (isBackup === undefined || isBackup === null) {
            dicomViewer.removeimageCanvasOfAllBackupViewPorts(studyViewportId);
            for (var key in resizeCineManager) {
                var studyLayoutId = key.split("_")[1];
                if (studyViewportId == studyLayoutId) {
                    delete resizeCineManager[key];
                }
            }
            dicomViewer.viewports.removeAllBackupViewportBySeriesIndex(studyViewportId);
        }
        if (isBackup === undefined || isBackup === null || isBackup === false) {
            for (var layoutId in cineManager) {
                var studyLayoutId = layoutId.split("_")[1];
                if (cineManager[layoutId] !== undefined && studyViewportId == studyLayoutId) {
                    if (cineManager[layoutId].timer == null) {
                        updatePlayIcon("stop.png", "play.png");
                    } else {
                        var parentElement = $("#playBackward").parent().css("background", "");
                        var parentElement = $("#playForward").parent().css("background", "#868696");
                        $("#" + layoutId).trigger("click");
                        updatePlayIcon("play.png", "stop.png");
                        if (isCineEnabled()) {
                            var obj = {};
                            obj.id = "playButton"
                            var seriesLayout = dicomViewer.viewports.getViewport(layoutId);
                            if (cineManager[layoutId].playStudy == true) {
                                seriesLayout.seriesIndex = 0;
                                seriesLayout.scrollData.imageIndex = 0;
                            }

                            dicomViewer.setActiveSeriesLayout(seriesLayout);
                            updatePlayIcon("stop.png", "play.png");
                            playCineImage(obj, undefined);
                        }
                    }
                }
            }
            $("#" + backupLayoutId).trigger("click");

        } else {

            if (cineManager[layoutId] !== undefined) {
                if (cineManager[layoutId].timer == null) {
                    updatePlayIcon("stop.png", "play.png");
                } else {
                    var parentElement = $("#playBackward").parent().css("background", "");
                    var parentElement = $("#playForward").parent().css("background", "#868696");
                    $("#" + layoutId).trigger("click");
                    updatePlayIcon("play.png", "stop.png");
                    if (isCineEnabled()) {
                        var obj = {};
                        obj.id = "playButton"
                        playCineImage(obj);
                        playCineImage(obj);
                    }
                }
            }
            changeSelection(layoutId);
        }
        autoCinePlay();
    }

    function focusActiveLayout(event) {
        $("#" + getActiveSeriesLayout().seriesLayoutId).focus();
    }

    /**
     * To create the custom/embed pdf viewer
     * @param {Type} image - To specifies the image info
     * @param {Type} viewport - To specifies the viewport details
     * @param {Type} render - To specifies the image render
     * @param {Type} seriesLevelDiv - To specifies the series layout Div ID
     */
    function createPDFRender(image, viewport, renderer, seriesLevelDiv) {
        var urlParameters = dicomViewer.getPdfFrameUrl(image.imageUid);
        if (urlParameters.FrameNumber !== undefined) {
            urlParameters.FrameNumber = undefined;
        }

        var isPdfViewer = isEmbedPdfViewer(image.imageType) ? false : true;
        var pdfData = isPdfViewer ? "pdf" : "pdfData";
        var url = dicomViewer.url.getDicomImageURL(urlParameters);
        viewport.addImageRender(pdfData, renderer);

        if (isPdfViewer) {
            var pdfUrl = "pdfviewer1x1";
            var pdfDiv = "<div id='pdf' style='height:100%;width:100%'><iframe id='pdfviewer1x1' name='pdfviewer1x1' style='height:100%;width:100%' src=" + url + " onload='this.focus()'/></div>"
            $("#" + seriesLevelDiv).empty();
            $("#" + seriesLevelDiv).append(pdfDiv);
            $("#" + pdfUrl).bind('mousewheel DOMMouseScroll', scroll);
            $("#" + pdfUrl).mousedown(selectViewport);
            $("#" + pdfUrl).mouseover(focusActiveLayout);
            $("#" + pdfUrl).keydown(keyToMoveNextOrPreviousImage);

            $("#" + pdfUrl).on("dragover", allowDrop);
            $("#" + pdfUrl).on("drop", seriesDrop);
            $("#" + pdfUrl).click(selectViewport);
            bringToFrontPdf(seriesLevelDiv, viewport.imageType);
        } else {
            dicomViewer.createPDF(url, seriesLevelDiv);
        }
    }

    function setImageLevelLayout(studyUid, row, column, seriesLevelDiv, viewport, seriesIndex, imageIndex, frameIndex, isMoveSeries) {
        var isSingleFrameUS = false;
        if (studyUid !== undefined && seriesIndex !== undefined && isMoveSeries == true) {
            // set the row and column for series, when image count as 1
            var imageCount = 0;
            var frameCount = 0;
            imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
            frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex));
            imageCount = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex) ? frameCount : imageCount;

            if (imageCount == 1) {
                row = 1;
                column = 1;
                isSingleFrameUS = true;
            }
        }

        $("#" + seriesLevelDiv).empty();
        var imageLevelName = seriesLevelDiv + "ImageLevel";
        var appendString = "<table style='width:100%;height:99%;'>";
        for (var i = 0; i < row; i++) {
            appendString += "<tr style='height:" + (100 / row) + "%;'>";
            for (var j = 0; j < column; j++) {
                var tableDataId = imageLevelName + i + "x" + j + "id";
                appendString += "<td id=" + tableDataId + " style='width:" + ((100 / column)) + "%;height:" + ((100 / row)) + "%;'>";
                appendString = appendString + "<div id=" + imageLevelName + i + "x" + j + " style='height:98%;width:99%;'></div>";
                appendString += "</td>";
            }
            appendString += "</tr>";
        }
        appendString += "</table>";
        $("#" + seriesLevelDiv).html(appendString);
        $("#" + seriesLevelDiv).addClass('default-view');
        var defaultImageLayoutId = imageLevelName + "0x0";
        $("#" + defaultImageLayoutId + "id").removeClass('default-view');
        updateSpinnerLocation(seriesLevelDiv);

        var progressbar = new ViewportProgreeBar(seriesLevelDiv);
        dicomViewer.cacheIndicator.addCacheIndicator(progressbar);
        viewport.setProgressbar(progressbar);
        dicomViewer.progress.setSpinnerData(progressbar);
        if (studyUid === undefined) return;
        if (seriesIndex === undefined) return;
        var imageSeries = dicomViewer.Series.getSeries(studyUid, seriesIndex);
        //check the series is available based on series index if not available it ill return
        if (imageSeries == undefined) {
            return;
        }
        var spinner = dicomViewer.progress.createAndGetSpinner(seriesLevelDiv);
        dicomViewer.progress.putSpinner(seriesLevelDiv, spinner);

        //For storing the presentation values of the altered image(es)
        var updatedCanvasPresentation = undefined;
        var isPresentationUpdationRequired = true;
        if (row === 1 && column === 1) {
            var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
            var anUIDs = dicomViewer.Series.Image.getImageUid(image) + "*" + (frameIndex++)
            var defaultImageLayoutId = imageLevelName + "0x0";
            $("#" + defaultImageLayoutId + "id").removeClass('default-view');
            var renderer = undefined;
            renderer = viewport.getImageRender(viewport.seriesLayoutId + "ImageLevel0x0");

            //checking the availabilty for the rendered image as well as its presentation values, if the rendered image is altered then only fetch and store its presentation values
            if ((renderer != null || renderer != undefined) && renderer.presentationState != undefined) {
                if (isPresentationUpdationRequired) {
                    updatedCanvasPresentation = renderer.presentationState;
                    updatedCanvasPresentation.zoom = renderer.scaleValue;
                    isPresentationUpdationRequired = false;
                }
            }
            renderer = new ImageRenderer(defaultImageLayoutId, seriesLevelDiv);
            renderer.init(anUIDs, seriesIndex, imageIndex);

            if (image.modality === "US" && !isSingleFrameUS)
                viewport.setImageType(IMAGETYPE_RADECHO);
            else
                viewport.setImageType(image.imageType);
            if (image.imageType == IMAGETYPE_RAD || image.imageType == IMAGETYPE_RADECHO || image.imageType === IMAGETYPE_JPEG) {
                viewport.addImageRender(defaultImageLayoutId, renderer);

            }
            var imageUid = dicomViewer.Series.Image.getImageUid(image);
            var header = dicomViewer.header.getDicomHeader(imageUid);
            var imagePromise = undefined;

            if (header) {
                var imageType = image.imageType;
                if (imageType == IMAGETYPE_RADECHO || imageType == IMAGETYPE_RAD || image.imageType === IMAGETYPE_JPEG) {
                    disableOrEnableDicomTools(false);

                    if (image.modality == "CT") {
                        updateKendoArrowButton($("#winL_wrapper"), false);
                    }
                    imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + (frameIndex - 1));
                    if (imagePromise === undefined) {
                        var requestData = {
                            studyUid: studyUid,
                            seriesIndex: seriesIndex,
                            imageIndex: imageIndex,
                            frameIndex: frameIndex - 1,
                            imageUid: imageUid,
                            imageType: imageType,
                            layoutId: viewport.seriesLayoutId
                        };
                        imagePromise = dicomViewer.getImage(requestData);
                    }
                    var imageCanvas = null;
                    imagePromise.then(function (image) {
                        imageCanvas = image;
                    });

                    //On first time when the viewer is rendering the image, updatedCanvasPresentation will be undefined
                    if (updatedCanvasPresentation != null && updatedCanvasPresentation != undefined) {
                        if (imageCanvas != null && imageCanvas != undefined) {
                            if (imageCanvas.presentation.presentationMode == "MAGNIFY") {
                                updatedCanvasPresentation.presentationMode = "MAGNIFY";
                            }

                            imageCanvas.presentation = updatedCanvasPresentation;
                        }
                    }
                    //get the imageCanvas value based on the viewport id
                    var imageCanvasValue = imageCanvasOfViewPorts[seriesLevelDiv];
                    /* selected thumbnail image shoud have imageCanvasValue
                    other images we are doing indefined for imageCanvasValue to avoid
                    the duplication in the view port*/
                    if (selectThumbnailImageIndex !== undefined && selectThumbnailImageIndex != imageIndex) {
                        imageCanvasValue = undefined;
                    }
                    /*when the imageCanvasValue is undefines or already added imageCanvas is not equal to current imageaCanvas(identify using image id) we are adding the new imageCanvas to the object(view port div id as key and imageCanvas as value)*/
                    if (imageCanvasValue == undefined && imageCanvas !== null) {
                        /*Adding the new imageCanvas value to object based on viewport id as key*/
                        imageCanvas.seriesIndex = seriesIndex;
                        imageCanvas.imageIndex = imageIndex;
                        setimageCanvasOfViewPort(seriesLevelDiv, imageCanvas);
                        renderer.loadImageRenderer(imagePromise, imageCanvas, studyUid);
                        renderer.presentationState.windowLevel = imageCanvas.lastAppliedWindowLevel;
                    } else {
                        if (imageCanvasValue != undefined && imageCanvas != null) {
                            /*imageCanvas is alreday avilable in same image of same viewport if image id present in the imageCanvasValue is not maching with the image we are updating the image promised based on selcted user image
                    when drag the image thumbnail we can maintain the current image of the series on viewport*/
                            if (imageCanvasValue.imageUid != image.imageUid || imageCanvas.frameNumber != imageCanvasValue.frameNumber) {
                                var imagePromiseVal = dicomViewer.imageCache.getImagePromise(imageCanvasValue.imageUid + "_" + (imageCanvasValue.frameNumber));
                                if (imagePromiseVal != undefined) {
                                    imagePromise = imagePromiseVal;
                                }
                            }
                            if (imageCanvas.presentation) {
                                imageCanvasValue.presentation = imageCanvas.presentation;
                            }
                            renderer.loadImageRenderer(imagePromise, imageCanvasValue);
                            renderer.presentationState.windowLevel = imageCanvas.lastAppliedWindowLevel;
                            imageUid = imageCanvasValue.imageUid;
                        }
                    }
                }
            }
            if (image.imageType == IMAGETYPE_RADECHO) {
                var imageCountFlag = false;
                var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
                if (isMultiFrame) {
                    for (var i = 0; i < dicomViewer.Study.getSeriesCount(studyUid); i++) {
                        for (var j = 0; j < dicomViewer.Series.getImageCount(studyUid, i); j++) {
                            var image = dicomViewer.Series.Image.getImage(studyUid, i, j);
                            var multiFrameCount = dicomViewer.Series.Image.getImageFrameCount(image);
                            if (multiFrameCount > 1) {
                                imageCountFlag = true;
                                break;
                            }
                        }
                    }
                    disableToolbarForUsImages(true);
                } else {
                    for (var i = 0; i < dicomViewer.Study.getSeriesCount(studyUid); i++) {
                        var imageCount = dicomViewer.Series.getImageCount(studyUid, i);
                        if (imageCount > 1) {
                            imageCountFlag = true;
                            break;
                        }
                    }
                    disableToolbarForUsImages(false);
                }

                enableOrDisableNavigationTools(imageCountFlag);
                disableOrEnableDicomTools(false);
            } else if (image.imageType == IMAGETYPE_RADPDF) {
                createPDFRender(image, viewport, renderer, seriesLevelDiv);
            } else if (image.imageType == IMAGETYPE_RADECG) {
                viewport.addImageRender("ecgData", renderer);
                var urlParameters = dicomViewer.getJpegFrameUrl(imageUid, 0);
                var requestHeaders = getRequestHeaders(studyUid, seriesIndex, imageUid);
                dicomViewer.loadEcg(urlParameters, seriesLevelDiv, undefined, undefined, requestHeaders);
            } else if (image.imageType === IMAGETYPE_RADSR || image.imageType === IMAGETYPE_CDA) {
                viewport.addImageRender("srReport", renderer);
                var urlParameters = dicomViewer.getImageInfoURl(imageUid);
                imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + (frameIndex - 1));
                if (imagePromise === undefined) {
                    var requestData = {
                        studyUid: studyUid,
                        seriesIndex: seriesIndex,
                        imageIndex: imageIndex,
                        frameIndex: frameIndex - 1,
                        imageUid: imageUid,
                        imageType: imageType,
                        layoutId: viewport.seriesLayoutId
                    };
                    imagePromise = dicomViewer.getImage(requestData);
                }
                var requestHeaders = getRequestHeaders(studyUid, seriesIndex, imageUid);
                dicomViewer.loadSR(urlParameters, seriesLevelDiv, imagePromise, image.imageType, requestHeaders);
            } else if (image.imageType === IMAGETYPE_JPEG) {
                disableToolBarForNonDicom();
            } else if (isBlob(image.imageType)) {
                if (image.imageType === IMAGETYPE_VIDEO) {
                    viewport.addImageRender(image.imageType, renderer);
                    var videoUrls = dicomViewer.getVideoUrls(image.imageUid);
                    for (i = 0; i < videoUrls.length; i++) {
                        videoUrls[i].url = dicomViewer.url.getDicomImageURL(videoUrls[i].urlParameters);
                    }
                    dicomViewer.loadVideoPlayer(videoUrls, seriesLevelDiv);
                } else if (image.imageType === IMAGETYPE_AUDIO) {
                    viewport.addImageRender(image.imageType, renderer);
                    var audioURLObject = dicomViewer.getAudioUrl(image.imageUid);
                    var audioURL = dicomViewer.url.getDicomImageURL(audioURLObject);
                    dicomViewer.loadPlayer(audioURL, seriesLevelDiv, "mp3");
                } else if (image.imageType === IMAGETYPE_PDF || image.imageType === IMAGETYPE_TIFF) {
                    createPDFRender(image, viewport, renderer, seriesLevelDiv);
                } else { // unknown image
                    var height = $("#" + seriesLevelDiv).height();
                    var pdfDiv = "<div id='pdf' style='height:" + height + "px;line-height:" + height + "px;background:white' align='center'>Unknown Type</div>"
                    $("#" + seriesLevelDiv).empty();
                    $("#" + seriesLevelDiv).append(pdfDiv);
                }
            } else if (image.modality == 'US') {
                disableToolbarForUsImages(false);
            }

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            var studyLayoutId = getStudyLayoutId(seriesLevelDiv);
            var studyInformationdiv = "studyInfo" + studyLayoutId;
            if (studyDetails.procedure === null || studyDetails.procedure === "" || studyDetails.procedure.length === 0) {
                $("#" + studyInformationdiv).html("&nbsp");
            } else {
                $("#" + studyInformationdiv).html(studyDetails.procedure);
                updateToolTip($("#" + studyInformationdiv), studyDetails.procedure, "top");
            }

            var studyTime = "";
            var studyId = "";
            if (studyDetails.dateTime !== null && studyDetails.dateTime !== undefined) {
                studyTime = studyDetails.dateTime.replace("T", "@");
            }

            if (studyDetails.dicomStudyId !== null && studyDetails.dicomStudyId !== undefined) {
                studyId = studyDetails.dicomStudyId;
            }

            if (studyTime !== "" || studyId !== "") {
                var studyDisplayText = (studyId !== "" ? studyId + ", " + studyTime : studyTime);
                $("#studyUidDateTime" + studyLayoutId).html(studyDisplayText);
                updateToolTip($("#studyUidDateTime" + studyLayoutId), studyDisplayText, "top");
            }

            imageIndex = getImageIndexForImageUid(studyUid, seriesIndex, imageUid);
            progressbar.setSeriesInfo(studyUid, seriesIndex, imageIndex, frameIndex - 1);
            if (imageIndex == undefined)
                imageIndex = 0;
            $("#" + defaultImageLayoutId + "id").removeClass('default-view');
        } else {
            for (var i = 0; i < row; i++) {
                for (var j = 0; j < column; j++) {
                    if (dicomViewer.Series.getSeries(studyUid, seriesIndex)) {
                        var imageLayoutId = imageLevelName + i + "x" + j;
                        var framecount = 0;
                        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                        $("#" + imageLayoutId + "id").addClass('default-view');
                        if (!image) {
                            continue;
                        }
                        frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
                        if (!(frameCount > frameIndex)) {
                            if (!dicomViewer.thumbnail.isImageThumbnail(image)) {
                                imageIndex++;
                            }
                            frameIndex = 0;
                            image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                        }
                        if (image) {
                            var anUIDs = dicomViewer.Series.Image.getImageUid(image) + "*" + (frameIndex++)
                            var renderer = undefined;
                            renderer = viewport.getImageRender(viewport.seriesLayoutId + "ImageLevel" + i + "x" + j);
                            //checking the availabilty for the rendered image as well as its presentation values, if the rendered image is altered then only fetch and store its presentation values
                            if ((renderer != null || renderer != undefined) && renderer.presentationState != undefined) {
                                if (isPresentationUpdationRequired) {
                                    updatedCanvasPresentation = renderer.presentationState;
                                    updatedCanvasPresentation.zoom = renderer.scaleValue;
                                    isPresentationUpdationRequired = false;
                                }
                            }

                            renderer = new ImageRenderer(imageLayoutId, seriesLevelDiv);
                            renderer.init(anUIDs, seriesIndex, imageIndex);
                            viewport.addImageRender(imageLevelName + i + "x" + j, renderer);

                            var imageUid = dicomViewer.Series.Image.getImageUid(image);
                            var header = dicomViewer.header.getDicomHeader(imageUid);
                            var imagePromise = undefined;
                            if (header) {
                                imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + (frameIndex - 1));
                                if (imagePromise === undefined) {
                                    var requestData = {
                                        studyUid: studyUid,
                                        seriesIndex: seriesIndex,
                                        imageIndex: imageIndex,
                                        frameIndex: frameIndex - 1,
                                        imageUid: imageUid,
                                        imageType: imageType,
                                        layoutId: viewport.seriesLayoutId
                                    };
                                    imagePromise = dicomViewer.getImage(requestData);
                                }
                                var imageCanvasValue = null;
                                imagePromise.then(function (image) {
                                    imageCanvasValue = image;
                                });

                                //On first time when the viewer is rendering the image, updatedCanvasPresentation will be undefined
                                if (updatedCanvasPresentation != null && updatedCanvasPresentation != undefined && imageCanvasValue != null) {
                                    if (imageCanvasValue.presentation.presentationMode == "MAGNIFY") {
                                        updatedCanvasPresentation.presentationMode = "MAGNIFY";
                                    }
                                    imageCanvasValue.lastAppliedWindowWidth = updatedCanvasPresentation.windowWidth;
                                    imageCanvasValue.lastAppliedwindowCenter = updatedCanvasPresentation.windowCenter;
                                    imageCanvasValue.lastAppliedBrightness = updatedCanvasPresentation.brightness;
                                    imageCanvasValue.lastAppliedContrast = updatedCanvasPresentation.contrast;
                                    imageCanvasValue.presentation = updatedCanvasPresentation;
                                    imageCanvasValue.lastAppliedWindowLevel = updatedCanvasPresentation.windowLevel;
                                }

                                if (imageCanvasValue == null || imageCanvasValue == undefined || imageCanvasValue == "") {
                                    renderer.loadImageRenderer(imagePromise);
                                } else {
                                    renderer.loadImageRenderer(imagePromise, imageCanvasValue);
                                }

                                if (isPresentationUpdationRequired &&
                                    updatedCanvasPresentation === undefined) {
                                    updatedCanvasPresentation = jQuery.extend(true, {}, renderer.presentationState);
                                    if (imageCanvasValue !== null && imageCanvasValue !== undefined) {
                                        updatedCanvasPresentation.zoom = imageCanvasValue.presentation.zoom;
                                    }
                                    isPresentationUpdationRequired = false;
                                }

                                if (column > 1 || row > 1) {
                                    dicomViewer.tools.setDicomOverLayFalse(viewport);
                                }
                            }

                            imageIndex = getImageIndexForImageUid(studyUid, seriesIndex, imageUid);
                            progressbar.setSeriesInfo(studyUid, seriesIndex, imageIndex, frameIndex - 1);
                        }
                    }
                }
            }
        }
    }

    function getImageIndexForImageUid(studyUid, seriesIndex, imageUid) {
        var series = dicomViewer.Series.getSeries(studyUid, seriesIndex);
        for (var i = 0; i < dicomViewer.Series.getImageCount(studyUid, seriesIndex); i++) {
            if (imageUid === dicomViewer.Series.Image.getImage(studyUid, seriesIndex, i).imageUid) {
                return i;
            }
        }
    }

    /**
     * Selection the preference saved information to the ECG preference.
     */
    function updatePreferenceValues() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var render;
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLayoutId = $(this).attr('id');
            render = seriesLayout.getImageRender(imageLayoutId);
            return;
        });

        var windowAttr = seriesLayout.preferenceInfo.windowLevelSettings;
        if (render && render.presentationState) {
            windowAttr = render.presentationState.windowLevel;
        }

        var zoomAttr = seriesLayout.preferenceInfo.zoomLevelSetting;
        if (render && render.presentationState) {
            zoomAttr = render.presentationState.zoomLevel + "_zoom";
        }

        // Update Window level settings preference information
        dicomViewer.tools.updateWindowLevelSettings(windowAttr);
        dicomViewer.tools.updateZoomLevelSettings(zoomAttr);
        if (seriesLayout.preferenceInfo === undefined || seriesLayout.preferenceInfo === null ||
            seriesLayout.preferenceInfo.preferenceData === undefined || seriesLayout.preferenceInfo.preferenceData === null) {
            return;
        }
        if (seriesLayout.imageType === IMAGETYPE_RADECG) {
            resetContextMenuSelection();
            var thumbnailId;
            if ($(".selected-thumbnail-view")[0]) {
                thumbnailId = $(".selected-thumbnail-view")[0].id
                thumbnailId = $("#" + thumbnailId)[0].ecgPreferenceValues;
            }
            for (var preferenceId in preferenceList) {
                switch (preferenceList[preferenceId]) {
                    case "gridtype":
                        if (thumbnailId && thumbnailId.GridType) {
                            $("#" + thumbnailId.GridType).parent().css("background", "#868696");
                        } else {
                            $("#onemm").parent().css("background", "#868696");
                        }
                        break;
                    case "gridcolor":
                        if (thumbnailId && thumbnailId.GridColor) {
                            $("#" + thumbnailId.GridColor).parent().css("background", "#868696");
                        } else {
                            $("#redGrid").parent().css("background", "#868696");
                        }
                        break;
                    case "leadformat":
                        if (thumbnailId && thumbnailId.LeadFormat) {
                            $("#" + thumbnailId.LeadFormat).parent().css("background", "#868696");
                        } else {
                            $("#threebyfourplusthree").parent().css("background", "#868696");
                        }
                        break;
                    case "gain":
                        if (thumbnailId && thumbnailId.Gain) {
                            $("#" + thumbnailId.Gain).parent().css("background", "#868696");
                        } else {
                            $("#tenmmgain").parent().css("background", "#868696");
                        }
                        break;
                    case "signalthickness":
                        if (thumbnailId && thumbnailId.SignalThickness) {
                            $("#" + thumbnailId.SignalThickness).parent().css("background", "#868696");
                        } else {
                            $("#onethickness").parent().css("background", "#868696");
                        }
                        break;
                }
            }
        }
    }

    function resetContextMenuSelection() {
        $("#none").parent().css("background", "");
        $("#onemm").parent().css("background", "");
        $("#fivemm").parent().css("background", "");

        $("#redGrid").parent().css("background", "");
        $("#greenGrid").parent().css("background", "");
        $("#blueGrid").parent().css("background", "");
        $("#blackGrid").parent().css("background", "");
        $("#greyGrid").parent().css("background", "");

        $("#threebyfour").parent().css("background", "");
        $("#threebyfourplusone").parent().css("background", "");
        $("#threebyfourplusthree").parent().css("background", "");
        $("#sixbytwo").parent().css("background", "");
        $("#twelvebyone").parent().css("background", "");
        $("#averagecomplex").parent().css("background", "");

        $("#fivemmgain").parent().css("background", "");
        $("#tenmmgain").parent().css("background", "");
        $("#twentymmgain").parent().css("background", "");
        $("#fourtymmgain").parent().css("background", "");

        $("#onethickness").parent().css("background", "");
        $("#twothickness").parent().css("background", "");
        $("#threethickness").parent().css("background", "");
    }

    /**
     * Enable or disable the navigation tools
     * @param {Type} imageCountFlag - Specifies the image count
     * @param {Type} seriesLayout - Specifies the active series layout
     */
    function enableOrDisableNavigationTools(imageCountFlag, seriesLayout) {
        var image = null;
        var studyDetails;
        if (seriesLayout) {
            image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);
            studyDetails = dicomViewer.getStudyDetails(seriesLayout.studyUid);
        }

        $("#repeteOption").show();
        $("#repeteOption_overflow").show();

        if (imageCountFlag) {
            playerToolBarElement.hide();
            imageNavigationToolBarElement.hide();
            pdfToolBarElement.hide();
            tiffToolBarElement.hide();
            playerFiledSetElement.hide();
            imageFiledSetElement.hide();
            pdfFiledSetElement.hide();
            tiffFiledSetElement.hide();
            if (image && image.numberOfFrames > 1 && image.imageType == IMAGETYPE_JPEG) {
                tiffToolBarElement.show();
                tiffFiledSetElement.show();
            } else {
                playerToolBarElement.show();
                imageNavigationToolBarElement.show();
                playerFiledSetElement.show();
                imageFiledSetElement.show();
            }
        } else {
            playerToolBarElement.hide();
            imageNavigationToolBarElement.hide();
            pdfToolBarElement.hide();
            tiffToolBarElement.hide();
            playerFiledSetElement.hide();
            imageFiledSetElement.hide();
            pdfFiledSetElement.hide();
            tiffFiledSetElement.hide();
            pageFiledSetElement.hide();
            if (image && isEmbedPdfViewer(image.imageType)) {
                dicomViewer.updatePaging(seriesLayout.serieslayoutId);
            } else if (image && image.imageType == IMAGETYPE_JPEG && studyDetails.seriesCount > 1) {
                if (image.numberOfFrames > 1) {//VAI-307 Disply if multipage TIFF (JPEG)
                    tiffToolBarElement.show();
                    tiffFiledSetElement.show();            
                } 
            } else if (studyDetails && studyDetails.seriesCount > 1 && image.imageType !== IMAGETYPE_PDF && image.imageType !== IMAGETYPE_RADPDF && image.imageType !== IMAGETYPE_TIFF) {
                if (image.imageType == IMAGETYPE_RADECG) {
                    imageNavigationToolBarElement.show();
                    imageFiledSetElement.show();
                } else if (image.imageType == IMAGETYPE_VIDEO) {
                    playerFiledSetElement.hide();
                    imageFiledSetElement.show();
                    $("#repeteOption").hide();
                    $("#repeteOption_overflow").hide();
                    imageNavigationToolBarElement.show();
                } else {
                    playerToolBarElement.show();
                    imageNavigationToolBarElement.show();
                    playerFiledSetElement.show();
                    imageFiledSetElement.show();
                }
                EnableDisableNextSeriesImage(seriesLayout);
            }
            disableAllToolbarIcons();
        }
        disableQATools();
    }

    function selectViewport(event, studyUid) {
        if (window.event && window.event.shiftKey) {
            return;
        }

        var elementId = event.currentTarget.id;
        if (dicomViewer.measurement.isMeasurementBroken()) {
            dicomViewer.measurement.setMeasurementBroken(false);
            event.preventDefault();
        }

        /* Select the layout in the view port which is selected in the thumbnail only
        after changing the series level layout */
        var backserieslayoutid = dicomViewer.getActiveSeriesLayout();
        if (backserieslayoutid != undefined && actualSeriesIndex != 0) {
            elementId = backserieslayoutid.getSeriesLayoutId();
        }
        if (elementId === "") {
            return;
        }
        if (isViewPortDoubleClicked) {
            elementId = event.currentTarget.id;
        }

        $("#" + elementId).focus();
        var studyDiv = getStudyLayoutId(elementId);
        if (previousStudyLayout != "" || previousSaveAndLoadToolLayout != "") {
            if (document.getElementById(previousSaveAndLoadToolLayout) !== null &&
                document.getElementById(previousSaveAndLoadToolLayout) !== undefined) {
                document.getElementById(previousSaveAndLoadToolLayout).style.display = 'none';
            }
        }
        previousSaveAndLoadToolLayout = "saveAndLoad_" + studyDiv;
        previousStudyLayout = "#menuIL" + studyDiv
        var seriesLayout = dicomViewer.viewports.getViewport(elementId);
        showAndHideKendoTools(seriesLayout);
        if (seriesLayout == undefined) {
            processQaRequest(QAType.emptyViewport);
            return;
        }
        if (seriesLayout.imageType === IMAGETYPE_RADECG || seriesLayout.imageType === IMAGETYPE_RADPDF ||
            seriesLayout.imageType === IMAGETYPE_RADSR || seriesLayout.imageType === IMAGETYPE_CDA) {
            $("#menuIL" + studyDiv).children().addClass("k-state-disabled");
            if (document.getElementById(previousSaveAndLoadToolLayout) !== null &&
                document.getElementById(previousSaveAndLoadToolLayout) !== undefined) {
                document.getElementById(previousSaveAndLoadToolLayout).style.display = 'none';
            }
        } else {
            $("#menuIL" + studyDiv).children().removeClass("k-state-disabled");
            if (seriesLayout.imageType !== undefined) {
                if (document.getElementById(previousSaveAndLoadToolLayout) !== null &&
                    document.getElementById(previousSaveAndLoadToolLayout) !== undefined) {
                    document.getElementById(previousSaveAndLoadToolLayout).style.display = 'block';
                }
            }
        }

        // If the Viewport is already focused then no need to focus again.
        if ($("#" + elementId).hasClass('selected-view')) {
            // Page navigation enable and disable
            if (seriesLayout.getSeriesIndex() !== undefined && seriesLayout.getSeriesIndex() !== null) {
                var imageValue = dicomViewer.Series.Image.getImage(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex(), 0);
                var isImageThumbnails = dicomViewer.thumbnail.isImageThumbnail(imageValue);

                if (isImageThumbnails) {
                    var imageIndex = seriesLayout.scrollData.imageIndex;
                    // set the actual selected thumbnail image index value
                    if (selectThumbnailImageIndex !== undefined && selectThumbnailImageIndex != imageIndex) {
                        imageIndex = selectThumbnailImageIndex;
                    }
                    dicomViewer.thumbnail.selectImageThumbnail(seriesLayout.getSeriesIndex(), imageIndex);
                } else {
                    dicomViewer.thumbnail.selectThumbnail(seriesLayout.getSeriesIndex());
                }
            }

            EnableDisableReferenceLineMenu(seriesLayout);

            //Need to enable or disable the toolbar options based on the image type.
            if (seriesLayout !== null && seriesLayout !== undefined) {
                var selectedStudyUid = seriesLayout.getStudyUid();
                var selectedSeriesIndex = seriesLayout.getSeriesIndex();
                if (selectedStudyUid !== undefined && selectedSeriesIndex !== undefined) {
                    var modality = dicomViewer.Series.getModality(selectedStudyUid, selectedSeriesIndex);
                    var isCinePlay = isCineRunning(seriesLayout.getSeriesLayoutId());
                    if (!isCinePlay) {
                        enableOrDisableTools(modality, seriesLayout);
                        if (event.which == 1 && dicomViewer.mouseTools.getToolName() == TOOLNAME_DEFAULTTOOL) {
                            setDefaultCursorType(modality, seriesLayout);
                        }
                    } else {
                        showOrHideInCineRunning(modality, isCinePlay);
                        changeToolbarIcon($("#overlayButton"), "overlay.png", "overlay.png", false);
                        changeToolbarIcon($("#dicomheaderButton_wrapper"), "header.png", "header.png", false);
                    }
                }
            }

            updatePreferenceValues();
            return;
        }

        setActiveSeriesLayout(seriesLayout);

        // Page navigation enable and disable
        if (seriesLayout !== null && seriesLayout !== undefined) {
            var tmpStudyUID = seriesLayout.getStudyUid();
            var tmpSeriesIndex = seriesLayout.getSeriesIndex();
            var tmpImageUID = seriesLayout.getDefaultRendererImageUid();
            if (tmpStudyUID !== null && tmpStudyUID !== undefined && tmpSeriesIndex !== undefined) {
                var imageCountFlag = false;
                var isImageAvailable = dicomViewer.isImageAvilable(tmpStudyUID, tmpImageUID)
                var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(tmpStudyUID, tmpSeriesIndex);
                var multiFrameIncCount = 0;
                if (isMultiFrame) {
                    for (var i = 0; i < dicomViewer.Study.getSeriesCount(tmpStudyUID); i++) {
                        for (var j = 0; j < dicomViewer.Series.getImageCount(tmpStudyUID, i); j++) {
                            var image = dicomViewer.Series.Image.getImage(tmpStudyUID, i, j);
                            var multiFrameCount = dicomViewer.Series.Image.getImageFrameCount(image);
                            multiFrameCount == 1 ? ++multiFrameIncCount : "";
                            if (multiFrameCount > 1 || multiFrameIncCount > 1) {
                                imageCountFlag = true;
                                break;
                            }
                        }
                    }
                } else if (isImageAvailable && !isMultiFrame) {
                    multiFrameIncCount = 0;
                    for (var i = 0; i < dicomViewer.Study.getSeriesCount(tmpStudyUID); i++) {
                        var imageCount = dicomViewer.Series.getImageCount(tmpStudyUID, i);
                        imageCount == 1 ? ++multiFrameIncCount : "";
                        if (imageCount > 1 || multiFrameIncCount > 1) {
                            imageCountFlag = true;
                            break;
                        }
                    }
                }
                enableOrDisableNavigationTools(imageCountFlag, seriesLayout);
            } else {
                enableOrDisableNavigationTools(0);
                disableAllToolbarIcons();
            }
        }

        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                if (imageRender.imagePromise === undefined) {
                    return;
                }
                imageRender.imagePromise.then(function (image) {
                    dicomViewer.showCineRate(image.dicominfo.cineRate);
                });
            }
            return false;
        });
        if (cineManager[seriesLayout.seriesLayoutId] !== undefined) {
            if (cineManager[seriesLayout.seriesLayoutId].timer == null) {
                updatePlayIcon("stop.png", "play.png", undefined, undefined, cineManager[seriesLayout.seriesLayoutId].playStudy);
            } else {
                var parentElement = $("#playBackward").parent().css("background", "");
                var parentElement = $("#playForward").parent().css("background", "#868696");
                updatePlayIcon("play.png", "stop.png", undefined, undefined, cineManager[seriesLayout.seriesLayoutId].playStudy);
            }
            if (cineManager[seriesLayout.seriesLayoutId].direction) {
                var parentElement = $("#playBackward").parent().css("background", "");
                var parentElement = $("#playForward").parent().css("background", "#868696");
            } else {
                var parentElement = $("#playForward").parent().css("background", "");
                var parentElement = $("#playBackward").parent().css("background", "#868696");
            }
            showCineRate(cineManager[seriesLayout.seriesLayoutId].cineRate);
            if (cineManager[seriesLayout.seriesLayoutId].playStudy) {
                var repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
                var repeteOption_overflow = $("#repeteOption_overflow");
                var imageSrc = repeatButtonImage.src;
                var repateOptionButton = $("#repeteOption");
                if (imageSrc.indexOf("repeat.png") > -1) {
                    repeatButtonImage.src = imageSrc.replace("repeat.png", "repeteActive.png");
                    updateToolTip(repateOptionButton, "Repeat Series");
                    updateImageOverflow(repeteOption_overflow, "images/repeat.png", "images/repeteActive.png", false);
                }
            } else {
                var repeatButtonImage = document.getElementById("repeteOption").getElementsByTagName('img')[0];
                var repeteOption_overflow = $("#repeteOption_overflow");
                var imageSrc = repeatButtonImage.src;
                var repateOptionButton = $("#repeteOption");
                if (imageSrc.indexOf("repeteActive.png") > -1) {
                    repeatButtonImage.src = imageSrc.replace("repeteActive.png", "repeat.png");
                    updateToolTip(repateOptionButton, "Repeat Study");
                    updateImageOverflow(repeteOption_overflow, "images/repeteActive.png", "images/repeat.png", true);
                }
            }
        } else {
            if (canPlayCine(seriesLayout.imageType)) {
                var playBy = dicomViewer.configuration.cine.getCinePlayBy();
                cineplayBy(playBy);
            }
            updatePlayIcon("stop.png", "play.png");
        }
        var viewportElementIds = dicomViewer.viewports.getViewportIds();
        $(".selected-view").removeClass('selected-view').addClass('default-view');
        $("#" + elementId).removeClass('default-view').addClass('selected-view');
        var seriesIndex = seriesLayout.getSeriesIndex();
        if (studyUid === undefined)
            studyUid = seriesLayout.getStudyUid();
        if (studyUid === undefined || (seriesLayout.seriesIndex == undefined && seriesLayout.imageType == undefined)) {
            dicomViewer.thumbnail.removeSelctedThumbnail();
            disableAllToolbarIcons();
            setDefaultCursorType(undefined, seriesLayout);
            $('#imageDisplay' + studyDiv).hide();
            prepareQARequest(QAType.emptyViewport);
            return;
        }
        if (seriesLayout.getSeriesIndex() === undefined) {
            setStudyToolBarTools(seriesLayout);
            return;
        }

        var modality = dicomViewer.Series.getModality(studyUid, seriesIndex);
        var imageValue = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, 0);
        var isImageThumbnails = dicomViewer.thumbnail.isImageThumbnail(imageValue);
        if (isImageThumbnails) {
            var imageIndex = seriesLayout.scrollData.imageIndex;
            // set the actual selected thumbnail image index value
            if (selectThumbnailImageIndex !== undefined && selectThumbnailImageIndex != imageIndex) {
                imageIndex = selectThumbnailImageIndex;
            }
            dicomViewer.thumbnail.selectImageThumbnail(seriesIndex, imageIndex);
        } else {
            dicomViewer.getActiveSeriesLayout().setStudyUid(studyUid);
            // set the actual selected thumbnail image index value
            if (actualSeriesIndex != 0) {
                seriesIndex = actualSeriesIndex;
            }
            dicomViewer.thumbnail.selectThumbnail(seriesIndex);
            seriesIndex = seriesLayout.getSeriesIndex();
        }
        updatePreferenceValues();
        //link
        dicomViewer.link.updateLinkMenu();

        if (dicomViewer.link.getLinkToolActive()) {
            if (event.which == 1 && !dicomViewer.link.isSeriesLinked()) {
                dicomViewer.link.linkSeries();
            }
        }

        if (dicomViewer.link.isSeriesLinked()) {
            var img = document.getElementById('linkButton').children[0];
            document.getElementById('linkButton_overflow').children[0].src = 'images/unlink.png';
            img.src = 'images/unlink.png';
            updateToolTip($("#linkButton"), "UnLink");
        } else {
            var img = document.getElementById('linkButton').children[0];
            document.getElementById('linkButton_overflow').children[0].src = 'images/link.png';
            img.src = 'images/link.png';
            updateToolTip($("#linkButton"), "Link");
        }

        dicomViewer.viewports.refreshViewports(seriesLayout);
        setStudyToolBarTools(seriesLayout);
        setDefaultCursorType(modality, seriesLayout, event);
        enableOrDisableTools(modality, seriesLayout);
        if (actualSeriesIndex != 0 && isImageThumbnails == false) {
            seriesIndex = actualSeriesIndex;
        }
        if (imageIndex == undefined) {
            imageIndex = seriesLayout.getImageIndex();
        }
        updateThumbnailSelection(undefined, seriesIndex, imageIndex, studyUid);
        if (isCineRunning(seriesLayout.getSeriesLayoutId())) {
            showOrHideInCineRunning(modality, true);
        }
        var imageUid = seriesLayout.getDefaultRendererImageUid();
        var imageIndex = dicomViewer.Series.Image.getImageIndex(studyUid, seriesIndex, imageUid)
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);

        if (image !== undefined && image !== null) {
            if ((dicomViewer.Series.Image.getImageFrameCount(image) > 1) || dicomViewer.Series.getImageCount(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex()) > 1) {
                if (isCineRunning(seriesLayout.getSeriesLayoutId())) {
                    dicomViewer.startCine();
                    updatePlayIcon("play.png", "stop.png");
                }
            } else {
                if (dicomViewer.isDicomStudy(seriesLayout.getStudyUid())) {
                    dicomViewer.scroll.stopCineImage(undefined);
                    updatePlayIcon("stop.png", "play.png");
                }
            }
        }

        document.getElementById(studyDiv + '_close').style.visibility = "visible";

        var imageLayout = seriesLayout.getImageLayoutDimension().split("x");
        dicomViewer.tools.changeImageLayout(parseInt(imageLayout[0]), parseInt(imageLayout[1]));
        EnableDisableReferenceLineMenu(seriesLayout);
        EnableDisableNextSeriesImage(seriesLayout);

    }

    /**
     * Enable/Disable the cross reference line depends on the Image plane
     */
    function EnableDisableReferenceLineMenu(seriesLayout) {
        var studyuid = seriesLayout.getStudyUid();
        var studyDetials = dicomViewer.getStudyDetails(studyuid);
        if (studyDetials !== null && studyDetials !== undefined) {
            if (studyDetials.isXRefLineFound) {
                $("#scoutLine").show(); //cross reference line
                $("#scoutLine_overflow").show(); //cross reference line
                document.getElementById("context-link-crossRefLineSelector").style.display = "block"
                $("#context-link-menu").show();
            } else {
                $("#scoutLine").hide(); //cross reference line
                $("#scoutLine_overflow").hide(); //cross reference line
                document.getElementById("context-link-crossRefLineSelector").style.display = "none"
                $("#context-link-menu").hide();
            }
        }
        disableQATools();
    }

    function setStudyToolBarTools(seriesLayout) {
        var studyDiv = getStudyLayoutId(seriesLayout.seriesLayoutId);
        var imageLayoutDisplayId = "imageDisplay" + studyDiv;
        var seriesLayoutDisplayId = "seriesDisplay" + studyDiv;

        if (seriesLayout.getStudyUid() !== undefined && seriesLayout.getSeriesIndex() !== undefined && seriesLayout.getImageIndex() !== undefined) {
            var studyDetails = dicomViewer.getStudyDetails(seriesLayout.studyUid);
            if (studyDetails.isDicom == true) {
                $("#context-copyAttributes").show();
                $("li.copyAttributesPreference").show();
            }

            document.getElementById(seriesLayoutDisplayId).style.display = 'block';
            var imageCount = 0;
            if (seriesLayout.getImageIndex() != undefined) {
                imageCount = dicomViewer.Series.getImageCount(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex());
                var frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex(), seriesLayout.getImageIndex()));
                imageCount = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex()) ? frameCount : imageCount;
            }

            if (imageCount > 1) {
                document.getElementById(imageLayoutDisplayId).style.display = 'block';
            } else {
                document.getElementById(imageLayoutDisplayId).style.display = 'none';
            }

            changeIconSize();
        } else {
            document.getElementById(imageLayoutDisplayId).style.display = 'none';
            $("li.copyAttributesPreference").hide();
        }
    }

    function isToolSupportByImageType(modality, imageType, seriesLayout) {
        var cursorType = dicomViewer.tools.getCursorType();
        if (imageType === IMAGETYPE_RADSR || imageType === IMAGETYPE_RADPDF || imageType === IMAGETYPE_RADECG || imageType === IMAGETYPE_CDA) {
            return false;
        }
        var toolName = dicomViewer.mouseTools.getToolName();
        var activeTool;
        activeTool = (activeTool = dicomViewer.mouseTools.getActiveTool().measurementData) ? activeTool.measurementSubType : undefined;

        if (toolName === "XRefLineSelectionTool") {
            var studyDetials = dicomViewer.getStudyDetails(seriesLayout.studyUid);
            if (studyDetials !== null && studyDetials !== undefined && studyDetials.isXRefLineFound) {
                dicomViewer.tools.doXRefLineSelection();
                return true;
            }
            return false;
        }

        if (imageType === IMAGETYPE_RADECHO || imageType === IMAGETYPE_JPEG) {
            if (toolName === TOOLNAME_PAN) {
                $('#viewport_View').css('cursor', 'url(images/pan.cur), auto');
                var obj = {
                    id: "pan"
                }
                dicomViewer.tools.doPan(obj)
                return true;
            }
            if (toolName === TOOLNAME_ZOOM) {
                $('#viewport_View').css('cursor', 'url(images/zoom.cur), auto');
                var obj = {
                    id: "zoomButton"
                }
                dicomViewer.tools.doZoom(seriesLayout.preferenceInfo.zoomLevelSetting);
                return true;
            }
            if (toolName === TOOLNAME_WINDOWLEVEL) {
                dicomViewer.tools.doBrightnessContrast();
                return true;
            }
        }
        if (imageType === IMAGETYPE_RAD) {
            if (toolName === TOOLNAME_WINDOWLEVEL) {
                $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getWindowTool());
                return true;
            }
            if (toolName === TOOLNAME_WINDOWLEVEL_ROI) {
                $('#viewport_View').css('cursor', 'url(images/AutoWindowLevel.cur), auto');
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getWindowToolROI());
                return true;
            }
            if (toolName === TOOLNAME_ZOOM) {
                $('#viewport_View').css('cursor', 'url(images/zoom.cur), auto');
                var obj = {
                    id: "zoomButton"
                }
                dicomViewer.tools.doZoom(seriesLayout.preferenceInfo.zoomLevelSetting);
                return true;
            }
            if (toolName === TOOLNAME_PAN) {
                $('#viewport_View').css('cursor', 'url(images/pan.cur), auto');
                var obj = {
                    id: "pan"
                }
                dicomViewer.tools.doPan(obj)
                return true;
            }
            if (toolName === TOOLNAME_LINK) {
                if (dicomViewer.link.getLinkToolActive()) {
                    $('#viewport_View').css('cursor', 'url(images/link.cur), auto');
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getLinkTool());
                } else {
                    $('#viewport_View').css('cursor', 'default');
                }
                return true;
            }
        }
        if (toolName === "lineMeasurement") {
            if ((cursorType != "default" && cursorType == "annotatearrow") || (cursorType == "default" && activeTool == "Arrow")) {
                var obj = {
                    id: "10_arrow"
                }
                dicomViewer.tools.do2DMeasurement(obj);
            } else if ((cursorType != "default" && cursorType == "annotateline") ||
                (cursorType == "default" && activeTool == "2DLine")) {
                var obj = {
                    id: "9_line"
                }
                dicomViewer.tools.do2DMeasurement(obj);
            } else if (cursorType != "default" && cursorType == "mitrallength" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(0, "mitralRegurgitationLength", "cm");
            } else if (cursorType != "default" && cursorType == "aorticlength" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(0, "aorticRegurgitationLength", "cm");
            } else if (cursorType != "default" && cursorType == "mitralthickness" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(0, "mitralValveAnteriorLeafletThickness", "mm");
            } else {
                $('#viewport_View').css('cursor', 'url(images/measuremnet.png), auto');
                var obj = {
                    id: "0_measurement"
                }
                dicomViewer.tools.do2DMeasurement(obj)
            }
            return true;
        }
        if (toolName === "pointMeasurement") {
            if (cursorType != "default" && cursorType == "mitralvelocity" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(1, "mitralRegurgitationPeakVelocity", "m/s");
            } else if (cursorType != "default" && cursorType == "aorticregurgitationvelocity" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(1, "aorticRegurgitationPeakVelocity", "m/s");
            } else if (cursorType != "default" && cursorType == "aorticstenosisvelocity" && modality == "US") {
                var obj = {
                    type: 1
                }
                dicomViewer.tools.do2DMeasurement(1, "aorticStenosisPeakVelocity", "m/s");
            } else {
                $('#viewport_View').css('cursor', 'url(images/measuremnet.png), auto');
                var obj = {
                    id: "1_measurement"
                }
                dicomViewer.tools.do2DMeasurement(obj);
            }
            return true;
        }
        if (modality === "US" && toolName === "traceMeasurement") {
            $('#viewport_View').css('cursor', 'url(images/measuremnet.png), auto');
            var obj = {
                id: "2_measurement"
            }
            dicomViewer.tools.do2DMeasurement(obj)
            return true;
        }
        if (toolName === "mitralMeanGradientMeasurement") {
            if ((cursorType != "default" && cursorType == "annotatefreehand") || (cursorType == "default" && activeTool == "freehand")) {
                var obj = {
                    id: "13_freehand"
                }
                dicomViewer.tools.do2DMeasurement(obj)
                return true;
            } else if (cursorType != "default" && cursorType == "mitralgradient" && modality == "US") {
                dicomViewer.tools.do2DMeasurement(5, "mitralStenosisMeanGradient", "mmHg");
                return true;
            }
        }
        if (toolName === "angleMeasurement") {
            $('#viewport_View').css('cursor', 'url(images/measuremnet.png), auto');
            var obj = {
                id: "angle_measurement"
            }
            dicomViewer.tools.do2DMeasurement(obj)
            return true;
        }

        if (toolName == "rectangleMeasurement") {
            if ((cursorType != "default" && cursorType == "annotaterectangle") || (cursorType == "default" && activeTool == "rectangle")) {
                var obj = {
                    id: "12_rectangle"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            } else if ((cursorType != "default" && cursorType == "annotatetext") || (cursorType == "default" && activeTool == "text")) {
                var obj = {
                    id: "8_text"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            } else if (modality === "CT") {
                var obj = {
                    id: "14_measurement"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            } else {
                var obj = {
                    id: "12_rectangle"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            }
        }

        if (toolName === "ellipseMeasurement") {
            if ((cursorType != "default" && cursorType == "annotateellipse") || (cursorType == "default" && activeTool == "ellipse")) {
                var obj = {
                    id: "11_ellipse"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            } else if (modality === "CT") {
                var obj = {
                    id: "7_measurement"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            } else {
                var obj = {
                    id: "11_ellipse"
                }
                dicomViewer.tools.do2DMeasurement(obj);
                return true;
            }
        }
        if (toolName === "pen") {
            var obj = {
                id: "15_pen"
            };
            dicomViewer.tools.do2DMeasurement(obj);
            return true;
        }
        return false;
    }

    /**
     * Handle the default tool copy attributes or default
     */
    function handleDefaultTool(isDicom, seriesLayout, event) {
        try {
            var resetDefault = false;
            if (dicomViewer.mouseTools.getToolName() === TOOLNAME_COPYATTRIBUTES && event.which == 1) {
                var tool = dicomViewer.mouseTools.getActiveTool();
                var data = tool.getCopyAttributesData();
                if (seriesLayout.studyUid === data.studyUid) {
                    tool.setActiveImageRenderer(seriesLayout.getImageRender(seriesLayout.seriesLayoutId + "ImageLevel0x0"));
                    tool.hanleMouseDown();
                } else {
                    tool.setCopyAttributesData(undefined);
                    resetDefault = true;
                }
            } else {
                resetDefault = true;
            }

            if (isDicom && resetDefault) {
                $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getWindowTool());
            } else if (resetDefault) {
                $('#viewport_View').css('cursor', 'url(images/brightness.cur), auto');
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getBrightnessContrastTool());
            }
        } catch (e) {}
    }

    function setDefaultCursorType(modality, seriesLayout, event) {
        if (seriesLayout.studyUid && seriesLayout.seriesIndex != undefined) {
            if (modality == undefined && seriesLayout.imageType !== IMAGETYPE_JPEG) {
                $('#viewport_View').css('cursor', 'default');
            } else if (!isToolSupportByImageType(modality, seriesLayout.imageType, seriesLayout)) {
                if ((modality == "US") || (seriesLayout.imageType === IMAGETYPE_JPEG) || (seriesLayout.imageType === IMAGETYPE_RADECHO)) {
                    handleDefaultTool(false, seriesLayout, event);
                } else if (isBlob(seriesLayout.imageType) ||
                    seriesLayout.imageType === IMAGETYPE_RADSR ||
                    seriesLayout.imageType === IMAGETYPE_CDA) {
                    $('#viewport_View').css('cursor', 'default');
                } else if (seriesLayout.imageType === IMAGETYPE_RAD) {
                    handleDefaultTool(true, seriesLayout, event);
                }

                //whenever cine is running in repeat study mode the active mouse tool should be default tool
                if (dicomViewer.scroll.isCineRunning(seriesLayout.seriesLayoutId) && isToPlayStudy(seriesLayout.seriesLayoutId)) {
                    dicomViewer.tools.doDefault();
                }
            }
        } else {
            dicomViewer.tools.doDefault();
        }
    }

    function enableOrDisableTools(modality, seriesLayout) {
        if (modality == "ECG" || seriesLayout.imageType === IMAGETYPE_RADECG || seriesLayout.imageType === IMAGETYPE_RADPDF) {
            enableOrDisableNavigationTools(0, seriesLayout)
            $("#ecgPreference").prop("disabled", false);
            $("#ecgPreference").css("background-color", "");
            disableOrEnableDicomTools(true);
            enableOrDisableToolsForECG();
            if (seriesLayout.imageType === IMAGETYPE_RADPDF) {
                disbaleToolForECGPDF();
                var element = document.getElementsByName("pdfviewer1x1");
                if (element !== null) {
                    var window = element[0];
                    if (window !== undefined && window.contentWindow.document.body !== null) {
                        window.contentWindow.document.body.focus();
                    }
                }
            }
            //enableToolsForNonDicom();
        } else if (modality === "CT") {
            disableOrEnableToolbarForCTImages();
        } else if (modality == "US" && seriesLayout.imageType === IMAGETYPE_RADECHO) {
            var imageCountFlag = false;
            var studyUID = seriesLayout.getStudyUid();
            var seriesIndex = seriesLayout.getSeriesIndex();
            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUID, seriesIndex);
            if (isMultiFrame) {
                for (var i = 0; i < dicomViewer.Study.getSeriesCount(studyUID); i++) {
                    for (var j = 0; j < dicomViewer.Series.getImageCount(studyUID, i); j++) {
                        var image = dicomViewer.Series.Image.getImage(studyUID, i, j);
                        var multiFrameCount = dicomViewer.Series.Image.getImageFrameCount(image);
                        if (multiFrameCount >= 1) {
                            imageCountFlag = true;
                            break;
                        }
                    }
                }
                disableToolbarForUsImages(true);
            } else {
                for (var i = 0; i < dicomViewer.Study.getSeriesCount(studyUID); i++) {
                    var imageCount = dicomViewer.Series.getImageCount(studyUID, i);
                    if (imageCount > 1) {
                        imageCountFlag = true;
                        break;
                    }
                }
                disableToolbarForUsImages(false);
            }

            enableOrDisableNavigationTools(imageCountFlag, seriesLayout);
        } else if (modality === "SR" || modality === "CDA" || seriesLayout.imageType === IMAGETYPE_RADSR || seriesLayout.imageType === IMAGETYPE_CDA) {
            enableOrDisableNavigationTools(0, seriesLayout);
            disableOrEnableSRTools();
            $("#dicomheaderButton_wrapper").removeClass("k-state-disabled");
            $("#refreshButton").removeClass("k-state-disabled");
            $('#winL_wrapper').addClass('k-state-disabled');
            if (modality === "CDA" || seriesLayout.imageType === IMAGETYPE_CDA) {
                $("#dicomImageHeader").hide();
                $("#dicomImageHeader_overflow").hide(); //Dicom Header Overflow
            } else {
                $("#dicomImageHeader").show();
                $("#dicomImageHeader_overflow").show(); //Dicom Header Overflow
            }
        } else if (seriesLayout.imageType === IMAGETYPE_JPEG) {
            disableToolBarForNonDicom();
        } else if (isBlob(seriesLayout.imageType)) {
            disableToolForBlob(true);
        } else if (seriesLayout.imageType === IMAGETYPE_RAD) {
            $("#ecgPreference").prop("disabled", true);
            $("#ecgPreference").css("background-color", "black");
            disableOrEnableDicomTools(false);
            enableOrDisableNavigationTools(true, seriesLayout);
        }
        if (seriesLayout && isEmbedPdfViewer(seriesLayout.imageType)) {
            $("#zoomButton_wrapper").removeClass("k-state-disabled");
            $("#flipVButton").removeClass("k-state-disabled");
            $("#flipHButton").removeClass("k-state-disabled");
            $("#rotateButton").removeClass("k-state-disabled");
            $("#refreshButton").removeClass("k-state-disabled");
            $("#zoomButton_overflow").show();
            $("#zoomButton_overflow").addClass("k-state-disabled");
            $("#flipVButton_overflow").show();
            $("#flipHButton_overflow").show();
            $("#rotateButton_overflow").show();
            $("#refreshButton_overflow").show();
        }
    }

    function allowDrop(event) {
        var viewportObject = dicomViewer.viewports.getViewport(event.currentTarget.id);
        if (viewportObject !== undefined && viewportObject.getStudyUid() != undefined && viewportObject.getStudyUid() != dragThumbnailStudyUid) {
            return;
        }
        event.preventDefault();
    }

    function seriesDrop(event) {
        dicomViewer.measurement.setMeasurementBroken(false);
        var dragThumimageUid = event.originalEvent.dataTransfer.getData("text");
        var thumbnailRenderer = dicomViewer.thumbnail.getThumbnail($('#' + dragThumimageUid).parent().attr('id'));
        var studyUid = thumbnailRenderer.getStudyUid();
        var currentSeriesLayoutId = event.currentTarget.id;
        var checkViewport = dicomViewer.viewports.checkVewportAvailable(currentSeriesLayoutId, studyUid);
        var isUpdateViewportHeight = false;
        if ((dicomViewer.viewports.getViewport(currentSeriesLayoutId)).studyUid == undefined) {
            isUpdateViewportHeight = true;
        }

        if (!checkViewport) {
            return;
        }
        dragThumbnailStudyUid = undefined;
        event.preventDefault();

        // Change the viewport selection if the current and target viewports are mismatching 
        var activeViewportStudyId = dicomViewer.getActiveSeriesLayout().getStudyUid();
        if (activeViewportStudyId !== undefined && activeViewportStudyId !== null) {
            if (activeViewportStudyId !== studyUid) {
                changeSelection(currentSeriesLayoutId);
            }
        }

        var seriesId = event.target.id;
        if (event.target.previousSibling) {
            var parentElemet = $('#' + event.target.previousSibling.id).parent()
            if (parentElemet[0] === undefined) {
                seriesId = event.currentTarget.id;
            } else {
                seriesId = getParentElement($('#' + event.target.previousSibling.id), 'div');
            }
        }
        var studyUid = thumbnailRenderer.getStudyUid();
        var seriesLayout = dicomViewer.viewports.getViewport(seriesId);

        if (!seriesLayout) {
            var parentElemet = $('#' + seriesId).parent();
            if (parentElemet[0] === undefined) {
                seriesId = event.currentTarget.id;
            } else {
                seriesId = getParentElement($('#' + seriesId), 'div');
            }
            seriesLayout = dicomViewer.viewports.getViewport(seriesId);
        }
        if (seriesLayout === undefined) {

            seriesId = dicomViewer.getActiveSeriesLayout().getSeriesLayoutId();
            seriesLayout = dicomViewer.viewports.getViewport(seriesId);
        }
        seriesLayout.setStudyUid(studyUid);
        seriesLayout.isDragAndDrop = true;
        /*When we drag and drop the image removing the value*/
        imageCanvasOfViewPorts[seriesLayout.seriesLayoutId] = undefined;
        var seriesNo = thumbnailRenderer.seriesIndex;
        var imageNumber = thumbnailRenderer.imageCountOfSeries;
        //Check the number is available while drag and drop the  thumbnail
        //Number is undefined while drag and drop the series thumbnail
        if (imageNumber == undefined) {
            imageNumber = 0;
            imageIndexNumber = 0;
        } else {
            //number is available while drag and drop the image level thumbnail
            imageNumber = imageNumber - 1;
            imageIndexNumber = imageNumber;
        }
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesNo, imageNumber);
        if (image !== undefined) {
            $("#" + currentSeriesLayoutId).mousedown(selectViewport);
            $("#" + currentSeriesLayoutId).mouseover(focusActiveLayout);
            $("#" + currentSeriesLayoutId).unbind('keydown');
            $("#" + currentSeriesLayoutId).keydown(keyToMoveNextOrPreviousImage);
        }
        var imageUid = dicomViewer.Series.Image.getImageUid(image);
        var imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + 0);
        if (dicomViewer.isSeriesInComplete(studyUid, seriesNo, imageNumber)) {
            dicomViewer.enableCacheData(studyUid, true);
            dicomViewer.cacheImages(studyUid);
        }

        var isSameSeries = false;
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesLayout.seriesIndex);
        if (!isMultiFrame) {
            if (seriesLayout.seriesIndex == parseInt(seriesNo)) {
                isSameSeries = true;
            } else {
                dicomViewer.viewports.removeDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + seriesLayout.seriesIndex);
            }
        } else {
            if (seriesLayout.scrollData.imageIndex == parseInt(imageNumber)) {
                isSameSeries = true;
            } else {
                dicomViewer.viewports.removeDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + seriesLayout.scrollData.imageIndex);
            }
        }

        seriesLayout.setSeriesIndex(parseInt(seriesNo));
        seriesLayout.setImageIndex(parseInt(imageIndexNumber));
        seriesLayout.setFrameIndex(0);
        seriesLayout.removeAllImageRenders();

        //Update the view port height if viewport is empty
        if (isUpdateViewportHeight) {
            var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);
            viewportHeight(currentSeriesLayoutId, image.imageType);
            var viewportId = currentSeriesLayoutId.split("_")[1];
            createSaveAndLoadPStateGUI("saveAndLoad_" + viewportId, seriesLayout.studyUid, viewportId);
        }

        seriesLayout.setImageCount(dicomViewer.Series.getImageCount(studyUid, seriesNo));
        var imageLayout = seriesLayout.getImageLayoutDimension().split("x");
        setImageLevelLayout(studyUid, parseInt(imageLayout[0]), parseInt(imageLayout[1]), seriesId, seriesLayout, seriesNo, imageNumber, 0, true);
        if (dicomViewer.viewports.isDuplicateViewport(isMultiFrame, isMultiFrame ? imageNumber : seriesNo) && !isSameSeries) {
            dicomViewer.viewports.addDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + (isMultiFrame ? imageNumber : seriesNo), seriesLayout);
        }

        var viewportElementIds = dicomViewer.viewports.getViewportIds();
        for (var i = 0; i < viewportElementIds.length; i++) {
            $("#" + viewportElementIds[i]).removeClass('selected-view').addClass('default-view');
        }
        $("#" + seriesId).trigger("click", [studyUid]);
        changeIconSize();
        dicomViewer.scroll.stopCineImage(undefined);
        changePlayDirection(); // function has implemented in viewer.cshtml
        var modality = dicomViewer.Series.getModality(studyUid, seriesNo);
        if ((dicomViewer.Series.Image.getImageFrameCount(image) > 1) && (modality === "US" || modality === "XA")) {
            dicomViewer.startCine();
            updatePlayIcon("play.png", "stop.png");
        } else {
            dicomViewer.scroll.stopCineImage(undefined);
            updatePlayIcon("stop.png", "play.png");
        }

        //Toggling the state of the Next and Previous Image/Series Button on mouse wheel click
        EnableDisableNextSeriesImage(seriesLayout);
        updatePreset(seriesLayout);
    }

    /**
     * change the preset for WL and Zoom
     * @param {Type} seriesLayout - it specifies the active series
     */
    function updatePreset(seriesLayout) {
        var layoutId = seriesLayout.seriesLayoutId + "ImageLevel0x0";
        var render = seriesLayout.imageRenders[layoutId];
        if (render != undefined && render != null &&
            render.presentationState != undefined &&
            render.presentationState != null) {

            var preset = (render.presentationState).windowLevel;
            dicomViewer.tools.updateWindowLevelSettings(preset);
        } else if (seriesLayout && seriesLayout.imageType === IMAGETYPE_RADECG) {
            var preferenceInfo = seriesLayout.preferenceInfo;
            var zoomsettings = preferenceInfo.zoomLevelSetting;
            zoomsettings = zoomsettings ? zoomsettings.split("_")[0] : 2;
            dicomViewer.tools.setZoomLevel(parseInt(zoomsettings));
        }
    }

    function loadImageFromThumbnail(seriesNo, imageNumber) {
        dicomViewer.measurement.setMeasurementBroken(false);
        var seriesLayout = getActiveSeriesLayout();
        var studyUid = seriesLayout.getStudyUid();
        imageCanvasOfViewPorts[seriesLayout.seriesLayoutId] = undefined;
        if (imageNumber === undefined) {
            imageNumber = 0;
            imageIndexNumber = 0;
        } else {
            //number is available while drag and drop the image level thumbnail
            imageNumber = imageNumber - 1;
            imageIndexNumber = imageNumber;
        }
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesNo, imageNumber)
        var imageUid = dicomViewer.Series.Image.getImageUid(image);
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesLayout.seriesIndex);
        var isSameSeries = false;
        if (!isMultiFrame) {
            if (seriesLayout.seriesIndex == parseInt(seriesNo)) {
                isSameSeries = true;
            } else {
                dicomViewer.viewports.removeDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + seriesLayout.seriesIndex);
            }
        } else {
            if (seriesLayout.scrollData.imageIndex == parseInt(imageNumber)) {
                isSameSeries = true;
            } else {
                dicomViewer.viewports.removeDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + seriesLayout.scrollData.imageIndex);
            }
        }

        seriesLayout.setSeriesIndex(parseInt(seriesNo));
        seriesLayout.setImageIndex(parseInt(imageIndexNumber));
        seriesLayout.setFrameIndex(0);
        seriesLayout.removeAllImageRenders();
        seriesLayout.setImageCount(dicomViewer.Series.getImageCount(studyUid, seriesNo));
        var imageLayout = seriesLayout.getImageLayoutDimension().split("x");
        setImageLevelLayout(seriesLayout.studyUid, parseInt(imageLayout[0]), parseInt(imageLayout[1]), seriesLayout.seriesLayoutId, seriesLayout, seriesNo, imageNumber, 0, true);
        updatePreset(seriesLayout);
        if (dicomViewer.viewports.isDuplicateViewport(isMultiFrame, isMultiFrame ? imageNumber : seriesNo) && !isSameSeries) {
            dicomViewer.viewports.addDuplicateViewportsBySeriesIndex(seriesLayout.seriesLayoutId.split('_')[0] + "_" + seriesLayout.seriesLayoutId.split('_')[1] + "_" + (isMultiFrame ? imageNumber : seriesNo), seriesLayout);
        }

        var viewportElementIds = dicomViewer.viewports.getViewportIds();
        for (var i = 0; i < viewportElementIds.length; i++) {
            $("#" + viewportElementIds[i]).removeClass('selected-view').addClass('default-view');
        }
        $("#" + seriesLayout.seriesLayoutId).trigger("click", [studyUid]);
        if (image !== undefined) {
            $("#" + seriesLayout.seriesLayoutId).mousedown(selectViewport);
            $("#" + seriesLayout.seriesLayoutId).mouseover(focusActiveLayout);
            $("#" + seriesLayout.seriesLayoutId).unbind('keydown');
            $("#" + seriesLayout.seriesLayoutId).keydown(keyToMoveNextOrPreviousImage);
        }
        dicomViewer.scroll.stopCineImage(undefined);
        changePlayDirection();
        var imagePromise = dicomViewer.imageCache.getImagePromise(imageUid + "_" + 0);
        if (image.imageType !== IMAGETYPE_JPEG && !isBlob(image.imageType)) {
            if (dicomViewer.isSeriesInComplete(studyUid, seriesNo, imageNumber)) {
                dicomViewer.enableCacheData(studyUid, true);
                dicomViewer.cacheImages(studyUid);
            }
        }
    }

    function getParentElement(childId, parentTag) {
        //remove hashTag at index 0 if it's present
        var child;
        if (childId[0] == "#")
            child = document.getElementById(childId.substring(1));
        else
            child = document.getElementById(childId);
        var parent = child.parentNode;
        while (parent.tagName != parentTag.toUpperCase()) {
            child = parent;
            parent = child.parentNode;
        }
        return parent.id;
    }

    function setActiveSeriesLayout(seriesLayout) {
        if (seriesLayout === undefined) {
            throw "Active series layout should not be null/undefined";
        }
        activeSeriesLayout = seriesLayout;
    }

    function getActiveSeriesLayout() {
        return activeSeriesLayout;
    }

    function keyToMoveNextOrPreviousImage(event) {
        if (event.keyCode === 40) //down key
        {
            setTimeout(function () {
                moveToNextOrPreviousImage(true);
            }, 0);
        } else if (event.keyCode === 38) //Up Key
        {
            setTimeout(function () {
                moveToNextOrPreviousImage(false);
            }, 0);
        }
    }

    /**
     * check whether the image has the multiframe or not
     * @param {Type} image - it specifies the image properties
     */
    function canMoveSeries(image) {
        if (!dicomViewer.thumbnail.canRunCine(image)) {
            return (image.modality == "US") ? true : false;
        } else {
            return true;
        }
    }

    /**
     * If the measurement is not completed then it will complete that measurement
     * @param {Type} evt - scroll event
     */
    function completeMeasurement(evt) {
        var toolName = dicomViewer.mouseTools.getToolName();
        if (toolName === "pointMeasurement" || toolName === "lineMeasurement" || toolName === "angleMeasurement" ||
            toolName === 'traceMeasurement' || toolName === 'volumeMeasurement' || toolName === 'ellipseMeasurement' ||
            toolName === 'rectangleMeasurement' || toolName === 'mitralMeanGradientMeasurement') {
            tool = dicomViewer.mouseTools.getActiveTool();
            tool.hanleMouseOut(evt);
        }
    }

    function scroll(event) {
        event.preventDefault();
        var serieLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid;
        if (serieLayout !== undefined && serieLayout !== null) {
            studyUid = serieLayout.getStudyUid();
            if ((isToPlayStudy(serieLayout.getSeriesLayoutId()) && (isCineRunning(serieLayout.getSeriesLayoutId())))) {
                return;
            }
        }

        completeMeasurement(event);

        var render = undefined;
        if (serieLayout.imageType === IMAGETYPE_RADSR || serieLayout.imageType === IMAGETYPE_CDA) {
            render = serieLayout.imageRenders["srReport"];
        } else {
            render = serieLayout.imageRenders[serieLayout.seriesLayoutId + "ImageLevel0x0"];
        }
        var scrollDown = event.originalEvent.wheelDelta < 0 || event.originalEvent.detail > 0;
        var playerButtomImage = document.getElementById("playButton_wrapper").getElementsByTagName('img')[0].src;
        if (serieLayout.imageType === IMAGETYPE_TIFF || serieLayout.imageType === IMAGETYPE_PDF || serieLayout.imageType === IMAGETYPE_RADPDF ||
            serieLayout.imageType === IMAGETYPE_RADSR || serieLayout.imageType === IMAGETYPE_CDA ||
            serieLayout.imageType === IMAGETYPE_RADECG || serieLayout.imageType === IMAGETYPE_RADPDF ||
            serieLayout.seriesIndex === undefined || render.imageIndex === undefined) {
            return;
        }
        var image = dicomViewer.Series.Image.getImage(studyUid, serieLayout.seriesIndex, render.imageIndex);

        /* if (dicomViewer.mouseTools.getToolName() === 'Zoom') {
             return;
              //When zoom function in active disabling scroll image feature Zoom feature is based on mouse wheel event
         }*/
        var scrollDown = event.originalEvent.wheelDelta < 0 || event.originalEvent.detail > 0;
        var playerButtomImage = document.getElementById("playButton_wrapper").getElementsByTagName('img')[0].src;
        var isImageThumbnails = dicomViewer.thumbnail.isImageThumbnail(image, false);
        if ((canMoveSeries(image)) && ((isImageThumbnails && (isCineRunning(serieLayout.seriesLayoutId) || (image.numberOfFrames === 1))) || (dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, serieLayout.seriesIndex) && image.numberOfFrames === 1))) {
            dicomViewer.tools.moveSeries(scrollDown);
        } else {
            moveToNextOrPreviousImage(scrollDown);
        }

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

    function getCurrentImageAndFrameIndex(moveToNext, seriesLayout) {
        // Frame Index must be calculate using the visibility of the ImageLevel viewports.
        var lastImageFrame;
        if (moveToNext) {
            lastImageFrame = $("#" + seriesLayout.getSeriesLayoutId() + " div:last").attr("id");
        } else {
            lastImageFrame = $("#" + seriesLayout.getSeriesLayoutId() + " div:first").attr("id");
        }

        var imageRender = seriesLayout.getImageRender(lastImageFrame);

        var imageIndex = null;
        if (imageRender != undefined) {
            var anUIDs = imageRender.anUIDs;
            var resultArray = anUIDs.split("*");
            var frameIndex = parseInt(resultArray[1]);

            //imageIndex = seriesLayout.getImageIndex();
            imageIndex = imageRender.imageIndex;
        }
        if (imageIndex === null || imageIndex === undefined || imageIndex === -1) {
            imageIndex = seriesLayout.getImageIndex();
        }
        return [imageIndex, frameIndex];
    }

    /**
     * - Move the Next or Previous Image. Boolean argument will decide whether it is move Next or Previous image. 
     */
    function moveToNextOrPreviousImage(moveToNext, linkedSeriesLayout, navigatePos, useStartPosition) {
        endMeasurement();
        var seriesLayout = undefined;
        if (linkedSeriesLayout !== undefined) {
            seriesLayout = linkedSeriesLayout;
        } else {
            seriesLayout = getActiveSeriesLayout();
        }

        var studyUid = seriesLayout.studyUid;
        var seriesIndex = seriesLayout.getSeriesIndex();
        var imageLayoutCount = seriesLayout.getImageLayoutCount();
        var numberOfImages = dicomViewer.Series.getImageCount(studyUid, seriesIndex);

        var imageAndFrameIndex = getCurrentImageAndFrameIndex(moveToNext, seriesLayout);
        var imageIndex = imageAndFrameIndex[0];
        var frameIndex = imageAndFrameIndex[1];

        var frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex));
        if (frameCount === undefined) {
            return;
        }

        var isSeriesHasMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);

        var imagePos = 0;
        if (navigatePos === undefined) {
            imagePos = 1;
        } else {
            if (navigatePos.xDiff !== undefined) {
                var perImageWidth = Math.ceil($("#" + seriesLayout.getSeriesLayoutId()).width() / (isSeriesHasMultiframe ? frameCount : numberOfImages));
                if (navigatePos.xDiff >= perImageWidth) {
                    imagePos = Math.ceil(navigatePos.xDiff / perImageWidth);
                }
            } else if (navigatePos.yDiff !== undefined) {
                var perImageHeight = Math.ceil($("#" + seriesLayout.getSeriesLayoutId()).height() / (isSeriesHasMultiframe ? frameCount : numberOfImages));
                if (navigatePos.yDiff >= perImageHeight) {
                    imagePos = Math.ceil(navigatePos.yDiff / perImageHeight);
                }
            }
        }

        var lastDivId = $("#" + seriesLayout.getSeriesLayoutId() + " div:last").attr("id");
        var firstDivId = $("#" + seriesLayout.getSeriesLayoutId() + " div:first").attr("id");
        if (moveToNext) {
            if (isSeriesHasMultiframe) {
                var imageRenders = seriesLayout.imageRenders;
                var firstFrameIndex = -1;
                var lastFrameIndex = 0;
                if (imageRenders !== undefined) {
                    var imageRender = imageRenders[firstDivId];
                    if (imageRender !== undefined)
                        firstFrameIndex = parseInt(imageRender.anUIDs.split("*")[1]);
                    imageRender = imageRenders[lastDivId];
                    if (imageRender !== undefined)
                        lastFrameIndex = parseInt(imageRender.anUIDs.split("*")[1]);
                    if (frameCount === lastFrameIndex + 1) {
                        return;
                    } else {
                        if (useStartPosition) {
                            firstFrameIndex = navigatePos.frameIndex;
                        }
                        frameIndex = firstFrameIndex + imagePos;
                    }
                }
            } else {
                var imageRenders = seriesLayout.imageRenders;
                var lastImageIndex = 0;
                if (imageRenders !== undefined) {
                    var imageRender = imageRenders[firstDivId];
                    if (imageRender === undefined)
                        imageIndex = -1;
                    else
                        imageIndex = imageRender.imageIndex;
                    imageRender = imageRenders[lastDivId];
                    if (imageRender === undefined)
                        lastImageIndex = -1;
                    else
                        lastImageIndex = imageRender.imageIndex;

                    if (numberOfImages === lastImageIndex + 1) {
                        return;
                    } else {
                        if (useStartPosition) {
                            imageIndex = navigatePos.imageIndex;
                        }
                        imageIndex = imageIndex + imagePos;
                    }
                }
            }

        } else {
            if (isSeriesHasMultiframe) {
                var imageRenders = seriesLayout.imageRenders;
                if (imageRenders !== undefined) {
                    var firstFrameIndex = 1;
                    var imageRender = imageRenders[firstDivId];
                    if (imageRender !== undefined)
                        firstFrameIndex = parseInt(imageRender.anUIDs.split("*")[1]);
                    if (firstFrameIndex <= 0) {
                        return;
                    } else {
                        if (useStartPosition) {
                            firstFrameIndex = navigatePos.frameIndex;
                        }
                        frameIndex = firstFrameIndex - imagePos;
                    }
                }
            } else {
                var imageRenders = seriesLayout.imageRenders;
                if (imageRenders !== undefined) {
                    var imageRender = imageRenders[firstDivId];
                    if (imageRender !== undefined)
                        imageIndex = imageRender.imageIndex;
                    if (imageIndex <= 0) {
                        return;
                    } else {
                        if (useStartPosition) {
                            imageIndex = navigatePos.imageIndex;
                        }
                        imageIndex = imageIndex - imagePos;
                    }
                }

            }
        }

        if (isSeriesHasMultiframe) {
            if (frameIndex < 0) {
                return;
            }
        } else if(imageIndex < 0 ) {
            return;
        }

        loadimages(seriesLayout, seriesIndex, imageIndex, frameIndex, undefined, isSeriesHasMultiframe);

        // Perform the link operation
        if (linkedSeriesLayout === undefined) {
            dicomViewer.link.doLink(seriesLayout, moveToNext);
        }

        //Move to next frame/image
        seriesLayout.setImageIndex(imageIndex);
        seriesLayout.setFrameIndex(frameIndex);

        //Enable or disable the Next/Previous series, and Next/Previous image and repeat series
        EnableDisableNextSeriesImage(seriesLayout);

        var toolName = dicomViewer.mouseTools.getToolName();
        var activeTool = dicomViewer.mouseTools.getActiveTool();
        if (activeTool) {
            activeTool = activeTool.measurementData
        }
        activeTool = (activeTool) ? activeTool.measurementSubType : undefined;

        if (toolName == "lineMeasurement" && activeTool == undefined) {
            var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.getImageIndex());
            if (seriesLayout && image) {
                setDefaultCursorType(image.modality, seriesLayout);
            } else {
                dicomViewer.tools.do2DMeasurement({
                    id: "0"
                });
            }

        } else if (toolName == "ellipseMeasurement" && activeTool == "hounsfield") {
            dicomViewer.tools.do2DMeasurement({
                id: "7"
            });
        } else if (toolName == "rectangleMeasurement" && activeTool == "hounsfield") {
            dicomViewer.tools.do2DMeasurement({
                id: "14"
            });
        }

    }

    function pauseCinePlay(runStatus, isAllLayout) {
        if (isAllLayout === true) {
            for (var key in cineManager) {
                if (cineManager[key] !== undefined)
                    cineManager[key].status = runStatus;
            }
        } else {
            cineManager[getActiveSeriesLayout().seriesLayoutId].status = runStatus;
        }
        var layoutId = getActiveSeriesLayout().seriesLayoutId;
        if (cineManager[layoutId] !== undefined && cineManager[layoutId].status === CINEPAUSE)
            showCineRate(0);
        if (isCineRunning(layoutId)) {
            if (runStatus === CINEPAUSE)
                updatePlayIcon("stop.png", "play.png");
            else
                updatePlayIcon("play.png", "stop.png");
        }
    }

    function stopCineImage(direction, linkedSeriesLayout) {
        var activeSeriesLayout = undefined;
        if (linkedSeriesLayout !== undefined) {
            activeSeriesLayout = linkedSeriesLayout;
        } else {
            activeSeriesLayout = getActiveSeriesLayout();
        }

        // Perform the link operation
        if (linkedSeriesLayout === undefined) {
            dicomViewer.link.doLink(activeSeriesLayout, false, direction, false);
        }

        var layoutId = activeSeriesLayout.seriesLayoutId;
        var studyUid = activeSeriesLayout.getStudyUid();
        var modality = dicomViewer.Series.getModality(studyUid, activeSeriesLayout.seriesIndex);
        if (cineManager[activeSeriesLayout.seriesLayoutId] !== undefined) {
            clearInterval(cineManager[activeSeriesLayout.seriesLayoutId].timer);
            cineManager[activeSeriesLayout.seriesLayoutId].timer = null;
            showOrHideInCineRunning(modality, false);

            //Disabling the tool bar buttons again as per the modality because the previous method making the tool bar enable again as cine is in stop mode
            enableOrDisableTools(modality, activeSeriesLayout);
        }
        showCineRate(0);
        myDropDown.wrapper.hide();
        $("#" + layoutId).focus();

        var firstImageFrame = $("#" + activeSeriesLayout.getSeriesLayoutId() + " div:first").attr("id");
        var imageRender = activeSeriesLayout.getImageRender(firstImageFrame);
        var currentImageIndex = null;
        var currentFrameIndex = null;
        if (imageRender != undefined) {
            var anUIDs = imageRender.anUIDs;
            var resultArray = anUIDs.split("*");
            currentFrameIndex = parseInt(resultArray[1]);
            currentImageIndex = imageRender.imageIndex;
        } else {
            currentImageIndex = activeSeriesLayout.getImageIndex();
            currentFrameIndex = activeSeriesLayout.getFrameIndex();
        }

        activeSeriesLayout.setImageIndex(currentImageIndex);
        activeSeriesLayout.setFrameIndex(currentFrameIndex);
    }

    function isCineRunning(seriesLayoutId) {
        if (cineManager[seriesLayoutId] !== undefined) {
            if (cineManager[seriesLayoutId].timer) {
                return true;
            }
        }
        return false;
    }

    function startCine() {
        var activeSeriesLayout = getActiveSeriesLayout();
        var seriesLayoutId = activeSeriesLayout.getSeriesLayoutId();
        var studyUid = activeSeriesLayout.getStudyUid();
        var modality = dicomViewer.Series.getModality(studyUid, activeSeriesLayout.seriesIndex);
        var direction = true;
        if (cineManager[seriesLayoutId] != undefined)
            direction = cineManager[seriesLayoutId].direction;
        if (activeSeriesLayout.imageType === IMAGETYPE_RADECHO || modality === "XA") {
            if (!isCineRunning(seriesLayoutId)) {
                runCineImage(direction);
            }
        } else {
            if (!isCineRunning(seriesLayoutId)) {
                runCineImage(direction);
            }
            showOrHideInCineRunning(modality, true);
        }
        EnableDisableNextSeriesImage(activeSeriesLayout);
    }

    /**
     * Play/Stop the Cine on mouse wheel click
     */
    function toggleCineRunning() {
        endMeasurement();
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var seriesLayoutId = seriesLayout.getSeriesLayoutId();
        var studyUid = seriesLayout.getStudyUid();
        var seriesIndex = seriesLayout.getSeriesIndex();
        var imageIndex = seriesLayout.getImageIndex();
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
        if (isMultiFrame === true) {
            imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
        } else {
            imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
        }
        if ((imageCount <= 1 && !dicomViewer.scroll.isToPlayStudy(seriesLayout.seriesLayoutId)) || imageCount <= 4) {
            return;
        }
        var direction = true;
        if (cineManager[seriesLayoutId] != undefined && cineManager[seriesLayoutId].direction != undefined)
            direction = cineManager[seriesLayoutId].direction;
        if (isCineRunning(seriesLayoutId)) {
            stopCineImage(direction);
            updatePlayIcon("stop.png", "play.png");
            UpdateImageType();
        } else {
            runCineImage(direction);
            updatePlayIcon("play.png", "stop.png");
        }
        //Toggling the state of the Next and Previous Image/Series Button on mouse wheel click
        EnableDisableNextSeriesImage(seriesLayout);
    }

    function isCineRunningOnAnyViewPort() {
        for (var key in cineManager) {
            if (cineManager[key] !== undefined) {
                if (cineManager[key].timer) {
                    return true;
                }
            }
        }
        return false;
    }

    function showCineRate(cineRate) {
        var rate = "0";
        if (cineRate !== undefined) {
            rate = cineRate;
        }
        if (isNaN(rate))
            rate = 0;
        document.getElementById("cineRateDisplay").innerHTML = Math.round(rate / 1000) + " FPS";
    }

    function onCineSpeedChange() {
        var seriesLayout = getActiveSeriesLayout();
        if (cineManager[seriesLayout.seriesLayoutId] === undefined) {
            cineManager[seriesLayout.seriesLayoutId] = {};
        }
        cineManager[seriesLayout.seriesLayoutId].speed = $("#cineSpeedButton").val();
    };

    /**
     * To check whether any dialog window is open or not
     */
    function isDialogOpen() {
        var visible = false;
        if ($('#dicomHeader').is(':visible')) {
            visible = true;
        } else if ($('#imagingData').is(':visible')) {
            visible = true;
        } else if ($('#viewerVersionInfoModal').is(':visible')) {
            visible = true;
        }
        if (visible) {
            updatePlayIcon("stop.png", "play.png");
        }
        return visible;
    }

    function runCineImage(direction, linkedSeriesLayout) {
        var seriesLayout = undefined;
        if (linkedSeriesLayout !== undefined) {
            seriesLayout = linkedSeriesLayout;
        } else {
            seriesLayout = getActiveSeriesLayout();
        }

        if (seriesLayout && seriesLayout.imageType == IMAGETYPE_JPEG) {
            return;
        }

        var perviousMilliSec;
        var frameRatePerSec;
        var tempmilliSec;
        var tempdiff = 0;
        var frameCountForFPS = 0;
        var imageLayoutCount = seriesLayout.getImageLayoutCount();
        var seriesIndex = seriesLayout.getSeriesIndex();
        var imageIndex = seriesLayout.getImageIndex(); //imageAndFrameIndex[0];
        var frameIndex = seriesLayout.getFrameIndex(); //imageAndFrameIndex[1];
        var studyUid = seriesLayout.studyUid;
        var modality = dicomViewer.Series.getModality(studyUid, seriesLayout.seriesIndex);
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        var frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
        var imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
        var seriesCount = dicomViewer.Study.getSeriesCount(studyUid);
        var isMultiFrame = dicomViewer.thumbnail.isImageThumbnail(image);
        if (cineManager[seriesLayout.seriesLayoutId] === undefined) {
            cineManager[seriesLayout.seriesLayoutId] = {};
            var playBy = dicomViewer.configuration.cine.getCinePlayBy();
            if (playBy == "Study") {
                cineManager[seriesLayout.seriesLayoutId].playStudy = true;
                dicomViewer.configuration.cine.setCinePlayBy(playBy);
            }
        }
        cineManager[seriesLayout.seriesLayoutId].direction = direction;
        cineManager[seriesLayout.seriesLayoutId].status = CINERUN;
        clearInterval(cineManager[seriesLayout.seriesLayoutId].timer); // clear interval

        var imageUid = dicomViewer.Series.Image.getImageUid(image);
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
        var cineRate = $("#cineSpeedButton").val();
        var cineRepeatForImage = 1;
        var expectedCineRate;
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
        if (dicomHeader !== undefined) {
            cineRate = dicomHeader.imageInfo.cineRate;
            if (cineRate === 0 && ((dicomHeader.imageInfo.numberOfFrames > 1 && isMultiFrame) ||
                    !isMultiFrame && imageCount > 1)) {
                cineRate = $("#cineSpeedButton").val();
                if (myDropDown !== null) {
                    if (cineManager[seriesLayout.seriesLayoutId] !== undefined && cineManager[seriesLayout.seriesLayoutId].speed !== undefined) {
                        myDropDown.value(cineManager[seriesLayout.seriesLayoutId].speed);
                    }
                }
            } else {
                if (myDropDown !== null) {
                    myDropDown.wrapper.hide();
                }
            }
        } else {
            if (cineManager[seriesLayout.seriesLayoutId].speed === undefined) {
                cineRate = $("#cineSpeedButton").val();
            } else {
                cineRate = cineManager[seriesLayout.seriesLayoutId].speed;
            }
        }

        expectedCineRate = cineRate;
        cineRate = 1000 / cineRate;
        cineManager[seriesLayout.seriesLayoutId].cineRate = cineRate;
        cineManager[seriesLayout.seriesLayoutId].nextImageStart = true;
        seriesLayout.setSeriesIndex(seriesIndex);
        seriesLayout.setImageIndex(imageIndex);
        seriesLayout.setStudyUid(studyUid);
        showOrHideInCineRunning(modality, true);

        // Perform the link operation
        if (linkedSeriesLayout === undefined) {
            dicomViewer.link.doLink(seriesLayout, false, direction, true);
        }

        var moveSeries = false;
        var cineFunc = function (seriesLayout) {
            if (isDialogOpen()) {
                return;
            }
            var startTime = new Date().getTime();
            if (cineManager[seriesLayout.seriesLayoutId].timer !== null && cineManager[seriesLayout.seriesLayoutId].nextImageStart == true && cineManager[seriesLayout.seriesLayoutId].status === CINERUN) {
                cineManager[seriesLayout.seriesLayoutId].nextImageStart = false;
                var isToPlayStudyEnabled = isToPlayStudy(seriesLayout.seriesLayoutId);
                if (frameCount === undefined) {
                    return;
                } else {
                    image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                    if (seriesIndex != seriesLayout.seriesIndex) {
                        imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                        isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex);
                        frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
                    }

                    var isLoaded = loadimages(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, isMultiFrame);
                    if (isToPlayStudyEnabled) {
                        var isUpdate = false;
                        var currentSeriesLayout = seriesLayout.imageLayoutDimension.split("x");
                        if (currentSeriesLayout.length > 1) {
                            if (isMultiFrame) {
                                if (direction == true) {
                                    isUpdate = ((frameIndex + 1) == frameCount) || frameIndex == 0 ? true : false;
                                } else {
                                    isUpdate = (frameIndex - 1) == frameCount || frameIndex == 0 ? true : false;
                                }
                            } else {
                                if (direction == true) {
                                    isUpdate = ((imageIndex + 1) == imageCount) || imageIndex == 0 ? true : false;
                                } else {
                                    isUpdate = ((imageIndex - 1) == imageCount) || imageIndex == 0 ? true : false;
                                }
                            }
                        }

                        if ((repeatSeriesIndex !== seriesIndex && isUpdate) ||
                            (isMultiFrame && repeatImageIndex !== imageIndex && isUpdate)) {
                            repeatSeriesIndex = seriesIndex;
                            repeatImageIndex = imageIndex;
                            setImageLevelLayout(studyUid, currentSeriesLayout[0], currentSeriesLayout[1], seriesLayout.seriesLayoutId, seriesLayout, seriesIndex, imageIndex, frameIndex, true);
                            var imagecnt = isMultiFrame ? frameCount : imageCount;
                            var studyDiv = getStudyLayoutId(seriesLayout.seriesLayoutId);

                            if (imagecnt == 1) {
                                $('#imageDisplay' + studyDiv).hide();
                            } else {
                                $('#imageDisplay' + studyDiv).show();
                            }

                            showOrHideInCineRunning(modality, true);
                            if (seriesLayout.getSeriesLayoutId() === dicomViewer.getActiveSeriesLayout().getSeriesLayoutId()) {
                                seriesLayout.setSeriesIndex(seriesIndex);
                                seriesLayout.setImageIndex(imageIndex);
                                seriesLayout.setStudyUid(studyUid);
                                if (!isNonDicomStudy(image.modality)) {
                                    updateThumbnailSelection(image, seriesIndex, imageIndex, studyUid, moveSeries);
                                }
                                moveSeries = false;
                            }
                        }
                    }
                    if (!isLoaded) {
                        cineManager[seriesLayout.seriesLayoutId].nextImageStart = true;
                        return;
                    }
                    dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
                    cineRate = $("#cineSpeedButton").val();
                    if (dicomHeader !== undefined) {
                        cineRate = dicomHeader.imageInfo.cineRate;
                        if (cineRate === 0) {
                            if (cineManager[seriesLayout.seriesLayoutId].speed === undefined) {
                                cineRate = $("#cineSpeedButton").val();
                            } else {
                                cineRate = cineManager[seriesLayout.seriesLayoutId].speed;
                            }
                        }
                    } else {
                        if (cineManager[seriesLayout.seriesLayoutId].speed === undefined) {
                            cineRate = $("#cineSpeedButton").val();
                        } else {
                            cineRate = cineManager[seriesLayout.seriesLayoutId].speed;
                        }
                    }
                    expectedCineRate = cineRate;
                    cineRate = 1000 / cineRate;
                    cineManager[seriesLayout.seriesLayoutId].cineRate = cineRate;
                }

                if (isMultiFrame && frameCount === 1 || !isMultiFrame && imageCount === 1) {
                    if (isToPlayStudyEnabled) {
                        cineRate = (dicomViewer.configuration.cine.getIdleTime()) * 1000;
                        cineManager[seriesLayout.seriesLayoutId].cineRate = cineRate;
                    } else {
                        return;
                    }
                }
                if (direction) {
                    if ((isMultiFrame && frameIndex < (frameCount - 1)) || (!isMultiFrame && imageIndex < (imageCount - 1))) {
                        if (isMultiFrame) {
                            frameIndex++;
                        } else {
                            imageIndex++;
                        }
                    } else {
                        var imageOrFrameCount = isMultiFrame ? frameCount : imageCount;
                        if (imageOrFrameCount <= 1 || (imageOrFrameCount > 1 && isToPlayStudyEnabled)) {
                            if (cineRepeatForImage < dicomViewer.configuration.cine.getTimesToRepeat() &&
                                imageOrFrameCount <= dicomViewer.configuration.cine.getFramesToRepeat() && imageOrFrameCount > 1) {
                                cineRepeatForImage++;
                            } else {
                                cineRepeatForImage = 1;
                                imageIndex++;
                                if (isMultiFrame) {
                                    moveSeries = true;
                                }
                                image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                            }
                        }
                        var imagelayout = seriesLayout.imageLayoutDimension.split("x");
                        if (imagelayout.length == 2) {
                            if (imagelayout[0] == "2" && imagelayout[1] == "2") {
                                if (imageIndex == frameIndex - 3) {
                                    imageIndex = imageCount;
                                }
                            } else if (imagelayout[0] != "1" || imagelayout[1] != "1") {
                                if (imageIndex == frameIndex - 1) {
                                    imageIndex = imageCount;
                                }
                            }
                        }
                        if (!isMultiFrame && imageIndex == (imageCount - 1) && imageOrFrameCount > 1) {
                            imageIndex = 0;
                        }
                        if (imageIndex >= imageCount) {
                            imageIndex = 0;
                            if (isToPlayStudyEnabled) {
                                seriesIndex++;
                                moveSeries = true;
                                if (seriesIndex >= seriesCount) seriesIndex = 0;
                                imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                                image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                                imageUid = dicomViewer.Series.Image.getImageUid(image);
                                isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);
                            }
                        }
                        frameIndex = 0;
                        frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex));
                    }
                } else {
                    if ((isMultiFrame && frameIndex > 0) || (!isMultiFrame && imageIndex > 0)) {
                        if (isMultiFrame) {
                            frameIndex--;
                            seriesLayout.getProgressbar().updateImagePosition(frameCount, frameIndex);
                        } else {
                            imageIndex--;
                        }
                    } else {
                        var imageOrFrameCount = isMultiFrame ? frameCount : imageCount;
                        if (imageOrFrameCount <= 1 || (imageOrFrameCount > 1 && isToPlayStudyEnabled)) {
                            if (cineRepeatForImage < dicomViewer.configuration.cine.getTimesToRepeat() &&
                                imageOrFrameCount <= dicomViewer.configuration.cine.getFramesToRepeat() && imageOrFrameCount > 1) {
                                cineRepeatForImage++;
                            } else {
                                cineRepeatForImage = 1;
                                imageIndex--;
                                if (isMultiFrame) {
                                    moveSeries = true;
                                }
                                image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                            }
                        }
                        if (!isMultiFrame && imageIndex == 0 && imageOrFrameCount > 1) {
                            imageIndex = imageCount - 1;
                        }
                        if (imageIndex < 0) {
                            if (isToPlayStudyEnabled) {
                                seriesIndex--;
                                moveSeries = true;
                                if (seriesIndex < 0) seriesIndex = seriesCount - 1;
                                imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                                imageIndex = imageCount - 1;
                                image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
                                imageUid = dicomViewer.Series.Image.getImageUid(image);
                            }
                            // Image count should calculate for new Series Index images.
                            imageIndex = imageCount - 1;
                        }
                        frameCount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex));
                        frameIndex = frameCount - 1;
                    }
                }
                //Displaying Cine Rate for multiframe images
                if (seriesLayout.seriesLayoutId == getActiveSeriesLayout().seriesLayoutId) {
                    var index = isMultiFrame ? frameIndex : imageIndex;
                    if (index == 1) {
                        tempdiff = 0;
                        frameCountForFPS = 0;
                        if (perviousMilliSec == undefined) {
                            perviousMilliSec = new Date().getTime();
                        }
                    } else {
                        //Stop the cine and play again will go inside if 
                        if (perviousMilliSec == undefined) {
                            perviousMilliSec = new Date().getTime();
                            frameCountForFPS = 0;
                        } else {
                            frameCountForFPS++;
                            var currentTime = new Date().getTime();
                            tempmilliSec = currentTime - perviousMilliSec;
                            tempdiff = tempdiff + tempmilliSec;
                        }
                    }

                    if (index != 0) {
                        frameRatePerSec = Math.round((frameCountForFPS * 1000) / tempdiff);
                    } else {
                        frameRatePerSec = 1;
                    }

                    if (frameRatePerSec != undefined) {
                        if (isNaN(frameRatePerSec)) {
                            frameRatePerSec = 0;
                        }
                        document.getElementById("cineRateDisplay").innerText = Math.round(frameRatePerSec) + "/ " + Math.round(expectedCineRate) + " FPS";
                    }
                    perviousMilliSec = new Date().getTime();
                }

                if (seriesLayout.getProgressbar().seriesIndex != seriesIndex || seriesLayout.getProgressbar().imageIndex != imageIndex) {
                    seriesLayout.getProgressbar().setSeriesInfo(studyUid, seriesIndex, imageIndex, 0);
                }

                if (cineManager[seriesLayout.seriesLayoutId].timer != null || cineManager[seriesLayout.seriesLayoutId].timer != undefined) {
                    clearInterval(cineManager[seriesLayout.seriesLayoutId].timer); // clear interval 
                    var timeDiff = new Date().getTime() - startTime;
                    cineRate = Math.abs(cineRate - timeDiff);

                    if (cineRate <= 0 || (image && isNonDicomStudy(image.modality))) {
                        cineRate = 1;
                    }
                    cineManager[seriesLayout.seriesLayoutId].timer = setInterval(cineFunc, cineRate, seriesLayout);
                }
            }
        }

        cineManager[seriesLayout.seriesLayoutId].timer = setInterval(cineFunc, cineRate, seriesLayout);
    }

    function getImageIndex(seriesIndex, imageIndex, frameIndex) {
        while (frameIndex > 0) {
            var count = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(seriesIndex, imageIndex++));
            if (count === undefined) {
                return count;
            }
            frameIndex -= count;
        }
        return imageIndex - 1;
    }

    function getImageIndexOfFrame(studyUid, seriesIndex, imageIndex, nextFramesCount) {
        while (nextFramesCount > 0) {
            nextFramesCount -= dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, --imageIndex));
        }
        return imageIndex; //Adding one for extra deduce in while loop
    }

    function getNextDownScrollCount(seriesIndex, imageIndex, frameIndex) {
        while (frameIndex < 0) {
            frameIndex += dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(seriesIndex, --imageIndex));
        }
        return imageIndex;
    }

    function getScrollDownFrameCount(studyUid, seriesIndex, imageIndex) {
        var count = 0;
        for (var i = --imageIndex; i >= 0; i--) {
            count += dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, i));
        }
        return count;
    }

    function getNextUpScrollCount(studyUid, seriesIndex, imageIndex) {
        var count = 0;
        for (var i = imageIndex; i < dicomViewer.Series.getImageCount(studyUid, seriesIndex); i++) {
            var framecount = dicomViewer.Series.Image.getImageFrameCount(dicomViewer.Series.Image.getImage(studyUid, seriesIndex, i));
            if (framecount === undefined) {
                return count;
            }
            count += framecount;
        }
        return count;
    }

    function loadImagesInViewport(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, imageLevelLayoutIndex) {
        var studyUid = seriesLayout.getStudyUid();
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        if (image === undefined)
            return;
        var frameCount = dicomViewer.Series.Image.getImageFrameCount(image);

        if (frameIndex >= frameCount) {
            dumpConsoleLogs(LL_DEBUG, undefined, "loadImagesInViewport", "FrameIndex > FrameCount, considering it as Non-Multiframe image.");
            if (frameCount <= 1 || isToPlayStudyEnabled === undefined || isToPlayStudyEnabled) {
                imageIndex++;
                var imageCount = dicomViewer.Series.getImageCount(studyUid, seriesIndex);
                if (imageIndex >= imageCount) imageIndex = 0;
            }
            frameIndex = 0;

            if (frameCount > 1) {
                seriesLayout.getProgressbar().setSeriesInfo(studyUid, seriesIndex, imageIndex, 0);
            }
        }

        var imageLevelId = $("#" + seriesLayout.getSeriesLayoutId() + " div")[imageLevelLayoutIndex].id;
        var imageRender = seriesLayout.getImageRender(imageLevelId);
        imageIndex = Math.min(imageIndex, dicomViewer.Series.getImageCount(studyUid, seriesIndex) - 1);
        imageIndex = Math.max(0, imageIndex);
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        if (image != undefined && imageRender !== undefined) {
            var imageUid = dicomViewer.Series.Image.getImageUid(image);
            var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(studyUid, seriesIndex);

            var loadImageDeferred;
            var requestData = {
                studyUid: studyUid,
                seriesIndex: seriesIndex,
                imageIndex: imageIndex,
                frameIndex: frameIndex,
                imageUid: imageUid,
                imageType: image.imageType,
                layoutId: seriesLayout.seriesLayoutId
            };
            loadImageDeferred = dicomViewer.getImage(requestData);

            loadImageDeferred.done(function (imageCanvas) {
                var deferred = $.Deferred();
                deferred.resolve(imageCanvas);
                var anUIDs = imageCanvas.imageUid + "*" + imageCanvas.frameNumber;
                var newImageIndex = parseInt(dicomViewer.Series.Image.getImageIndex(studyUid, seriesIndex, imageCanvas.imageUid));
                imageRender.refresh(deferred, anUIDs, false, newImageIndex, seriesIndex, isToPlayStudyEnabled);
                updateActiveProgressbar(seriesLayout, newImageIndex, imageCanvas.frameNumber);
                imageLevelLayoutIndex++;
                if ($("#" + seriesLayout.getSeriesLayoutId() + " div").length === imageLevelLayoutIndex) {
                    seriesLayout.setSeriesIndex(seriesIndex);
                    if (cineManager[seriesLayout.seriesLayoutId] != undefined)
                        cineManager[seriesLayout.seriesLayoutId].nextImageStart = true;
                }
                // Need to increase the frameIndex or imageIndex based on modality type.
                if ($("#" + seriesLayout.getSeriesLayoutId() + " div").length > 0) {
                    if (dicomViewer.thumbnail.isImageThumbnail(image)) {
                        frameIndex++;
                        dumpConsoleLogs(LL_DEBUG, undefined, "loadImagesInViewport", "Increased the FrameIndex to: " + frameIndex);
                    } else if ((dicomViewer.Series.getImageCount(studyUid, seriesIndex) - 1) != imageIndex) {
                        imageIndex++;
                        dumpConsoleLogs(LL_DEBUG, undefined, undefined, "Increased the ImageIndex to: " + imageIndex);
                    }
                }
                if ($("#" + seriesLayout.getSeriesLayoutId() + " div").length > imageLevelLayoutIndex) {
                    loadImagesInViewport(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, imageLevelLayoutIndex);
                }
            });

            loadImageDeferred.fail(function () {
                dumpConsoleLogs(LL_WARN, undefined, "loadImagesInViewport", "Image loading failed for " + imageIndex);
                imageLevelLayoutIndex++;
                if ($("#" + seriesLayout.getSeriesLayoutId() + " div").length > imageLevelLayoutIndex)
                    loadImagesInViewport(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, imageLevelLayoutIndex);
                if ($("#" + seriesLayout.getSeriesLayoutId() + " div").length === imageLevelLayoutIndex) {
                    seriesLayout.setSeriesIndex(seriesIndex);
                    seriesLayout.setImageIndex(newImageIndex);
                    seriesLayout.setFrameIndex(imageCanvas.frameNumber);
                    if (cineManager[seriesLayout.seriesLayoutId] != undefined)
                        cineManager[seriesLayout.seriesLayoutId].nextImageStart = true;
                }
            });
        }
    }

    /**
     * Load images is used to load the image using imageIndex and FrameIndex.
     * This method will loop the Series Layout id and load the images.
     */
    function loadimages(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, isMultiFrame) {
        var isToPlayStudyEnabled = isToPlayStudy(seriesLayout.seriesLayoutId);
        var imageLayout = $("#" + seriesLayout.getSeriesLayoutId() + " div")[0];
        if (imageLayout === undefined) {
            return false;
        }

        var imageLevelId = imageLayout.id;
        if (imageLevelId === "") return false;

        var viewportCount = $("#" + seriesLayout.getSeriesLayoutId() + " div").length;
        if (viewportCount > 0) {
            if (!isMultiFrame) {
                var imageCount = dicomViewer.Series.getImageCount(seriesLayout.studyUid, seriesIndex);
                if (((imageIndex + viewportCount) >= imageCount) && imageCount > viewportCount) {
                    //Updating the image index so that the last image will not copy to other previous viewports in image level layout
                    imageIndex = imageCount - viewportCount;
                }
            }
            loadImagesInViewport(seriesLayout, seriesIndex, imageIndex, frameIndex, isToPlayStudyEnabled, 0);
        }
        return true;
    }

    /**
     * Update the thumbnail selection.
     */
    function updateThumbnailSelection(image, activeSeriesIndex, activeImageIndex, studyUid, moveSeries) {
        var selectThumbnailId = false;
        if (image == undefined || moveSeries) {
            selectThumbnailId = true;
        }

        if (activeSeriesIndex === undefined || activeSeriesIndex === null) {
            dumpConsoleLogs(LL_WARN, undefined, "updateThumbnailSelection", "activeSeriesIndex is null");
            return;
        }

        if (activeImageIndex === undefined || activeImageIndex === null) {
            dumpConsoleLogs(LL_WARN, undefined, "updateThumbnailSelection", "activeImageIndex is null");
            return;
        }

        if (image === undefined || image === null) {
            image = dicomViewer.Series.Image.getImage(studyUid, activeSeriesIndex, activeImageIndex);
        }
        var frameCount = 0;
        if (image != undefined) {
            frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
        }
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (frameCount > 1) {
            if (seriesLayout.getSeriesIndex() !== activeSeriesIndex || seriesLayout.getImageIndex() !== activeImageIndex) {
                dumpConsoleLogs(LL_WARN, undefined, "updateThumbnailSelection", "activeSeriesIndex/activeImageIndex is mismatched");
                return;
            }
        } else {
            if (seriesLayout.getSeriesIndex() !== activeSeriesIndex) {
                dumpConsoleLogs(LL_WARN, undefined, "updateThumbnailSelection", "activeSeriesIndex is mismatched");
                return;
            }
        }
        var thumbnailId;
        if (frameCount > 1 /*|| (seriesIndex == tempseriesIndex && tempseriesIndex != 0)*/ ) {
            thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + "_thumb" + (activeImageIndex);
        } else {
            thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + "_thumb";
            var element = $(thumbnailId)[0];
            if (element == null || element == undefined) {
                thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + "_thumb" + (activeImageIndex);
            }
        }

        var series = dicomViewer.Series.getSeries(studyUid, activeSeriesIndex, 0);
        var appendThumb = "_thumb";
        if (series.iskeyImageSeries) {
            activeSeriesIndex = series.seriesIndex;
            appendThumb = "_keythumb";
        }

        var thumbnailId;
        if (frameCount > 1 /*|| (seriesIndex == tempseriesIndex && tempseriesIndex != 0)*/ ) {
            thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + appendThumb + (activeImageIndex);
        } else {
            thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + appendThumb;
            var element = $(thumbnailId)[0];
            if (element == null || element == undefined) {
                thumbnailId = "#imageviewer_" + dicomViewer.replaceDotValue(studyUid) + "_" + (activeSeriesIndex) + appendThumb + (activeImageIndex);
            }
        }

        if (!$(thumbnailId).hasClass('selected-thumbnail-view')) {
            $('.selected-thumbnail-view').removeClass('selected-thumbnail-view').addClass('default-thumbnail-view');
            $(thumbnailId).removeClass("default-thumbnail-view").addClass('selected-thumbnail-view');
            dumpConsoleLogs(LL_DEBUG, undefined, "updateThumbnailSelection", "Highlighting selected thumbnail id : " + thumbnailId);
        }

        if (selectThumbnailId && thumbnailId !== undefined) {
            dicomViewer.thumbnail.makeThumbnailVisible(thumbnailId);
        }
    }

    /**
     * Update the progress bar for the active image. The updateImagePosition method will be called the the updateImagePosition and updateCachePosition.
     */
    function updateActiveProgressbar(seriesLayout, imageIndex, frameIndex) {
        var seriesIndex = seriesLayout.getSeriesIndex();
        var studyUid = seriesLayout.getStudyUid();
        var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
        if (image === undefined) {
            return;
        }
        var frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
        if (frameCount === undefined) {
            return;
        }
        if (frameCount > 1) {
            seriesLayout.getProgressbar().updateImagePosition(frameCount, frameIndex);
        } else {
            seriesLayout.getProgressbar().updateImagePosition(dicomViewer.Series.getImageCount(studyUid, seriesIndex), imageIndex);
        }
    }

    /**
     * Setting the Cine play mode as well as the direction of the cine play
     * @param {Type} studyPlayBy - Cine play mode type (Stack/Study)
     */
    function setCinePlayBy(studyPlayBy) {
        var seriesLayout = getActiveSeriesLayout();
        if (cineManager[seriesLayout.seriesLayoutId] === undefined) {
            cineManager[seriesLayout.seriesLayoutId] = {};
        }

        var linkStudyPlay = false;
        var direction = getPlayerDirection();
        setCineDirection(direction);

        if (studyPlayBy === "Study") {
            cineManager[seriesLayout.seriesLayoutId].playStudy = true;
            dicomViewer.configuration.cine.setCinePlayBy("Study");
            linkStudyPlay = true;
        } else {
            cineManager[seriesLayout.seriesLayoutId].playStudy = false;
            dicomViewer.configuration.cine.setCinePlayBy("Stack");
            linkStudyPlay = false;
        }

        // if any series is linked then getting that linked viewport id
        var linkSeriesId = dicomViewer.link.getTargetViewport(seriesLayout);
        if (linkSeriesId !== undefined) {
            if (cineManager[linkSeriesId] === undefined) {
                cineManager[linkSeriesId] = {};
                cineManager[linkSeriesId].direction = direction;
            }

            cineManager[linkSeriesId].playStudy = linkStudyPlay;
        }
    }

    function isToPlayStudy(layoutId) {
        if (cineManager[layoutId] === undefined || cineManager[layoutId].playStudy === undefined) {
            return false;
        }
        return cineManager[layoutId].playStudy;
    }

    function setCineDirection(direction) {
        var seriesLayout = getActiveSeriesLayout();
        if (cineManager[seriesLayout.seriesLayoutId] === undefined) {
            cineManager[seriesLayout.seriesLayoutId] = {};
        }
        cineManager[seriesLayout.seriesLayoutId].direction = direction;
    }

    function removeCineManager(serieslayoutId) {
        if (cineManager[serieslayoutId] !== undefined) {
            clearInterval(cineManager[serieslayoutId].timer);
            delete cineManager[serieslayoutId];
        }
    }

    function getimageCanvasOfViewPort(seriesLayout) {
        return imageCanvasOfViewPorts[seriesLayout];
    }

    function removeimageCanvasOfViewPort(seriesLayout) {
        imageCanvasOfViewPorts[seriesLayout] = undefined;
    }

    function removeimageCanvasOfAllViewPorts(studyLayoutId) {
        for (var key in imageCanvasOfViewPorts) {
            var index = key.indexOf(studyLayoutId);
            if (index >= 0) {

                delete imageCanvasOfViewPorts[key];
            }
        }
    }

    function removeimageCanvasOfAllBackupViewPorts(studyLayoutId) {
        for (var key in imageCanvasOfBackupViewPorts) {
            var index = key.indexOf(studyLayoutId);
            if (index >= 0) {

                delete imageCanvasOfBackupViewPorts[key];
            }
        }
    }

    function setimageCanvasOfViewPort(layoutId, imageCanvas) {
        if (imageCanvas === undefined) delete imageCanvasOfViewPorts[layoutId];
        else imageCanvasOfViewPorts[layoutId] = imageCanvas;
    }

    function removeimageCanvasOfViewPort(layoutId) {
        delete imageCanvasOfViewPorts[layoutId];
    }

    function getimageCanvasOfBackupViewPort(seriesLayout) {
        return imageCanvasOfBackupViewPorts[seriesLayout];
    }

    function setimageCanvasOfBackupViewPort(layoutId, imageCanvas) {
        imageCanvasOfBackupViewPorts[layoutId] = imageCanvas;
    }

    function removeimageCanvasOfBackupViewPort(layoutId) {
        delete imageCanvasOfBackupViewPorts[layoutId];
    }

    function getCurrentSeriesLayoutIds() {
        return currentSeriesLayoutIds;
    }

    function convertDicomDateToDisplayFormat(value) {
        var dicomDate = dicomViewer.changeNullToEmpty(value);
        var displayDate = "";
        if (dicomDate !== "" && dicomDate.length === 8) {
            displayDate = dicomDate.substring(0, 4) + "-" + dicomDate.substring(4, 6) + "-" + dicomDate.substring(6, 8);
        }

        return displayDate;
    }

    function changeSelection(layoutId) {
        var obj = {
            currentTarget: {
                id: layoutId
            }
        }
        selectViewport(obj);
    }

    /**
     * Apply the preference info zoom level setting from display settings.
     * @param {Type} studyUid - Study Uid
     * @param {Type} preferenceInfo - Preference Info object
     * @param {Type} seriesIndex - series Index
     */
    function ApplyDisplaySettings(studyUid, preferenceInfo, seriesIndex) {
        try {
            // Apply the display settings
            var displaySettings = undefined;
            var series = dicomViewer.Series.getSeries(studyUid, seriesIndex);
            if (series !== undefined && series.displaySettings !== undefined) {
                displaySettings = series.displaySettings;
            }

            //Apply the zoom level settings
            preferenceInfo.zoomLevelSetting = (displaySettings === undefined ? preferenceInfo.zoomLevelSetting : displaySettings.ZoomMode);
        } catch (e) {}
    }

    /**
     * Set the rearranged series positions while changing the series layout
     * @param {Type} positions 
     */
    function setReArrangedSeriesPositions(positions) {
        try {
            multiFrameImageIndex = 0;
            actualSeriesIndex = 0;
            selectThumbnailImageIndex = undefined;
            isViewPortDoubleClicked = false;
            if (positions !== undefined) {
                multiFrameImageIndex = positions.multiFrameImageIndex;
                actualSeriesIndex = positions.actualSeriesIndex;
                selectThumbnailImageIndex = positions.selectThumbnailImageIndex;
                isViewPortDoubleClicked = positions.isViewPortDoubleClicked;
                pageView = positions.pageView;
            }
        } catch (e) {}
    }

    /**
     * Remove the study from study level layout map
     * @param {Type} studyUid
     */
    function RemoveStudyLevelLayout(studyUid) {
        if (studyUid != undefined) {
            if (seriesLayoutMap.has(studyUid)) {
                seriesLayoutMap.set(studyUid, undefined);
            }
        }
    }

    /**
     * Play the repeat cine manager
     */
    function playRepeatCineManager() {
        var allViewports = dicomViewer.viewports.getAllViewports();
        if (allViewports === null || allViewports === undefined) {
            return;
        }

        $.each(allViewports, function (key, value) {
            if (value.studyUid != undefined && value.seriesIndex != undefined) {
                for (var x in repeatCineManager) {
                    if (x == value.seriesLayoutId) {
                        var obj = {};
                        obj.id = "playButton";
                        dicomViewer.setActiveSeriesLayout(value);
                        updatePlayIcon("stop.png", "play.png");
                        if (repeatCineManager[x].playStudy && repeatCineManager[x].timer != null) {
                            playCineImage(obj, undefined);
                            setCinePlayBy("Study");
                        } else if (repeatCineManager[x].playStudy && repeatCineManager[x].timer == null) {
                            setCinePlayBy("Study");
                        } else if (!repeatCineManager[x].playStudy && repeatCineManager[x].timer != null) {
                            playCineImage(obj, undefined);
                            setCinePlayBy("Stack");
                        } else if (!repeatCineManager[x].playStudy && repeatCineManager[x].timer == null) {
                            setCinePlayBy("Stack");
                        }
                    }
                }
            }
        });

        for (var x in repeatCineManager) {
            delete repeatCineManager[x];
        }
    }

    /**
     * save the presentation
     * @param {Type} e - click event properties
     * @param {Type} viewportId - specifies the viewport Id
     */
    function savePState(e, viewportId) {
        ConfirmDialog('Do you want to save this presentation', "save", e, viewportId);
    }

    /**
     * load the prensentaion
     * @param {Type} e - click event properties
     */
    function loadPState(e) {
        loadPStateConfirm(e);
    }

    /**
     * Create the presentation current User PState Menu
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} studyLayoutId - Specifies the study layout Id
     */
    function getUserPStateMenu(studyUid, studyLayoutId) {
        try {
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === null ||
                studyDetails.PStates === undefined || studyDetails.PStates === null) {
                return "";
            }

            if (studyDetails.PStates.All.length == 0) {
                return "";
            }

            var menuIncrementer = 0;
            var currentUserPStateSeperatorId = studyUid + "_CUPState";
            var content = '<li class="k-separator" id="' + currentUserPStateSeperatorId + '"></li>';
            studyDetails.PStates.All.forEach(function (pState) {
                if (!pState.isOtherUser) {
                    pState.menuId = menuIncrementer;
                    var input = "loadPSSubmenu_" + studyLayoutId + "_" + pState.id + "_" + studyUid;
                    var id = "loadPSSubmenu_" + studyLayoutId + "_" + (menuIncrementer++);
                    content += '<li id="' + id + '"><a href="#" onclick=dicomViewer.loadPState("' + input + '")>' + pState.name + '</a></li>'
                }
            });

            var isOtherUserFound = studyDetails.PStates.All.filter(function (o) {
                return o.isOtherUser === true;
            })[0];
            if (!isOtherUserFound) {
                return content;
            }

            var isLoginUserFound = studyDetails.PStates.All.filter(function (o) {
                return !o.isOtherUser === true;
            })[0];
            var otherUserPStateSeperatorId = studyUid + "_OUPState";

            if (isLoginUserFound) {
                content += '<li class="k-separator" id="' + otherUserPStateSeperatorId + '">';
            }

            content += '<li>Other User<ul>';
            studyDetails.PStates.All.forEach(function (pState) {
                if (pState.isOtherUser) {
                    pState.menuId = menuIncrementer;
                    var input = "loadPSSubmenu_" + studyLayoutId + "_" + pState.id + "_" + studyUid;
                    var id = "loadPSSubmenu_" + studyLayoutId + "_" + (menuIncrementer++);
                    content += '<li id="' + id + '"><a href="#" onclick=dicomViewer.loadPState("' + input + '")>' + pState.name + '</a></li>'
                }
            });
            content += '</ul></li>'

            return content;
        } catch (e) {}

        return "";
    }

    /**
     * update the load button when save the presentaion
     * @param {Type} studyUid - It specifies the selected viewport study id
     */
    function updatePState(studyUid) {
        try {
            var viewportToolbarId = (dicomViewer.getActiveSeriesLayout().seriesLayoutId).split("_")[1];
            var viewportToolbar = "saveAndLoad_" + viewportToolbarId;
            createSaveAndLoadPStateGUI(viewportToolbar, studyUid, viewportToolbarId);
        } catch (e) {}
    }

    /**
     * Create the kendo save and load button GUI
     * @param {Type} viewportToolbarId - It specifies the viewport id
     * @param {Type} studyUid - It specifies the selected viewport study id
     * @param {Type} studyLayoutId - It specifies the viewport layout id 
     */
    function createSaveAndLoadPStateGUI(viewportToolbarId, studyUid, studyLayoutId) {
        try {
            document.getElementById(viewportToolbarId).innerHTML = "";
            var userPStateMenuContent = getUserPStateMenu(studyUid, studyLayoutId);
            var saveId = "savePState_" + studyUid;
            var editId = "editPState_" + studyUid;
            var newId = "newPState_" + studyUid;
            var deleteId = "deletePState_" + studyUid;
            var saveAndLoadMenu = "saveAndLoadPStateMenu_" + studyLayoutId;

            var content = '<html><body><ul id="' + saveAndLoadMenu + '" style="display:block;background: transparent">' +
                '<li><img src =images/loadPState.png ><ul>' +
                '<li id="' + dicomViewer.replaceDotValue(saveId) + '"><a href="#" onclick=dicomViewer.savePState("' + saveId + '","' + studyLayoutId + '")>Save</a></li>' +
                '<li style="display:none" id="' + dicomViewer.replaceDotValue(editId) + '"><a href="#" onclick=dicomViewer.editPState("' + editId + '")>Edit</a></li>' +
                '<li id ="' + dicomViewer.replaceDotValue(newId) + '"><a href="#" onclick=dicomViewer.newPState("' + newId + '")>New</a>' +
                '<li id="' + dicomViewer.replaceDotValue(deleteId) + '"><a href="#" onclick=dicomViewer.deletePState("' + deleteId + '")>Delete</a></li>' +
                '</li>' + userPStateMenuContent + '</body></html>'

            $("#" + viewportToolbarId).html(content);

            $("#" + saveAndLoadMenu).kendoMenu({
                animation: {
                    open: {
                        effects: "fadeIn"
                    }
                }
            });
            selectPState(studyUid, studyLayoutId);
        } catch (e) {}
    }

    /**
     * Select the PState
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} studyUid - Specifies the study layout id
     */
    function selectPState(studyUid, studyLayoutId) {
        try {
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            if (studyDetails.PStates === undefined || studyDetails.PStates === null) {
                enableOrDisablePStatesMenu(studyDetails, studyLayoutId);
                return;
            }

            var selectedPStateId = 0;
            var menuIncrementer = 0;
            var menuId = "#loadPSSubmenu_" + studyLayoutId + "_";
            studyDetails.PStates.All.forEach(function (pState) {
                if (pState.id === studyDetails.PStates.Active.id) {
                    selectedPStateId = pState.menuId;
                }
                updateToolTip($(menuId + pState.menuId), pState.tooltip, "top");
                $(menuId + menuIncrementer++).css("background-color", "#363636");
            });

            if (studyDetails.PStates.Active.isEmpty !== true) {
                $(menuId + selectedPStateId).css("background", "#868696");
            }

            var activePStateName = studyDetails.PStates.Active.name;
            var isDirty = studyDetails.PStates.Active.isDirty;
            if (studyDetails.PStates.Active.isNew) {
                isDirty = false;
            }

            var innerHtml = ($(menuId + selectedPStateId)[0].innerHTML).replace("*", "");
            var updatedText = isDirty ? activePStateName + "<font color='red' size=4>*</font>" : "<font color='white'>" + activePStateName + "</font>";
            innerHtml = innerHtml.replace(studyDetails.PStates.Active.name, updatedText);
            $(menuId + selectedPStateId)[0].innerHTML = innerHtml;

            // Enable/ Disable the PState menu items
            enableOrDisablePStatesMenu(studyDetails, studyLayoutId);
        } catch (e) {}
    }

    /**
     * editPState the PState
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} studyUid - Specifies the study layout id
     */
    function editPState(e) {
        try {
            dicomViewer.measurement.editPState(e);
        } catch (e) {}
    }

    /**
     * newPState the PState
     * @param {Type} e - click event properties
     */
    function newPState(e) {
        dicomViewer.measurement.newPState(e);
    }

    /**
     * deletePState the PState
     * @param {Type} e - click event properties
     */
    function deletePState(e) {
        deletePStateConfirm(e);
    }

    /**
     * Enable or disable the PState menu and its click events
     * @param {Type} studyDetails - Specifies the study details
     * @param {Type} studyLayoutId - Specifies the study layout id
     */
    function enableOrDisablePStatesMenu(studyDetails, studyLayoutId) {
        try {
            if (studyDetails == undefined || studyDetails == null) {
                return;
            }

            var studyUid = studyDetails.studyUid;
            var disableAllExceptSave = undefined;
            var disableEditNew = undefined;
            var isEditable = undefined;
            var enableAllExceptSave = undefined;
            var disableAll = undefined;
            var isEmptyActivePState = undefined;

            if (studyDetails.PStates == undefined || studyDetails.PStates == null) {
                disableAll = true;
            } else if (studyDetails.PStates.Active.isEditable == false) {
                disableAllExceptSave = false;
                disableEditNew = false;
                isEditable = false;
            } else if (studyDetails.PStates.Active.isNew == true) {
                disableAllExceptSave = false;
                disableEditNew = true;
            } else if (studyDetails.PStates.Active.isDirty == false) {
                enableAllExceptSave = true;
            } else if (studyDetails.PStates.Active.isEmpty == true) {
                isEmptyActivePState = true;
            }

            document.getElementById("saveAndLoadPStateMenu_" + studyLayoutId).style.display = disableAll ? "none" : "block";
            var saveId = "#savePState_" + dicomViewer.replaceDotValue(studyUid);
            var editId = "#editPState_" + dicomViewer.replaceDotValue(studyUid);
            var newId = "#newPState_" + dicomViewer.replaceDotValue(studyUid);
            var deleteId = "#deletePState_" + dicomViewer.replaceDotValue(studyUid);

            $(saveId).removeClass("k-state-disabled");
            $(editId).removeClass("k-state-disabled");
            $(newId).removeClass("k-state-disabled");
            $(deleteId).removeClass("k-state-disabled");

            $(saveId)[0].style.pointerEvents = 'auto';
            $(newId)[0].style.pointerEvents = 'auto';
            $(editId)[0].style.pointerEvents = 'auto';
            $(deleteId)[0].style.pointerEvents = 'auto';

            if (disableAllExceptSave == true) {
                $(newId).addClass("k-state-disabled");
                $(editId).addClass("k-state-disabled");
                $(deleteId).addClass("k-state-disabled");

                $(newId)[0].style.pointerEvents = 'none';
                $(editId)[0].style.pointerEvents = 'none';
                $(deleteId)[0].style.pointerEvents = 'none';
            } else if (disableEditNew == true) {
                $(newId).addClass("k-state-disabled");
                $(editId).addClass("k-state-disabled");

                $(newId)[0].style.pointerEvents = 'none';
                $(editId)[0].style.pointerEvents = 'none'

                if (studyDetails.PStates.Active.isDirty !== true) {
                    $(saveId).addClass("k-state-disabled");
                    $(saveId)[0].style.pointerEvents = 'none';
                }
            } else if (isEditable == false) {
                $(editId).addClass("k-state-disabled");
                $(saveId).addClass("k-state-disabled");
                $(deleteId).addClass("k-state-disabled");

                $(editId)[0].style.pointerEvents = 'none';
                $(saveId)[0].style.pointerEvents = 'none';
                $(deleteId)[0].style.pointerEvents = 'none';
            } else if (enableAllExceptSave == true) {
                $(saveId).addClass("k-state-disabled");
                $(saveId)[0].style.pointerEvents = 'none';
            } else if (disableAll === true || isEmptyActivePState === true) {
                $(newId).addClass("k-state-disabled");
                $(editId).addClass("k-state-disabled");
                $(deleteId).addClass("k-state-disabled");
                $(saveId).addClass("k-state-disabled");

                $(newId)[0].style.pointerEvents = 'none';
                $(editId)[0].style.pointerEvents = 'none';
                $(deleteId)[0].style.pointerEvents = 'none';
                $(saveId)[0].style.pointerEvents = 'none';
            }

            var toolTipText = (disableAll == true ? "" : "Save/Load presentation state");
            updateToolTip($("#saveAndLoad_" + studyLayoutId), toolTipText, "top");
        } catch (e) {}
    }

    /**
     * Confirmation dialog for presentation state
     * @param {Type} message - Specifies the confirmation message
     * @param {Type} state - Specifies the presentation state
     * @param {Type} e - Specifies the event arguments
     * @param {Type} viewportId - Specifies the viewport Id
     * @param {Type} studyDetails - Specifies the study details
     */
    function ConfirmDialog(message, state, e, viewportId, studyDetails) {
        try {
            $('<div></div>').appendTo('body')
                .html('<div><h6>' + message + '?</h6></div>')
                .dialog({
                    modal: true,
                    title: 'VIX Viewer',
                    zIndex: 10000,
                    autoOpen: true,
                    width: 'auto',
                    resizable: false,
                    buttons: {
                        "Yes": function () {
                            $(this).dialog('close');
                            selectPresentationState(state, e, viewportId, studyDetails);
                        },
                        "No": function () {
                            $(this).dialog('close');
                            if (state == "save&load") {
                                selectPresentationState("load", e);
                            }
                        },
                    },
                    close: function (event, ui) {
                        $(this).remove();
                    }
                });
        } catch (e) {}
    };

    /**
     * Select the presentation state
     * @param {Type} state - Specifies the presentation state
     * @param {Type} e - Specifies the event arguments
     * @param {Type} viewportId - Specifies the viewport Id
     * @param {Type} studyDetails - Specifies the study details
     */
    function selectPresentationState(state, e, viewportId, studyDetails) {
        try {
            switch (state) {
                case "save":
                    dicomViewer.measurement.savePState({
                        studyUid: e.split("_")[1],
                        isPrivate: false,
                        isEditable: true,
                        isNew: false,
                        viewportId: viewportId
                    });
                    break;
                case "load":
                    dicomViewer.measurement.loadPState(e.split("_")[3], e);
                    break;
                case "delete":
                    dicomViewer.measurement.deletePState(e);
                    break;
                case "untitledDelete":
                    dicomViewer.measurement.saveOrDeleteUnSavedPState(studyDetails, false);
                    break;
                case "save&load":
                    dicomViewer.measurement.savePState({
                        studyUid: e.split("_")[3],
                        isPrivate: false,
                        isEditable: true,
                        isNew: false,
                        viewportId: viewportId
                    });
                    dicomViewer.measurement.loadPState(e.split("_")[3], e);
                    break;
            }
        } catch (e) {}
    }

    /**
     * delete the PState based on the presentation
     * @param {Type} e - Specifies the event arguments
     */
    function deletePStateConfirm(e) {
        try {
            var studyUid = e.split("_")[1];
            if (studyUid === undefined || studyUid === null) {
                // Invalid parameters
                return;
            }

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            if (studyDetails.PStates == undefined || studyDetails.PStates == null) {
                // Invalid presentation state 
                return;
            }

            if (studyDetails.PStates.Active.isNew == true) {
                ConfirmDialog("Do you want to discard the untitled presentation state", "untitledDelete", e, undefined, studyDetails);
                return;
            }

            ConfirmDialog("Do you want to delete the current presentation state", "delete", e);
        } catch (e) {}
    }

    /**
     * load the PState based on the presentation state
     * @param {Type} e - Specifies the event arguments
     */
    var disabePStateConfirmMessage = true;

    function loadPStateConfirm(e) {
        try {
            var studyUid = e.split("_")[3];
            if (studyUid === undefined || studyUid === null) {
                // Invalid parameters
                return;
            }

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            if (studyDetails.PStates == undefined || studyDetails.PStates == null) {
                // Invalid presentation state 
                return;
            }

            if (studyDetails.PStates.Active.isDirty == true) {
                ConfirmDialog("Current presentation is edited.<br>Do you want to save the current presentation and load the selected one", "save&load", e, e.split("_")[1]);
                return;
            } else {
                if (disabePStateConfirmMessage) {
                    dicomViewer.measurement.loadPState(e.split("_")[3], e, undefined, false);
                } else {
                    ConfirmDialog('Do you want to load this presentation', "load", e);
                }
            }
        } catch (e) {}
    }

    /**
     * end the unfinished measurement
     */
    function endMeasurement() {
        try {
            if (dicomViewer.measurement.isEditMeasurement()) {
                var tool = dicomViewer.mouseTools.getActiveTool();
                var event = {};
                event.type = "dblclick";
                event.which = 1;
                tool.hanleDoubleClick(event);
            }
        } catch (e) {}
    }

    /**
     * check the study is dicom or non dicom
     */
    function isNonDicomStudy(modality) {
        try {
            if (modality == "" || modality == undefined ||
                modality == null || modality == "ECG" ||
                modality == "SR" || modality == "CDA" ||
                modality == "General") {
                return true;
            }
            return false;
        } catch (e) {}
    }

    /**
     * Auto play the cine while changing the series layout
     * @param {Type}  
     */
    function autoCinePlay() {
        try {
            var allViewports = dicomViewer.viewports.getAllViewports();
            if (allViewports === null || allViewports === undefined) {
                return;
            }

            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            $.each(allViewports, function (key, value) {
                if (value.studyUid != undefined && value.seriesIndex != undefined && canPlayCine(value.imageType)) {
                    var image = dicomViewer.Series.Image.getImage(value.studyUid, value.seriesIndex, value.getImageIndex());
                    if (dicomViewer.Series.Image.getImageFrameCount(image) > 1) {
                        if (!isFullScreenEnabled) {
                            dicomViewer.setActiveSeriesLayout(value);
                            dicomViewer.startCine();
                            updatePlayIcon("play.png", "stop.png");
                        }
                    }
                }
            });

            if (seriesLayout != null && seriesLayout != undefined) {
                dicomViewer.setActiveSeriesLayout(seriesLayout);
                if (seriesLayout.imageType && canPlayCine(seriesLayout.imageType)) {
                    var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.getImageIndex());
                    if (dicomViewer.Series.Image.getImageFrameCount(image) == 1) {
                        dicomViewer.tools.stopCineImage();
                        updatePlayIcon("stop.png", "play.png");
                        EnableDisableNextSeriesImage(seriesLayout);
                    }
                }
            }
        } catch (e) {}
    }

    function isCineRunningInViewport() {
        var isCineRunning = false;

        try
        {
            if (cineManager) {
                $.each(cineManager, function (key) {
                    if (cineManager[key] != null && cineManager[key].timer) {
                        isCineRunning = true;
                        return false;
                    }
                })
            }
        }
        catch(e)
        { }

        return isCineRunning;
    }

    dicomViewer.convertDicomDateToDisplayFormat = convertDicomDateToDisplayFormat;
    dicomViewer.getCurrentSeriesLayoutIds = getCurrentSeriesLayoutIds;
    dicomViewer.setImageLevelLayout = setImageLevelLayout;
    dicomViewer.setSeriesLayout = setSeriesLayout;
    dicomViewer.setStudyLayout = setStudyLayout;
    dicomViewer.refreshStudyLayout = refreshStudyLayout;
    dicomViewer.createStudyViewport = createStudyViewport;
    dicomViewer.loadStudyInNextViewport = loadStudyInNextViewport;
    dicomViewer.getActiveSeriesLayout = getActiveSeriesLayout;
    dicomViewer.setActiveSeriesLayout = setActiveSeriesLayout;
    dicomViewer.showCineRate = showCineRate;
    dicomViewer.pauseCinePlay = pauseCinePlay;
    dicomViewer.setStudyToolBarTools = setStudyToolBarTools;
    dicomViewer.scroll = {
        moveToNextOrPreviousImage: moveToNextOrPreviousImage,
        getCurrentImageAndFrameIndex: getCurrentImageAndFrameIndex,
        runCineImage: runCineImage,
        stopCineImage: stopCineImage,
        setCineDirection: setCineDirection,
        loadimages: loadimages,
        isCineRunning: isCineRunning,
        toggleCineRunning: toggleCineRunning,
        isToPlayStudy: isToPlayStudy,
        setCinePlayBy: setCinePlayBy,
        isCineRunningInViewport: isCineRunningInViewport
    };
    dicomViewer.getimageCanvasOfViewPort = getimageCanvasOfViewPort;
    dicomViewer.getimageCanvasOfBackupViewPort = getimageCanvasOfBackupViewPort;
    dicomViewer.setimageCanvasOfBackupViewPort = setimageCanvasOfBackupViewPort;
    dicomViewer.removeimageCanvasOfAllViewPorts = removeimageCanvasOfAllViewPorts;
    dicomViewer.setimageCanvasOfViewPort = setimageCanvasOfViewPort;
    dicomViewer.removeimageCanvasOfViewPort = removeimageCanvasOfViewPort;
    dicomViewer.removeimageCanvasOfBackupViewPort = removeimageCanvasOfBackupViewPort;
    dicomViewer.loadImageFromThumbnail = loadImageFromThumbnail;
    dicomViewer.getImageIndexForImageUid = getImageIndexForImageUid;
    dicomViewer.startCine = startCine;
    dicomViewer.onCineSpeedChange = onCineSpeedChange;
    dicomViewer.changeSelection = changeSelection;
    dicomViewer.removeCineManager = removeCineManager;
    dicomViewer.removeimageCanvasOfAllBackupViewPorts = removeimageCanvasOfAllBackupViewPorts;
    dicomViewer.IsFullScreenMode = IsFullScreenMode;
    dicomViewer.setReArrangedSeriesPositions = setReArrangedSeriesPositions;
    dicomViewer.setDefaultCursorType = setDefaultCursorType;
    dicomViewer.RemoveStudyLevelLayout = RemoveStudyLevelLayout;
    dicomViewer.playRepeatCineManager = playRepeatCineManager;
    dicomViewer.savePState = savePState;
    dicomViewer.loadPState = loadPState;
    dicomViewer.updatePState = updatePState;
    dicomViewer.deletePState = deletePState;
    dicomViewer.editPState = editPState;
    dicomViewer.newPState = newPState;
    dicomViewer.createSaveAndLoadPStateGUI = createSaveAndLoadPStateGUI;
    dicomViewer.enableOrDisablePStatesMenu = enableOrDisablePStatesMenu;
    dicomViewer.EnableDisableReferenceLineMenu = EnableDisableReferenceLineMenu;
    dicomViewer.updatePreset = updatePreset;
    dicomViewer.loadimages = loadimages;
    dicomViewer.getOrUpdateSeriesLayout = getOrUpdateSeriesLayout;
    dicomViewer.enableOrDisableTools = enableOrDisableTools;
    return dicomViewer;
}(dicomViewer));
