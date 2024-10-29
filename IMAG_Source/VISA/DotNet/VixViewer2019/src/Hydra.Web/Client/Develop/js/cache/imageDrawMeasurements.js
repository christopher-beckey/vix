/**
 * New node file
 */
var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var lineStatus = "added";

    var physicalUnitsXYDirectionArray = ["none", "%", "dB", "cm", "sec", "hertz", "dB/sec", "cm/sec", "cm\u00B2", "cm\u00B2/sec", "cm\u00B3", "cm\u00B3/sec", "\u00B0"];

    var measurementId = null;

    var measurementType = -1;

    var measurementUnits = null;

    var userStyle = {
        lineColor: "#00FFFF",
        lineWidth: 1,
        fontName: "Arial",
        fontSize: 12,
        textColor: "#00FFFF",
        isBold: false,
        isItalic: false,
        isUnderlined: false,
        isStrikeout: false,
        isFill: false,
        fillColor: "#00FFFF",
        gaugeLength: 7,
        gaugeStyle: "Line",
        precision: 2,
        measurementUnits: "cm",
        arcRadius: 20
    };

    // User Measurement Style key/value pair
    var userMeasurementStyleCol = {};

    var smoothConfig = {
        method: 'cubic',
        clip: 'periodic',
        lanczosFilterSize: 2,
        cubicTension: 0
    };

    /**
     *Set the user measurement style key/value pair
     */
    function setUserMeasurementCol(measurementStyleCol) {
        try {
            userMeasurementStyleCol = measurementStyleCol;
        } catch (e) {}
    }

    /**
     *Set the user measurement style by type
     */
    function setUserMeasurementStyleByType(type, useDefault, styleCol) {
        try {
            if (userMeasurementStyleCol === undefined || userMeasurementStyleCol === null) {
                userMeasurementStyleCol = {};
            }
            var measurementStyle = {
                useDefault: useDefault,
                styleCol: styleCol
            };

            userMeasurementStyleCol["" + type + ""] = measurementStyle;
        } catch (e) {}
    }

    function isValidPixelSpacing(pixelSpacing) {
        if (pixelSpacing !== undefined && pixelSpacing !== null) {
            return true;
        }
        return false;
    }

    function drawMeasurements(imageUid, frameIndex, context, presentation, imageRenderer) {

        var displayMeasurement = false;

        if (imageUid === undefined) {
            throw "drawMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "drawMeasurements : frameIndex is null/undefined";
        }
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        if (parentDiv === undefined)
            return;
        var tempData = dicomViewer.measurement.getTempData();
        if (parentDiv === dicomViewer.getActiveSeriesLayout().getSeriesLayoutId() && tempData) {
            var tool = dicomViewer.mouseTools.getActiveTool();
            var activeImageUid = undefined;
            if (tool) {
                var activeImageRenderer = tool.getActiveImageRenderer();
                if (activeImageRenderer) {
                    activeImageUid = activeImageRenderer.anUIDs.split("*")[0];
                }
            }
            if (tempData.measureType === "linedelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findLineToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "pointdelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context, parentDiv);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findPointToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "angledelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context, parentDiv);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findAngleToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "ellipsedelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context, parentDiv);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findEllipseToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "rectangledelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context, parentDiv);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findRectangleToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "WindowLevelROIdelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context, parentDiv);
                dicomViewer.measurement.resetMeasurementFlag();
            } else if (tempData.measureType === "tracedelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findTraceToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "volumedelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findVolumeToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "mitralGradientdelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findMitralToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "pendelete") {
                var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(tempData, imageRenderer, context);
                dicomViewer.measurement.resetMeasurementFlag();
                dicomViewer.measurement.findPenToDelete(imageData, imageRenderer);
            } else if (tempData.measureType === "line") {
                lineStatus = "added";
                var measurementResult;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    dicomViewer.measurement.updateMeasurements(dataToEdit, imageRenderer, tempData, context);
                    var editPoint = dicomViewer.measurement.findNearHandleToEdit(tempData.start, imageRenderer, context, dataToEdit); //dicomViewer.measurement.findNearHandleToEdit(tempData.start, imageRenderer, context, dataToEdit);
                    if (editPoint !== undefined) {
                        if (editPoint.start.handleActive) {
                            tempData.start.x = editPoint.start.x;
                            tempData.start.y = editPoint.start.y;
                        } else if (editPoint.end.handleActive) {
                            tempData.end.x = editPoint.end.x;
                            tempData.end.y = editPoint.end.y;
                        }
                        lineStatus = "modified";
                        dicomViewer.measurement.updateMeasurements(dataToEdit, imageRenderer, tempData, context);
                    }
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        measurementResult = drawLineMeasurement(imageUid, context, imageData, presentation, imageRenderer);
                    }
                }
                if (dicomViewer.measurement.isLineMeasurementEnd() && lineStatus === "added") {
                    if (measurementResult != null) {
                        sendMeasurement(measurementResult.id, measurementResult.value);
                    }
                    var lengthOfTemp = parseFloat(getLengthText(tempData))
                    if (lengthOfTemp > 0.05) {
                        dicomViewer.measurement.addMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                    }

                    var calibrationData = getUnitMeasurementMap(tempData.studyUid + "|" + imageRenderer.seriesIndex + "|" + imageRenderer.imageIndex + "|" + imageRenderer.anUIDs.split("*")[1]);

                    if (calibrationData) {
                        tempData.calibrationData = calibrationData;
                    }

                    if (dicomViewer.tools.getFlagFor2dLengthCalibration()) {
                        var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                        var coordinate = {
                            start: imageData.start,
                            end: imageData.end
                        };
                        dicomViewer.measurement.setCoordinate(coordinate);
                    }
                }
            } else if (tempData.measureType === "ellipse") {
                lineStatus = "added";
                var measurementResult;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateEllipseMeasurements(dataToEdit, imageRenderer, tempData, context);
                    lineStatus = "modified";
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        measurementResult = drawEllipseMeasurement(imageUid, context, imageData, presentation, imageRenderer, undefined, dicomViewer.measurement.isLineMeasurementEnd() ? false : true);
                    }
                }
                if (dicomViewer.measurement.isLineMeasurementEnd() && lineStatus === "added") {
                    var lengthOfTemp = parseFloat(getLengthText(tempData));
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    measurementResult = drawEllipseMeasurement(imageUid, context, imageData, presentation, imageRenderer, true, false);
                    if (lengthOfTemp > 0.05)
                        dicomViewer.measurement.addEllipseMeasurements(imageUid, frameIndex, imageRenderer, tempData, context, measurementResult);
                }
            } else if (tempData.measureType === "rectangle") {
                lineStatus = "added";
                var measurementResult;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateRectangleMeasurements(dataToEdit, imageRenderer, tempData, context, tempData.editMode);
                    lineStatus = "modified";
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        measurementResult = drawRectangleMeasurement(imageUid, context, imageData, presentation, imageRenderer, undefined, dicomViewer.measurement.isLineMeasurementEnd() ? false : true);
                    }
                }
                if (dicomViewer.measurement.isLineMeasurementEnd() && lineStatus === "added") {
                    var lengthOfTemp = parseFloat(getLengthText(tempData));
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    measurementResult = drawRectangleMeasurement(imageUid, context, imageData, presentation, imageRenderer, true, false);
                    if (lengthOfTemp > 0.05)
                        dicomViewer.measurement.addRectangleMeasurements(imageUid, frameIndex, imageRenderer, tempData, context, measurementResult);
                }
            } else if (tempData.measureType === "WindowLevelROI") {
                lineStatus = "added";
                var measurementResult;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    lineStatus = "modified";
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    measurementResult = drawWindowLevelROIMeasurement(imageUid, context, imageData, presentation, imageRenderer, undefined);
                }
                if (dicomViewer.measurement.isLineMeasurementEnd() && lineStatus === "added") {
                    var lengthOfTemp = parseFloat(getLengthText(tempData));
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    measurementResult = drawWindowLevelROIMeasurement(imageUid, context, imageData, presentation, imageRenderer, true);
                }

                if (!dicomViewer.tools.isShowAnnotationandMeasurement()) {
                    return;
                }
            } else if (tempData.measureType === "point") {
                lineStatus = "added";
                var measurementResult;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    dicomViewer.measurement.updateMeasurements(dataToEdit, imageRenderer, tempData, context);
                    var editPoint = dicomViewer.measurement.findNearHandleToEdit(tempData.start, imageRenderer, context, dataToEdit);
                    if (editPoint !== undefined) {
                        if (editPoint.start.handleActive) {
                            tempData.start.x = editPoint.end.x;
                            tempData.start.y = editPoint.end.y;
                        } else if (editPoint.end.handleActive) {
                            tempData.start.x = editPoint.start.x;
                            tempData.start.y = editPoint.start.y;
                        }
                        lineStatus = "modified";
                    }
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    measurementResult = drawPointMeasurement(imageUid, context, imageData, presentation, imageRenderer);
                }

                if (dicomViewer.measurement.isLineMeasurementEnd() && lineStatus === "added") {
                    if (measurementResult != null) {
                        sendMeasurement(measurementResult.id, measurementResult.value);
                    }
                    dicomViewer.measurement.addMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                }
            } else if (tempData.measureType === "trace") {
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateTraceIntoArray(tempData.end, imageRenderer, context, dataToEdit);
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        var measurementResult = drawTraceMeasurement(imageUid, context, imageData, presentation, imageRenderer, false, undefined, undefined, dicomViewer.measurement.isTraceMeasurementEnd() ? true : false);
                    }

                    if (dicomViewer.measurement.isLineMeasurementEnd()) {
                        lineStatus = "added";
                        dicomViewer.measurement.addTraceMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                    }
                }
            } else if (tempData.measureType === "angle") {
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateAngleIntoArray(tempData.end, imageRenderer, context, dataToEdit);
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        var measurementResult = drawAngleMeasurement(imageUid, context, imageData, presentation, imageRenderer, dicomViewer.measurement.isAngleMeasurementEnd() ? true : false);
                    }

                    if (dicomViewer.measurement.isLineMeasurementEnd()) {
                        lineStatus = "added";
                        dicomViewer.measurement.addAngleMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                    }
                }
            } else if (tempData.measureType === "volumeeditmove") {
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateVolumeintoArray(tempData.end, imageRenderer, context, dataToEdit);

                    updateDynamicVolumes(tempData, imageUid, imageData, frameIndex, parentDiv, presentation, context, imageRenderer);
                }
            } else if (tempData.measureType === "volume") {
                var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                var measurementResult = drawLineMeasurement(imageUid, context, imageData, presentation, imageRenderer);

                if (!dicomViewer.measurement.isVolumeMeasurementEnd()) {
                    updateDynamicVolumes(tempData, imageUid, imageData, frameIndex, parentDiv, presentation, context, imageRenderer);
                } else if (dicomViewer.measurement.isLineMeasurementEnd()) {
                    lineStatus = "added";
                    dicomViewer.measurement.addVolumeMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                }
            } else if (tempData.measureType === "mitralGradient") {
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updateMitralMeanGradientintoArray(tempData.end, imageRenderer, context, dataToEdit);
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    var isMeasurementEnd = dicomViewer.measurement.isMitralMeanGradientMeasurementEnd() ? true : false;
                    imageData.textPosition = tempData.textPosition;
                    if (activeImageUid == imageUid) {
                        if (imageData.measurementSubType === "freehand") {
                            drawFreeHandMeasurement(imageUid, context, imageData, presentation, imageRenderer, false, isMeasurementEnd, undefined);
                        } else {
                            drawMitralMeanGradientMeasurement(imageUid, context, imageData, presentation, imageRenderer, false, undefined, isMeasurementEnd);
                        }
                    }

                    if (dicomViewer.measurement.isLineMeasurementEnd()) {
                        lineStatus = "added";
                        dicomViewer.measurement.addMitralGradientMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                    } else {
                        var mitralMeasurements = dicomViewer.measurement.getMitralGradientMeasurements(imageUid, frameIndex);
                        if (mitralMeasurements != undefined && mitralMeasurements[tempData.measurementIndex] == undefined) displayMeasurement = true;

                    }
                }
            } else if (tempData.measureType === "pen") {
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    tempData.measurementId = dataToEdit.arryIndex;
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    dicomViewer.measurement.updatePenintoArray(tempData.end, imageRenderer, context, dataToEdit);
                } else {
                    var imageData = dicomViewer.measurement.getImageDataForMouseData(tempData, imageRenderer, context);
                    var isMeasurementEnd = dicomViewer.measurement.isPenToolEnd() ? true : false;
                    if (activeImageUid == imageUid) {
                        if (imageData.measurementSubType === "pen") {
                            drawPenMeasurement(imageUid, context, imageData, presentation, imageRenderer, isMeasurementEnd);
                        }
                    }
                    dicomViewer.measurement.addPenMeasurements(imageUid, frameIndex, imageRenderer, tempData, context);
                }
            }
        }

        var measurements = dicomViewer.measurement.getMeasurements(imageUid, frameIndex);
        if (measurements !== undefined && measurements.length !== 0) {
            for (var i = 0; i < measurements.length; i++) {
                var data = measurements[i];
                if (data !== undefined) {
                    if (data.measureType === "line") {
                        var dataToEdit = dicomViewer.measurement.getDataToEdit();
                        if (dataToEdit != undefined && i != dataToEdit.arryIndex) {
                            data.end.handleActive = false;
                            data.start.handleActive = false;
                        }
                        if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                            drawLineMeasurement(imageUid, context, data, presentation, imageRenderer);
                        }
                    } else if (data.measureType === "point") {
                        var dataToEdit = dicomViewer.measurement.getDataToEdit();
                        if (dataToEdit != undefined) {
                            if (i != dataToEdit.arryIndex) {
                                data.end.handleActive = false;
                                data.start.handleActive = false;
                            } else {
                                //while editing point measurement, again updating the position of the text for the selected point
                                data.textPosition = dicomViewer.measurement.pointTextPosition(data, imageRenderer);
                            }
                        }
                        if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                            drawPointMeasurement(imageUid, context, data, presentation, imageRenderer);
                        }
                    }
                }
            }
        }

        var ellipseMeasurements = dicomViewer.measurement.getEllipseMeasurements(imageUid, frameIndex);
        if (ellipseMeasurements !== undefined && ellipseMeasurements.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < ellipseMeasurements.length; i++) {
                measurements = ellipseMeasurements[i];
                var dataResultX = 0;
                var dataResultY = 0;
                if (measurements !== undefined) {
                    if (measurements.measureType === "ellipse") {
                        if (dicomViewer.measurement.isMeasurementDrawable(measurements.sessionType)) {
                            drawEllipseMeasurement(imageUid, context, measurements, presentation, imageRenderer, (measurements.editMode) ? undefined : true, measurements.editMode);
                        }
                    }
                }
            }
        }

        var rectangleMeasurements = dicomViewer.measurement.getRectangleMeasurements(imageUid, frameIndex);
        if (rectangleMeasurements !== undefined && rectangleMeasurements.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < rectangleMeasurements.length; i++) {
                measurements = rectangleMeasurements[i];
                var dataResultX = 0;
                var dataResultY = 0;
                if (measurements !== undefined) {
                    if (measurements.measureType === "rectangle") {
                        if (dicomViewer.measurement.isMeasurementDrawable(measurements.sessionType)) {
                            drawRectangleMeasurement(imageUid, context, measurements, presentation, imageRenderer, (measurements.editMode) ? undefined : true, measurements.editMode, measurements.editMode);
                        }
                    }
                }
            }
        }

        var traceMeasurements = dicomViewer.measurement.getTraceMeasurements(imageUid, frameIndex);

        if (traceMeasurements !== undefined && traceMeasurements.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < traceMeasurements.length; i++) {
                measurements = traceMeasurements[i];
                var dataResultX = 0;
                var dataResultY = 0;
                if (measurements !== undefined && measurements.length !== 0) {
                    for (var j = 0; j < measurements.length; j++) {
                        var data = measurements[j];
                        if (data.measureType === "trace") {
                            if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                dataResultX = parseInt(dataResultX) + parseInt((data.start.x).toFixed(0));
                                dataResultY = parseInt(dataResultY) + parseInt((data.start.y).toFixed(0));
                                var averageX = (parseInt(dataResultX) / (j + 1)).toFixed(0);
                                var averageY = (parseInt(dataResultY) / (j + 1)).toFixed(0);
                                var display = false;
                                if (j === measurements.length - 1) display = true;
                                measurementResult = drawTraceMeasurement(imageUid, context, data, presentation, imageRenderer, display, averageX, averageY, data.editMode);
                            }
                        }
                    }
                }
            }
            if (measurementResult != undefined)
                sendMeasurement(measurementResult.id, measurementResult.value);
        }

        // Angle measurement
        var angleMeasurements = dicomViewer.measurement.getAngleMeasurements(imageUid, frameIndex);

        if (angleMeasurements !== undefined && angleMeasurements.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < angleMeasurements.length; i++) {
                measurements = angleMeasurements[i];
                if (measurements !== undefined && measurements.length !== 0) {
                    for (var j = 0; j < measurements.length; j++) {
                        var data = measurements[j];
                        if (data.measureType === "angle") {
                            if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                measurementResult = drawAngleMeasurement(imageUid, context, data, presentation, imageRenderer, data.editMode);
                            }
                        }
                    }

                    for (var iIndex = 0; iIndex < measurements.length - 1; iIndex++) {
                        var firstLine = measurements[iIndex];
                        var secondLine = measurements[iIndex + 1];
                        var endPoint;
                        var centerPoint = {
                            x: firstLine.end.x.toFixed(0),
                            y: firstLine.end.y.toFixed(0)
                        };
                        var startPoint = {
                            x: firstLine.start.x.toFixed(0),
                            y: firstLine.start.y.toFixed(0)
                        };
                        if ((firstLine.end.x.toFixed(0) == secondLine.end.x.toFixed(0)) &&
                            (firstLine.end.y.toFixed(0) == secondLine.end.y.toFixed(0))) {
                            endPoint = {
                                x: secondLine.start.x.toFixed(0),
                                y: secondLine.start.y.toFixed(0)
                            };
                        } else {
                            endPoint = {
                                x: secondLine.end.x.toFixed(0),
                                y: secondLine.end.y.toFixed(0)
                            };
                        }
                        var angleValue = calculateAngle(startPoint, endPoint, centerPoint, measurements[iIndex].style);
                        if (dicomViewer.measurement.isMeasurementDrawable(measurements.sessionType)) {
                            drawAngleValue(context, firstLine, secondLine, imageRenderer, presentation, angleValue, "o");
                        }
                    }
                }
            }
        }

        var volumeMeasurements = dicomViewer.measurement.getVolumeMeasurements(imageUid, frameIndex);

        if (volumeMeasurements !== undefined && volumeMeasurements.length !== 0) {
            for (var i = 0; i < volumeMeasurements.length; i++) {
                measurements = volumeMeasurements[i];
                if (measurements !== undefined && measurements.length !== 0) {
                    var dataToEdit = dicomViewer.measurement.getDataToEdit();
                    var isQualifyforEdit = (dataToEdit !== undefined && (i === dataToEdit.arryIndex));
                    var data;
                    for (var j = 0; j < measurements.length; j++) {
                        data = measurements[j];
                        if (data.measureType === "volume") {
                            drawLineWithoutMeasurement(imageUid, context, data, presentation, imageRenderer, false, isQualifyforEdit);
                        }
                    }
                    if (!(i == volumeMeasurements.length - 1 && dicomViewer.measurement.isVolumeMeasurementEnd())) {
                        var firstPoint = {
                            start: {
                                x: measurements[0].start.x,
                                y: measurements[0].start.y
                            },
                            end: {
                                x: measurements[measurements.length - 1].end.x,
                                y: measurements[measurements.length - 1].end.y
                            },
                            measureType: "line",
                            style: data.style
                        };
                        drawLineWithoutMeasurement(imageUid, context, firstPoint, presentation, imageRenderer, true, isQualifyforEdit);
                    }
                }
            }

        }

        var mitralMeasurements = dicomViewer.measurement.getMitralGradientMeasurements(imageUid, frameIndex);

        if (mitralMeasurements !== undefined && mitralMeasurements.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < mitralMeasurements.length; i++) {
                measurements = mitralMeasurements[i];
                var dataResultX = 0;
                var dataResultY = 0;
                var dataMitralGradiant = 0;
                var gradiantValues = getAvgMitralMeanGradients(imageUid, measurements);

                if (measurements !== undefined && measurements.length !== 0) {
                    var freeHandPoints = [];
                    if (measurements[0].measureType === "mitralGradient" &&
                        measurements[0].measurementSubType === "freehand") {
                        for (var j = 0; j < measurements.length; j++) {
                            var imageCoordinate = dicomViewer.measurement.getCanvasDataForImageData(measurements[j], imageRenderer);
                            if (j == 0) {
                                freeHandPoints.push([parseInt(imageCoordinate.start.x),
                                                    parseInt(imageCoordinate.start.y)]);
                            }

                            freeHandPoints.push([parseInt(imageCoordinate.end.x),
                                                 parseInt(imageCoordinate.end.y)]);
                        }
                    }

                    for (var j = 0; j < measurements.length; j++) {
                        var data = measurements[j];
                        if (data.measureType === "mitralGradient") {
                            var display = false;
                            if (j === measurements.length - 1) display = true;
                            if (data.measurementSubType === "freehand") {
                                if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                    drawFreeHandMeasurement(imageUid, context, data, presentation, imageRenderer, display, data.editMode, freeHandPoints);
                                }
                            } else {
                                if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                    measurementResult = drawMitralMeanGradientMeasurement(imageUid, context, data, presentation, imageRenderer, display, gradiantValues, data.editMode);
                                }
                            }

                            if (data.measurementSubType !== "freehand") {
                                if ((i != mitralMeasurements.length - 1 && j == measurements.length - 1) ||
                                    (i == mitralMeasurements.length - 1 && j == measurements.length - 1 && (!dicomViewer.measurement.isMitralMeanGradientMeasurementEnd() || displayMeasurement))) {
                                    var firstPoint = {
                                        start: {
                                            x: measurements[0].start.x,
                                            y: measurements[0].start.y
                                        },
                                        end: {
                                            x: measurements[measurements.length - 1].end.x,
                                            y: measurements[measurements.length - 1].end.y
                                        },
                                        measureType: "line",
                                        style: data.style
                                    };
                                    if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                        drawLineWithoutMeasurement(imageUid, context, firstPoint, presentation, imageRenderer, true, isQualifyforEdit);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if (measurementResult != undefined)
                sendMeasurement(measurementResult.id, measurementResult.value);
        }

        var penMeasurement = dicomViewer.measurement.getPenMeasurements(imageUid, frameIndex);
        if (penMeasurement !== undefined && penMeasurement.length !== 0) {
            var measurementResult = undefined;
            for (var i = 0; i < penMeasurement.length; i++) {
                measurements = penMeasurement[i];
                var dataResultX = 0;
                var dataResultY = 0;


                if (measurements !== undefined && measurements.length !== 0) {
                    var penPoints = [];
                    for (var j = 0; j < measurements.length; j++) {
                        var data = measurements[j];
                        // updating the selected properties styles for the pen annotation
                        if (measurements.style !== undefined) {
                            data.style = measurements.style;
                        }
                        var display = false;
                        if (j === measurements.length - 1) {
                            display = true;
                        }
                        if (data.measurementSubType === "pen") {
                            if (dicomViewer.measurement.isMeasurementDrawable(data.sessionType)) {
                                drawPenMeasurement(imageUid, context, data, presentation, imageRenderer, data.editMode);
                            }
                        }
                    }
                }
            }
        }

    }

    function updateDynamicVolumes(tempData, imageUid, imageData, frameIndex, parentDiv, presentation, context, imageRenderer) {
        tempData.measurementComplete = true;
        var volumeMeasurements = dicomViewer.measurement.getVolumeMeasurements(imageUid, frameIndex);

        if (volumeMeasurements !== undefined && volumeMeasurements.length !== 0) {
            var measurements = volumeMeasurements[imageData.measurementId];
            if (measurements !== undefined && measurements.length !== 0) {
                var lastLineData = measurements[measurements.length - 1];
                if (imageData.measureType === "volume" || imageData.measureType === "volumeeditmove") {
                    drawLineWithoutMeasurement(imageUid, context, imageData, presentation, imageRenderer, false);
                }
                var lastData = [];
                if (tempData.measurementComplete === true) {
                    lastData = {
                        start: {
                            x: measurements[0].start.x,
                            y: measurements[0].start.y
                        },
                        end: {
                            x: lastLineData.end.x,
                            y: lastLineData.end.y
                        },
                        measureType: "line"
                    };
                    drawLineWithoutMeasurement(imageUid, context, lastData, presentation, imageRenderer, true);
                }
                //Find the mid point between the line
                //[(x_1 + x_2)/2 , (y_1 + y_2)/2]
                var midPointX = (lastData.start.x + lastData.end.x) / 2;
                var midPointY = (lastData.start.y + lastData.end.y) / 2;
                var arrLength = [];
                var lengthData = [];
                for (var j = 0; j < measurements.length - 1; j++) {
                    lengthData = {
                        start: {
                            x: midPointX,
                            y: midPointY
                        },
                        end: {
                            x: measurements[j].end.x,
                            y: measurements[j].end.y
                        },
                        measureType: "line"
                    };
                    //drawLineWithoutMeasurement(imageUid, context, lengthData, presentation, imageRenderer,true);

                    var value = getLengthText(lengthData);
                    arrLength[j] = parseInt(value.split(" ")[0]);
                }
                var maxIndex = findIndexOfGreatest(arrLength);
                lengthData = {
                    start: {
                        x: midPointX,
                        y: midPointY
                    },
                    end: {
                        x: measurements[maxIndex].end.x,
                        y: measurements[maxIndex].end.y
                    },
                    measureType: "line"
                };
                drawLineWithoutMeasurement(imageUid, context, lengthData, presentation, imageRenderer, true);
                var point = measurements[maxIndex];
                var slope = (lastData.end.y - lastData.start.y) / (lastData.end.x - lastData.start.x);
                var slope2 = (-1 / slope);
                var newAngle = Math.atan(slope2);
                var delta_x_A_C = 20000 * Math.cos(newAngle);
                var delta_y_A_C = 20000 * Math.sin(newAngle);
                var newX1 = point.end.x + delta_x_A_C;
                var newY1 = point.end.y + delta_y_A_C;

                delta_x_A_C = -20000 * Math.cos(newAngle);
                delta_y_A_C = -20000 * Math.sin(newAngle);
                var newX2 = point.end.x + delta_x_A_C;
                var newY2 = point.end.y + delta_y_A_C;


                newAngle = Math.atan(slope);
                delta_x_A_C = 20000 * Math.cos(newAngle);
                delta_y_A_C = 20000 * Math.sin(newAngle);
                var newX3 = lastData.end.x + delta_x_A_C;
                var newY3 = lastData.end.y + delta_y_A_C;

                delta_x_A_C = -20000 * Math.cos(newAngle);
                delta_y_A_C = -20000 * Math.sin(newAngle);
                var newX4 = lastData.end.x + delta_x_A_C;
                var newY4 = lastData.end.y + delta_y_A_C;
                var newIntersect = getIntersectionPoint(newX1, newY1,
                    newX2, newY2,
                    newX3, newY3, newX4, newY4);
                if (newIntersect === null)
                    return;
                midPointX = newIntersect.x;
                midPointY = newIntersect.y;
                var newData = {
                    start: {
                        x: midPointX,
                        y: midPointY
                    },
                    end: {
                        x: measurements[maxIndex].end.x,
                        y: measurements[maxIndex].end.y
                    },
                    measureType: "line"
                };
                drawLineWithoutMeasurement(imageUid, context, newData, presentation, imageRenderer, true);
                var firstPoint = [];
                var drawWithXAxis = false;
                if (Math.abs(midPointX - point.end.x) > Math.abs(midPointY - point.end.y)) {
                    drawWithXAxis = true;
                }


                var angle_A_B = Math.atan2((newData.end.y - newData.start.y), (newData.end.x - newData.start.x));
                var distance = -arrLength[maxIndex];
                var pointsToBeSent = {};
                var pointIndex = 0;
                for (var iTemp = 0; iTemp < (2 * arrLength[maxIndex]) / 10; iTemp++) {
                    var delta_x_A_C = distance * Math.cos(angle_A_B);
                    var delta_y_A_C = distance * Math.sin(angle_A_B)
                    var x3 = midPointX + delta_x_A_C;
                    var y3 = midPointY + delta_y_A_C;
                    var b = y3 - (slope * x3);
                    var point1 = [];
                    var point2 = [];
                    if (drawWithXAxis) {
                        point1 = {
                            x: (x3 - arrLength[maxIndex]),
                            y: ((slope * (x3 - arrLength[maxIndex])) + b)
                        };
                        point2 = {
                            x: (x3 + arrLength[maxIndex]),
                            y: ((slope * (x3 + arrLength[maxIndex])) + b)
                        };
                    } else {
                        point1 = {
                            x: ((y3 - arrLength[maxIndex] - b) / slope),
                            y: (y3 - arrLength[maxIndex])
                        };
                        point2 = {
                            x: ((y3 + arrLength[maxIndex] - b) / slope),
                            y: (y3 + arrLength[maxIndex])
                        };
                    }
                    var intersectPoint1 = undefined;
                    var intersectPoint2 = undefined;

                    for (var j = 0; j < measurements.length; j++) {

                        var intersect = getIntersectionPoint(measurements[j].start.x, measurements[j].start.y,
                            measurements[j].end.x, measurements[j].end.y,
                            x3, y3, point1.x, point1.y);
                        if (intersect != null) {
                            if (intersectPoint1 == null || intersectPoint1 == undefined) intersectPoint1 = intersect;
                            else if (intersectPoint2 == null || intersectPoint2 == undefined) intersectPoint2 = intersect;
                        }
                        intersect = getIntersectionPoint(measurements[j].start.x, measurements[j].start.y,
                            measurements[j].end.x, measurements[j].end.y,
                            x3, y3, point2.x, point2.y);
                        if (intersect != null) {
                            if (intersectPoint1 == null || intersectPoint1 == undefined) intersectPoint1 = intersect;
                            else if (intersectPoint2 == null || intersectPoint2 == undefined) intersectPoint2 = intersect;
                        }

                        if (intersectPoint1 !== null && intersectPoint2 !== null &&
                            intersectPoint1 !== undefined && intersectPoint2 !== undefined) {
                            firstPoint = {
                                start: {
                                    x: intersectPoint1.x,
                                    y: intersectPoint1.y
                                },
                                end: {
                                    x: intersectPoint2.x,
                                    y: intersectPoint2.y
                                },
                                measureType: "line"
                            };
                            drawLineWithoutMeasurement(imageUid, context, firstPoint, presentation, imageRenderer, true);
                            pointsToBeSent[pointIndex] = [];
                            pointsToBeSent[pointIndex][0] = intersectPoint1;
                            pointsToBeSent[pointIndex][1] = intersectPoint2;
                            pointIndex++;
                            intersectPoint1 = undefined;
                            intersectPoint2 = undefined;
                        }
                    }

                    distance = distance + 10;

                }
                var measurementToBeSent = {};
                for (var k = 0; k < measurements.length; k++) {
                    measurementToBeSent[k] = [];
                    measurementToBeSent[k][0] = measurements[k].start;
                    measurementToBeSent[k][1] = measurements[k].end;
                }
                var sendData = {
                    volumeId: imageData.measurementId,
                    volumePoints: measurementToBeSent,
                    volumeSegments: pointsToBeSent
                };
                sendVolumeMeasurements(JSON.stringify(sendData));
            }
        }
    }

    function getImageCoordinatesForMousePoint(mousePoint, imageRenderer, context) {
        var presentation = imageRenderer.presentationState;
        if (imageRenderer === undefined) {
            throw "getImageCoordinatesForMousePoint: imageRenderer is null/undefined";
        }
        if (imageRenderer.imagePromise === undefined) {
            throw "getImageCoordinatesForMousePoint: imagePromise is null/undefined";
        }
        if (mousePoint == null) {
            return null;
        }

        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });

        //var context = dicomViewer.measurement.getImageContext(imageUid,frameIndex);
        if (context === undefined) {
            throw "getImageCoordinatesForMousePoint: canvas 2d context is null/undefined";
        }
        if (presentation === undefined) {
            throw "getImageCoordinatesForMousePoint: presentation is null/undefined";
        }
        var pan = presentation.getPan();
        var imageCordinate = {};

        var contextPoint = context.transformedPoint(mousePoint.x, mousePoint.y);

        imageCordinate.x = (contextPoint.x - pan.x);
        imageCordinate.y = (contextPoint.y - pan.y);
        imageCordinate.handleActive = mousePoint.handleActive;

        return imageCordinate;
    }

    function getMousePointForImageCoordinates(imageCoordinate, imageRenderer, context) {
        var presentation = imageRenderer.presentationState;
        if (imageRenderer === undefined) {
            throw "getMousePointForImageCoordinates: imageRenderer is null/undefined";
        }
        if (imageRenderer.imagePromise === undefined) {
            throw "getMousePointForImageCoordinates: imagePromise is null/undefined";
        }
        if (imageCoordinate == null) {
            return null;
        }

        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });

        // var context = dicomViewer.measurement.getImageContext(imageUid,frameIndex);
        if (context === undefined) {
            throw "getMousePointForImageCoordinates: canvas 2d context is null/undefined";
        }
        if (presentation === undefined) {
            throw "getMousePointForImageCoordinates: presentation is null/undefined";
        }
        var pan = presentation.getPan();
        var mousePoint = {};
        var contextPoint = context.mousePoint(parseFloat(imageCoordinate.x) + pan.x, parseFloat(imageCoordinate.y) + pan.y);
        mousePoint.x = contextPoint.x;
        mousePoint.y = contextPoint.y;
        mousePoint.handleActive = imageCoordinate.handleActive;

        return mousePoint;
    }

    function getCanvasCoordinatesForImageCoordinates(imageCoordinate, imageRenderer) {
        var presentation = imageRenderer.presentationState;
        if (imageRenderer === undefined) {
            throw "getMousePointForImageCoordinates: imageRenderer is null/undefined";
        }
        if (imageRenderer.imagePromise === undefined) {
            throw "getMousePointForImageCoordinates: imagePromise is null/undefined";
        }
        if (presentation === undefined) {
            throw "getMousePointForImageCoordinates: presentation is null/undefined";
        }
        if (imageCoordinate == null) {
            return null;
        }

        var pan = presentation.getPan();
        var canvasCoordinates = {};
        canvasCoordinates.x = parseFloat(imageCoordinate.x) + pan.x;
        canvasCoordinates.y = parseFloat(imageCoordinate.y) + pan.y;
        canvasCoordinates.handleActive = imageCoordinate.handleActive;

        return canvasCoordinates;
    }

    function drawLineWithoutMeasurement(imageUid, context, data, presentation, imageRenderer, dottedLine, isQualifyforEdit) {
        var imageCoordinate = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        var scale = presentation.getZoom();
        // draw the line
        var currentTempData = dicomViewer.measurement.getTempData();
        if (isQualifyforEdit === true && currentTempData !== undefined && currentTempData.measureType !== null && currentTempData.measureType === "volumeedit" && (data.end.handleActive || data.start.handleActive)) {
            var radius = 2 / (imageRenderer.scaleValue / scale);
            context.beginPath();
            context.strokeStyle = '#DAA520';
            context.arc(imageCoordinate.start.x, imageCoordinate.start.y, radius, 0, 2 * Math.PI, false);
            context.closePath();
            context.stroke();
        }

        context.beginPath();
        updateContextStyle(context, imageCoordinate.style, false, imageRenderer.scaleValue);

        context.moveTo(imageCoordinate.start.x, imageCoordinate.start.y);
        context.lineTo(imageCoordinate.end.x, imageCoordinate.end.y);

        if (dottedLine) context.setLineDash([5 / scale, 10 / scale]);
        else context.setLineDash([]);
        context.closePath();
        context.stroke();
    }

    function drawLineMeasurement(imageUid, context, data, presentation, imageRenderer, editValue) {
        var imageCoordinate = data;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
        var usRegionFound = false;
        var resultText = null;
        var applyCalibration = false;
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var measurementUnit = null;
        var precision = parseInt(data.style.precision);

        applyCalibration = (measurementUnit = getUnitMeasurementMap(seriesLayout.studyUid + "|" + imageRenderer.seriesIndex + "|" + imageRenderer.imageIndex + "|" + imageRenderer.anUIDs.split("*")[1])) ? true : false;

        if (data.calibrationData && data.calibrationData !== "undefined") {
            applyCalibration = true;
            measurementUnit = !measurementUnit ? measurementUnit = {} : measurementUnit;
            measurementUnit.pixelSpacing = data.calibrationData.pixelSpacing;
            measurementUnit.pixelSpacing.unitType = data.calibrationData.unitType;
        }

        //set the last calibrated image
        setActiveCalibratedImage(seriesLayout.studyUid + "|" + imageRenderer.seriesIndex + "|" + imageRenderer.imageIndex + "|" + imageRenderer.anUIDs.split("*")[1]);

        var dicomImageInfo = dicomHeader.imageInfo.measurement;
        var pixelSpacing = dicomImageInfo ? dicomImageInfo.pixelSpacing : undefined;
        var isCaliber = dicomViewer.tools.getCursorType();

        if (measurementUnit != null && applyCalibration) {
            var value = getLengthUsingPixelSpacing(imageCoordinate, measurementUnit.pixelSpacing, false);
            if (parseFloat(value) > 0.05) {

                var calibrateFlag = (pixelSpacing == undefined ||
                    (pixelSpacing.row <= 0 && pixelSpacing.column <= 0)) ? false : true;
                resultText = getDisplayLengthText(value, calibrateFlag, data.measurementComplete, data.style.measurementUnits, calibrateFlag, precision);
            } else {
                return;
            }
        } else if ((isCaliber == "calibrate") || (dicomImageInfo != null && dicomImageInfo !== undefined)) {
            if (isValidPixelSpacing(pixelSpacing)) {
                var value = getLengthUsingPixelSpacing(imageCoordinate, pixelSpacing, true);
                if (parseFloat(value) > 0.05) {
                    resultText = getDisplayLengthText(value, false, data.measurementComplete, data.style.measurementUnits, undefined, precision);
                } else if (pixelSpacing.row <= 0 && pixelSpacing.column <= 0 && dicomViewer.tools.getFlagFor2dLengthCalibration() && data.measurementSubType != "2DLine" && data.measurementSubType != "Arrow") {
                    value = 1;
                    resultText = "";
                } else if (data.measurementSubType == "2DLine" || data.measurementSubType == "Arrow") {
                    value = 1;
                    resultText = "";
                } else {
                    return;
                }
            } else if ((isCaliber === "calibrate")) {
                value = 1;
                resultText = "";
            } else if (dicomImageInfo && (dicomImageInfo.usRegions != null) && (dicomImageInfo.usRegions.length > 0)) {

                var regionSpatialFormat = 0;
                var physicalUnitsXDirection = 0;
                var physicalUnitsYDirection = 0;
                var physicalDeltaX = 0.0;
                var physicalDeltaY = 0.0;

                for (var i = 0; i < dicomHeader.imageInfo.measurement.usRegions.length; i++) {
                    var usRegion = dicomHeader.imageInfo.measurement.usRegions[i];

                    if (((imageCoordinate.start.x <= usRegion.regionLocationMaxX1) && (imageCoordinate.start.x >= usRegion.regionLocationMinX0)) &&
                        ((imageCoordinate.start.y <= usRegion.regionLocationMaxY1) && (imageCoordinate.start.y >= usRegion.regionLocationMinY0)) &&
                        ((imageCoordinate.end.x <= usRegion.regionLocationMaxX1) && (imageCoordinate.end.x >= usRegion.regionLocationMinX0)) &&
                        ((imageCoordinate.end.y <= usRegion.regionLocationMaxY1) && (imageCoordinate.end.y >= usRegion.regionLocationMinY0)) &&
                        (!((usRegion.regionSpatialFormat == 0) && (usRegion.physicalUnitsXDirection == 0) && (usRegion.physicalUnitsYDirection == 0)))) {

                        usRegionFound = true;
                        regionSpatialFormat = usRegion.regionSpatialFormat;
                        physicalUnitsXDirection = usRegion.physicalUnitsXDirection;
                        physicalUnitsYDirection = usRegion.physicalUnitsYDirection;
                        physicalDeltaX = usRegion.physicalDeltaX;
                        physicalDeltaY = usRegion.physicalDeltaY;
                        break;
                    }
                }

                if (usRegionFound) {

                    if ((regionSpatialFormat == 1) && (physicalUnitsXDirection == 3) && (physicalUnitsYDirection == 3)) {

                        var pixelSpacing = {
                            column: Math.abs(physicalDeltaX) * 10.0,
                            row: Math.abs(physicalDeltaY) * 10.0,
                        };

                        var lengthInCM = getLengthUsingPixelSpacing(imageCoordinate, pixelSpacing, true);

                        if (imageCoordinate.style.measurementUnits != null) {
                            if (imageCoordinate.style.measurementUnits == "mm") {
                                lengthInCM *= 10.0;
                                resultText = "" + lengthInCM.toFixed(precision) + " mm";
                            } else if (imageCoordinate.style.measurementUnits == "in") {
                                resultText = "" + lengthInCM.toFixed(precision) + " in";
                            } else {
                                resultText = "" + lengthInCM.toFixed(precision) + " cm";
                            }
                        } else {
                            if (lengthInCM < 0.01) {
                                lengthInCM *= 10000.0;
                                resultText = "" + lengthInCM.toFixed(precision) + " \u00B5" + "cm";
                            } else if (lengthInCM < 1) {
                                lengthInCM *= 10.0;
                                resultText = "" + lengthInCM.toFixed(precision) + " mm";
                            } else
                                resultText = "" + lengthInCM.toFixed(precision) + " cm";
                        }
                    } else {

                        var lengthX = Math.abs(imageCoordinate.end.x - imageCoordinate.start.x) * Math.abs(physicalDeltaX);
                        var lengthY = Math.abs(imageCoordinate.end.y - imageCoordinate.start.y) * Math.abs(physicalDeltaY);

                        var unitsX;
                        var unitsY;
                        if ((physicalUnitsXDirection < 0) || (physicalUnitsXDirection > 12)) {
                            unitsX = "unknown";
                        } else if ((physicalUnitsYDirection < 0) || (physicalUnitsYDirection > 12)) {
                            unitsY = "unknown";
                        } else {
                            unitsX = physicalUnitsXYDirectionArray[physicalUnitsXDirection];
                            unitsY = physicalUnitsXYDirectionArray[physicalUnitsYDirection];
                        }

                        if (imageCoordinate.measurementType == 1) // Y- Axis
                            resultText = "" + lengthY.toFixed(precision) + " " + unitsY;
                        else // X-axis
                            resultText = "" + lengthX.toFixed(precision) + " " + unitsX;
                    }
                } else
                    resultText = getLengthText(imageCoordinate);
            } else {
                resultText = getLengthText(imageCoordinate);
            }
            var value = resultText.split(" ")[0];
            if (parseFloat(value) < 0.05) {
                return;
            }
        } else {
            resultText = getLengthText(imageCoordinate);
        }

        if (editValue === undefined) {
            var dist = Math.sqrt(Math.pow(data.end.x - data.start.x, 2) +
                Math.pow(data.end.y - data.start.y, 2));

            if (data.measurementSubType == "Arrow") {
                if (dist * imageRenderer.scaleValue < 10) {
                    return;
                }
            }

            // draw the line
            context.beginPath();
            updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
            context.moveTo(data.start.x, data.start.y);
            context.lineTo(data.end.x, data.end.y);
            context.setLineDash([]);
            context.closePath();
            context.stroke();

            drawLineHandles(imageUid, context, data, presentation, imageRenderer);

            if (data.measurementSubType != "2DLine" && data.measurementSubType != "Arrow") {
                drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false);
            }
        }
        // for reporting
        if ((usRegionFound) && (imageCoordinate.measurementId != null)) {
            return {
                id: imageCoordinate.measurementId,
                value: resultText
            };
        }

        return null;
    }

    function drawEllipseMeasurement(imageUid, context, data, presentation, imageRenderer, isEllipseEnd, isEditMode) {
        var imageCoordinate = data;
        var result = 0;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var deltaY = (data.start.y - data.end.y);
        var deltaX = (data.end.x - data.start.x);
        if (data.start.y < data.end.y)
            result = Math.abs(Math.atan2(deltaY, deltaX));
        else
            result = Math.abs(Math.atan2(deltaY, deltaX)) * -1;

        var zoom = presentation.getZoom();
        if (data !== undefined) {
            if (data.first == null || data.first == undefined || !data.isCustomEllipse) {
                context.setLineDash([], []);
                updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
                // PR file Ellipse - Compund graphic sequence
                drawEllipseWithinRectangleBounds(context, data);
                if (isEditMode == undefined || isEditMode) {
                    var radius = (4 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
                    context.setLineDash([]);
                    // draws the four quadrant points.
                    drawArcandLine(data.start, undefined, radius, true, "#DAA520", context);
                    drawArcandLine(data.end, undefined, radius, true, "#DAA520", context);

                    var third = {
                        x: data.start.x,
                        y: data.end.y
                    }
                    var fourth = {
                        x: data.end.x,
                        y: data.start.y
                    }
                    drawArcandLine(third, undefined, radius, true, "#DAA520", context);
                    drawArcandLine(fourth, undefined, radius, true, "#DAA520", context);
                }
            } else {
                // calculate and draw the four ellipse quadrants.
                drawQuadrantsOfEllipse(data, context, imageRenderer.scaleValue, zoom, isEditMode);
                if (isEditMode == undefined || isEditMode) {
                    var radius = (4 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
                    context.setLineDash([]);
                    // draws the four quadrant points.
                    drawArcandLine(data.first, undefined, radius, true, "#DAA520", context);
                    drawArcandLine(data.second, undefined, radius, true, "#DAA520", context);
                    drawArcandLine(data.third, undefined, radius, true, "#DAA520", context);
                    drawArcandLine(data.fourth, undefined, radius, true, "#DAA520", context);
                }
            }
        }
        if (isEllipseEnd != undefined && data.measurementSubType != "ellipse") {
            if (isEllipseEnd) {
                resultText = calculateStandardDeviation(imageUid, context, imageCoordinate, presentation, imageRenderer);
                drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false, true);
                return resultText;
            } else {
                drawMeasurementsLength(context, data, imageRenderer, presentation, imageCoordinate.measurementResult, false, true);
            }
        }
        return null;
    }

    /**
     * darws ellipse with 2 points (Compund graphic sequence)
     * @param {Type} context 
     * @param {Type} data 
     */
    function drawEllipseWithinRectangleBounds(context, data) {
        context.save();
        context.beginPath();
        //Dynamic scaling
        var scalex = 1 * ((data.end.x - data.start.x) / 2);
        var scaley = 1 * ((data.end.y - data.start.y) / 2);
        scalex = scalex == 0 ? 1 : scalex;
        scaley = scaley == 0 ? 1 : scaley;
        context.scale(scalex, scaley);
        //Create ellipse
        var point = {
            x: (data.start.x / scalex) + 1,
            y: (data.start.y / scaley) + 1
        }
        context.arc(point.x, point.y, 1, 0, 2 * Math.PI, false);
        //Restore and draw
        context.restore();
        context.closePath();
        if (data.style.isFill) {
            context.fillStyle = data.style.fillColor;
            context.fill();
        } else {
            context.strokeStyle = data.style.lineColor;
            context.stroke();
        }
    }

    /**
     * draws Arc or Line using given inputs.
     * @param {Type} start 
     * @param {Type} end 
     * @param {Type} radius 
     * @param {Type} isArc 
     * @param {Type} strokeStyle 
     * @param {Type} context 
     */
    function drawArcandLine(start, end, radius, isArc, strokeStyle, context) {
        context.beginPath();
        context.strokeStyle = strokeStyle;
        context.moveTo(start.x, start.y);
        if (isArc) {
            context.arc(start.x, start.y, radius, 0, 2 * Math.PI, false);
        } else {
            context.lineTo(end.x, end.y);
        }
        context.closePath();
        context.stroke();
    }

    /**
     * 
     * @param {Type} data 
     * @param {Type} context 
     * @param {Type} scaleValue 
     */
    function drawQuadrantsOfEllipse(data, context, scaleValue, zoom, isEditMode) {
        // draws cross line between quadrants.
        if (data.isEditable && (isEditMode == undefined || isEditMode)) {
            context.setLineDash([5 / zoom], [5 / zoom]);
            drawArcandLine(data.first, data.second, undefined, false, data.style.lineColor, context);
            drawArcandLine(data.fourth, data.third, undefined, false, data.style.lineColor, context);
        }

        context.setLineDash([], []);
        context.save();

        updateContextStyle(context, data.style, false, scaleValue);

        if (data.center == null || data.center == undefined) {
            // PR file Ellipse - Compund graphic sequenceata
            data.center = {
                x: (data.first.x + data.second.x) / 2,
                y: (data.first.y + data.second.y) / 2
            }
        }

        // draws the curve segment from first quadrant to fourth quadrant.
        drawQuadrant(data.first, data.fourth, {
            q1: data.third,
            q2: data.second
        }, data.center, context);

        // draws the curve segment from fourth quadrant to second quadrant.
        drawQuadrant(data.fourth, data.second, {
            q1: data.first,
            q2: data.third
        }, data.center, context);

        // draws the curve segment from second quadrant to third quadrant.
        drawQuadrant(data.second, data.third, {
            q1: data.fourth,
            q2: data.first
        }, data.center, context);

        // draws the curve segment from third quadrant to first quadrant.
        drawQuadrant(data.third, data.first, {
            q1: data.second,
            q2: data.fourth
        }, data.center, context);

        context.restore();
    }

    /**
     * 
     * @param {Type} start 
     * @param {Type} end 
     * @param {Type} oppositeQuads 
     * @param {Type} center 
     * @param {Type} context 
     * @param {Type} quadrant 
     */
    function drawQuadrant(start, end, oppositeQuads, center, context) {
        context.setLineDash([]);
        // check if the quadrants are circular form.
        if (isCircularQuadrant(start, end, center)) {
            // draws circular curve.
            renderCurveSegment(0, Math.PI * 0.5, center, start, false, context);
        } else {
            // draws two curve segment between starting and ending quadrant.

            // calculate two center points and angles to draw the curve
            var quadInfo = getQuadrantInfo(start, end, oppositeQuads, center, context);

            var angle = Math.abs(quadInfo.r2Angle);
            var swap = quadInfo.isSwapped;
            var center = quadInfo.c2Pt;

            // draws the first curve segment of a quadrant.
            var firstEndPt = renderCurveSegment(0, angle, center, swap ? start : end, swap ? false : true, context);

            angle = Math.abs(quadInfo.r1Angle);
            center = quadInfo.c1Pt;
            // draws the second curve segment of a quadrant.
            var secondEndPt = renderCurveSegment(0, angle, center, swap ? end : start, swap ? true : false, context);

            // connects the missing path between two curve segments.
            if (firstEndPt != undefined && secondEndPt != undefined) {
                context.moveTo(firstEndPt.x, firstEndPt.y);
                context.quadraticCurveTo(firstEndPt.x, firstEndPt.y, secondEndPt.x, secondEndPt.y);
                context.stroke();
            }
        }
    }

    /**
     * Returns the endpoint for the drawn curve segment.
     * @param {Type} startAngle 
     * @param {Type} endAngle 
     * @param {Type} center 
     * @param {Type} quadrant 
     * @param {Type} isNegative 
     * @param {Type} context 
     */
    function renderCurveSegment(startAngle, endAngle, center, quadrant, isNegative, context) {
        context.beginPath();
        var point;
        for (var i = startAngle; i < endAngle; i += 0.01) {
            point = rotate(center.x, center.y, quadrant, isNegative ? -i : i);
            if (i == startAngle) {
                context.moveTo(point.x, point.y);
            } else {
                context.lineTo(point.x, point.y);
            }
        }
        context.stroke();
        return point;
    }

    function checkLoop(isNegative, i, endAngle) {
        return isNegative ? i > endAngle : i < endAngle;
    }

    function incrLoop(isNegative, i) {
        return isNegative ? i - 0.01 : i + 0.01;
    }

    /**
     * Rotate a point to given radians with given center point.
     * @param {Type} cx 
     * @param {Type} cy 
     * @param {Type} point 
     * @param {Type} radians 
     */
    function rotate(cx, cy, point, radians) {
        cos = Math.cos(radians),
            sin = Math.sin(radians),
            nx = (cos * (point.x - cx)) + (sin * (point.y - cy)) + cx,
            ny = (cos * (point.y - cy)) - (sin * (point.x - cx)) + cy;
        return {
            x: nx,
            y: ny
        };
    }

    /**
     * Checks whether the quadrants are circular.
     * @param {Type} start 
     * @param {Type} end 
     * @param {Type} center 
     */
    function isCircularQuadrant(start, end, center) {
        var firstPos = findDSAValue(start, center),
            secondPos = findDSAValue(end, center);
        if (Math.abs(secondPos.distance - firstPos.distance) <= 2) {
            return true;
        }
        return false;
    }

    /**
     * Calculate distance, angle and slope values for two given points.
     * @param {Type} start 
     * @param {Type} end 
     */
    function findDSAValue(start, end) {
        var dx = end.x - start.x,
            dy = end.y - start.y,
            distance = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)),
            cosalpha = dx / distance,
            angle, slope;
        slope = (end.y - start.y) / (end.x - start.x);
        if (dy / distance < 0) {
            angle = (Math.PI * 2 - Math.acos(cosalpha));
        } else {
            angle = (Math.acos(cosalpha));
        }
        return {
            distance: distance,
            angle: angle,
            slope: slope
        };
    }

    /**
     * Calculates the two center points and angles to draw the two curve segments of the quadrants.
     * @param {Type} start 
     * @param {Type} end 
     * @param {Type} oppositeQuads 
     * @param {Type} center 
     * @param {Type} context 
     */
    function getQuadrantInfo(start, end, oppositeQuads, center, context) {
        /* Refer the following pdf for the calculations.
        https://academics.rowan.edu/csm/departments/math/facultystaff/faculty/osler/106%20APPROXIMATING%20AN%20ELLIPSE%20WITH%20FOUR%20CIRCULAR%20ARCS%20Sept2submission%20to%20MACE_Rev3a.pdf
        *
        */
        var quadrantInfo = {},
            dx, dy, slopeDistance, startDist, endDist,
            cosalpha, r1Angle, r2Angle, slope, c1Pt, c2Pt;

        var startPos = findDSAValue(center, start);
        startDist = startPos.distance;
        var endPos = findDSAValue(center, end);
        endDist = endPos.distance;
        var slopePos = findDSAValue(start, end);
        slopeDistance = slopePos.distance;

        r2Angle = slopePos.angle - Math.PI;
        r1Angle = Math.abs(Math.PI - ((Math.PI * 0.5) + r2Angle));

        var multiplier = (r2Angle > -Math.PI * 0.5 && r2Angle < Math.PI * 0.5) ? -1 : 1;
        var finalDist = startDist - endDist,
            finalStartPt = start,
            finalEndPt = end,
            finalStartPos = startPos,
            finalEndPos = endPos,
            opposite = oppositeQuads.q1,
            isSwapped = false;

        // Swap the end points if the end point distance to center point is greater than start point distance.
        if (endDist > startDist) {
            finalDist = endDist - startDist;
            finalStartPt = end;
            finalEndPt = start;
            finalStartPos = endPos;
            finalEndPos = startPos;
            multiplier = -multiplier;
            opposite = oppositeQuads.q2;
            isSwapped = true;
        }

        // find mid point after subtracting the difference to center along the slope of start and end points.
        var normalizedSlopeDist = (slopeDistance - finalDist) / 2;
        slope = slopePos.slope;
        var midPt = {
            x: finalStartPt.x + multiplier * (normalizedSlopeDist / Math.sqrt(1 + Math.pow(slope, 2))),
            y: finalStartPt.y + multiplier * ((slope * normalizedSlopeDist) / Math.sqrt(1 + Math.pow(slope, 2)))
        };

        // find a point of perpendicular line to the slope from the above mid point.
        slope = -(1 / slope);
        multiplier = (r2Angle > 0 && r2Angle < Math.PI) ? -1 : 1;
        tempPt = {
            x: midPt.x + multiplier * (slopeDistance / Math.sqrt(1 + Math.pow(slope, 2))),
            y: midPt.y + multiplier * ((slope * slopeDistance) / Math.sqrt(1 + Math.pow(slope, 2)))
        };

        // find the two centers to draw the curve segments.
        var centers = findC1andC2Points(finalStartPt, finalEndPt, opposite, center, midPt, tempPt);

        // find two angles of curve segments.
        var centerPos = findDSAValue(centers.c1Pt, centers.c2Pt);
        r1Angle = Math.atan((centerPos.slope - finalStartPos.slope) / (1 + (finalStartPos.slope * centerPos.slope)));
        r2Angle = Math.atan((centerPos.slope - finalEndPos.slope) / (1 + (finalEndPos.slope * centerPos.slope)));

        r1Angle = isNaN(r1Angle) ? (Math.PI * 0.25) : r1Angle;
        r2Angle = isNaN(r2Angle) ? (Math.PI * 0.25) : r2Angle;

        quadrantInfo = {
            r1Angle: r1Angle,
            r2Angle: r2Angle,
            c1Pt: centers.c1Pt,
            c2Pt: centers.c2Pt,
            isSwapped: isSwapped
        }
        return quadrantInfo;
    }

    /**
     * Returns two center points using given lines by finding its intersections.
     * @param {Type} start 
     * @param {Type} end 
     * @param {Type} opposite 
     * @param {Type} center 
     * @param {Type} midPt 
     * @param {Type} tempPt 
     */
    function findC1andC2Points(start, end, opposite, center, midPt, tempPt) {
        var c2Pt = findIntersectingPt(midPt, end, opposite, tempPt),
            c1Pt = findIntersectingPt(midPt, center, start, c2Pt);
        return {
            c1Pt: c1Pt,
            c2Pt: c2Pt
        };
    }

    /**
     * Return the point of intersection.
     */
    function findIntersectingPt(pt1, pt2, pt3, pt4) {
        // Line AB represented as a1x + b1y = c1
        var a1 = pt4.y - pt1.y;
        var b1 = pt1.x - pt4.x;
        var c1 = a1 * (pt1.x) + b1 * (pt1.y);

        // Line CD represented as a2x + b2y = c2
        var a2 = pt3.y - pt2.y;
        var b2 = pt2.x - pt3.x;
        var c2 = a2 * (pt2.x) + b2 * (pt2.y);

        var determinant = a1 * b2 - a2 * b1,
            intersectingPt;
        if (determinant == 0) {
            // The lines are parallel.
        } else {
            intersectingPt = {
                x: (b2 * c1 - b1 * c2) / determinant,
                y: (a1 * c2 - a2 * c1) / determinant
            };
        }
        return intersectingPt;
    }

    /**
     * To draw rectangle measurement of hounsfield and annotation types
     * @param {Type} imageUid 
     * @param {Type} context 
     * @param {Type} data 
     * @param {Type} presentation 
     * @param {Type} imageRenderer 
     * @param {Type} isRectangleEnd 
     * @param {Type} isEditMode 
     */
    function drawRectangleMeasurement(imageUid, context, data, presentation, imageRenderer, isRectangleEnd, isEditMode, isEdit) {
        var isFill = data.style.isFill;
        updateContextStyle(context, data.style, false, imageRenderer.scaleValue, undefined, isFill);
        var imageCoordinate = getAndUpdateTextBounds(context, data, imageRenderer);
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var deltaY = (data.end.y - data.start.y);
        var deltaX = (data.end.x - data.start.x);

        var result = 0;
        if (data.start.y < data.end.y)
            result = Math.abs(Math.atan2(deltaY, deltaX));
        else
            result = Math.abs(Math.atan2(deltaY, deltaX)) * -1;

        if (data !== undefined) {
            context.beginPath();
            //Restore and draw
            if (data.measurementSubType === "text") {
                context.setLineDash([4, 4]);
            } else {
                context.setLineDash([]);
            }
            //Create rectangle
            if (!(data.measurementType == 8 && data.measurementSubType === "text" &&
                    ((isRectangleEnd == undefined && isEditMode == false && isEdit == undefined) ||
                        (isRectangleEnd == true && isEditMode == false))
                )) {
                context.moveTo(data.start.x, data.start.y);
                context.lineTo(data.start.x, data.end.y);
                context.lineTo(data.end.x, data.end.y);
                context.lineTo(data.end.x, data.start.y);
                context.closePath();
                if (isFill) {
                    context.fill();
                } else {
                    context.stroke();
                }

            }

            context.setLineDash([]);
            if (isEditMode == undefined || isEditMode) {
                var radius = (4 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
                context.lineWidth = radius;
                context.beginPath();
                context.strokeStyle = "#DAA520";
                context.arc(data.start.x, data.start.y, radius, 0, 2 * Math.PI, false);
                context.closePath();
                context.stroke();

                context.beginPath();
                context.strokeStyle = "#DAA520";
                context.arc(data.start.x, data.end.y, radius, 0, 2 * Math.PI, false);
                context.closePath();
                context.stroke();

                context.beginPath();
                context.strokeStyle = "#DAA520";
                context.arc(data.end.x, data.end.y, radius, 0, 2 * Math.PI, false);
                context.closePath();
                context.stroke();

                context.beginPath();
                context.strokeStyle = "#DAA520";
                context.arc(data.end.x, data.start.y, radius, 0, 2 * Math.PI, false);
                context.closePath();
                context.stroke();
            }
        }

        var isText = (data.measurementSubType === "text") ? true : false;
        if (isRectangleEnd != undefined && data.measurementSubType === "hounsfield") {
            if (isRectangleEnd) {
                resultText = calculateStandardDeviation(imageUid, context, imageCoordinate, presentation, imageRenderer);
                drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false, false, false, true);
                return resultText;
            } else {
                drawMeasurementsLength(context, data, imageRenderer, presentation, imageCoordinate.measurementResult, false, false, false, true);
            }
        } else if ((isEdit && isText) || (isRectangleEnd != undefined && isText)) {
            if ((isEdit) || (isRectangleEnd && data.measurementText !== undefined && data.measurementText.length > 0)) {
                resultText = data.measurementText;
                drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false, false, true);
            }
        }
        return null;
    }

    function drawPointMeasurement(imageUid, context, data, presentation, imageRenderer, editValue) {
        var imageCoordinate = data;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var scale = presentation.getZoom();
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);

        var resultText = null;
        if (dicomHeader.imageInfo.measurement != null) {
            if ((dicomHeader.imageInfo.measurement.usRegions != null) && (dicomHeader.imageInfo.measurement.usRegions.length > 0)) {
                var usRegionFound = false;
                var regionSpatialFormat = 0;
                var physicalUnitsXDirection = 0;
                var physicalUnitsYDirection = 0;
                var roiPosXValue = 0.0;
                var roiPosYValue = 0.0;
                var isReferencePixelX0Present = false;
                var isReferencePixelY0Present = false;

                for (var i = 0; i < dicomHeader.imageInfo.measurement.usRegions.length; i++) {
                    var usRegion = dicomHeader.imageInfo.measurement.usRegions[i];

                    if (((usRegion.regionSpatialFormat == 2) || (usRegion.regionSpatialFormat == 3)) &&
                        ((imageCoordinate.start.x <= usRegion.regionLocationMaxX1) && (imageCoordinate.start.x >= usRegion.regionLocationMinX0)) &&
                        ((imageCoordinate.start.y <= usRegion.regionLocationMaxY1) && (imageCoordinate.start.y >= usRegion.regionLocationMinY0))) {
                        usRegionFound = true;
                        regionSpatialFormat = usRegion.regionSpatialFormat;
                        physicalUnitsXDirection = usRegion.physicalUnitsXDirection;
                        physicalUnitsYDirection = usRegion.physicalUnitsYDirection;
                        isReferencePixelX0Present = usRegion.isReferencePixelX0Present;
                        isReferencePixelY0Present = usRegion.isReferencePixelY0Present;

                        if (isReferencePixelX0Present) {
                            roiPosXValue = (imageCoordinate.start.x - (usRegion.regionLocationMinX0 + usRegion.referencePixelX0) + usRegion.referencePixelPhysicalValueX) * usRegion.physicalDeltaX;
                        }

                        if (isReferencePixelY0Present) {

                            if (usRegion.regionSpatialFormat == 2)
                                // M-Mode
                                roiPosYValue = -((usRegion.regionLocationMinY0 + usRegion.referencePixelY0) - imageCoordinate.end.y + usRegion.referencePixelPhysicalValueY) * Math.abs(usRegion.physicalDeltaY);
                            else
                                // Spectral
                                roiPosYValue = ((usRegion.regionLocationMinY0 + usRegion.referencePixelY0) - imageCoordinate.end.y + usRegion.referencePixelPhysicalValueY) * Math.abs(usRegion.physicalDeltaY);
                        }

                        break;
                    }
                }

                if (usRegionFound) {

                    var unitsX;
                    var unitsY;
                    if ((physicalUnitsXDirection < 0) || (physicalUnitsXDirection > 12)) {
                        unitsX = "unknown";
                    } else if ((physicalUnitsYDirection < 0) || (physicalUnitsYDirection > 12)) {
                        unitsY = "unknown";
                    } else {
                        unitsX = physicalUnitsXYDirectionArray[physicalUnitsXDirection];
                        unitsY = physicalUnitsXYDirectionArray[physicalUnitsYDirection];
                    }

                    if ((!isReferencePixelX0Present) && (isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 1) {
                            // Y- Axis
                            resultText = formatMeasurementResult(roiPosYValue, unitsY, imageCoordinate.measurementUnits);
                        } else {
                            resultText = formatMeasurementResult(null, unitsX, imageCoordinate.measurementUnits);
                        }
                    } else if ((isReferencePixelX0Present) && (!isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 1) {
                            // Y- Axis
                            resultText = formatMeasurementResult(null, unitsY, imageCoordinate.measurementUnits);
                        } else {
                            resultText = formatMeasurementResult(roiPosXValue, unitsX, imageCoordinate.measurementUnits);
                        }
                    } else if ((!isReferencePixelX0Present) && (!isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 1) {
                            // Y- Axis
                            resultText = formatMeasurementResult(null, unitsY, imageCoordinate.measurementUnits);
                        } else {
                            resultText = formatMeasurementResult(null, unitsX, imageCoordinate.measurementUnits);
                        }
                    } else
                    if (imageCoordinate.measurementType == 1) {
                        // Y- Axis
                        resultText = formatMeasurementResult(roiPosYValue, unitsY, imageCoordinate.measurementUnits);
                    } else {
                        resultText = formatMeasurementResult(roiPosXValue, unitsX, imageCoordinate.measurementUnits);
                    }
                } else {
                    resultText = "" + (imageCoordinate.end.x).toFixed(0) + " pix, " + (imageCoordinate.end.y).toFixed(0) + " pix";
                }
            } else {
                resultText = "" + (imageCoordinate.end.x).toFixed(0) + " pix, " + (imageCoordinate.end.y).toFixed(0) + " pix";
            }
        } else {
            resultText = "" + (imageCoordinate.end.x).toFixed(0) + " pix, " + (imageCoordinate.end.y).toFixed(0) + " pix";
        }

        if (editValue === undefined) {
            // draw the line
            context.beginPath();
            updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
            //var rectSize = 2 / (imageRenderer.scaleValue / scale);
            var rectSize = (3 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
            //context.fillRect(data.end.x, data.end.y, rectSize, rectSize);
            context.arc(data.end.x, data.end.y, rectSize, 0, 2 * Math.PI, false);
            if (data.start.handleActive)
                context.fillStyle = '#DAA520';
            else
                context.fillStyle = data.style.lineColor;
            context.fill();
            context.closePath();

            context.stroke();

            drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, true);
        }

        // for reporting
        if ((usRegionFound) && (imageCoordinate.measurementId != null)) {
            return {
                id: imageCoordinate.measurementId,
                value: resultText
            };
        }

        return null;
    }

    function drawTraceMeasurement(imageUid, context, data, presentation, imageRenderer, drawTraceEnd, averageX, averageY, isEditMode) {
        var imageCoordinate = data;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var scale = presentation.getZoom();
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
        var usRegionFound = false;

        // draw the line
        context.beginPath();
        if (isEditMode == undefined || isEditMode)
            context.fillStyle = '#DAA520';
        else
            context.fillStyle = data.style.lineColor;
        var rectSize = 2 / (imageRenderer.scaleValue / scale);
        //context.fillRect(data.end.x, data.end.y, rectSize, rectSize);
        context.arc(data.start.x, data.start.y, rectSize, 0, 2 * Math.PI, false);
        context.closePath();
        context.fill();
        context.beginPath();
        updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
        context.moveTo(data.start.x, data.start.y);
        context.lineTo(data.end.x, data.end.y);
        context.setLineDash([5 / scale, 10 / scale]);
        context.closePath();
        context.stroke();

        if (drawTraceEnd) {
            // Draw the text
            resultText = "" + (averageX) + " pix, " + (averageY) + " pix";
            drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false);

            // for reporting
            if ((usRegionFound) && (imageCoordinate.measurementId != null)) {
                return {
                    id: imageCoordinate.measurementId,
                    value: resultText
                };
            }
        }
        return null;
    }

    // Draw angle 
    function drawAngleMeasurement(imageUid, context, data, presentation, imageRenderer, isEditMode) {
        var imageCoordinate = data;

        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var scale = presentation.getZoom();

        // draw the line
        context.beginPath();
        updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
        var rectSize = 2 / (imageRenderer.scaleValue / scale);

        if (data.start.handleActive)
            context.fillStyle = '#DAA520';
        else
            context.fillStyle = data.style.lineColor;
        context.fill();
        context.moveTo(data.start.x, data.start.y);
        context.lineTo(data.end.x, data.end.y);
        context.setLineDash([]);
        context.closePath();
        context.stroke();
        if (isEditMode == undefined || isEditMode) {
            drawLineHandles(imageUid, context, data, presentation, imageRenderer);
        }
        return null;
    }

    /**
     * Calculates the angle (in degree) between two vectors pointing outward from one center
     *
     * @param p0 first point
     * @param p1 second point
     * @param c center point
     */
    function calculateAngle(p0, p1, c, style) {
        var p0c = Math.sqrt(Math.pow(c.x - p0.x, 2) + Math.pow(c.y - p0.y, 2)); // p0->c (b)   
        var p1c = Math.sqrt(Math.pow(c.x - p1.x, 2) + Math.pow(c.y - p1.y, 2)); // p1->c (a)
        var p0p1 = Math.sqrt(Math.pow(p1.x - p0.x, 2) + Math.pow(p1.y - p0.y, 2)); // p0->p1 (c)

        var angleRad = Math.acos((p1c * p1c + p0c * p0c - p0p1 * p0p1) / (2 * p1c * p0c));
        var resultDeg = (angleRad * 180) / Math.PI;
        return resultDeg.toFixed(parseInt(style.precision));
    }

    function drawMitralMeanGradientMeasurement(imageUid, context, data, presentation, imageRenderer, drawTraceEnd, gadiantValues, isEditMode) {
        var imageCoordinate = data;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
        data.textPosition = imageCoordinate.textPosition;
        var scale = presentation.getZoom();
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
        var usRegionFound = false;

        // draw the line
        context.beginPath();
        if (isEditMode == undefined || isEditMode)
            context.fillStyle = '#DAA520';
        else
            context.fillStyle = data.style.lineColor;
        var rectSize = 2 / (imageRenderer.scaleValue / scale);
        //context.fillRect(data.end.x, data.end.y, rectSize, rectSize);
        context.arc(data.start.x, data.start.y, rectSize, 0, 2 * Math.PI, false);
        context.closePath();
        context.fill();
        context.beginPath();
        updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
        context.moveTo(data.start.x, data.start.y);
        context.lineTo(data.end.x, data.end.y);
        context.setLineDash([5 / scale, 10 / scale]);
        context.closePath();
        context.stroke();

        if (drawTraceEnd) {
            // Draw the text
            if (gadiantValues.Unit == "pix") {
                resultText = "" + (gadiantValues.PixelX) + " pix, " + (gadiantValues.PixelY) + " pix";
            } else {
                resultText = "" + (gadiantValues.Value) + " " + gadiantValues.Unit;
            }

            drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, false);

            // for reporting
            if (imageCoordinate.measurementId != null) {
                return {
                    id: imageCoordinate.measurementId,
                    value: resultText
                };
            }
        }
        return null;
    }

    /**
     * Draw the free hand measurement
     */
    function drawFreeHandMeasurement(imageUid, context, data, presentation,
        imageRenderer, drawTraceEnd, isEditMode, measurements) {
        try {
            var imageCoordinate = data;
            data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
            var scale = presentation.getZoom();

            context.beginPath();
            if (isEditMode == undefined || isEditMode) {
                context.fillStyle = '#DAA520';
            } else {
                context.fillStyle = data.style.lineColor;
            }

            var rectSize = 2 / (imageRenderer.scaleValue / scale);
            context.arc(data.start.x, data.start.y, rectSize, 0, 2 * Math.PI, false);
            context.closePath();
            context.fill();

            // Draw line
            if (measurements != undefined) {
                if (measurements.length >= 2) {
                    context.beginPath();
                    context.setLineDash([]);
                    context.moveTo.apply(context, measurements[0]);

                    // Draw the line curve
                    var length = measurements.length;
                    for (var i = 0; 0 <= length ? i < length : i > length; 0 <= length ? i++ : i--) {
                        addCurveSegment(context, i, measurements);
                    }
                    var lineJoin = context.lineJoin;
                    var lineCap = context.lineCap;
                    updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
                    context.lineJoin = 'round';
                    context.lineCap = 'round';
                    context.stroke();
                    context.lineJoin = lineJoin;
                    context.lineCap = lineCap;
                }
            }
        } catch (e) {}
    }

    /**
     * Draw pen
     */
    function drawPenMeasurement(imageUid, context, data, presentation,
        imageRenderer, isEditMode) {
        try {
            var imageCoordinate = data;
            data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);
            var scale = presentation.getZoom();
            var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
            var usRegionFound = false;

            // draw the line
            context.beginPath();
            if (isEditMode == undefined || isEditMode)
                context.fillStyle = '#DAA520';
            else
                context.fillStyle = data.style.lineColor;
            var rectSize = 2 / (imageRenderer.scaleValue / scale);
            //context.fillRect(data.end.x, data.end.y, rectSize, rectSize);
            context.closePath();
            context.fill();
            context.beginPath();
            updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
            context.lineJoin = 'round';
            context.lineCap = 'round';
            context.moveTo(data.start.x, data.start.y);
            context.lineTo(data.end.x, data.end.y);
            context.setLineDash([]);
            context.closePath();
            context.stroke();
        } catch (e) {}
    }

    /**
     * Calculate the line distance
     * @param {Type} a - Specifies the point 1
     * @param {Type} b - Specifies the point 2
     */
    function distance(a, b) {
        return Math.sqrt(Math.pow(a[0] - b[0], 2) + Math.pow(a[1] - b[1], 2));
    }

    /**
     * Add the curve segment
     */
    function addCurveSegment(context, i, points) {
        try {
            var averageLineLength, du, end, pieceCount, pieceLength, s, start, t, u, _ref, _ref2, _ref3;
            s = Smooth(points, smoothConfig);
            averageLineLength = 1;
            pieceCount = 2;

            for (t = 0, _ref = 1 / pieceCount; t < 1; t += _ref) {
                _ref2 = [s(i + t), s(i + t + 1 / pieceCount)], start = _ref2[0], end = _ref2[1];
                pieceLength = distance(start, end);
                du = averageLineLength / pieceLength;
                for (u = 0, _ref3 = 1 / pieceCount; 0 <= _ref3 ? u < _ref3 : u > _ref3; u += du) {
                    context.lineTo.apply(context, s(i + t + u));
                }
            }

            context.lineTo.apply(context, s(i + 1));
        } catch (e) {}
    }

    function getAvgMitralMeanGradients(imageUid, measurements) {

        if (measurements == null || measurements.length == 0) {
            return null;
        }

        var isSameUnits = true;
        var isNanVal = false;

        var avgGradiants = {
            Value: 0,
            PixelX: 0,
            PixelY: 0,
            Unit: ""
        };
        for (var index = 0; index < measurements.length; index++) {
            var data = measurements[index];
            var gradientVal = getAvgMitralMeanGradient(imageUid, data);
            if (gradientVal.Unit != "pix") {
                gradientVal.PixelX = (data.start.x).toFixed(0);
                gradientVal.PixelY = (data.start.y).toFixed(0);
            } else {
                isSameUnits = false;
            }

            if (gradientVal.Value == "N/A") {
                isNanVal = true;
            }

            avgGradiants.PixelX = parseInt((avgGradiants.PixelX)) + parseInt((gradientVal.PixelX));
            avgGradiants.PixelY = parseInt((avgGradiants.PixelY)) + parseInt((gradientVal.PixelY));
            avgGradiants.Value = (isNanVal == false ? parseFloat((avgGradiants.Value).toFixed(2)) + parseFloat((gradientVal.Value)) : 0);
            avgGradiants.Unit = (isSameUnits == false ? "pix" : gradientVal.Unit);
        }

        avgGradiants.PixelX = (avgGradiants.PixelX / measurements.length).toFixed(0);
        avgGradiants.PixelY = (avgGradiants.PixelY / measurements.length).toFixed(0);
        avgGradiants.Value = (isNanVal == false ? (avgGradiants.Value / measurements.length).toFixed(2) : "N/A ");
        return avgGradiants;
    }

    function getAvgMitralMeanGradient(imageUid, data) {
        var imageCoordinate = data;
        var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);

        var resultText = {};
        if (dicomHeader.imageInfo.measurement != null) {
            if ((dicomHeader.imageInfo.measurement.usRegions != null) && (dicomHeader.imageInfo.measurement.usRegions.length > 0)) {
                var usRegionFound = false;
                var regionSpatialFormat = 0;
                var physicalUnitsXDirection = 0;
                var physicalUnitsYDirection = 0;
                var roiPosXValue = 0.0;
                var roiPosYValue = 0.0;
                var isReferencePixelX0Present = false;
                var isReferencePixelY0Present = false;

                for (var i = 0; i < dicomHeader.imageInfo.measurement.usRegions.length; i++) {
                    var usRegion = dicomHeader.imageInfo.measurement.usRegions[i];

                    if (((usRegion.regionSpatialFormat == 2) || (usRegion.regionSpatialFormat == 3)) &&
                        ((imageCoordinate.start.x <= usRegion.regionLocationMaxX1) && (imageCoordinate.start.x >= usRegion.regionLocationMinX0)) &&
                        ((imageCoordinate.start.y <= usRegion.regionLocationMaxY1) && (imageCoordinate.start.y >= usRegion.regionLocationMinY0))) {
                        usRegionFound = true;
                        regionSpatialFormat = usRegion.regionSpatialFormat;
                        physicalUnitsXDirection = usRegion.physicalUnitsXDirection;
                        physicalUnitsYDirection = usRegion.physicalUnitsYDirection;
                        isReferencePixelX0Present = usRegion.isReferencePixelX0Present;
                        isReferencePixelY0Present = usRegion.isReferencePixelY0Present;

                        if (isReferencePixelX0Present) {
                            roiPosXValue = (imageCoordinate.start.x - (usRegion.regionLocationMinX0 + usRegion.referencePixelX0) + usRegion.referencePixelPhysicalValueX) * usRegion.physicalDeltaX;
                        }

                        if (isReferencePixelY0Present) {

                            if (usRegion.regionSpatialFormat == 2)
                                // M-Mode
                                roiPosYValue = -((usRegion.regionLocationMinY0 + usRegion.referencePixelY0) - imageCoordinate.start.y + usRegion.referencePixelPhysicalValueY) * Math.abs(usRegion.physicalDeltaY);
                            else
                                // Spectral
                                roiPosYValue = ((usRegion.regionLocationMinY0 + usRegion.referencePixelY0) - imageCoordinate.start.y + usRegion.referencePixelPhysicalValueY) * Math.abs(usRegion.physicalDeltaY);
                        }

                        break;
                    }
                }

                if (usRegionFound) {

                    var unitsX;
                    var unitsY;
                    if ((physicalUnitsXDirection < 0) || (physicalUnitsXDirection > 12)) {
                        unitsX = "unknown";
                    } else if ((physicalUnitsYDirection < 0) || (physicalUnitsYDirection > 12)) {
                        unitsY = "unknown";
                    } else {
                        unitsX = physicalUnitsXYDirectionArray[physicalUnitsXDirection];
                        unitsY = physicalUnitsXYDirectionArray[physicalUnitsYDirection];
                    }

                    if ((!isReferencePixelX0Present) && (isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 5) // Y- Axis
                            return formatMitralGradientMeasurement(roiPosYValue, unitsY, imageCoordinate.measurementUnits);
                        else
                            return formatMitralGradientMeasurement(null, unitsX, imageCoordinate.measurementUnits);
                    } else if ((isReferencePixelX0Present) && (!isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 5) // Y- Axis
                            return formatMitralGradientMeasurement(null, unitsY, imageCoordinate.measurementUnits);
                        else
                            return formatMitralGradientMeasurement(roiPosXValue, unitsX, imageCoordinate.measurementUnits);
                    } else if ((!isReferencePixelX0Present) && (!isReferencePixelY0Present)) {
                        if (imageCoordinate.measurementType == 5) // Y- Axis
                            return formatMitralGradientMeasurement(null, unitsY, imageCoordinate.measurementUnits);
                        else
                            return formatMitralGradientMeasurement(null, unitsX, imageCoordinate.measurementUnits);
                    } else
                    if (imageCoordinate.measurementType == 5) // Y- Axis
                        return formatMitralGradientMeasurement(roiPosYValue, unitsY, imageCoordinate.measurementUnits);
                    else
                        return formatMitralGradientMeasurement(roiPosXValue, unitsX, imageCoordinate.measurementUnits);
                } else {}
            } else {}
        } else {}

        resultText.Value = 0;
        resultText.PixelX = (imageCoordinate.start.x).toFixed(0);
        resultText.PixelY = (imageCoordinate.start.y).toFixed(0);
        resultText.Unit = "pix";

        return resultText;
    }

    // Determine length(pixel) of point on line from midpoint based on image zoom percentage
    function getLenAsPerZoom(zoomVal) {
        // Check whether the typof of zoomval and convert back to float to avoid the viewer crash
        if (typeof zoomVal == "string") {
            zoomVal = parseFloat(zoomVal);
        }

        var zoomValue = zoomVal.toFixed(2);
        var length = 10;
        if (zoomValue >= "2.5") {
            length = 5;
        } else if (zoomValue < "2.5" && zoomValue >= "1.00") {
            length = 10;
        } else if (zoomValue < "1.00" && zoomValue >= "0.80") {
            length = 15;
        } else if (zoomValue < "0.80" && zoomValue >= "0.60") {
            length = 20;
        } else if (zoomValue < "0.60" && zoomValue >= "0.40") {
            length = 30;
        } else if (zoomValue < "0.40" && zoomValue >= "0.20") {
            length = 50;
        } else if (zoomValue < "0.20" && zoomValue >= "0.10") {
            length = 60;
        } else if (zoomValue < "0.10") {
            length = 80;
        }
        return length;
    }

    // Get point on angle tool lines to draw small point betweent them
    function getPointOnLine(x1, y1, x2, y2, zoomVal, arcRadius) {

        // Determine line lengths
        var xlen = x2 - x1;
        var ylen = y2 - y1;

        // Determine hypotenuse length 
        var hlen = Math.sqrt(Math.pow(xlen, 2) + Math.pow(ylen, 2));

        // The variable identifying the length of the `shortened` line.
        // In this case 10 units.
        var smallerLen = arcRadius;

        // Determine the ratio between they shortened value and the full hypotenuse.
        var ratio = smallerLen / hlen;

        var smallerXLen = xlen * ratio;
        var smallerYLen = ylen * ratio;

        var Point = {
            x: x1 + smallerXLen,
            y: y1 + smallerYLen
        };
        return Point;
    }

    // Draw Angle values, arc and angle unit
    function drawAngleValue(context, firstLine, secondLine, imageRenderer, presentation, resultText, angleUnit) {
        var firstLineData = dicomViewer.measurement.getCanvasDataForImageData(firstLine, imageRenderer);
        var PointToStart = getPointOnLine(firstLineData.end.x, firstLineData.end.y, firstLineData.start.x, firstLineData.start.y, presentation.zoom, firstLineData.style.arcRadius);

        var secondLineData = dicomViewer.measurement.getCanvasDataForImageData(secondLine, imageRenderer);
        secondLineData.textPosition = secondLine.textPosition;
        // firstLineData.end is always center point
        var secondPointX;
        var secondPointY;
        if (firstLineData.end.x == secondLineData.end.x) {
            secondPointX = secondLineData.start.x;
            secondPointY = secondLineData.start.y;
        } else {
            secondPointX = secondLineData.end.x;
            secondPointY = secondLineData.end.y;
        }
        var PointToEnd = getPointOnLine(firstLineData.end.x, firstLineData.end.y, secondPointX, secondPointY, presentation.zoom, firstLineData.style.arcRadius);

        context.save();
        // Draw the small line
        context.beginPath();
        updateContextStyle(context, firstLineData.style, false, imageRenderer.scaleValue);
        context.moveTo(PointToStart.x, PointToStart.y);
        context.lineTo(PointToEnd.x, PointToEnd.y);
        context.closePath();
        context.stroke();

        // Draw angle value  and unit
        var textX = firstLineData.end.x;
        var textY = firstLineData.end.y;
        var scale = presentation.getZoom();
        updateContextStyle(context, firstLineData.style, true, imageRenderer.scaleValue);
        updateTextBounds({
            x: textX,
            y: textY
        }, resultText + "°", context, firstLineData, imageRenderer);

        context.translate(textX, textY);
        context.rotate(-1 * (presentation.getRotation() * Math.PI / 180));
        if (imageRenderer.isPrint == true && presentation.isFlipHorizontalRequired) {
            if (presentation.rotation && (presentation.rotation !== 180 && presentation.orientation !== 6)) {
                context.scale(1, -1);
            } else {
                context.scale(-1, 1);
            }
        } else if (presentation.vFlip && presentation.hFlip) {
            context.scale(-1, -1);
        } else if (presentation.hFlip) {
            context.scale(-1, 1);
        } else if (presentation.vFlip) {
            context.scale(1, -1);
        } else {
            context.scale(1, 1);
        }

        if (!isNaN(resultText)) {
            var textWidth = context.measureText(resultText).width;

            //for text position right, default value
            var newTextX = 15 / imageRenderer.scaleValue;
            var delY = 15 / imageRenderer.scaleValue;

            //for text position left, shifting it to left
            if (secondLineData.textPosition == "left") {
                newTextX = -newTextX;
            }
            //for text position top, shifting it to top
            if (secondLineData.textPosition == "top") {
                delY = -delY;
            }
            if (secondLineData.textPosition == "top-left") {
                newTextX = -(3 / 2 * textWidth + (15 / imageRenderer.scaleValue));
            }

            context.textAlign = "start";
            context.fillText(angleUnit, newTextX, delY);
            context.textAlign = "end";
            context.textBaseline = "top";
            context.fillText(" " + resultText, newTextX, delY);
            var width = context.measureText(resultText).width;
            var fontSize = firstLineData.style.fontSize / imageRenderer.scaleValue;
            if (firstLineData.style.isStrikeout) {
                context.moveTo(newTextX, delY + (fontSize / 2));
                context.lineTo(newTextX - width, delY + (fontSize / 2));
                context.stroke();
            }
            if (firstLineData.style.isUnderlined) {
                context.moveTo(newTextX, delY + fontSize);
                context.lineTo(newTextX - width, delY + fontSize);
                context.stroke();
            }
        }
        context.restore();
    }

    // Draw Lines of angle measurement tool
    function drawMeasurementsLength(context, data, imageRenderer, presentation, resultText, isPoint, isEllipse, isText, isRect) {
        var textX;
        var textY;
        if (isText) {
            updateContextStyle(context, data.style, true, imageRenderer.scaleValue, true);
            var fontSize = data.style.fontSize / imageRenderer.scaleValue;
            var width = data.end.x - data.start.x;
            var height = data.end.y - data.start.y;
            if (data.end.x < data.start.x) {
                width = data.start.x - data.end.x;
            }
            if (data.end.y < data.start.y) {
                height = data.start.y - data.end.y;
            }
            //Text annotation rectangle coordinates
            x1 = Math.min(data.start.x, data.end.x);
            x2 = Math.max(data.start.x, data.end.x);
            y1 = Math.min(data.start.y, data.end.y);
            y2 = Math.max(data.start.y, data.end.y);

            if (presentation.rotation == 90 || presentation.rotation == 270) {
                //switching the width and height of the rectangle
                temp = width;
                width = height;
                height = temp;
            }
            //On the basis of orientation of the image, rendering the result text starting at the top-left corner of the rectangle
            switch (presentation.orientation) {
                case 0:
                    textX = x1; //0 degree
                    textY = y1 + fontSize;
                    break;
                case 1:
                    textX = x2 - fontSize; // 270 degree
                    textY = y1;
                    break;
                case 2:
                    textX = x2; // 180 degree
                    textY = y2 - fontSize;
                    break;
                case 3:
                    textX = x1 + fontSize; // 90 degree
                    textY = y2;
                    break;
                case 4:
                    textX = x2; //0 degree
                    textY = y1 + fontSize;
                    break;
                case 5:
                    textX = x1 + fontSize; // 270 degree
                    textY = y1;
                    break;
                case 6:
                    textX = x1; // 180 degree
                    textY = y2 - fontSize;
                    break;
                case 7:
                    textX = x2 - fontSize; // 270 degree
                    textY = y2;
            }

            context.save();
            context.translate(textX, textY);
            context.rotate(-1 * (presentation.getRotation() * Math.PI / 180));
            if (imageRenderer.isPrint == true && presentation.isFlipHorizontalRequired) {
                if (presentation.rotation && (presentation.rotation !== 180 && presentation.orientation !== 6)) {
                    context.scale(1, -1);
                } else {
                    context.scale(-1, 1);
                }
            } else if (presentation.vFlip && presentation.hFlip) {
                context.scale(-1, -1);
            } else if (presentation.hFlip) {
                context.scale(-1, 1);
            } else if (presentation.vFlip) {
                context.scale(1, -1);
            } else {
                context.scale(1, 1);
            }

            var words = data.measurementText.split("\n");
            var actualLineIndex = 0;
            for (var i = 0; i < words.length; i++) {
                var prependText = "";
                var appendText = "";
                var diffX = "";
                var isAppend = false;
                var lineHeight = actualLineIndex * fontSize;

                if (words[i] == "") {
                    continue;
                } else {
                    actualLineIndex++;
                }

                if (lineHeight > height - fontSize) {
                    break;
                }

                var textWidth = context.measureText(words[i]);
                var perTextWidth = textWidth.width / words[i].length;

                diffX = words.length ? parseInt(width) : 0;
                isAppend = false;

                if (diffX > parseInt(perTextWidth * 2)) {
                    var sliceIndex = parseInt(diffX / perTextWidth);

                    // get the slice index by word ends
                    var splitText = words[i].split(/\s+/);
                    var previousWordPos = 0;
                    for (var k = 0; k < splitText.length; k++) {
                        var currentLength = (splitText[k].length) + 1;
                        if (currentLength == sliceIndex || previousWordPos == sliceIndex) {
                            sliceIndex = currentLength;
                            break;
                        } else if ((previousWordPos + currentLength) >= sliceIndex) {
                            sliceIndex = previousWordPos == 0 ? sliceIndex : previousWordPos;
                            break;
                        }
                        previousWordPos += currentLength;
                    }

                    var trimmedText = words[i].slice(0, sliceIndex);
                    var trimmedTextWidth = context.measureText(trimmedText);
                    var perTextWidth = trimmedTextWidth.width / trimmedText.length;

                    if (trimmedTextWidth.width > parseInt(width)) {
                        diffX = trimmedTextWidth.width - parseInt(width);
                        var sliceIndex = parseInt(diffX / perTextWidth);
                        var slicedText = trimmedText.slice(sliceIndex, trimmedText.length);
                        words.splice(i + 1, 0, slicedText);
                        slicedText = words[i].slice(trimmedText.length, words[i].length);
                        words.splice(i + 2, 0, slicedText);
                        words[i] = trimmedText.slice(0, sliceIndex);
                        i--;
                        actualLineIndex--;
                        continue;
                    } else if (trimmedTextWidth.width < parseInt(textWidth.width / 4)) {
                        if (words[i + 1] !== undefined) {
                            words[i + 1] = words[i] + words[i + 1];
                            words.splice(i, 1);
                            i--;
                            actualLineIndex--;
                            continue;
                        }
                    }
                    prependText = words[i].slice(sliceIndex, words[i].length);
                    if (i == words.length - 1) {
                        words[i] = trimmedText;
                        words.push(prependText);
                    } else {
                        words[i] = trimmedText;
                        words.splice(i + 1, 0, prependText);
                    }
                }
                context.fillText(words[i], 0, lineHeight);
                if (data.style.isStrikeout) {
                    context.moveTo(0, lineHeight - 5);
                    context.lineTo(0 + trimmedTextWidth.width, lineHeight - 5);
                    context.stroke();
                }
                if (data.style.isUnderlined) {
                    context.moveTo(0, lineHeight + 5);
                    context.lineTo(0 + trimmedTextWidth.width, lineHeight + 5);
                    context.stroke();
                }
            }
            context.restore();
            return;
        } else if (isEllipse || isRect) {
            updateContextStyle(context, data.style, true, imageRenderer.scaleValue);
            var fontSize = data.style.fontSize / imageRenderer.scaleValue;
            var textX = (data.start.x + data.end.x) / 2;
            var textY = (data.start.y + data.end.y) / 2;
            var delY = 0;
            context.save();
            context.translate(textX, textY);
            context.rotate(-1 * (presentation.getRotation() * Math.PI / 180));
            if (imageRenderer.isPrint == true && presentation.isFlipHorizontalRequired) {
                if (presentation.rotation && (presentation.rotation !== 180 && presentation.orientation !== 6)) {
                    context.scale(1, -1);
                } else {
                    context.scale(-1, 1);
                }
            } else if (presentation.vFlip && presentation.hFlip) {
                context.scale(-1, -1);
            } else if (presentation.hFlip) {
                context.scale(-1, 1);
            } else if (presentation.vFlip) {
                context.scale(1, -1);
            } else {
                context.scale(1, 1);
            }

            //Whether it is ellipse or rectangle the start and end points will be this
            if (data.first != undefined && data.second != undefined &&
                data.third != undefined && data.fourth != undefined) {
                var rectangle = {
                    x1: Math.min(data.first.x, data.second.x, data.third.x, data.fourth.x),
                    x2: Math.max(data.first.x, data.second.x, data.third.x, data.fourth.x)
                };
            } else {
                var rectangle = {
                    x1: Math.min(data.start.x, data.end.x),
                    x2: Math.max(data.start.x, data.end.x)
                };
            }

            textX = (rectangle.x2 - rectangle.x1) / 2;
            var textWidth = context.measureText(text).width;

            updateTextBounds({
                x: textX,
                y: textY
            }, resultText, context, data, imageRenderer);

            //Switching the text at the left side if it is going outside the right-end of the viewport
            if (data.textPosition == "left") {
                newTextX = -(textX + 2 * textWidth + (30 / imageRenderer.scaleValue));
                lineX = -textX - (30 / imageRenderer.scaleValue);
            } else {
                newTextX = textX + (30 / imageRenderer.scaleValue);
                lineX = textX;
            }

            //Shifting the text more up if it is going outside the bottom of the viewport
            if (data.textPosition == "top") {
                delY = delY - (30 / imageRenderer.scaleValue);
            }

            if (data.textPosition == "top-left") {
                newTextX = -(textX + 2 * textWidth + (30 / imageRenderer.scaleValue));
                lineX = -textX - (30 / imageRenderer.scaleValue);
                delY = delY - (30 / imageRenderer.scaleValue);
            }

            for (var iIndex = 0; iIndex < resultText.length; iIndex++) {
                var text = resultText[iIndex];
                context.fillText(" " + text, newTextX, delY);
                var width = context.measureText(text).width;
                var fontSize = data.style.fontSize / imageRenderer.scaleValue;
                if (data.style.isStrikeout) {
                    context.moveTo(newTextX, delY - (fontSize / 2.5));
                    context.lineTo(newTextX + width, delY - (fontSize / 2.5));
                    context.stroke();
                }
                if (data.style.isUnderlined) {
                    context.moveTo(newTextX, delY + 5);
                    context.lineTo(newTextX + width, delY + 5);
                    context.stroke();
                }
                if (fontSize <= 15) {
                    delY += (15 / imageRenderer.scaleValue);
                } else {
                    delY += fontSize;
                }
            }
            if (resultText.length > 0) {
                updateContextStyle(context, data.style, false, imageRenderer.scaleValue);
                context.beginPath();
                context.moveTo(lineX, 0);
                context.lineTo(lineX + (30 / imageRenderer.scaleValue), 0);
                context.setLineDash([2, 2]);
                context.stroke();
            }
            context.restore();
            return;
        } else if (isPoint) {
            var scale = presentation.getZoom();
            updateContextStyle(context, data.style, true, imageRenderer.scaleValue);
            var textX = data.end.x;
            var textY = data.end.y;
            context.save();
            var txtDistance = 4 / (imageRenderer.scaleValue / scale);
            if (presentation.getOrientation() % 4 == 2 || presentation.getOrientation() % 4 == 1) txtDistance = -1 * txtDistance;
            context.translate(textX + txtDistance, textY - txtDistance);
            context.rotate(-1 * (presentation.getRotation() * Math.PI / 180));

            if (imageRenderer.isPrint == true && presentation.isFlipHorizontalRequired) {
                if (presentation.rotation && (presentation.rotation !== 180 && presentation.orientation !== 6)) {
                    context.scale(1, -1);
                } else {
                    context.scale(-1, 1);
                }
            } else if (presentation.vFlip && presentation.hFlip) {
                context.scale(-1, -1);
            } else if (presentation.hFlip) {
                context.scale(-1, 1);
            } else if (presentation.vFlip) {
                context.scale(1, -1);
            } else {
                context.scale(1, 1);
            }

            //for text position top as well as right, no need to shift
            var newTextX = 0;
            var delY = 0;
            var textWidth = context.measureText(text).width;

            //for text position left, shifting it to left
            if (data.textPosition == "left") {
                newTextX = -(3 / 2 * textWidth + (15 / imageRenderer.scaleValue));
            }
            //for text position top-left, shifting it to top-left
            if (data.textPosition == "top-left") {
                newTextX = -(3 / 2 * textWidth + (15 / imageRenderer.scaleValue));
                delY = -(15 / imageRenderer.scaleValue);
            }
            context.fillText(" " + resultText, newTextX, delY);
            var width = context.measureText(resultText).width;
            var fontSize = data.style.fontSize / imageRenderer.scaleValue;
            if (data.style.isStrikeout) {
                context.moveTo(newTextX, delY - (fontSize / 2.5));
                context.lineTo(newTextX + width, delY - (fontSize / 2.5));
                context.stroke();
            }
            if (data.style.isUnderlined) {
                context.moveTo(newTextX, delY + 5);
                context.lineTo(newTextX + width, delY + 5);
                context.stroke();
            }
            context.restore();
        } else {
            updateContextStyle(context, data.style, true, imageRenderer.scaleValue);
            var textX = (data.start.x + data.end.x) / 2;
            var atext = (data.start.x - data.end.x) / 2;
            var textY = (data.start.y + data.end.y) / 2;
            var textWidth = resultText.length;
            var delY = 0;
            newTextX = 0;
            updateTextBounds({
                x: textX,
                y: textY
            }, resultText, context, data, imageRenderer);
            context.save();
            context.translate(textX, textY);
            context.rotate(-1 * (presentation.getRotation() * Math.PI / 180));

            if (imageRenderer.isPrint == true && presentation.isFlipHorizontalRequired) {
                if (presentation.rotation && (presentation.rotation !== 180 && presentation.orientation !== 6)) {
                    context.scale(1, -1);
                } else {
                    context.scale(-1, 1);
                }
            } else if (presentation.vFlip && presentation.hFlip) {
                context.scale(-1, -1);
            } else if (presentation.hFlip) {
                context.scale(-1, 1);
            } else if (presentation.vFlip) {
                context.scale(1, -1);
            } else {
                context.scale(1, 1);
            }

            //for text position top as well as right, no need to shift
            newTextX = 0;
            delY = 0;

            //for text position left as well as top-left, shifting it to left side
            if (data.textPosition == "left" || data.textPosition == "top-left") {
                newTextX = -(7 * textWidth) / imageRenderer.scaleValue;
            }

            context.fillText(" " + resultText, newTextX, delY);
            var width = context.measureText(resultText).width;
            var fontSize = data.style.fontSize / imageRenderer.scaleValue;

            var lineDash = context.getLineDash();
            context.setLineDash([0]);

            if (data.style.isStrikeout) {
                context.beginPath();
                context.moveTo(newTextX, delY - (fontSize / 2.5));
                context.lineTo(newTextX + width, delY - (fontSize / 2.5));
                context.stroke();
            }
            if (data.style.isUnderlined) {
                context.beginPath();
                context.moveTo(newTextX, delY + 5);
                context.lineTo(newTextX + width, delY + 5);
                context.stroke();
            }
            context.setLineDash(lineDash);
            context.restore();
        }
    }

    function getIntersectionPoint(x1, y1, x2, y2, x3, y3, x4, y4) {
        var d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
        if (d == 0) return null;

        var xi = ((x3 - x4) * (x1 * y2 - y1 * x2) - (x1 - x2) * (x3 * y4 - y3 * x4)) / d;
        var yi = ((y3 - y4) * (x1 * y2 - y1 * x2) - (y1 - y2) * (x3 * y4 - y3 * x4)) / d;


        if (xi < Math.min(x1, x2) || xi > Math.max(x1, x2)) return null;
        if (xi < Math.min(x3, x4) || xi > Math.max(x3, x4)) return null;

        return {
            x: xi,
            y: yi
        };
    }

    function formatMeasurementResult(result, units, desiredUnits) {

        if ((desiredUnits != null) && (units == "cm/sec")) {

            if (result == null)
                return "N/A " + desiredUnits;

            if (desiredUnits == "m/s") {
                result /= 100.0;
                return "" + Math.abs(result.toFixed(2)) + " " + desiredUnits;
            } else if (desiredUnits == "mmHg") {
                result /= 100.0;
                result = (result * result) * 4.0;
                return "" + Math.abs(result.toFixed(2)) + " " + desiredUnits;
            }
        }

        if (result == null)
            return "N/A " + units;
        else
            return "" + Math.abs(result.toFixed(2)) + " " + units;
    }

    function formatMitralGradientMeasurement(result, units, desiredUnits) {

        var gradiantResult = {
            Value: "",
            Unit: ""
        }
        if ((desiredUnits != null) && (units == "cm/sec")) {

            if (result == null) {
                gradiantResult.Value = "N/A";
                gradiantResult.Unit = desiredUnits;
                return gradiantResult;
            }

            if (desiredUnits == "m/s") {
                result /= 100.0;
                gradiantResult.Value = result.toFixed(2);
                gradiantResult.Unit = desiredUnits;
                return gradiantResult;
            } else if (desiredUnits == "mmHg") {
                result /= 100.0;
                result = (result * result) * 4.0;
                gradiantResult.Value = result.toFixed(2);
                gradiantResult.Unit = desiredUnits;
                return gradiantResult;
            }
        }

        if (result == null) {
            gradiantResult.Value = "N/A";
            gradiantResult.Unit = units;
            return gradiantResult;
        } else {
            gradiantResult.Value = Math.abs(result.toFixed(2));
            gradiantResult.Unit = units;
            return gradiantResult;
        }
    }

    function getLengthText(data) {
        var dx = (data.start.x - data.end.x);
        var dy = (data.start.y - data.end.y);
        var lengthInPixels = Math.sqrt(dx * dx + dy * dy);

        return "" + lengthInPixels.toFixed(2) + " pix";
    }

    // not defined for empty array
    function findIndexOfGreatest(elements) {
        var max = elements[0];
        var maxIndex = 0;

        for (var i = 1; i < elements.length; i++) {
            if (elements[i] > max) {
                maxIndex = i;
                max = elements[i];
            }
        }
        return maxIndex;
    }

    function getLengthUsingPixelSpacing(data, pixelSpacing, bInCM) {

        var dx = Math.abs(data.start.x - data.end.x);
        var dy = Math.abs(data.start.y - data.end.y);

        dx *= pixelSpacing.column;
        dy *= pixelSpacing.row;

        var lengthInCM = undefined;
        if (dx == 0.0) lengthInCM = dy;
        else if (dy == 0.0) lengthInCM = dx;
        else lengthInCM = dy / (Math.sin(Math.atan(dy / dx)));

        if (bInCM)
            lengthInCM /= 10.0;

        return lengthInCM;
    }

    function getDisplayLengthText(value, isCalibrated, isMeasurementCompleted, theUnitType, isOwnerPixelSpacing, precision) {
        if (dicomViewer.tools.getFlagFor2dLengthCalibration() && !isMeasurementCompleted) {
            return "";
        }

        var unit = "cm";
        var resultValue = value;
        var unitType = "";

        if (theUnitType != undefined) {
            unitType = theUnitType;
        } else {
            unitType = dicomViewer.measurement.getDefaultLineMeasurementUnit();
        }

        if (unitType == "UNITS_MM" || unitType == "mm") {
            unit = "mm";
            resultValue = resultValue * 10.0;
        } else if (unitType == "UNITS_INCHES" || unitType == "in") {
            unit = "in";
            resultValue = resultValue / 2.54;
        }

        unit = " " + unit + (isCalibrated == true ? " (c*)" : (isOwnerPixelSpacing == false ? " (c)" : ""));
        var resultText = "" + resultValue.toFixed(precision) + unit;

        return resultText;
    }

    function drawLineHandles(imageUid, context, data, presentation, imageRenderer) {
        //console.log("Draw line handles");

        var scale = presentation.getZoom();
        if (data.end.handleActive || data.start.handleActive) {
            context.beginPath();
            context.strokeStyle = '#DAA520';
            var radius = (4 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
            context.lineWidth = radius;
            context.arc(data.end.x, data.end.y, radius, 0, 2 * Math.PI, false);
            context.closePath();
            context.stroke();
            context.beginPath();
            context.arc(data.start.x, data.start.y, radius, 0, 2 * Math.PI, false);
            context.closePath();
            context.stroke();
            if (data.measurementSubType != "Arrow") {
                return;
            }
        } else if (data.measureType == "angle" || data.measurementSubType == "2DLine") {
            return;
        }
        var lengthOfSlope = data.style.gaugeLength;
        var gaugeStyle = data.style.gaugeStyle;
        var slope = (data.start.y - data.end.y) / (data.start.x - data.end.x);
        var startHandle = getHandlePoint(data.start.x, data.start.y, lengthOfSlope, slope)
        var endHandle = getHandlePoint(data.end.x, data.end.y, lengthOfSlope, slope)

        var isFill = (data.style.isFill) ? true : false;
        updateContextStyle(context, data.style, !isFill, imageRenderer.scaleValue, undefined, isFill);
        if (data.measurementSubType == "Arrow") {
            drawArrow(context, data.end.x, data.end.y, data.start.x, data.start.y, imageRenderer.scaleValue, isFill);
        } else if (gaugeStyle == "Point") {
            drawPoint(context, imageRenderer, data);
        } else {
            drawLine(context, imageRenderer, startHandle, endHandle);
        }
    }

    /**
     * draw line measurement
     * @param context - specifies the 2d context
     * @param imageRenderer - specifies the image render
     * @param startHandle - specifies the start handle
     * @param endHandle - specifies the end handle
     */
    function drawLine(context, imageRenderer, startHandle, endHandle) {
        // draw the line
        context.beginPath();
        context.moveTo(startHandle[0].x, startHandle[0].y);
        context.lineTo(startHandle[1].x, startHandle[1].y);
        context.moveTo(endHandle[0].x, endHandle[0].y);
        context.lineTo(endHandle[1].x, endHandle[1].y);
        context.closePath();
        context.stroke();
    }

    /**
     * draw point measurement
     * @param context - specifies the 2d context
     * @param imageRenderer - specifies the image render
     */
    function drawPoint(context, imageRenderer, data) {
        context.beginPath();
        context.strokeStyle = data.style.lineColor;
        var gaugelength = data.style.gaugeLength ? parseInt(data.style.gaugeLength) : 3;
        var radius = (gaugelength * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
        context.lineWidth = radius;
        context.fillStyle = data.style.lineColor;
        context.arc(data.end.x, data.end.y, radius, 0, 2 * Math.PI, false);
        context.fill();
        context.closePath();
        context.stroke();
        context.beginPath();
        context.arc(data.start.x, data.start.y, radius, 0, 2 * Math.PI, false);
        context.fill();
        context.closePath();
        context.stroke();
    }

    /**
     * draw arrow
     * @param context - specifies the 2d context
     * @param x1 - specifies the first point
     * @param y1 - specifies the second point
     * @param x2 - specifies the third point 
     * @param y2 - specifies the fourth point
     * @param y2 -  specified the fill option for polygon
     */
    function drawArrow(context, x1, y1, x2, y2, scaleValue, isFill) {
        var ang = Math.atan2(y2 - y1, x2 - x1);
        if (ang != 0) {
            context.beginPath();
            context.moveTo(x1, y1);
            // default arrow array
            var arrow = [[2, 0], [-20, -8], [-20, 8]];
            for (pt in arrow) {
                // scaling the arrow dimensions with respect to the scale value
                arrow[pt][0] = arrow[pt][0] / scaleValue;
                arrow[pt][1] = arrow[pt][1] / scaleValue;
            }
            drawFilledPolygon(context, translateShape(rotateShape(arrow, ang), x2, y2), isFill);
        }
    }

    /**
     * fill arrow polygon
     * @param context - specifies the 2d context
     * @param shape - specifies the shape whether angle or polygon like that.
     * @param isFill - specified the fill option for polygon
     */
    function drawFilledPolygon(context, shape, isFill) {
        context.beginPath();
        context.moveTo(shape[0][0], shape[0][1]);

        for (p in shape) {
            if (p == 1) {
                context.lineTo(shape[p][0], shape[p][1]);
            } else if (p == 2) {
                if (isFill) {
                    context.lineTo(shape[p][0], shape[p][1]);
                } else {
                    context.moveTo(shape[p][0], shape[p][1]);
                }
            }
        }

        context.lineTo(shape[0][0], shape[0][1]);
        if (isFill) {
            context.fill();
        } else {
            context.stroke();
        }
    }

    /**
     * draw arrow like shape
     * @param shape - specifies the shape whether angle or polygon like that.
     * @param ang - specifies the angle
     */
    function rotateShape(shape, ang) {
        var rv = [];
        for (p in shape)
            rv.push(rotatePoint(ang, shape[p][0], shape[p][1]));
        return rv;
    }

    /**
     * translate the shape
     * @param shape - specifies the shape whether angle or polygon like that.
     * @param x - specifies the first point
     * @param y - specifies the second point
     */
    function translateShape(shape, x, y) {
        var rv = [];
        for (p in shape)
            rv.push([shape[p][0] + x, shape[p][1] + y]);
        return rv;
    }

    /**
     * rotate the point
     * @param ang - specifies the angle
     * @param x - specifies the first point
     * @param y - specifies the second point.
     */
    function rotatePoint(ang, x, y) {
        return [
            (x * Math.cos(ang)) - (y * Math.sin(ang)),
            (x * Math.sin(ang)) + (y * Math.cos(ang))
        ];
    }

    function getHandlePoint(px, py, length, slope) {
        // if slope is 0 or undefined, we can't use our regular formula
        if (slope === 0) {
            return [{
                x: px,
                y: py + length
            }, {
                x: px,
                y: py - length
            }];
        } else if (slope === undefined) {
            return [{
                x: px + length,
                y: py
            }, {
                x: px - length,
                y: py
            }];
        } else {
            var m = -1 / slope;
            var x1 = (Math.pow(m, 2) * px + length * Math.sqrt(Math.pow(m, 2) + 1) + px) / (Math.pow(m, 2) + 1);
            var x2 = (Math.pow(m, 2) * px - length * Math.sqrt(Math.pow(m, 2) + 1) + px) / (Math.pow(m, 2) + 1);
            var y1 = m * (x1 - px) + py;
            var y2 = m * (x2 - px) + py;
            return [{
                x: parseFloat(x1.toFixed(1)),
                y: parseFloat(y1.toFixed(1))
            }, {
                x: parseFloat(x2.toFixed(1)),
                y: parseFloat(y2.toFixed(1))
            }];
        }
    }

    function setMeasurementType(type, id, units) {
        measurementType = type;
        measurementId = id;
        measurementUnits = units;
    }

    function getMeasurementType() {
        return {
            measurementType: measurementType,
            measurementId: measurementId,
            measurementUnits: measurementUnits
        };
    }

    //Return true when the cine is playing on the selected viewport
    function isMeasuremntDisabled() {
        var imageElement = document.getElementById("playButton_wrapper").getElementsByTagName('img')[0];
        var playerButtomImage = imageElement.src;
        if (playerButtomImage.indexOf("stop.png") > -1) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 
     * @param {Type} value 
     */
    function sign(value) {
        return (value >= 0) ? 1 : -1;
    }

    /**
     * Calculate the mean value of the region
     * @param {Type}  
     */
    function calculateStandardDeviation(imageUid, context, data, presentation, imageRenderer, editValue) {
        var imageCanvas;
        imageRenderer.imagePromise.then(function (image) {
            imageCanvas = image;
        });

        if (!imageCanvas && data.measurementResult) {
            return data.measurementResult;
        }

        var precision = parseInt(data.style.precision);
        var displayString = [];
        var startX = Math.min(Math.round(data.start.x), Math.round(data.end.x));
        var startY = Math.min(Math.round(data.start.y), Math.round(data.end.y));

        var endX = Math.max(Math.round(data.start.x), Math.round(data.end.x));
        var endY = Math.max(Math.round(data.start.y), Math.round(data.end.y));

        var ptStart = {
            x: startX,
            y: startY
        };
        var ptEnd = {
            x: endX,
            y: endY
        };

        var nSgnX = sign(ptEnd.x - ptStart.x);
        var nSgnY = sign(ptEnd.y - ptStart.y);
        var numberOfPixels = 0;

        var nAggregate = 0;
        var ptDifferenceX = Math.abs(ptEnd.x - ptStart.x) / 2;
        var ptDifferenceY = Math.abs(ptEnd.y - ptStart.y) / 2;
        var dXOverA = 0;
        var dYOverB = 0;
        var mean = 0;
        var pixelList = [];
        var ptOrigin = {
            x: (ptStart.x + ptEnd.x) / 2,
            y: (ptStart.y + ptEnd.y) / 2
        }

        // Calculate the mean value
        var isValidRegion = (ptDifferenceX > 1 ? true : (ptDifferenceY > 1 ? true : false));
        var imageData = dicomViewer.imageCache.getImageData(imageCanvas, imageRenderer.imageCanvas.canvasId);
        if (imageCanvas !== undefined && imageData !== undefined && isValidRegion) {
            var nPixelValue;
            for (var j = ptStart.y; j <= ptEnd.y; j += 1 * nSgnY) {
                for (var i = ptStart.x; i <= ptEnd.x; i += 1 * nSgnX) {
                    dXOverA = ((i - ptOrigin.x) / ptDifferenceX);
                    dYOverB = ((j - ptOrigin.y) / ptDifferenceY);

                    nPixelValue = imageData[(imageCanvas.columns * j) + i];
                    if (nPixelValue === undefined) {
                        nPixelValue = imageCanvas.minPixel;
                    }

                    pixelList.push(nPixelValue);
                    nAggregate += nPixelValue;
                    numberOfPixels++;
                }
            }

            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            var measurementUnit = null;
            var pixelSpacing = (measurementUnit = getUnitMeasurementMap(seriesLayout.studyUid + "|" + imageRenderer.seriesIndex + "|" + imageRenderer.imageIndex + "|" + imageRenderer.anUIDs.split("*")[1])) ? measurementUnit.pixelSpacing : undefined;

            // Check for pixel spacing
            if (pixelSpacing === undefined) {
                var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
                pixelSpacing = dicomHeader.imageInfo.measurement.pixelSpacing
            }

            var unitType = measurementUnit ? measurementUnit.unitType : undefined;
            mean = (nAggregate / numberOfPixels).toFixed(2);
            var stdDevMean = mean;
            if (presentation !== undefined && presentation !== null) {
                var slope = presentation.lookupObj.rescaleSlope;
                var intercept = presentation.lookupObj.rescaleIntercept;
                mean = parseFloat(mean) * slope + intercept;
            }

            displayString.push("Area: " + getEllipseArea(numberOfPixels, pixelSpacing, unitType, data.style.measurementUnits, precision));
            displayString.push("Avg: " + parseFloat(mean).toFixed(precision));
            displayString.push("StdDev: " + getEllipseStdDev(pixelList, stdDevMean, numberOfPixels, precision));
        }
        return displayString;
    }

    /**
     * To get the area string
     * @param {Type} numberOfPixels - No of pixels in the selected region
     */
    function getEllipseArea(numberOfPixels, pixelSpacing, unitType, measurementUnits, precision) {
        var pixelSpacingX = 1.0;
        var pixelSpacingY = 1.0;

        if (pixelSpacing.column !== undefined) {
            pixelSpacingX = pixelSpacing.column;
        }
        if (pixelSpacing.row !== undefined) {
            pixelSpacingX = pixelSpacing.row;
        }

        // Calculate the area
        var area = numberOfPixels * pixelSpacingX * pixelSpacingY;
        if (unitType === undefined || unitType === null) {
            measurementUnits = (measurementUnits == 'in') ? 'inches' : measurementUnits;
            unitType = 'UNITS_' + measurementUnits.toUpperCase(); //dicomViewer.measurement.getDefaultLineMeasurementUnit();
            area /= 10;
        }

        // Convert to other units if needed
        var areaString = "";
        switch (unitType) {
            case "UNITS_MM":
                area = area * 10.0;
                suffix = "sqmm";
                break;
            case "UNITS_CM":
                area /= 10;
                suffix = "sqcm";
                break;

            case "UNITS_INCHES":
                area = (area / (25.4 * 25.4)) * 10;
                suffix = "sqin";
                break;
        }

        areaString = area.toFixed(precision) + " " + suffix;
        return areaString;
    }

    /**
     * Get the standard deviation
     * @param {Type} pixelList - Pixels with in the region
     * @param {Type} average - Mean value
     * @param {Type} numberOfPixels - No Of pixels
     */
    function getEllipseStdDev(pixelList, average, numberOfPixels, precision) {
        if (pixelList.length > 1) {
            var nAggregateSE = 0;
            pixelList.forEach(function (pixelValue) {
                nAggregateSE += ((pixelValue - average) * (pixelValue - average));
            });

            return Math.sqrt(nAggregateSE / (numberOfPixels - 1)).toFixed(precision);
        }
        return 0;
    }

    /**
     * To draw WindowLevelROI measurement
     * @param {Type} imageUid 
     * @param {Type} context 
     * @param {Type} data 
     * @param {Type} presentation 
     * @param {Type} imageRenderer 
     */
    function drawWindowLevelROIMeasurement(imageUid, context, data, presentation, imageRenderer, isRectangleEnd, isEnd) {
        var imageCoordinate = data;
        data = dicomViewer.measurement.getCanvasDataForImageData(data, imageRenderer);

        var deltaY = (data.end.y - data.start.y);
        var deltaX = (data.end.x - data.start.x);
        var result = 0;
        if (data.start.y < data.end.y)
            result = Math.abs(Math.atan2(deltaY, deltaX));
        else
            result = Math.abs(Math.atan2(deltaY, deltaX)) * -1;

        if (data !== undefined) {
            context.save();
            context.beginPath();
            //Restore and draw
            context.restore();
            context.strokeStyle = '#CCCC66';
            var radius = (3 * imageRenderer.viewportHeight) / (1000 * imageRenderer.scaleValue);
            context.lineWidth = radius;
            //Create rectangle
            context.moveTo(data.start.x, data.start.y);
            context.lineTo(data.start.x, data.end.y);
            context.lineTo(data.end.x, data.end.y);
            context.lineTo(data.end.x, data.start.y);

            context.closePath();
            context.stroke();
        }

        return null;
    }

    /**
     * To get the ROI WindowLevel values
     * @param {Type} imageUid 
     * @param {Type} context 
     * @param {Type} data 
     * @param {Type} presentation 
     * @param {Type} imageRenderer 
     */
    function GetROIWindowLevelValues(imageUid, context, data, presentation, imageRenderer) {
        var imageCanvas;
        imageRenderer.imagePromise.then(function (image) {
            imageCanvas = image;
        });

        var precision = parseInt(data.style.precision);
        var displayString = [];
        var startX = Math.min(Math.round(data.start.x), Math.round(data.end.x));
        var startY = Math.min(Math.round(data.start.y), Math.round(data.end.y));

        var endX = Math.max(Math.round(data.start.x), Math.round(data.end.x));
        var endY = Math.max(Math.round(data.start.y), Math.round(data.end.y));

        var ptStart = {
            x: startX,
            y: startY
        };
        var ptEnd = {
            x: endX,
            y: endY
        };

        var nSgnX = sign(ptEnd.x - ptStart.x);
        var nSgnY = sign(ptEnd.y - ptStart.y);
        var numberOfPixels = 0;

        var nAggregate = 0;
        var ptDifferenceX = Math.abs(ptEnd.x - ptStart.x) / 2;
        var ptDifferenceY = Math.abs(ptEnd.y - ptStart.y) / 2;
        var dXOverA = 0;
        var dYOverB = 0;
        var mean = 0;
        var pixelList = [];
        var ptOrigin = {
            x: (ptStart.x + ptEnd.x) / 2,
            y: (ptStart.y + ptEnd.y) / 2
        }

        // Calculate the mean value
        var imageData = dicomViewer.imageCache.getImageData(imageCanvas, imageRenderer.imageCanvas.canvasId);
        if (imageCanvas !== undefined && imageData !== undefined && ptDifferenceX > 1 && ptDifferenceY > 1) {
            var nPixelValue;
            for (var j = ptStart.y; j <= ptEnd.y; j += 1 * nSgnY) {
                for (var i = ptStart.x; i <= ptEnd.x; i += 1 * nSgnX) {
                    dXOverA = ((i - ptOrigin.x) / ptDifferenceX);
                    dYOverB = ((j - ptOrigin.y) / ptDifferenceY);

                    // Check whether the pixel is inside the selected region
                    //if (dXOverA * Math.abs(dXOverA) + dYOverB * Math.abs(dYOverB) <= 1)
                    {
                        //nPixelValue = context.getImageData(i, j, 1, 1).data[0];                       
                        nPixelValue = imageData[(imageCanvas.columns * j) + i];
                        if (nPixelValue === undefined) {
                            nPixelValue = imageCanvas.minPixel;
                        }
                        pixelList.push(nPixelValue);
                        nAggregate += nPixelValue;
                        numberOfPixels++;
                    }
                }
            }

            mean = (nAggregate / numberOfPixels).toFixed(2);
            return {
                level: parseInt(mean),
                window: parseInt(getEllipseStdDev(pixelList, mean, numberOfPixels, precision))
            };
        }
    }

    /**
     * get and update the text bounds
     * @param {Type} context - Specifies the context
     * @param {Type} data - Specifies the data
     * @param {Type} imageRenderer - Specifies the image renderer
     */
    function getAndUpdateTextBounds(context, data, imageRenderer) {
        try {
            if (data.measurementSubType !== "text") {
                return data;
            }

            var height = data.end.y - data.start.y;
            if (data.end.y < data.start.y) {
                height = data.start.y - data.end.y;
            }

            // To avoid the external presentation text rendering
            if (height == 0) {
                var fontSize = 15 / imageRenderer.scaleValue;
                var lineWidth = data.style.lineWidth / imageRenderer.scaleValue;
                data.end.x = data.start.x + context.measureText(data.measurementText).width + (lineWidth * 2);
                data.end.y = data.start.y + fontSize + (lineWidth * 2);
            }

            return data;
        } catch (e) {}

        return data;
    }

    /**
     * Get the user measurement key/value pair
     */
    function getUserMeasurementCol() {
        return userMeasurementStyleCol;
    }

    /**
     * Get the user measurement style by type
     */
    function getUserMeasurementStyleByType(type, defaultType) {
        if (jQuery.isEmptyObject(userMeasurementStyleCol) || type == undefined) {
            return userStyle;
        }

        if (defaultType !== undefined) {
            type = (getUseDefaultValue(defaultType)) ? ("sys" + type) : type;
        } else {
            type = (userMeasurementStyleCol[type].useDefault) ? ("sys" + type) : type;
        }

        return userMeasurementStyleCol[type].styleCol;
    }

    /**
     * Get useDefault value for given type
     * @param {Type}  
     */
    function getUseDefaultValue(type) {
        if (jQuery.isEmptyObject(userMeasurementStyleCol) || type == undefined) {
            return true;
        }

        return userMeasurementStyleCol[type].useDefault;
    }

    /**
     * Get the scoutline style
     */
    function getScoutLineStyle() {
        return getUserMeasurementStyleByType("LBLSCOUT");
    }

    /**
     * Get the ruler style
     */
    function getRulerStyle() {
        return getUserMeasurementStyleByType("LBLRULER");
    }

    /**
     *Get the overlay style
     */
    function getOverlayStyle() {
        return getUserMeasurementStyleByType("LBLOVERLAY");
    }

    /**
     *Get the orientation style
     */
    function getOrientationStyle() {
        return getUserMeasurementStyleByType("LBLORIENTATION");
    }

    function updateContextStyle(context, measurementStyle, isFont, scaleValue, isText, isFill) {
        if (isText || isFont) {
            context.fillStyle = measurementStyle.textColor;
        } else if (isFill) {
            context.fillStyle = measurementStyle.fillColor;
        } else {
            context.strokeStyle = measurementStyle.lineColor;
        }

        var fontStyle = "normal";
        if (measurementStyle.isItalic && measurementStyle.isBold) {
            fontStyle = "italic bold";
        } else if (measurementStyle.isItalic) {
            fontStyle = "italic";
        } else if (measurementStyle.isBold) {
            fontStyle = "bold";
        }
        context.lineWidth = measurementStyle.lineWidth / scaleValue;
        context.font = fontStyle + " " + (measurementStyle.fontSize / scaleValue) + "px" + " " + measurementStyle.fontName;
    }

    function updateTextBounds(textPt, text, context, data, imageRenderer) {
        if (data.imageData) {
            data.imageData.textBounds = [];
            data.imageData.measurementText = undefined;
            var presentation = imageRenderer.presentationState;
            if (presentation) {
                var pan = presentation.getPan();
                var topLeftPt = {};
                var bottomRightPt = {};
                var displayText = "";
                var lineLength = 1;
                var textWidth = 0;

                if (Object.prototype.toString.call(text) === '[object Array]') {
                    lineLength = text.length;
                    text.forEach(function (val) {
                        displayText += val;
                        displayText += "\r\n";

                        var lineTextWidth = context.measureText(val).width;
                        if (lineTextWidth > textWidth) {
                            textWidth = lineTextWidth;
                        }
                    });
                    displayText = displayText.trim();
                } else {
                    displayText = text;
                    textWidth = context.measureText(displayText).width;
                }

                topLeftPt.x = parseFloat(textPt.x) - pan.x;
                topLeftPt.y = parseFloat(textPt.y) - pan.y;
                bottomRightPt.x = topLeftPt.x + textWidth;
                bottomRightPt.y = topLeftPt.y + (data.style.fontSize * lineLength);

                data.imageData.textBounds.push(topLeftPt);
                data.imageData.textBounds.push(bottomRightPt);
                data.imageData.measurementText = displayText;
            }
        }
    }

    function getMeasurementStyle(type) {
        try {
            var style = undefined;
            if (!type) {
                style = dicomViewer.measurement.draw.getUserMeasurementStyleByType();
                return style;
            }

            if (type == "LINE" || type == "ARROW") {
                var lineStyle = getUserMeasurementStyleByType("LINE");
                var arrowStyle = getUserMeasurementStyleByType("ARROW");
                style = getUserMeasurementStyleByType("PEN");

                if (lineStyle) {
                    style.gaugeLength = lineStyle.gaugeLength;
                    style.gaugeStyle = lineStyle.gaugeStyle;
                }
                if (arrowStyle) {
                    style.fillColor = arrowStyle.fillColor;
                    style.isFill = arrowStyle.isFill;
                }
            } else if (type == "PEN" || type == "FREEHAND") {
                style = getUserMeasurementStyleByType(type);
            } else if (type == "LENGTH" || type == "ANGLE" || type == "TRACE" ||
                type == "MRL" || type == "MVALT" || type == "ARL") {

                var textStyle = getUserMeasurementStyleByType("LBLANNOTATION");
                if (type == "MRL" || type == "MVALT" || type == "ARL") {
                    style = getUserMeasurementStyleByType(type);
                    var usStyle = getUserMeasurementStyleByType("MG");
                    if (usStyle) {
                        style.precision = usStyle.precision;
                        style.measurementUnits = usStyle.measurementUnits;
                        style.gaugeLength = usStyle.gaugeLength;
                        style.gaugeStyle = usStyle.gaugeStyle;
                    }
                } else {
                    var lengthStyle = getUserMeasurementStyleByType("LENGTH");
                    var angleStyle = getUserMeasurementStyleByType("ANGLE");

                    style = getUserMeasurementStyleByType("POINT");

                    if (lengthStyle) {
                        style.gaugeLength = lengthStyle.gaugeLength;
                        style.gaugeStyle = lengthStyle.gaugeStyle;
                    }

                    if (angleStyle) {
                        style.arcRadius = angleStyle.arcRadius;
                    }
                }

                if (textStyle) {
                    style.textColor = textStyle.textColor;
                    style.fontName = textStyle.fontName;
                    style.fontSize = textStyle.fontSize;
                    style.isBold = textStyle.isBold;
                    style.isItalic = textStyle.isItalic;
                    style.isStrikeout = textStyle.isStrikeout;
                    style.isUnderlined = textStyle.isUnderlined;
                }
            } else if (type == "POINT" || type == "MRPV" || type == "ARPV" || type == "ASPV") {
                var textStyle = getUserMeasurementStyleByType("LBLANNOTATION");
                style = getUserMeasurementStyleByType(type);

                if (textStyle) {
                    style.textColor = textStyle.textColor;
                    style.fontName = textStyle.fontName;
                    style.fontSize = textStyle.fontSize;
                    style.isBold = textStyle.isBold;
                    style.isItalic = textStyle.isItalic;
                    style.isStrikeout = textStyle.isStrikeout;
                    style.isUnderlined = textStyle.isUnderlined;
                }
            } else if (type == "ELLIPSE" || type == "RECT") {
                style = getUserMeasurementStyleByType("RECT");
                var rectStyle = getUserMeasurementStyleByType("HOUNSFIELDRECT");

                if (rectStyle) {
                    style.precision = rectStyle.precision;
                    style.measurementUnits = rectStyle.measurementUnits;
                }
            } else {
                style = getUserMeasurementStyleByType(type);
            }
            return style;
        } catch (e) {}
    }

    dicomViewer.measurement.draw = {
        drawMeasurements: drawMeasurements,
        setMeasurementType: setMeasurementType,
        getMeasurementType: getMeasurementType,
        getHandlePoint: getHandlePoint,
        getMousePointForImageCoordinates: getMousePointForImageCoordinates,
        getImageCoordinatesForMousePoint: getImageCoordinatesForMousePoint,
        getCanvasCoordinatesForImageCoordinates: getCanvasCoordinatesForImageCoordinates,
        drawLineMeasurement: drawLineMeasurement,
        drawPointMeasurement: drawPointMeasurement,
        setUserMeasurementCol: setUserMeasurementCol,
        setUserMeasurementStyleByType: setUserMeasurementStyleByType,
        getUserMeasurementCol: getUserMeasurementCol,
        getUserMeasurementStyleByType: getUserMeasurementStyleByType,
        getScoutLineStyle: getScoutLineStyle,
        getRulerStyle: getRulerStyle,
        getOverlayStyle: getOverlayStyle,
        getOrientationStyle: getOrientationStyle,
        isMeasuremntDisabled: isMeasuremntDisabled,
        drawWindowLevelROIMeasurement: drawWindowLevelROIMeasurement,
        GetROIWindowLevelValues: GetROIWindowLevelValues,
        getMeasurementStyle: getMeasurementStyle
    };

    return dicomViewer;
}(dicomViewer));
