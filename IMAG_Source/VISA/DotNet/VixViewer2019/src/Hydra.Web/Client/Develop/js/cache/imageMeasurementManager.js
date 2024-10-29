/**
 * New node file
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var isMeasurementEdit;
    var dicomImageMeasurements = {};

    var dicomImageAngleMeasurements = {};

    var dicomImageEllipseMeasurements = {};

    var dicomImageRectangleMeasurements = {};

    var dicomImageTraceMeasurements = {};

    var dicomImageVolumeMeasurements = {};

    var dicomImageMitralGradientMeasurements = {};

    var dicomImagePenMeasurements = {};

    var mousePressedCounter = 0;

    var tempdata = undefined; // On going data

    var lineMeasurementUnit = "UNITS_CM"; // centimeters as default

    var dataToDelete = {
        measurmentType: "",
        keyId: "",
        arryIndex: "",
        isEditable: "",
        sessionType: 0
    };

    var dataToEdit = undefined;

    var activeImageRenderer = undefined;

    var isLineDeleteCheck = false;
    var isPointDeleteCheck = false;
    var isAngleDeleteCheck = false;
    var isEllipseDeleteCheck = false;
    var isRectangleDeleteCheck = false;
    var isTraceDeleteCheck = false;
    var isVolumeDeleteCheck = false;
    var isMitralGradineDelete = false;
    var isPenDelete = false;

    var MT_GLOBAL = "GLOBAL";
    var MT_LENGTH = "LENGTH";
    var MT_LINE = "LINE";
    var MT_ARROW = "ARROW";
    var MT_POINT = "POINT";
    var MT_ANGLE = "ANGLE";
    var MT_ELLIPSE = "ELLIPSE";
    var MT_HOUNSFIELDELLIPSE = "HOUNSFIELDELLIPSE";
    var MT_RECT = "RECT";
    var MT_HOUNSFIELDRECT = "HOUNSFIELDRECT";
    var MT_TEXT = "TEXT";
    var MT_TRACE = "TRACE";
    var MT_MG = "MG";
    var MT_ASPV = "ASPV";
    var MT_ARPV = "ARPV";
    var MT_MRPV = "MRPV";
    var MT_ARL = "ARL";
    var MT_MRL = "MRL";
    var MT_MVALT = "MVALT";
    var MT_FREEHAND = "FREEHAND";
    var MT_PEN = "PEN";
    var MT_LABEL = "LABEL";

    var selectedSessionType = 2;

    function setTempData(mouseData) {
        tempdata = mouseData;
    }

    function getTempData() {
        return tempdata;
    }

    function removeTempdata() {
        tempdata = undefined;
    }

    function getDefaultLineMeasurement() {
        return {
            start: {
                x: undefind,
                y: undefined
            },
            end: {
                x: undefined,
                y: undefined
            },
            measurementType: "line"
        };
    }

    function getImageDataForMouseData(mouseData, imageRenderer, context) {
        var start, end = null;
        var first, second, third, fourth, center = null;
        start = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.start, imageRenderer, context);
        end = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.end, imageRenderer, context);
        if (mouseData.measureType == "ellipse") {
            first = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.first, imageRenderer, context);
            second = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.second, imageRenderer, context);
            third = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.third, imageRenderer, context);
            fourth = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.fourth, imageRenderer, context);
            center = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData.center, imageRenderer, context);
        }

        var imageData = {};
        imageData.start = start;
        imageData.end = end;
        imageData.first = first;
        imageData.second = second;
        imageData.third = third;
        imageData.fourth = fourth;
        imageData.center = center;
        imageData.isCustomEllipse = mouseData.isCustomEllipse;
        imageData.measureType = mouseData.measureType;
        imageData.measurementId = mouseData.measurementId;
        imageData.measurementType = mouseData.measurementType;
        imageData.measurementUnits = mouseData.measurementUnits;
        imageData.measurementComplete = mouseData.measurementComplete;
        imageData.measurementSubType = mouseData.measurementSubType;
        imageData.measurementText = mouseData.measurementText;
        imageData.studyUid = mouseData.studyUid;
        imageData.isEditable = mouseData.isEditable;
        imageData.sessionType = mouseData.sessionType;
        imageData.style = mouseData.style;
        imageData.calibrationData = mouseData.calibrationData;
        return imageData;
    }


    function getCanvasDataForImageData(imageData, imageRenderer) {
        var start, end = null;
        var first, second, third, fourth, center = null;
        start = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.start, imageRenderer);
        end = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.end, imageRenderer);

        if (imageData.measureType == "ellipse") {
            first = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.first, imageRenderer);
            second = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.second, imageRenderer);
            third = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.third, imageRenderer);
            fourth = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.fourth, imageRenderer);
            center = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates(imageData.center, imageRenderer);
        }

        var canvasData = {};
        canvasData.start = start;
        canvasData.end = end;
        canvasData.first = first;
        canvasData.second = second;
        canvasData.third = third;
        canvasData.fourth = fourth;
        canvasData.center = center;
        canvasData.isCustomEllipse = imageData.isCustomEllipse;
        canvasData.measureType = imageData.measureType;
        canvasData.measurementId = imageData.measurementId;
        canvasData.measurementType = imageData.measurementType;
        canvasData.measurementUnits = imageData.measurementUnits;
        canvasData.measurementComplete = imageData.measurementComplete;
        canvasData.measurementSubType = imageData.measurementSubType;
        canvasData.measurementText = imageData.measurementText;
        canvasData.studyUid = imageData.studyUid;
        canvasData.isEditable = imageData.isEditable;
        canvasData.sessionType = imageData.sessionType;
        canvasData.style = imageData.style;
        canvasData.calibrationData = imageData.calibrationData;
        canvasData.imageData = imageData;

        return canvasData;
    }

    var lineMeasurementEnd = false;

    function setLineMeasurementEnd(flag) {
        lineMeasurementEnd = flag;
    }

    function isLineMeasurementEnd() {
        return lineMeasurementEnd;
    }

    var measurementBroken = false;

    function setMeasurementBroken(flag) {
        measurementBroken = flag;
    }

    function isMeasurementBroken() {
        return measurementBroken;
    }

    var traceMeasurementEnd = false;

    function setTraceMeasurementEnd(flag) {
        traceMeasurementEnd = flag;
    }

    function isTraceMeasurementEnd() {
        return traceMeasurementEnd;
    }

    var traceMeasurementId = -1;

    function setTraceMeasurementId(traceId) {
        traceMeasurementId = traceId;
    }

    function getTraceMeasurementId() {
        return traceMeasurementId;
    }

    // Angle Measurement
    var angleMeasurementEnd = false;

    function setAngleMeasurementEnd(flag) {
        angleMeasurementEnd = flag;
    }

    function isAngleMeasurementEnd() {
        return angleMeasurementEnd;
    }

    var angleMeasurementId = -1;

    function setAngleMeasurementId(angleId) {
        angleMeasurementId = angleId;
    }

    function getAngleMeasurementId() {
        return angleMeasurementId;
    }

    function resetMousePressedCounter() {
        mousePressedCounter = 0;
    }

    function getMousePressedCounter() {
        return mousePressedCounter;
    }

    function increaseMousePressedCounter() {
        mousePressedCounter = mousePressedCounter + 1;
    }


    var volumeMeasurementEndFlag = false;

    function setVolumeMeasurementEnd(flag) {
        volumeMeasurementEndFlag = flag;
    }

    function isVolumeMeasurementEnd() {
        return volumeMeasurementEndFlag;
    }

    var volumeMeasurementId = -1;

    function setVolumeMeasurementId(volumeId) {
        volumeMeasurementId = volumeId;
    }

    function getVolumeMeasurementId() {
        return volumeMeasurementId;
    }

    var mitralMeanGradientMeasurementEnd = false;

    function setMitralMeanGradientMeasurementEnd(flag) {
        mitralMeanGradientMeasurementEnd = flag;
    }

    function isMitralMeanGradientMeasurementEnd() {
        return mitralMeanGradientMeasurementEnd;
    }

    var mitralMeanGradientMeasurementId = -1;

    function setMitralMeanGradientMeasurementId(Id) {
        mitralMeanGradientMeasurementId = Id;
    }

    function getMitralMeanGradientMeasurementId() {
        return mitralMeanGradientMeasurementId;
    }

    var penToolEnd = false;

    function setPenToolEnd(flag) {
        penToolEnd = flag;
    }

    function isPenToolEnd() {
        return penToolEnd;
    }

    function addMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMeasurements : imageRenderer is null/undefined";
        }

        var measurements = dicomImageMeasurements[imageUid + "_" + frameIndex];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        mosueData = undefined; // Release the memory for the data 
        measurements[measurements.length] = imageData;
        imageData = undefined; // Release the memory for the data
        dicomImageMeasurements[imageUid + "_" + frameIndex] = measurements;

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    var isNearToStartPoint, isNearToFirstPoint;
    var isNearToEndPoint, isNearToSecondPoint;
    var isNearToStartX, isNearToThirdPoint;
    var isNearToEndX, isNearToFourthPoint;
    var indexToEditMitral = 0;

    function resetHandeler() {
        isNearToStartPoint = undefined;
        isNearToEndPoint = undefined;
        isNearToStartX = undefined;
        isNearToEndX = undefined;

        isNearToFirstPoint = undefined;
        isNearToSecondPoint = undefined;
        isNearToThirdPoint = undefined;
        isNearToFourthPoint = undefined;
        indexToEditMitral = 0;
    }

    function updateMeasurements(dataToedit, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMeasurements : imageRenderer is null/undefined";
        }

        var measurement = dicomImageMeasurements[dataToedit.keyId];
        if (measurement === undefined) {
            return;
        }

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToedit);
        measurement = measurement[dataToedit.arryIndex];
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        if (measurement.measureType === "line") {
            if (isNearToStartPoint == undefined) {
                isNearToStartPoint = findNearHanleByPoint(imageData.end, measurement.start);
            } else if (isNearToEndPoint == undefined) {
                isNearToEndPoint = findNearHanleByPoint(imageData.end, measurement.end);
            }
            if (isNearToStartPoint) {
                measurement.start.x = imageData.end.x;
                measurement.start.y = imageData.end.y;
            } else if (isNearToEndPoint) {
                measurement.end.x = imageData.end.x;
                measurement.end.y = imageData.end.y;
            }

            if (mosueData) {
                measurement.textPosition = mosueData.textPosition;
            }
            dicomImageMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        } else {
            mosueData = undefined; // Release the memory for the data
            if (measurement.measurementId === imageData.measurementId) {
                measurement = imageData;
            } else {
                measurement.end = imageData.end;
                measurement.start = imageData.start;
            }
            dicomImageMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        }
    }

    function getMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageMeasurements[imageUid + "_" + frameIndex];
    }
    // Angle measurement
    function getAngleMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageAngleMeasurements[imageUid + "_" + frameIndex];
    }

    function resetAngleEditMode(imageUid, frameIndex, dataToEdit) {
        if (imageUid === undefined) {
            throw "resetAngleEditMode: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "resetAngleEditMode : frameIndex is null/undefined";
        }
        var angleMeasurement = dicomImageAngleMeasurements[imageUid + "_" + frameIndex];
        if (angleMeasurement === undefined) {
            throw "resetAngleEditMode : angleMeasurement is null/undefined";
        }
        var measurementData = angleMeasurement[dataToEdit.arryIndex];
        for (i = 0; i < measurementData.length; i++) {
            measurementData[i].editMode = false;
        }
        angleMeasurement[dataToEdit.arryIndex] = measurementData;
        dicomImageAngleMeasurements[imageUid + "_" + frameIndex] = angleMeasurement;
    }

    function addAngleMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addAngleMeasurements : imageRenderer is null/undefined";
        }

        var angleMeasurements = dicomImageAngleMeasurements[imageUid + "_" + frameIndex];

        if (angleMeasurements === undefined) {
            angleMeasurements = [];
        }
        var measurements = angleMeasurements[mosueData.measurementId];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        var measureLength = measurements.length;
        measurements[measureLength] = imageData;
        if (measureLength == 1) {
            measurements[0].editMode = false;
            measurements[1].editMode = false;
        }

        angleMeasurements[mosueData.measurementId] = measurements;
        dicomImageAngleMeasurements[imageUid + "_" + frameIndex] = angleMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    function addTraceMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addTraceMeasurements : imageRenderer is null/undefined";
        }

        var tarceMeasurements = dicomImageTraceMeasurements[imageUid + "_" + frameIndex];

        if (tarceMeasurements === undefined) {
            tarceMeasurements = [];
        }
        var measurements = tarceMeasurements[mosueData.measurementId];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        var measureLength = measurements.length;
        measurements[measureLength] = imageData;
        tarceMeasurements[mosueData.measurementId] = measurements;
        dicomImageTraceMeasurements[imageUid + "_" + frameIndex] = tarceMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    function getTraceMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageTraceMeasurements[imageUid + "_" + frameIndex];
    }

    function updateTraceMeasurements(dataToedit, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMeasurements : imageRenderer is null/undefined";
        }

        var measurement = dicomImageTraceMeasurements[dataToedit.keyId];
        if (measurement === undefined) {
            return;
        }

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToedit);
        measurement = measurement[dataToedit.arryIndex];
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        if (measurement.measureType === "line") {
            if (isNearToStartPoint == undefined) {
                isNearToStartPoint = findNearHanleByPoint(imageData.end, measurement.start);
            } else if (isNearToEndPoint == undefined) {
                isNearToEndPoint = findNearHanleByPoint(imageData.end, measurement.end);
            }
            if (isNearToStartPoint) {
                measurement.start.x = imageData.end.x;
                measurement.start.y = imageData.end.y;
            } else if (isNearToEndPoint) {
                measurement.end.x = imageData.end.x;
                measurement.end.y = imageData.end.y;
            }
            dicomImageTraceMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        } else {
            mosueData = undefined; // Release the memory for the data
            if (measurement.measurementId === imageData.measurementId) {
                measurement = imageData;
            } else {
                measurement.end = imageData.end;
                measurement.start = imageData.start;
            }
            dicomImageTraceMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        }
    }

    function resetTraceEditMode(imageUid, frameIndex, dataToEdit) {
        if (imageUid === undefined) {
            throw "resetTraceEditMode: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "resetTraceEditMode : frameIndex is null/undefined";
        }
        var traceMeasurement = dicomImageTraceMeasurements[imageUid + "_" + frameIndex];
        if (traceMeasurement === undefined) {
            throw "resetTraceEditMode : traceMeasurement is null/undefined";
        }

        var measurementIndex;
        if (dataToEdit == undefined) {
            measurementIndex = traceMeasurement.length - 1;
        } else {
            measurementIndex = dataToEdit.arryIndex;
        }
        var measurementData = traceMeasurement[measurementIndex];
        for (i = 0; i < measurementData.length; i++) {
            measurementData[i].editMode = false;
        }
        traceMeasurement[measurementIndex] = measurementData;
        dicomImageTraceMeasurements[imageUid + "_" + frameIndex] = traceMeasurement;
    }

    function addEllipseMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context, measurementResult) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addTraceMeasurements : imageRenderer is null/undefined";
        }

        var ellipseMeasurements = dicomImageEllipseMeasurements[imageUid + "_" + frameIndex];

        if (ellipseMeasurements === undefined) {
            ellipseMeasurements = [];
        }

        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        var measureLength = ellipseMeasurements.length;
        ellipseMeasurements[measureLength] = imageData;
        ellipseMeasurements[measureLength].measurementResult = measurementResult;
        ellipseMeasurements[measureLength].editMode = false;
        dicomImageEllipseMeasurements[imageUid + "_" + frameIndex] = ellipseMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    function resetEllipseEditMode(imageUid, frameIndex, dataToEdit) {
        if (imageUid === undefined) {
            throw "resetEditMode: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "resetEditMode : frameIndex is null/undefined";
        }
        var measurementData = dicomImageEllipseMeasurements[imageUid + "_" + frameIndex];
        if (measurementData === undefined) {
            throw "resetEllipseEditMode : measurementData is null/undefined";
        }

        measurementData[dataToEdit.arryIndex].editMode = false;
        dicomImageEllipseMeasurements[imageUid + "_" + frameIndex] = measurementData;
    }

    function getEllipseMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageEllipseMeasurements[imageUid + "_" + frameIndex];
    }

    function updateEllipseMeasurements(dataToedit, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMeasurements : imageRenderer is null/undefined";
        }

        var measurement = dicomImageEllipseMeasurements[dataToedit.keyId];
        if (measurement === undefined) {
            return;
        }

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToedit);
        measurement = measurement[dataToedit.arryIndex];
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        if (measurement.measureType === "ellipse") {
            var first, second;
            if (measurement.isCustomEllipse) {
                first = measurement.first;
                second = measurement.second;
            } else {
                first = measurement.start;
                second = measurement.end;
            }
            if (isNearToFirstPoint == undefined) {
                isNearToFirstPoint = findNearHanleByPoint(imageData.end, first);
            }
            if (isNearToSecondPoint == undefined) {
                isNearToSecondPoint = findNearHanleByPoint(imageData.end, second);
            }
            if (isNearToThirdPoint == undefined) {
                isNearToThirdPoint = (measurement.isCustomEllipse) ? findNearHanleByPoint(imageData.end, measurement.third) : isHandleNearByX(imageData.end, measurement.start);
            }
            if (isNearToFourthPoint == undefined) {
                isNearToFourthPoint = (measurement.isCustomEllipse) ? findNearHanleByPoint(imageData.end, measurement.fourth) : isHandleNearByX(imageData.end, measurement.end);
            }

            if (isNearToFirstPoint) {
                if (measurement.isCustomEllipse && !validateEllipseMovement(1, imageData, measurement)) {
                    return;
                }
                var startAngle = findAngle(1, measurement);
                measurement.start.x = imageData.end.x;
                measurement.start.y = imageData.end.y;
                if (measurement.isCustomEllipse) {
                    measurement.first.x = imageData.end.x;
                    measurement.first.y = imageData.end.y;
                    adjustQuadrantsOfEllipse(1, measurement, startAngle);
                }

                isNearToSecondPoint = undefined;
                isNearToThirdPoint = undefined;
                isNearToFourthPoint = undefined;
            } else if (isNearToSecondPoint) {
                if (measurement.isCustomEllipse && !validateEllipseMovement(2, imageData, measurement)) {
                    return;
                }
                var startAngle = findAngle(2, measurement);
                measurement.end.x = imageData.end.x;
                measurement.end.y = imageData.end.y;
                if (measurement.isCustomEllipse) {
                    measurement.second.x = imageData.end.x;
                    measurement.second.y = imageData.end.y;
                    adjustQuadrantsOfEllipse(2, measurement, startAngle);
                }

                isNearToFirstPoint = undefined;
                isNearToThirdPoint = undefined;
                isNearToFourthPoint = undefined;
            } else if (isNearToThirdPoint) {
                if (measurement.isCustomEllipse) {
                    if (!validateEllipseMovement(3, imageData, measurement)) {
                        return;
                    }
                    var startAngle = findAngle(3, measurement);
                    measurement.third.x = imageData.end.x;
                    measurement.third.y = imageData.end.y;
                    adjustQuadrantsOfEllipse(3, measurement, startAngle);
                    measurement.start = measurement.first;
                    measurement.end = measurement.second;
                } else {
                    measurement.start.x = imageData.end.x;
                    measurement.end.y = imageData.end.y;
                }

                isNearToFirstPoint = undefined;
                isNearToSecondPoint = undefined;
                isNearToFourthPoint = undefined;
            } else if (isNearToFourthPoint) {
                if (measurement.isCustomEllipse) {
                    if (!validateEllipseMovement(4, imageData, measurement)) {
                        return;
                    }
                    var startAngle = findAngle(4, measurement);
                    measurement.fourth.x = imageData.end.x;
                    measurement.fourth.y = imageData.end.y;
                    adjustQuadrantsOfEllipse(4, measurement, startAngle);
                    measurement.start = measurement.first;
                    measurement.end = measurement.second;
                } else {
                    measurement.start.y = imageData.end.y;
                    measurement.end.x = imageData.end.x;
                }

                isNearToFirstPoint = undefined;
                isNearToSecondPoint = undefined;
                isNearToThirdPoint = undefined;
            } else {
                isNearToFirstPoint = undefined;
                isNearToSecondPoint = undefined;
                isNearToThirdPoint = undefined;
                isNearToFourthPoint = undefined;
            }

            measurement.editMode = true;
            dicomImageEllipseMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        } else {
            mosueData = undefined; // Release the memory for the data
            if (measurement.measurementId === imageData.measurementId) {
                measurement = imageData;
            } else {
                measurement.end = imageData.end;
                measurement.start = imageData.start;
                measurement.second = imageData.second;
                measurement.first = imageData.first;

            }
            dicomImageEllipseMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        }
    }

    /**
     * Returns false if distance is less than minimum.
     * @param {Type} nearToPoint 
     * @param {Type} imageData 
     * @param {Type} measurement 
     */
    function validateEllipseMovement(nearToPoint, imageData, measurement) {
        var tempData = {
            start: measurement.center,
            end: imageData.end
        };
        var dist2Center = findQuadrantsDistance(nearToPoint, measurement, measurement.center);
        var distance = parseFloat(getLength(tempData), 2);
        if (distance < 50 && distance != dist2Center) {
            return false;
        }
        var totalDist = findQuadrantsDistance(nearToPoint, measurement, imageData.end);

        if ((distance + dist2Center - totalDist) > 10) {
            return false;
        }
        return true;
    }

    /**
     * 
     * @param {Type} nearToPoint 
     * @param {Type} measurement 
     * @param {Type} startAngle 
     */
    function adjustQuadrantsOfEllipse(nearToPoint, measurement, startAngle) {
        var cx = measurement.center.x,
            cy = measurement.center.y,
            endAngle = adjustCenterOfEllipse(nearToPoint, measurement),
            toAngle = endAngle - startAngle;
        if (nearToPoint == 1 || nearToPoint == 2) {
            applyTransform(cx, cy, measurement, 3, toAngle);
        } else if (nearToPoint == 3 || nearToPoint == 4) {
            applyTransform(cx, cy, measurement, 1, toAngle);
        }
    }

    /**
     * Apply the transform to the center of quadrant in case of rotation.
     * @param {Type} nearToPoint 
     * @param {Type} measurement 
     */
    function adjustCenterOfEllipse(nearToPoint, measurement) {
        var point = measurement.first;
        if (nearToPoint == 3 || nearToPoint == 4) {
            point = measurement.fourth;
        }
        var dx = point.x - measurement.center.x,
            dy = point.y - measurement.center.y,
            distance = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)),
            angle = findAngle(nearToPoint, measurement);
        measurement.center = {
            x: point.x + Math.cos(angle) * distance,
            y: point.y + Math.sin(angle) * distance
        };
        return angle;
    }

    /**
     * Returns angle between two given points.
     * @param {Type} nearToPoint 
     * @param {Type} measurement 
     */
    function findAngle(nearToPoint, measurement) {
        var isFirstHalf = (nearToPoint == 1 || nearToPoint == 2),
            start = isFirstHalf ? measurement.start : measurement.fourth,
            end = isFirstHalf ? measurement.end : measurement.third,
            dx = end.x - start.x,
            dy = end.y - start.y,
            distance = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)),
            cosalpha = dx / distance,
            angle;
        if (dy / distance < 0) {
            angle = (Math.PI * 2 - Math.acos(cosalpha));
        } else {
            angle = (Math.acos(cosalpha));
        }
        return angle;
    }

    /**
     * Apply the transform to all the quadrants in case of rotation.
     * @param {Type} cx 
     * @param {Type} cy 
     * @param {Type} measurement 
     * @param {Type} applyToPoint 
     * @param {Type} toAngle 
     */
    function applyTransform(cx, cy, measurement, applyToPoint, toAngle) {
        var rotatedPt,
            translatedPt,
            xDiff = measurement.center.x - cx,
            yDiff = measurement.center.y - cy;
        if (applyToPoint == 3) {
            rotatedPt = rotate(cx, cy, measurement, 3, -toAngle, 0, true);
            translatedPt = {
                x: rotatedPt.x + xDiff,
                y: rotatedPt.y + yDiff
            }
            measurement.third = translatedPt;
            rotatedPt = rotate(cx, cy, measurement, 4, -toAngle, 0, true);
            translatedPt = {
                x: rotatedPt.x + xDiff,
                y: rotatedPt.y + yDiff
            }
            measurement.fourth = translatedPt;
        } else if (applyToPoint == 1) {
            rotatedPt = rotate(cx, cy, measurement, 1, -toAngle, 0, true);
            translatedPt = {
                x: rotatedPt.x + xDiff,
                y: rotatedPt.y + yDiff
            }
            measurement.first = translatedPt;
            rotatedPt = rotate(cx, cy, measurement, 2, -toAngle, 0, true);
            translatedPt = {
                x: rotatedPt.x + xDiff,
                y: rotatedPt.y + yDiff
            }
            measurement.second = translatedPt;
        }
    }

    /**
     * Rotate a point to given radians with given center point.
     * @param {Type} cx 
     * @param {Type} cy 
     * @param {Type} measurement 
     * @param {Type} toRotate 
     * @param {Type} radians 
     * @param {Type} distance 
     * @param {Type} isCenter 
     */
    function rotate(cx, cy, measurement, toRotate, radians, distance, isCenter) {
        var point;
        if (toRotate == 1) {
            point = {
                x: measurement.first.x,
                y: measurement.first.y
            }
        } else if (toRotate == 2) {
            point = {
                x: measurement.second.x,
                y: measurement.second.y
            }
        } else if (toRotate == 3) {
            point = {
                x: measurement.third.x,
                y: measurement.third.y
            }
        } else if (toRotate == 4) {
            point = {
                x: measurement.fourth.x,
                y: measurement.fourth.y
            }
        }
        if (isCenter) {
            var cos = Math.cos(radians),
                sin = Math.sin(radians),
                nx = (cos * (point.x - cx)) + (sin * (point.y - cy)) + cx,
                ny = (cos * (point.y - cy)) - (sin * (point.x - cx)) + cy;
            return {
                x: nx,
                y: ny
            };
        }
        var rotatedPoint = {
            x: point.x + Math.cos(radians) * distance,
            y: point.y + Math.sin(radians) * distance
        }
        return rotatedPoint;
    }

    /**
     * 
     * @param {Type} measurement 
     * @param {Type} endPt 
     */
    function findQuadrantsDistance(nearToPoint, measurement, endPt) {
        var tempData, distance;
        if (nearToPoint == 1) {
            tempData = {
                start: measurement.second,
                end: endPt
            };
        } else if (nearToPoint == 2) {
            tempData = {
                start: measurement.first,
                end: endPt
            };
        } else if (nearToPoint == 3) {
            tempData = {
                start: measurement.fourth,
                end: endPt
            };
        } else if (nearToPoint == 4) {
            tempData = {
                start: measurement.third,
                end: endPt
            };
        }
        distance = parseFloat(getLength(tempData), 2);
        return distance;
    }

    /**
     * To hold rectangle measurements and annotations
     * @param {Type} imageUid 
     * @param {Type} frameIndex 
     * @param {Type} imageRenderer 
     * @param {Type} mosueData 
     * @param {Type} context 
     * @param {Type} measurementResult 
     */
    function addRectangleMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context, measurementResult) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addTraceMeasurements : imageRenderer is null/undefined";
        }

        var rectangleMeasurements = dicomImageRectangleMeasurements[imageUid + "_" + frameIndex];

        if (rectangleMeasurements === undefined) {
            rectangleMeasurements = [];
        }

        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        var measureLength = rectangleMeasurements.length;
        rectangleMeasurements[measureLength] = imageData;
        rectangleMeasurements[measureLength].measurementResult = measurementResult;
        rectangleMeasurements[measureLength].editMode = false;
        dicomImageRectangleMeasurements[imageUid + "_" + frameIndex] = rectangleMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    /**
     * To reset the edit mode of rectangle measurements
     * @param {Type} imageUid 
     * @param {Type} frameIndex 
     * @param {Type} dataToEdit 
     */
    function resetRectangleEditMode(imageUid, frameIndex, dataToEdit) {
        if (imageUid === undefined) {
            throw "resetEditMode: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "resetEditMode : frameIndex is null/undefined";
        }
        var measurementData = dicomImageRectangleMeasurements[imageUid + "_" + frameIndex];
        measurementData[dataToEdit.arryIndex].editMode = false;
        dicomImageRectangleMeasurements[imageUid + "_" + frameIndex] = measurementData;
    }

    /**
     * To get rectangle measurement from the array
     * @param {Type} imageUid 
     * @param {Type} frameIndex 
     */
    function getRectangleMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageRectangleMeasurements[imageUid + "_" + frameIndex];
    }

    /**
     * To update rectangle measurement data
     * @param {Type} dataToedit 
     * @param {Type} imageRenderer 
     * @param {Type} mosueData 
     * @param {Type} context 
     */
    function updateRectangleMeasurements(dataToedit, imageRenderer, mosueData, context, isUpdate) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMeasurements : imageRenderer is null/undefined";
        }

        var measurement = dicomImageRectangleMeasurements[dataToedit.keyId];
        if (measurement === undefined) {
            return;
        }

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToedit);
        measurement = measurement[dataToedit.arryIndex];
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        if (measurement.measureType === "rectangle") {

            if (isUpdate !== false) {
                if (isNearToStartPoint == undefined) {
                    isNearToStartPoint = findNearHanleByPoint(imageData.end, measurement.start);
                }
                if (isNearToEndPoint == undefined) {
                    isNearToEndPoint = findNearHanleByPoint(imageData.end, measurement.end);
                }
                if (isNearToStartX == undefined) {
                    isNearToStartX = isHandleNearByX(imageData.end, measurement.start);
                }
                if (isNearToEndX == undefined) {
                    isNearToEndX = isHandleNearByX(imageData.end, measurement.end);
                }
            } else {
                isNearToStartPoint = undefined;
                isNearToEndPoint = undefined;
                isNearToStartX = undefined;
                isNearToEndX = undefined;
            }

            if (isNearToStartPoint) {
                measurement.start.x = imageData.end.x;
                measurement.start.y = imageData.end.y;
                isNearToEndPoint = undefined;
                isNearToStartX = undefined;
                isNearToEndX = undefined;
            } else if (isNearToEndPoint) {
                measurement.end.x = imageData.end.x;
                measurement.end.y = imageData.end.y;
                isNearToStartPoint = undefined;
                isNearToStartX = undefined;
                isNearToEndX = undefined;
            } else if (isNearToStartX) {
                measurement.start.x = imageData.end.x;
                measurement.end.y = imageData.end.y;
                isNearToStartPoint = undefined;
                isNearToEndPoint = undefined;
                isNearToEndX = undefined;
            } else if (isNearToEndX) {
                measurement.start.y = imageData.end.y;
                measurement.end.x = imageData.end.x;
                isNearToStartPoint = undefined;
                isNearToEndPoint = undefined;
                isNearToStartX = undefined;
            } else {
                isNearToStartPoint = undefined;
                isNearToEndPoint = undefined;
                isNearToStartX = undefined;
                isNearToEndX = undefined;
            }

            measurement.editMode = true;
            dicomImageRectangleMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        } else {
            mosueData = undefined; // Release the memory for the data
            if (measurement.measurementId === imageData.measurementId) {
                measurement = imageData;
            } else {
                measurement.end = imageData.end;
                measurement.start = imageData.start;
            }
            dicomImageRectangleMeasurements[dataToedit.keyId][dataToedit.arryIndex] = measurement;
        }
    }

    /**
     * To check if the mouse point is near by rectangle measurement corners
     * @param {Type} mouseData 
     * @param {Type} point 
     */
    function isHandleNearByX(mouseData, point) {
        if (point.x - 2 <= mouseData.x &&
            point.x + 2 >= mouseData.x) {
            return true;
        }
        return false;
    }

    function addVolumeMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addVolumeMeasurements : imageRenderer is null/undefined";
        }

        var volumeMeasurements = dicomImageVolumeMeasurements[imageUid + "_" + frameIndex];

        if (volumeMeasurements === undefined) {
            volumeMeasurements = [];
        }
        var measurements = volumeMeasurements[mosueData.measurementId];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        measurements[measurements.length] = imageData;
        volumeMeasurements[mosueData.measurementId] = measurements;
        dicomImageVolumeMeasurements[imageUid + "_" + frameIndex] = volumeMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

    }

    function getVolumeMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMeasurements : frameIndex is null/undefined";
        }
        return dicomImageVolumeMeasurements[imageUid + "_" + frameIndex];
    }

    function removeMeasurement(imageUid, frameIndex) {

    }

    function addMitralGradientMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMitralGradientMeasurements : imageRenderer is null/undefined";
        }

        var mitralMeasurements = dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex];

        if (mitralMeasurements === undefined) {
            mitralMeasurements = [];
        }
        var measurements = mitralMeasurements[mosueData.measurementIndex];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        imageData.textPosition = mosueData.textPosition;
        var measureLength = measurements.length;
        measurements[measureLength] = imageData;
        if (!mitralMeanGradientMeasurementEnd) {
            for (i = 0; i < measureLength; i++) {
                measurements[i].editMode = false;
            }
        }
        mitralMeasurements[mosueData.measurementIndex] = measurements;
        dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex] = mitralMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    function resetMitralEditMode(imageUid, frameIndex, dataToEdit) {
        if (imageUid === undefined) {
            throw "resetMitralEditMode: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "resetMitralEditMode : frameIndex is null/undefined";
        }
        var mitralMeasurement = dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex];
        if (mitralMeasurement === undefined) {
            throw "resetMitralEditMode : mitralMeasurement is null/undefined";
        }

        var measurementIndex;
        if (dataToEdit == undefined) {
            measurementIndex = mitralMeasurement.length - 1;
        } else {
            measurementIndex = dataToEdit.arryIndex;
        }
        var measurementData = mitralMeasurement[measurementIndex];
        if (measurementData == undefined) {
            return;
        }

        for (i = 0; i < measurementData.length; i++) {
            measurementData[i].editMode = false;
        }
        mitralMeasurement[measurementIndex] = measurementData;
        dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex] = mitralMeasurement;
    }

    function getMitralGradientMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMitralGradientMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMitralGradientMeasurements : frameIndex is null/undefined";
        }
        return dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex];
    }

    function getLength(data) {
        var dx = (data.start.x - data.end.x);
        var dy = (data.start.y - data.end.y);
        var lengthInPixels = Math.sqrt(dx * dx + dy * dy);

        return lengthInPixels.toFixed(2);
    }

    function getMousePos(canvas, pointX, pointY) {
        var rect = canvas.getBoundingClientRect();
        return {
            x: pointX - rect.left,
            y: pointY - rect.top
        };
    }

    function findTraceToDelete(mouseData, imageRenderer) {
        isTraceDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //        loop: for (var i in dicomImageTraceMeasurements) {
        //          if (dicomImageTraceMeasurements.hasOwnProperty(i)) {
        var tarceMeasurements = dicomImageTraceMeasurements[measurementKeyId];
        if (tarceMeasurements !== undefined) {
            for (var n = 0; n < tarceMeasurements.length; n++) {
                if (activeImageRenderer === undefined) {
                    var measurements = tarceMeasurements[n];
                    if (measurements !== undefined) {
                        for (var m = 0; m < measurements.length; m++) {
                            var data = measurements[m];
                            if (data !== undefined && data.measureType == "trace") {
                                var originalLineDistance = getLength(data);

                                var tempData = {
                                    start: {
                                        x: data.start.x,
                                        y: data.start.y
                                    },
                                    end: {
                                        x: mouseData.x,
                                        y: mouseData.y
                                    },
                                    measureType: "line"
                                };
                                var firstDistance = getLength(tempData);

                                var tempData2 = {
                                    start: {
                                        x: mouseData.x,
                                        y: mouseData.y
                                    },
                                    end: {
                                        x: data.end.x,
                                        y: data.end.y
                                    },
                                    measureType: "line"
                                };

                                var secondDistance = getLength(tempData2);

                                var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                                if (Math.abs(totalDistance - originalLineDistance) < 5) {
                                    dataToDelete.measurmentType = "Trace";
                                    dataToDelete.keyId = measurementKeyId;
                                    dataToDelete.arryIndex = n;
                                    dataToDelete.isEditable = data.isEditable;
                                    dataToDelete.sessionType = data.sessionType;
                                    activeImageRenderer = imageRenderer;
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
        //  }
        //}

        if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isAngleDeleteCheck === false) {
            findAngleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function findVolumeToDelete(mouseData, imageRenderer) {
        isVolumeDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //loop: for (var i in dicomImageVolumeMeasurements) {
        //  if (dicomImageVolumeMeasurements.hasOwnProperty(i)) {
        var volumeMeasurements = dicomImageVolumeMeasurements[measurementKeyId];
        if (volumeMeasurements !== undefined) {
            for (var n = 0; n < volumeMeasurements.length; n++) {
                var measurements = volumeMeasurements[n];
                if (measurements !== undefined) {
                    for (var m = 0; m < measurements.length; m++) {
                        var data = measurements[m];
                        if (data !== undefined && data.measureType == "volume") {
                            var originalLineDistance = getLength(data);

                            var tempData = {
                                start: {
                                    x: data.start.x,
                                    y: data.start.y
                                },
                                end: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                measureType: "line"
                            };
                            var firstDistance = getLength(tempData);

                            var tempData2 = {
                                start: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                end: {
                                    x: data.end.x,
                                    y: data.end.y
                                },
                                measureType: "line"
                            };

                            var secondDistance = getLength(tempData2);

                            var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                            if (Math.abs(totalDistance - originalLineDistance) < 5 || (originalLineDistance < 5 && originalLineDistance > 0)) {
                                dataToDelete.measurmentType = "volume";
                                dataToDelete.keyId = measurementKeyId;
                                dataToDelete.arryIndex = n;
                                dataToDelete.isEditable = data.isEditable;
                                dataToDelete.sessionType = data.sessionType;
                                activeImageRenderer = imageRenderer;
                                return;

                            }
                        }
                    }
                }
            }
        }
        // }
        // }
        if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isAngleDeleteCheck === false) {
            findAngleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function findMitralToDelete(mouseData, imageRenderer) {
        isMitralGradineDelete = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //loop: for (var i in dicomImageVolumeMeasurements) {
        //  if (dicomImageVolumeMeasurements.hasOwnProperty(i)) {
        var volumeMeasurements = dicomImageMitralGradientMeasurements[measurementKeyId];
        if (volumeMeasurements !== undefined) {
            for (var n = 0; n < volumeMeasurements.length; n++) {
                var measurements = volumeMeasurements[n];
                if (measurements !== undefined) {
                    for (var m = 0; m < measurements.length; m++) {
                        var data = measurements[m];
                        if (data !== undefined && data.measureType == "mitralGradient") {
                            var originalLineDistance = getLength(data);

                            var tempData = {
                                start: {
                                    x: data.start.x,
                                    y: data.start.y
                                },
                                end: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                measureType: "mitralGradient"
                            };
                            var firstDistance = getLength(tempData);

                            var tempData2 = {
                                start: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                end: {
                                    x: data.end.x,
                                    y: data.end.y
                                },
                                measureType: "mitralGradient"
                            };

                            var secondDistance = getLength(tempData2);

                            var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                            if (Math.abs(totalDistance - originalLineDistance) < 5) {
                                dataToDelete.measurmentType = "mitralGradient";
                                dataToDelete.keyId = measurementKeyId;
                                dataToDelete.arryIndex = n;
                                dataToDelete.isEditable = data.isEditable;
                                dataToDelete.sessionType = data.sessionType;
                                activeImageRenderer = imageRenderer;
                                return;

                            }
                        }
                    }
                }
            }
        }
        // }
        // }
        if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isAngleDeleteCheck === false) {
            findAngleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function deleteSelectedMeasurment() {
        if (activeImageRenderer != undefined) {
            var keyId = dataToDelete.keyId;
            var arrayIndex = dataToDelete.arryIndex;
            var measurementType = dataToDelete.measurmentType;
            if (measurementType === "mitralGradient") {
                delete dicomImageMitralGradientMeasurements[keyId][arrayIndex];
            } else if (measurementType === "Trace") {
                delete dicomImageTraceMeasurements[keyId][arrayIndex];
            } else if (measurementType === "volume") {
                delete dicomImageVolumeMeasurements[keyId][arrayIndex];
            } else if (measurementType === "line" || measurementType === "point") {
                delete dicomImageMeasurements[keyId][arrayIndex];
            } else if (measurementType === "angle") {
                delete dicomImageAngleMeasurements[keyId][arrayIndex];
            } else if (measurementType === "ellipse") {
                delete dicomImageEllipseMeasurements[keyId][arrayIndex];
            } else if (measurementType === "rectangle") {
                delete dicomImageRectangleMeasurements[keyId][arrayIndex];
            } else if (measurementType === "pen") {
                delete dicomImagePenMeasurements[keyId][arrayIndex];
            }

            updateDirtyPState(activeImageRenderer.seriesLevelDivId, dataToDelete, true);
            dataToEdit = undefined;
            setDataToDelete();
            activeImageRenderer.renderImage(false);
            activeImageRenderer = undefined;
        }
    }

    function updateMeasurementTextData(dataToedit, text) {
        var measurement = dicomImageRectangleMeasurements[dataToedit.keyId];
        if (measurement === undefined) {
            return;
        }
        dicomImageRectangleMeasurements[dataToedit.keyId][dataToedit.arryIndex].measurementText = text;
    }

    function findLineToDelete(mouseData, imageRenderer) {
        var flagFor2dLengthCalibration = dicomViewer.tools.getFlagFor2dLengthCalibration();
        isLineDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //   loop: for (var i in dicomImageMeasurements) {
        //    if (dicomImageMeasurements.hasOwnProperty(i)) {
        var measurements = dicomImageMeasurements[measurementKeyId];
        if (measurements !== undefined) {
            for (var m = 0; m < measurements.length; m++) {
                var data = measurements[m];
                if (data !== undefined && data.measureType == "line") {
                    var originalLineDistance = getLength(data);

                    var tempData = {
                        start: {
                            x: data.start.x,
                            y: data.start.y
                        },
                        end: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        measureType: "line"
                    };
                    var firstDistance = getLength(tempData);

                    var tempData2 = {
                        start: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        end: {
                            x: data.end.x,
                            y: data.end.y
                        },
                        measureType: "line"
                    };

                    var secondDistance = getLength(tempData2);

                    var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                    if (Math.abs(totalDistance - originalLineDistance) < 5 /*|| originalLineDistance < 5*/ ) {
                        //delete dicomImageMeasurements[i][m];
                        dataToDelete.measurmentType = "line";
                        dataToDelete.keyId = measurementKeyId;
                        dataToDelete.arryIndex = m;
                        dataToDelete.isEditable = data.isEditable;
                        dataToDelete.sessionType = data.sessionType;
                        activeImageRenderer = imageRenderer;
                        return;
                    }
                }
            }
        }
        if (flagFor2dLengthCalibration) {
            dataToDelete.measurmentType = "line";
            dataToDelete.keyId = measurementKeyId;
            dataToDelete.arryIndex = m;
            activeImageRenderer = imageRenderer;
            setDataToDelete();
            return;
        }
        // }
        //}
        if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function findPointToDelete(mouseData, imageRenderer) {
        isPointDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        // loop: for (var i in dicomImageMeasurements) {
        //      if (dicomImageMeasurements.hasOwnProperty(i)) {
        var measurements = dicomImageMeasurements[measurementKeyId];
        if (measurements !== undefined) {
            for (var m = 0; m < measurements.length; m++) {
                var data = measurements[m];
                if (data !== undefined && data.measureType == "point") {
                    if (Math.abs(data.end.x - mouseData.x) < 5 && Math.abs(data.end.y - mouseData.y) < 5) {
                        dataToDelete.measurmentType = "point";
                        dataToDelete.keyId = measurementKeyId;
                        dataToDelete.arryIndex = m;
                        dataToDelete.isEditable = data.isEditable;
                        dataToDelete.sessionType = data.sessionType;
                        activeImageRenderer = imageRenderer;
                        return;
                    }
                }
            }
        }
        //        }
        //    }
        if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isAngleDeleteCheck === false) {
            findAngleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function findEllipseToDelete(mouseData, imageRenderer) {
        isEllipseDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //   loop: for (var i in dicomImageMeasurements) {
        //    if (dicomImageMeasurements.hasOwnProperty(i)) {
        var measurements = dicomImageEllipseMeasurements[measurementKeyId];
        if (measurements !== undefined) {
            for (var m = 0; m < measurements.length; m++) {
                var data = measurements[m];
                if (data !== undefined && data.measureType == "ellipse") {
                    var originalLineDistance = getLength(data);

                    var tempData1 = {
                        start: {
                            x: data.start.x,
                            y: data.start.y
                        },
                        end: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        measureType: "ellipse"
                    };
                    var firstDistance = getLength(tempData1);

                    var tempData2 = {
                        start: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        end: {
                            x: data.end.x,
                            y: data.end.y
                        },
                        measureType: "ellipse"
                    };

                    var secondDistance = getLength(tempData2);

                    var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                    var isEditable = false;
                    if (Math.abs(totalDistance - originalLineDistance) < 15) {
                        isEditable = true;
                    } else if (data.third !== undefined && data.third !== null) {
                        var tempData = {
                            start: {
                                x: data.third.x,
                                y: data.third.y
                            },
                            end: {
                                x: data.fourth.x,
                                y: data.fourth.y
                            },
                            measureType: "ellipse"
                        };
                        var secondLineDistance = getLength(tempData);

                        var tempData3 = {
                            start: {
                                x: data.third.x,
                                y: data.third.y
                            },
                            end: {
                                x: mouseData.x,
                                y: mouseData.y
                            },
                            measureType: "ellipse"
                        };
                        var thirdDistance = getLength(tempData3);

                        var tempData4 = {
                            start: {
                                x: mouseData.x,
                                y: mouseData.y
                            },
                            end: {
                                x: data.fourth.x,
                                y: data.fourth.y
                            },
                            measureType: "ellipse"
                        };

                        var fourthDistance = getLength(tempData4);

                        totalDistance = parseInt(thirdDistance) + parseInt(fourthDistance);
                        if (Math.abs(totalDistance - secondLineDistance) < 15) {
                            isEditable = true;
                        }
                    }

                    if (isEditable) {
                        //delete dicomImageMeasurements[i][m];
                        dataToDelete.measurmentType = "ellipse";
                        dataToDelete.keyId = measurementKeyId;
                        dataToDelete.arryIndex = m;
                        dataToDelete.isEditable = data.isEditable;
                        dataToDelete.sessionType = data.sessionType;
                        activeImageRenderer = imageRenderer;
                        return;
                    }
                }
            }
        }
        // }
        //}
        if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function findRectangleToDelete(mouseData, imageRenderer) {
        isRectangleDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        //   loop: for (var i in dicomImageMeasurements) {
        //    if (dicomImageMeasurements.hasOwnProperty(i)) {
        var measurements = dicomImageRectangleMeasurements[measurementKeyId];
        if (measurements !== undefined) {
            for (var m = 0; m < measurements.length; m++) {
                var data = measurements[m];
                if (data !== undefined && data.measureType == "rectangle") {
                    var originalLineDistance = getLength(data);

                    var tempData = {
                        start: {
                            x: data.start.x,
                            y: data.start.y
                        },
                        end: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        measureType: "rectangle"
                    };
                    var firstDistance = getLength(tempData);

                    var tempData2 = {
                        start: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        end: {
                            x: data.end.x,
                            y: data.end.y
                        },
                        measureType: "rectangle"
                    };

                    var secondDistance = getLength(tempData2);

                    var tempData3 = {
                        start: {
                            x: data.start.x,
                            y: data.end.y
                        },
                        end: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        measureType: "rectangle"
                    };

                    var thirdDistance = getLength(tempData3);

                    var tempData4 = {
                        start: {
                            x: mouseData.x,
                            y: mouseData.y
                        },
                        end: {
                            x: data.end.x,
                            y: data.start.y
                        },
                        measureType: "rectangle"
                    };

                    var fourthDistance = getLength(tempData4);

                    var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                    var totalDistance1 = parseInt(thirdDistance) + parseInt(fourthDistance);
                    if (Math.abs(totalDistance - originalLineDistance) < 15 || Math.abs(totalDistance1 - originalLineDistance) < 15) {
                        //delete dicomImageMeasurements[i][m];
                        dataToDelete.measurmentType = "rectangle";
                        dataToDelete.keyId = measurementKeyId;
                        dataToDelete.arryIndex = m;
                        dataToDelete.isEditable = data.isEditable;
                        dataToDelete.sessionType = data.sessionType;
                        activeImageRenderer = imageRenderer;
                        return;
                    }
                }
            }
        }
        // }
        //}
        if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function PointInRect(x, y) {
        return this.x <= x && x <= this.x + this.width &&
            this.y <= y && y <= this.y + this.height;
    }

    function findAngleToDelete(mouseData, imageRenderer) {
        isAngleDeleteCheck = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");
        var tarceMeasurements = dicomImageAngleMeasurements[measurementKeyId];
        if (tarceMeasurements !== undefined) {
            for (var n = 0; n < tarceMeasurements.length; n++) {
                if (activeImageRenderer === undefined) {
                    var measurements = tarceMeasurements[n];
                    if (measurements !== undefined) {
                        for (var m = 0; m < measurements.length; m++) {
                            var data = measurements[m];
                            if (data !== undefined && data.measureType == "angle") {
                                var originalLineDistance = getLength(data);

                                var tempData = {
                                    start: {
                                        x: data.start.x,
                                        y: data.start.y
                                    },
                                    end: {
                                        x: mouseData.x,
                                        y: mouseData.y
                                    },
                                    measureType: "line"
                                };
                                var firstDistance = getLength(tempData);

                                var tempData2 = {
                                    start: {
                                        x: mouseData.x,
                                        y: mouseData.y
                                    },
                                    end: {
                                        x: data.end.x,
                                        y: data.end.y
                                    },
                                    measureType: "line"
                                };

                                var secondDistance = getLength(tempData2);

                                var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                                if (Math.abs(totalDistance - originalLineDistance) < 5) {
                                    dataToDelete.measurmentType = "angle";
                                    dataToDelete.keyId = measurementKeyId;
                                    dataToDelete.arryIndex = n;
                                    dataToDelete.isEditable = data.isEditable;
                                    dataToDelete.sessionType = data.sessionType;
                                    activeImageRenderer = imageRenderer;
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer);
        } else if (activeImageRenderer === undefined && isMitralGradineDelete === false) {
            findMitralToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    function resetMeasurementFlag() {
        isLineDeleteCheck = false;
        isPointDeleteCheck = false;
        isAngleDeleteCheck = false;
        isEllipseDeleteCheck = false;
        isRectangleDeleteCheck = false;
        isTraceDeleteCheck = false;
        isVolumeDeleteCheck = false;
        isMitralGradineDelete = false;
        isPenToolEnd = false;
    }

    function findNearHandle(mouseData, imageRenderer, context) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        loop: for (i in dicomImageMeasurements) {
            if (dicomImageMeasurements.hasOwnProperty(i)) {
                var measurements = dicomImageMeasurements[i];
                if (measurements !== undefined) {
                    for (var m = 0; m < measurements.length; m++) {
                        data = measurements[m];
                        if (data !== undefined) {
                            var isNearToStartPoint = findNearHanleByPoint(imageData, data.start);
                            var isNearToEndPoint = findNearHanleByPoint(imageData, data.end);
                            if (isNearToStartPoint) {
                                data.start.handleActive = true;
                                measurements.splice(m, 1);
                                break loop;
                            } else if (isNearToEndPoint) {
                                data.end.handleActive = true;
                                measurements.splice(m, 1);
                                break loop;
                            } else {
                                data = undefined;
                            }
                        }
                    }
                }
            }
        }
        if (data !== undefined) {
            return getMouseDataForImageData(data, imageRenderer, context);
        }
        return undefined;
    }


    function findNearHandleToEdit(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        var measurements = dicomImageMeasurements[keyId];
        if (measurements === undefined)
            return;
        measurements = measurements[arrayIndex];
        data = dicomImageMeasurements[keyId][arrayIndex];
        if (data !== undefined) {
            var isNearToStartPoint = findNearHanleByPoint(imageData, data.start);
            var isNearToEndPoint = findNearHanleByPoint(imageData, data.end);
            if (isNearToStartPoint) {
                data.start.handleActive = true;
                data.start.x = imageData.x;
                data.start.y = imageData.y;
            } else if (isNearToEndPoint) {
                data.end.handleActive = true;
                data.end.x = imageData.x;
                data.end.y = imageData.y;
            } else {
                data = undefined;
            }

        }
        if (data !== undefined) {
            return getMouseDataForImageData(data, imageRenderer, context);
        }
        return undefined;
    }

    function updateVolumeintoArray(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        var measurements = dicomImageVolumeMeasurements[keyId];

        if (measurements === undefined)
            return;
        measurements = measurements[arrayIndex];
        data = dicomImageVolumeMeasurements[keyId][arrayIndex];
        for (var index = 0; index < data.length; index++) {
            var tempData = data[index];
            if (tempData !== undefined) {
                var isNearToStartPoint = findNearHanleByPoint(imageData, tempData.start);
                var isNearToEndPoint = findNearHanleByPoint(imageData, tempData.end);
                if ((data.length - 1) === index) {
                    if (isNearToEndPoint) {
                        tempData.start.x = imageData.x;
                        tempData.start.y = imageData.y;
                        tempData.end.x = imageData.x;
                        tempData.end.y = imageData.y;
                    }
                } else {
                    if (isNearToStartPoint) {
                        tempData.start.x = imageData.x;
                        tempData.start.y = imageData.y;
                    } else if (isNearToEndPoint) {
                        tempData.end.x = imageData.x;
                        tempData.end.y = imageData.y;
                    }
                }
            }
        }
    }

    function updateTraceIntoArray(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        var measurements = dicomImageTraceMeasurements[keyId];

        if (measurements === undefined)
            return;
        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToEdit);
        measurements = measurements[arrayIndex];
        data = dicomImageTraceMeasurements[keyId][arrayIndex];
        for (var index = indexToEditMitral; index < data.length; index++) {
            var tempData = data[index];
            if (tempData !== undefined) {
                var isNearToStartPoint = findNearHanleByPoint(imageData, tempData.start);
                if (isNearToStartPoint && index == 0) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint && index == data.length - 1) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    tempData.end.x = imageData.x;
                    tempData.end.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImageTraceMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImageTraceMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                }
            }
            tempData.editMode = true;
        }
    }

    function updateAngleIntoArray(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var measurements = dicomImageAngleMeasurements[keyId];

        if (measurements === undefined)
            return;

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToEdit);
        measurements = measurements[arrayIndex];
        data = dicomImageAngleMeasurements[keyId][arrayIndex];
        for (var index = 0; index < data.length; index++) {
            var tempData = data[index];
            if (tempData !== undefined) {
                var isNearToStartPoint = findNearHanleByPoint(imageData, tempData.start);
                var isNearToEndPoint = findNearHanleByPoint(imageData, tempData.end);
                if (isNearToEndPoint) {
                    tempData.end.x = imageData.x;
                    tempData.end.y = imageData.y;
                } else if (isNearToStartPoint) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                }
                tempData.editMode = true;
            }
        }
    }

    function updateMitralMeanGradientintoArray(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        var measurements = dicomImageMitralGradientMeasurements[keyId];

        if (measurements === undefined)
            return;

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToEdit);
        measurements = measurements[arrayIndex];
        data = dicomImageMitralGradientMeasurements[keyId][arrayIndex];
        for (var index = indexToEditMitral; index < data.length; index++) {
            var tempData = data[index];
            if (tempData !== undefined) {
                var isNearToStartPoint = findNearHanleByPoint(imageData, tempData.start);
                if (isNearToStartPoint && index == 0) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint && index == data.length - 1 && tempData.measurementSubType == "mitral") {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    tempData.end.x = imageData.x;
                    tempData.end.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImageMitralGradientMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImageMitralGradientMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                }
            }
            tempData.editMode = true;
        }
    }

    function findNearHanleByPoint(mouseData, point) {
        if (point.x - 10 <= mouseData.x &&
            point.x + 10 >= mouseData.x &&
            point.y - 10 <= mouseData.y &&
            point.y + 10 >= mouseData.y) {
            return true;
        }
        return false;
    }


    function getMouseDataForImageData(imageData, imageRenderer, context) {
        var startPoint = dicomViewer.measurement.draw.getMousePointForImageCoordinates(imageData.start, imageRenderer, context);
        var endPoint = dicomViewer.measurement.draw.getMousePointForImageCoordinates(imageData.end, imageRenderer, context);
        var mouseData = {};
        mouseData.start = startPoint;
        mouseData.end = endPoint;
        mouseData.measureType = imageData.measureType;
        mouseData.measurementText = imageData.measurementText;
        return mouseData;
    }


    function removeAllMeasurements(imageUid, frameIndex, renderer) {
        if (imageUid === undefined || frameIndex === undefined) {
            throw "Error in imageUid or FrameIndex";
        }
        delete dicomImageMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageTraceMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageVolumeMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageMitralGradientMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageAngleMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageEllipseMeasurements[imageUid + "_" + frameIndex];
        delete dicomImageRectangleMeasurements[imageUid + "_" + frameIndex];
        delete dicomImagePenMeasurements[imageUid + "_" + frameIndex];
        setDataToEdit(undefined);

        if (renderer !== undefined && renderer !== null) {
            updateDirtyPState(renderer.seriesLevelDivId, {
                keyId: imageUid + "_" + frameIndex
            }, true);
        }
    }

    var imageContexts = {};

    function setImageContext(imageUid, frameIndex, context) {
        imageContexts[imageUid + "_" + frameIndex] = context;
    }

    function getImageContext(imageUid, frameIndex) {
        return imageContexts[imageUid + "_" + frameIndex];
    }

    function setDataToEdit(data, isProperty) {
        if (activeImageRenderer != undefined && data === "edit") {
            dataToEdit = dataToDelete;
            var auids = dataToEdit.keyId.split("_");
            var sereiesId = $('#' + activeImageRenderer.parentElement).parent().closest('div').attr('id');
            if (isFullScreenEnabled) {
                sereiesId = previousLayoutSelection;
            }
            var measurementData;
            if (dataToEdit.measurmentType === "volume") {
                measurementData = getVolumeMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData);
                measurementData.measureType = "volumeedit";
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "mitralGradient") {
                measurementData = getMitralGradientMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "Trace") {
                measurementData = getTraceMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "angle") {
                measurementData = getAngleMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "ellipse") {
                measurementData = getEllipseMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "rectangle") {
                measurementData = getRectangleMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "pen") {
                measurementData = getPenMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                dicomViewer.measurement.setTempData(measurementData);
            } else {
                measurementData = getMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.end.handleActive = true;
                measurementData.start.handleActive = true;
            }
            setTool(measurementData);
            activeImageRenderer.renderImage(false);
            isMeasurementEdit = true;

            if (isProperty) {
                var tool = dicomViewer.mouseTools.getActiveTool();
                if (tool && !tool.activeImageRenderer) {
                    tool.activeImageRenderer = activeImageRenderer;
                }

                return measurementData.length > 0 ? measurementData[0] : measurementData;
            }
        }
        if (data === undefined) {
            //editing done
            isMeasurementEdit = false;
            dataToEdit = data;
        }
    }

    /**
     * Update measurement style of selected annotation
     * @param {Type}  
     */
    function udpateMeasurementProperty(measurementStyle) {
        if (dataToEdit != undefined && measurementStyle != undefined) {
            var auids = dataToEdit.keyId.split("_");
            var sereiesId = $('#' + activeImageRenderer.parentElement).parent().closest('div').attr('id');
            if (isFullScreenEnabled) {
                sereiesId = previousLayoutSelection;
            }
            var measurementData;
            if (dataToEdit.measurmentType === "volume") {
                measurementData = getVolumeMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.style = measurementStyle;
                measurementData.measureType = "volumeedit";
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "mitralGradient") {
                measurementData = getMitralGradientMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                if (measurementData.length > 0) {
                    $.each(measurementData, function (keyId, value) {
                        value.style = measurementStyle;
                    });
                }
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "Trace") {
                measurementData = getTraceMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                if (measurementData.length > 0) {
                    $.each(measurementData, function (keyId, value) {
                        value.style = measurementStyle;
                    });
                }
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "angle") {
                measurementData = getAngleMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                if (measurementData.length > 0) {
                    $.each(measurementData, function (keyId, value) {
                        value.style = measurementStyle;
                    });
                }
                dicomViewer.measurement.setTempData(measurementData[0]);
            } else if (dataToEdit.measurmentType === "ellipse") {
                measurementData = getEllipseMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.style = measurementStyle;
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "rectangle") {
                measurementData = getRectangleMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.style = measurementStyle;
                dicomViewer.measurement.setTempData(measurementData);
            } else if (dataToEdit.measurmentType === "pen") {
                measurementData = getPenMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.style = measurementStyle;
                dicomViewer.measurement.setTempData(measurementData);
            } else {
                measurementData = getMeasurements(auids[0], auids[1], sereiesId)[dataToEdit.arryIndex];
                measurementData.style = measurementStyle;
                measurementData.end.handleActive = false;
                measurementData.start.handleActive = false;
            }
            setTool(measurementData);
            activeImageRenderer.renderImage(false);
            isMeasurementEdit = true;
        }
        var tool = dicomViewer.mouseTools.getActiveTool();
        if (tool.ToolType == "angleMeasurement") {
            dicomViewer.measurement.setTempData(undefined);
        }
        tool.hanleDoubleClick();
    }

    /**
     * Set the image tool while editing the selected shape
     * @param {Type} measurement - type of the annotation/measurement data
     */
    function setTool(measurement) {
        dicomViewer.mouseTools.setPreviousTool(dicomViewer.mouseTools.getActiveTool());
        dicomViewer.mouseTools.setCursor(dicomViewer.mouseTools.getToolCursor(1));
        if (measurement.measureType == "line") {
            LineMeasurement.prototype.setMeasurementSubType();
            if (measurement.measurementSubType == "2DLength") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool());
                LineMeasurement.prototype.setMeasurementSubType(measurement.measurementSubType);
            } else if (measurement.measurementSubType == "2DLine") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(4));
                LineMeasurement.prototype.setMeasurementSubType(measurement.measurementSubType);
            } else if (measurement.measurementSubType == "Arrow") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(5));
                LineMeasurement.prototype.setMeasurementSubType(measurement.measurementSubType);
            } else if (measurement.measurementId == "mitralRegurgitationLength") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(1));
                dicomViewer.measurement.draw.setMeasurementType(0, 'mitralRegurgitationLength', 'cm');
            } else if (measurement.measurementId == "aorticRegurgitationLength") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(2));
                dicomViewer.measurement.draw.setMeasurementType(1, 'aorticRegurgitationPeakVelocity', 'm/s');
            } else if (measurement.measurementId == "mitralValveAnteriorLeafletThickness") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DLengthMeasureTool(3));
                dicomViewer.measurement.draw.setMeasurementType(0, 'mitralValveAnteriorLeafletThickness', 'mm');
            }
            return;
        }
        if (measurement.measureType == "rectangle") {
            if (measurement.measurementSubType == "hounsfield") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool());
                RectangleMeasurement.prototype.setMeasurementSubType("hounsfield");
            } else if (measurement.measurementSubType == "rectangle") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool(1));
                RectangleMeasurement.prototype.setMeasurementSubType("rectangle");
            } else if (measurement.measurementSubType == "text") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getRectangleMeasureTool(2));
                RectangleMeasurement.prototype.setMeasurementSubType("text");
            }
            return;
        }
        if (measurement.measureType == "ellipse") {
            if (measurement.measurementSubType == "hounsfield") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getEllipseMeasureTool());
                EllipseMeasurement.prototype.setMeasurementSubType("hounsfield");
            } else if (measurement.measurementSubType == "ellipse") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getEllipseMeasureTool(1));
                EllipseMeasurement.prototype.setMeasurementSubType("ellipse");
            }
            return;
        }
        if (measurement.measureType == "point") {
            if (measurement.measurementId == "mitralRegurgitationPeakVelocity") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(1));
                dicomViewer.measurement.draw.setMeasurementType(1, 'mitralRegurgitationPeakVelocity', 'm/s');
            } else if (measurement.measurementId == "aorticRegurgitationPeakVelocity") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(2));
                dicomViewer.measurement.draw.setMeasurementType(1, 'aorticRegurgitationPeakVelocity', 'm/s');
            } else if (measurement.measurementId == "aorticStenosisPeakVelocity") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool(3));
                dicomViewer.measurement.draw.setMeasurementType(1, 'aorticStenosisPeakVelocity', 'm/s');
            } else {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.get2DPointMeasureTool());
                dicomViewer.measurement.draw.setMeasurementType(1, null, null);
            }
            return;
        }
        if ($.isArray(measurement) && measurement.length > 0) {
            if (measurement[0].measureType == "angle") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getAngleMeasureTool());
            } else if (measurement[0].measureType == "trace") {
                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getTraceMeasureTool());
            }
            if (measurement[0].measureType == "mitralGradient") {
                if (measurement[0].measurementSubType == "mitral") {
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getMitralMeanGradientMeasureTool());
                } else if (measurement[0].measurementSubType == "freehand") {
                    dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getMitralMeanGradientMeasureTool(1));
                }
            }
        }
    }

    function getDataToDelete() {
        return dataToDelete;
    }

    function getDataToEdit() {
        return dataToEdit;
    }

    function setDataToDelete() {
        dataToDelete = {
            measurmentType: "",
            keyId: "",
            arryIndex: "",
            isEditable: "",
            sessionType: 0
        };
    }

    function setCoordinate(coordinate) {
        this.coordinate = coordinate;
    }

    function getCoordinate() {
        return this.coordinate;
    }

    /**
     * 
     * set the default the unit type  
     */
    function getDefaultLineMeasurementUnit() {
        return this.lineMeasurementUnit = lineMeasurementUnit;
    }

    /**
     * 
     * verify the image uid having pixel spacing or not
     */
    function isCalibratePixelSpacing(render) {
        if (dicomViewer.tools.isCaliberEnabled(render)) {
            dicomViewer.tools.setLengthCalibrationFlag(true);
            dicomViewer.tools.setCalibrationActiveTool();
        }
    }

    /**
     * Save the study presentation state
     * @param {Type} pStateDetails - Specifies the PState details
     */
    function savePState(pStateDetails) {
        try {
            if (pStateDetails === undefined) {
                // Invalid input parameters
                return;
            }

            // Check whether the presentation state is enabled or not
            if (isPStateEnabled() !== true) {
                return;
            }

            var studyUid = pStateDetails.studyUid;
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }
            showAndHideSplashWindow("show", "Saving Presentation", pStateDetails.viewportId);
            var imagePStates = {};

            // Length measurements
            $.each(dicomImageMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value.studyUid)) {
                        return;
                    }

                    var measurementType = undefined;
                    if (value.measureType === "line") {
                        switch (value.measurementSubType) {
                            case "2DLength":
                                measurementType = MT_LENGTH;
                                break;

                            case "2DLine":
                                measurementType = MT_LINE;
                                break;

                            case "Arrow":
                                measurementType = MT_ARROW;
                                break;
                        }

                        if (measurementType === undefined) {
                            if (value.measurementId !== undefined && value.measurementId !== null) {
                                measurementType = getUSMeasurementType(value.measurementId);
                            }
                        }
                    } else if (value.measureType === "point") {
                        measurementType = MT_POINT;
                        if (value.measurementId !== undefined && value.measurementId !== null) {
                            measurementType = getUSMeasurementType(value.measurementId);
                        }
                    }

                    addImagePState(imagePStates, keyId, value, measurementType, studyDetails);
                });
            });

            // Angle measurements
            $.each(dicomImageAngleMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value[0].studyUid)) {
                        return;
                    }

                    addImagePState(imagePStates, keyId, value, MT_ANGLE, studyDetails);
                });
            });

            // Ellipse measurements
            $.each(dicomImageEllipseMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value.studyUid)) {
                        return;
                    }

                    var measurementType = undefined;
                    switch (value.measurementSubType) {
                        case "hounsfield":
                            measurementType = MT_HOUNSFIELDELLIPSE;
                            break;

                        case "ellipse":
                            measurementType = MT_ELLIPSE;
                            break;
                    }

                    addImagePState(imagePStates, keyId, value, measurementType, studyDetails);
                });
            });

            // Rectangle measurements
            $.each(dicomImageRectangleMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value.studyUid)) {
                        return;
                    }

                    var measurementType = undefined;
                    switch (value.measurementSubType) {
                        case "hounsfield":
                            measurementType = MT_HOUNSFIELDRECT;
                            break;

                        case "rectangle":
                            measurementType = MT_RECT;
                            break;

                        case "text":
                            measurementType = MT_TEXT;
                            break;
                    }

                    addImagePState(imagePStates, keyId, value, measurementType, studyDetails);
                });
            });

            // Trace measurements
            $.each(dicomImageTraceMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value[0].studyUid)) {
                        return;
                    }

                    addImagePState(imagePStates, keyId, value, MT_TRACE, studyDetails);
                });
            });

            // Mitral gradient measurements
            $.each(dicomImageMitralGradientMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value[0].studyUid)) {
                        return;
                    }

                    var measurementType = MT_MG;
                    switch (value[0].measurementSubType) {
                        case "freehand":
                            measurementType = MT_FREEHAND;
                            break;
                    }

                    addImagePState(imagePStates, keyId, value, measurementType, studyDetails);
                });
            });

            // pen measurements
            $.each(dicomImagePenMeasurements, function (keyId, values) {
                values.forEach(function (value) {
                    if (!isSameStudy(studyUid, value[0].studyUid)) {
                        return;
                    }
                    addImagePState(imagePStates, keyId, value, MT_PEN, studyDetails);
                });
            });

            // Save the presentation state
            var studyPState = getStudyPState(imagePStates, pStateDetails);
            if (studyPState === undefined || studyPState === null) {
                // Invalid PState objects
                return;
            }

            // Send the presentation state to server
            var contextId = studyDetails.modality == "General" ? studyDetails[0].contextId : studyDetails.contextId;
            var pStateUrl = dicomViewer.url.getPStateUrl(contextId);
            var pState = JSON.stringify(studyPState);
            $.ajax({
                    type: 'POST',
                    contentType: "application/json; charset=utf-8",
                    url: pStateUrl,
                    async: false,
                    data: pState,
                    cache: false
                })
                .success(function (data) {
                    var description = "Successfully saved the presentation state for the context id: " + decodeURIComponent(studyDetails.contextId);
                    sendViewerStatusMessage("200", description);
                    showAndHideSplashWindow("success", "Presentation state saved successfully");

                    // Refresh PStates
                    loadPState(studyUid, undefined, true);
                    $("#saveAndLoadPStateMenu_" + pStateDetails.viewportId)[0].style.display = "none";
                })
                .fail(function (data) {
                    var description = "Failed to save the presentation state for the context id: " + decodeURIComponent(studyDetails.contextId);
                    sendViewerStatusMessage("500", description);
                    showAndHideSplashWindow("error", "Failed to save the presentation state");

                })
                .error(function (xhr, status) {
                    var description = xhr.statusText + "\nFailed to save the presentation state to server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                    showAndHideSplashWindow("error", "Failed to save presentation state in server");

                });
        } catch (e) {
            showAndHideSplashWindow("error", "Failed to save presentation state");
        }
        setTimeout(function () {
            $("#saveAndLoadPStateMenu_" + pStateDetails.viewportId)[0].style.display = "block";
        }, 1500)
    }

    /**
     * show and hide the spalash window
     * @param {Type} messageType - Type of message
     * @param {Type} message - message content
     * @param {Type} studyViewer - study viewer viewportID
     */
    function showAndHideSplashWindow(messageType, message, viewportId) {
        try {
            if (messageType == "show") {
                $("#splash-window").show().center(viewportId);
                $("#splash-content")[0].innerHTML = "<img src = images/presentaionLoader.gif>  " + message + "";
                $("#splash-content").show();
                $("#saveAndLoadPStateMenu_" + viewportId)[0].style.display = "none";
            } else if (messageType == "success") {
                setTimeout(function () {
                    $("#splash-content")[0].innerHTML = "" + message + "";
                }, 1000)
            } else {
                setTimeout(function () {
                    $("#splash-content")[0].innerHTML = "" + message + "";
                }, 1000)
            }
        } catch (e) {}
        setTimeout(function () {
            $("#splash-window").fadeOut(1000);
        }, 1500)
    }

    /**
     * Load the study presentation
     * @param {Type} studyUid - Specifies the studyUid
     * @param {Type} selectedPState - Specifies the selected PState
     * @param {Type} isRefreshMenuOnly - Specifies the flag to refesh the PState menu
     */
    function loadPState(studyUid, selectedPState, isRefreshMenuOnly, isStatus, isAsync) {
        try {
            var t0 = Date.now();
            dumpConsoleLogs(LL_INFO, undefined, "loadPState ", "Start", undefined, true);

            if (studyUid === undefined) {
                // Invalid input parameters
                return;
            }

            // Check whether the presentation state is enabled or not
            if (isPStateEnabled() !== true) {
                return;
            }

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            var viewportId = (selectedPState == undefined) ? undefined : ((selectedPState == null) ? undefined : selectedPState.split("_"));
            if (isRefreshMenuOnly === undefined && viewportId != undefined && isStatus !== false) {
                showAndHideSplashWindow("show", "Applying Presentation", viewportId[1]);
            }

            if (isAsync === undefined) {
                isAsync = false;
            }

            var contextId = studyDetails.modality == "General" ? studyDetails[0].contextId : studyDetails.contextId;
            var pStateUrl = dicomViewer.url.getPStateUrl(contextId);
            $.ajax({
                    url: pStateUrl,
                    cache: false,
                    async: isAsync
                })
                .done(function (data) {
                    if (data == undefined || data == null || data.length == 0) {
                        if (isRefreshMenuOnly == false) {
                            resetPState(studyDetails);
                        }

                        return;
                    }

                    // Parse the JSON PState string
                    data.forEach(function (item) {
                        if (item.data !== undefined && item.data !== null) {
                            item.presentationStates = JSON.parse(item.data);
                            item.presentationStates = item.presentationStates.filter(function (o) {
                                if (getImageUrnFromUId(studyDetails, o.imageId) != undefined) {
                                    return true;
                                }

                                return o.imageUrn !== undefined;
                            });

                            item.isOldPState = (item.presentationStates.length == 0 ? true : false);
                        }
                    });

                    // Filter the new pstate only
                    data = data.filter(function (o) {
                        return o.isOldPState == false;
                    });
                    if (data.length == 0) {
                        resetPState(studyDetails);
                        return;
                    }

                    var userDUZ = getUserDuz();
                    var recentPState = undefined;
                    if (selectedPState !== undefined) {
                        // Get the selected presentation state
                        recentPState = data.filter(function (o) {
                            return o.id === selectedPState.split("_")[2];
                        })[0];

                        // Check whether the pstate is external
                        if (recentPState === undefined) {
                            var existingPState = studyDetails.PStates.All.filter(function (o) {
                                return o.id === selectedPState.split("_")[2];
                            })[0];
                            if (existingPState !== undefined) {
                                recentPState = data.filter(function (o) {
                                    return o.contextId === existingPState.contextId;
                                })[0];
                            }
                        }

                        // Check whether the selected PState is other user 
                        var isOtherUser = (userDUZ !== parseInt(recentPState.userId));
                        if (isOtherUser) {
                            recentPState.isEditable = false;
                        }
                    } else {
                        // Get the recent presentation state
                        var userPStates = data.filter(function (o) {
                            return userDUZ === parseInt(o.userId);
                        });
                        if (!userPStates || userPStates.length === 0) {
                            userPStates = data.filter(function (o) {
                                return userDUZ !== parseInt(o.userId);
                            });
                        }

                        if (userPStates !== undefined && userPStates !== null) {
                            var recentDate = Math.max.apply(null, userPStates.map(function (o) {
                                if (!o.isExternal) {
                                    return new Date(parseDate(o.dateTime));
                                } else {
                                    return -1;
                                }
                            }));

                            // Check whether the pstate is external
                            var recentPStates = undefined;
                            if (recentDate === -1) {
                                recentPStates = userPStates.filter(function (o) {
                                    return (o.isExternal === true);
                                });
                            } else {
                                recentPStates = userPStates.filter(function (o) {
                                    if (o.dateTime === null) return false;
                                    return new Date(parseDate(o.dateTime)).valueOf() === recentDate;
                                });
                            }

                            if (!recentPStates || recentPStates.length === 0) {
                                recentPStates = recentPStates;
                            }

                            recentPState = recentPStates[0];
                            if (recentPState && userDUZ == -1) {
                                recentPState.isEditable = false;
                            }
                        }
                    }

                    // Update the presentation state
                    updatePState(recentPState, studyDetails);
                    refreshPState(studyUid);

                    if (isRefreshMenuOnly === undefined && isStatus !== false) {
                        showAndHideSplashWindow("success", "Applied Presentation successfully");
                    }

                    // Update the study presentations states
                    var activePStateId = (recentPState !== undefined ? recentPState.id : undefined);
                    isRefreshMenuOnly = (isRefreshMenuOnly == true ? true : (selectedPState != undefined ? true : false));
                    updateStudyPStates(data, studyDetails, activePStateId, isRefreshMenuOnly);
                    viewportId != undefined ? $("#saveAndLoadPStateMenu_" + viewportId[1])[0].style.display = "none" : "";
                })
                .fail(function (data) {
                    resetPState(studyDetails);

                    var description = "Failed to get the presentation state for the context id: " + decodeURIComponent(studyDetails.contextId);
                    sendViewerStatusMessage("500", description);
                    if (isRefreshMenuOnly === undefined) {
                        showAndHideSplashWindow("error", "Failed to Apply Presentation state");
                    }
                })
                .error(function (xhr, status) {
                    resetPState(studyDetails);

                    var description = xhr.statusText + "\nFailed to get the presentation state from server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                    if (isRefreshMenuOnly === undefined) {
                        showAndHideSplashWindow("error", "Failed to get presentation state from server");
                    }
                });
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, "loadPState", e.message, undefined, true);
        } finally {
            (viewportId != undefined) ? setTimeout(function () {
                $("#saveAndLoadPStateMenu_" + viewportId[1])[0].style.display = "block";
            }, 1500): "";
            dumpConsoleLogs(LL_INFO, undefined, "loadPState ", "End", (Date.now() - t0), true);
        }
    }

    /**
     * To convert given date format into milliseconds
     * @param {Type} dateString 
     */
    function parseDate(dateString) {
        var time = Date.parse(dateString);
        if (!time) {
            if (!time) {
                bound = dateString.indexOf(' ');
                var dateData = dateString.slice(0, bound).split('-');
                var timeData = dateString.slice(bound + 1, -1).split(':');

                time = Date.UTC(dateData[0], dateData[1] - 1, dateData[2], timeData[0], timeData[1], timeData[2]);
            }
        }
        return time;
    }

    /**
     * Load the length or point measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurementKeyId - Specifies the measurement key
     * @param {Type} measurements - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadLengthOrPointMeasurement(imageKeyId, measurementKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurementKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var measureType = undefined;
            var measurementSubType = undefined;
            var measurementType = -1;
            var measurementUnits = undefined;
            var measurementId = undefined;
            switch (measurementKeyId) {
                case MT_LENGTH:
                    measurementSubType = "2DLength";
                    measurementType = 0;
                    measurementUnits = "cm";
                    measureType = "line";
                    break;

                case MT_LINE:
                    measurementSubType = "2DLine";
                    measurementType = 9;
                    measureType = "line";
                    break;

                case MT_ARROW:
                    measurementSubType = "Arrow";
                    measurementType = 10;
                    measureType = "line";
                    break;

                case MT_MVALT:
                    measurementSubType = "mitralValveAnteriorLeafletThickness";
                    measurementId = measurementSubType;
                    measurementType = 0;
                    measurementUnits = "mm";
                    measureType = "line";
                    break;

                case MT_MRL:
                    measurementSubType = "mitralRegurgitationLength";
                    measurementId = measurementSubType;
                    measurementType = 0;
                    measurementUnits = "cm";
                    measureType = "line";
                    break;

                case MT_ARL:
                    measurementSubType = "aorticRegurgitationLength";
                    measurementId = measurementSubType;
                    measurementType = 0;
                    measurementUnits = "cm";
                    measureType = "line";
                    break;

                case MT_POINT:
                    measurementSubType = "point";
                    measurementType = 1;
                    measureType = "point";
                    break;

                case MT_MRPV:
                    measurementSubType = "mitralRegurgitationPeakVelocity";
                    measurementId = measurementSubType;
                    measurementType = 1;
                    measurementUnits = "m/s";
                    measureType = "point";
                    break;

                case MT_ARPV:
                    measurementSubType = "aorticRegurgitationPeakVelocity";
                    measurementId = measurementSubType;
                    measurementType = 1;
                    measurementUnits = "m/s";
                    measureType = "point";
                    break;

                case MT_ASPV:
                    measurementSubType = "aorticStenosisPeakVelocity";
                    measurementId = measurementSubType;
                    measurementType = 1;
                    measurementUnits = "m/s";
                    measureType = "point";
                    break;
            }

            var measurements = dicomImageMeasurements[imageKeyId];
            if (measurements === undefined) {
                measurements = [];
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: measureType,
                    measurementSubType: measurementSubType,
                    measurementId: measurementId,
                    measurementComplete: true,
                    measurementType: measurementType,
                    measurementUnits: measurementUnits,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    calibrationData: measurement.calibrationData,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                measurements.push(measurementData);
            }
            dicomImageMeasurements[imageKeyId] = measurements;
        } catch (e) {}
    }

    /**
     * Load the angle measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurement - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadAngleMeasurement(imageKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var angleMeasurements = dicomImageAngleMeasurements[imageKeyId];
            if (angleMeasurements === undefined) {
                angleMeasurements = [];
            }

            var measurementId = angleMeasurements.length;
            var measurements = angleMeasurements[measurementId];
            if (measurements === undefined) {
                measurements = [];
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: "angle",
                    measurementSubType: undefined,
                    measurementId: measurementId,
                    measurementComplete: true,
                    measurementType: undefined,
                    measurementUnits: undefined,
                    editMode: false,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                measurements.push(measurementData);
            }

            angleMeasurements[measurementId] = measurements;
            dicomImageAngleMeasurements[imageKeyId] = angleMeasurements;
        } catch (e) {}
    }

    /**
     * Load the ellipse measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurementKeyId - Specifies the measurement key
     * @param {Type} measurements - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadEllipseMeasurement(imageKeyId, measurementKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurementKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var measurementSubType = undefined;
            var measurementType = undefined;
            var measurementUnits = undefined;
            switch (measurementKeyId) {
                case MT_ELLIPSE:
                    measurementSubType = "ellipse";
                    measurementType = 11;
                    break;

                case MT_HOUNSFIELDELLIPSE:
                    measurementSubType = "hounsfield";
                    measurementType = 7;
                    measurementUnits = "cm";
                    break;
            }

            var ellipseMeasurements = dicomImageEllipseMeasurements[imageKeyId];
            if (ellipseMeasurements === undefined) {
                ellipseMeasurements = [];
            }

            var measurementResult = undefined;
            if (measurementSubType === "hounsfield") {
                var text = measurement.text;
                if (text !== undefined) {
                    measurementResult = text.split(",");
                }
            }

            var start = {};
            var end = {};
            var isCustomEllipse = false;
            for (var index = 0; index < points.length; index += 4) {
                var start, end = null;
                var first, second, third, fourth, center = null;
                start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                if (points.length > 4) {
                    isCustomEllipse = true;
                    first = {
                        x: parseFloat(points[index]),
                        y: parseFloat(points[index + 1])
                    };

                    second = {
                        x: parseFloat(points[index + 2]),
                        y: parseFloat(points[index + 3])
                    };

                    third = {
                        x: parseFloat(points[index + 4]),
                        y: parseFloat(points[index + 5])
                    };

                    fourth = {
                        x: parseFloat(points[index + 6]),
                        y: parseFloat(points[index + 7])
                    };
                }

                if (points.length > 8) {
                    center = {
                        x: parseFloat(points[index + 8]),
                        y: parseFloat(points[index + 9])
                    };
                }

                index = points.length;

                var measurementData = {
                    start: start,
                    end: end,
                    first: first,
                    second: second,
                    third: third,
                    fourth: fourth,
                    center: center,
                    isCustomEllipse: isCustomEllipse,
                    measureType: "ellipse",
                    measurementSubType: measurementSubType,
                    measurementId: -1,
                    measurementComplete: true,
                    measurementType: measurementType,
                    measurementUnits: measurementUnits,
                    editMode: false,
                    measurementResult: measurementResult,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                ellipseMeasurements.push(measurementData);
            }

            dicomImageEllipseMeasurements[imageKeyId] = ellipseMeasurements;
        } catch (e) {}
    }

    /**
     * Load the rectangle measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurementKeyId - Specifies the measurement key
     * @param {Type} measurements - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadRectangleMeasurement(imageKeyId, measurementKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurementKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var measurementSubType = undefined;
            var measurementType = undefined;
            var measurementUnits = undefined;
            switch (measurementKeyId) {
                case MT_RECT:
                    measurementSubType = "rectangle";
                    measurementType = 12;
                    break;

                case MT_HOUNSFIELDRECT:
                    measurementSubType = "hounsfield";
                    measurementType = 14;
                    measurementUnits = "cm";
                    break;

                case MT_TEXT:
                    measurementSubType = "text";
                    measurementType = 8;
                    break;
            }

            var rectangleMeasurements = dicomImageRectangleMeasurements[imageKeyId];
            if (rectangleMeasurements === undefined) {
                rectangleMeasurements = [];
            }

            var measurementResult = undefined;
            var measurementText = undefined;
            if (measurementSubType === "hounsfield" || measurementSubType === "text") {
                var text = measurement.text;
                if (text !== undefined) {
                    if (measurementSubType === "text") {
                        measurementText = text.replace("<BR>", "\n");
                        measurementText = measurementText.replace("<br>", "\n");
                    } else {
                        measurementResult = text.split(",");
                    }
                }
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: "rectangle",
                    measurementSubType: measurementSubType,
                    measurementId: -1,
                    measurementComplete: true,
                    measurementType: measurementType,
                    measurementUnits: measurementUnits,
                    editMode: false,
                    measurementResult: measurementResult,
                    measurementText: measurementText,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                rectangleMeasurements.push(measurementData);
            }

            dicomImageRectangleMeasurements[imageKeyId] = rectangleMeasurements;
        } catch (e) {}
    }

    /**
     * Load the trace measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurement - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadTraceMeasurement(imageKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var tarceMeasurements = dicomImageTraceMeasurements[imageKeyId];
            if (tarceMeasurements === undefined) {
                tarceMeasurements = [];
            }

            var measurementId = tarceMeasurements.length;
            var measurements = tarceMeasurements[measurementId];
            if (measurements === undefined) {
                measurements = [];
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: "trace",
                    measurementSubType: undefined,
                    measurementId: measurementId,
                    measurementComplete: true,
                    measurementType: 2,
                    measurementUnits: undefined,
                    editMode: false,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                measurements.push(measurementData);
            }

            tarceMeasurements[measurementId] = measurements;
            dicomImageTraceMeasurements[imageKeyId] = tarceMeasurements;
        } catch (e) {}
    }

    /**
     * Load the Mitral Gradient measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurementKeyId - Specifies the measurement key* 
     * @param {Type} measurement - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadMitralGradientMeasurement(imageKeyId, measurementKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var measurementSubType = undefined;
            var measurementType = undefined;
            switch (measurementKeyId) {
                case MT_MG:
                    measurementSubType = MT_MG;
                    measurementType = 5;
                    break;

                case MT_FREEHAND:
                    measurementSubType = "freehand";
                    measurementType = 13;
                    break;
            }

            var mitralMeasurements = dicomImageMitralGradientMeasurements[imageKeyId];
            if (mitralMeasurements === undefined) {
                mitralMeasurements = [];
            }

            var measurementId = mitralMeasurements.length;
            var measurements = mitralMeasurements[measurementId];
            if (measurements === undefined) {
                measurements = [];
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: "mitralGradient",
                    measurementSubType: measurementSubType,
                    measurementId: measurementId,
                    measurementComplete: true,
                    measurementType: measurementType,
                    measurementUnits: undefined,
                    editMode: false,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                measurements.push(measurementData);
            }

            mitralMeasurements[measurementId] = measurements;
            dicomImageMitralGradientMeasurements[imageKeyId] = mitralMeasurements;
        } catch (e) {}
    }

    /**
     * get image PState
     * @param {Type} imagePStates - Specifies the image PStates
     * @param {Type} imageKeyId - Specifies the image KeyId 
     * @param {Type} studyDetails - Specifies the study details 
     */
    function getImagePState(imagePStates, imageKeyId, studyDetails) {
        try {
            var imagePState = imagePStates[imageKeyId];
            if (imagePState !== undefined) {
                return imagePState;
            } else {
                var imageUids = imageKeyId.split("_");
                imagePState = {};
                imagePState.id = getUUID();
                imagePState.imageId = imageUids[0];
                imagePState.frameNumber = imageUids[1];
                imagePState.objects = [];
                imagePState.layers = [];
                imagePState.imageUrn = getImageUrnFromUId(studyDetails, imagePState.imageId);

                imagePStates[imageKeyId] = imagePState;
            }

            return imagePState;
        } catch (e) {}
    }

    /**
     * Get the study PState
     * @param {Type} imagePStates - Specifies the image PState
     * @param {Type} pStateDescription - Specifies the presentation state description
     * @param {Type} isPrivate - Specifies the flag to make private
     * @param {Type} isEditable - Specifies the flag to make editalbe
     */
    function getStudyPState(imagePStates, pStateDetails, isPrivate, isEditable) {
        try {
            if (imagePStates == undefined || imagePStates == null || imagePStates.length == 0) {
                // Invalid or empty image PStates
                return undefined;
            }

            var studyUid = pStateDetails.studyUid;
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            var description = "";
            if (studyDetails.PStates !== undefined && studyDetails.PStates !== null) {
                description = studyDetails.PStates.Active.description;
            }

            var studyPState = {};
            var isPrivate = (pStateDetails.isPrivate === undefined ? false : pStateDetails.isPrivate);
            var isEditable = (pStateDetails.isEditable === undefined ? true : pStateDetails.isEditable);
            var isNew = (pStateDetails.isNew === undefined ? false : pStateDetails.isNew);
            description = (description === undefined ? "" : description);

            // Update the PState with an existing PState
            if (!isNew) {
                if (studyDetails.PStates !== undefined) {
                    if (studyDetails.PStates.Active.isNew == true) {
                        removeUnSavedPState(studyDetails);
                        studyPState.id = null;
                    } else {
                        studyPState.id = studyDetails.PStates.Active.id;
                    }
                }
            }

            studyPState.isPrivate = isPrivate;
            studyPState.isEditable = isEditable;
            studyPState.description = description;

            var presentationStates = [];
            $.each(imagePStates, function (keyId, imagePState) {
                presentationStates.push(imagePState);
            });
            studyPState.data = JSON.stringify(presentationStates);

            return studyPState;
        } catch (e) {}

        return undefined;
    }

    /**
     * Get the graphic object PState
     * @param {Type} measuements - Specifies the measurements
     * @param {Type} measurementType - Specifies the measurement type
     */
    function getGraphicObjectPState(measuements, measurementType) {
        try {
            if (measuements == undefined || measuements == null) {
                // Invalid measurements
                return undefined;
            }

            var graphicObject = {};
            graphicObject.id = getUUID();
            graphicObject.type = measurementType;
            graphicObject.points = [];
            graphicObject.text = "";
            graphicObject.graphicLayerIndex = 0;
            graphicObject.style = getGrpahicStyle(measuements, measurementType, true);
            if (measuements.calibrationData) {
                graphicObject.calibrationData = measuements.calibrationData;
            }

            switch (measurementType) {
                case MT_LENGTH:
                case MT_LINE:
                case MT_ARROW:
                case MT_POINT:
                case MT_MVALT:
                case MT_MRL:
                case MT_ARL:
                case MT_MRPV:
                case MT_ARPV:
                case MT_ASPV:
                    {
                        addPointsInPState(measuements, graphicObject.points);
                        break;
                    }

                case MT_LABEL:
                    {
                        if (measuements.textBounds && measuements.measurementText) {
                            graphicObject.text = measuements.measurementText;
                            measuements.textBounds.forEach(function (pt) {
                                graphicObject.points.push(Math.round(pt.x));
                                graphicObject.points.push(Math.round(pt.y));
                            });
                        }

                        break;
                    }

                case MT_ANGLE:
                case MT_TRACE:
                case MT_MG:
                case MT_PEN:
                case MT_FREEHAND:
                    {
                        measuements.forEach(function (value) {
                            addPointsInPState(value, graphicObject.points);
                        });
                        break;
                    }

                case MT_ELLIPSE:
                case MT_HOUNSFIELDELLIPSE:
                case MT_RECT:
                case MT_HOUNSFIELDRECT:
                case MT_TEXT:
                    {
                        var isEllispe = (measurementType === MT_HOUNSFIELDELLIPSE ||
                            measurementType === MT_ELLIPSE);
                        addPointsInPState(measuements, graphicObject.points, isEllispe);
                        if (measuements.measurementResult) {
                            var text = "";
                            measuements.measurementResult.forEach(function (textItem) {
                                text += textItem;
                                text += ",";
                            });
                            graphicObject.text = text.slice(0, -1);
                        } else if (measurementType === MT_TEXT) {
                            graphicObject.text = measuements.measurementText;
                        }
                        break;
                    }
            }

            return graphicObject;
        } catch (e) {}

        return undefined;
    }

    /**
     * Add points in PState 
     * @param {Type} measuements -  Specifies the measurements
     * @param {Type} points - points
     */
    function addPointsInPState(measuements, points, isEllispe) {
        try {
            points.push(Math.round(measuements.start.x));
            points.push(Math.round(measuements.start.y));
            points.push(Math.round(measuements.end.x));
            points.push(Math.round(measuements.end.y));

            if (isEllispe && measuements.isCustomEllipse) {
                if (measuements.first != null) {
                    points.push(Math.round(measuements.third.x));
                    points.push(Math.round(measuements.third.y));
                    points.push(Math.round(measuements.fourth.x));
                    points.push(Math.round(measuements.fourth.y));
                }
                if (measuements.center != null) {
                    points.push(Math.round(measuements.center.x));
                    points.push(Math.round(measuements.center.y));
                }
            }
        } catch (e) {}
    }

    /**
     * Add the image PState
     * @param {Type} imagePStates - Specifies the image PStates
     * @param {Type} imageKeyIdId - Specifies the image key
     * @param {Type} measuements - Specifies the measurements
     * @param {Type} measurementType - Specifies the measurement type
     * @param {Type} studyDetails - Specifies the study details
     */
    function addImagePState(imagePStates, imageKeyId, measuements, measurementType, studyDetails) {
        try {
            var imagePState = getImagePState(imagePStates, imageKeyId, studyDetails);
            var graphicObject = getGraphicObjectPState(measuements, measurementType);
            if (graphicObject === undefined) {
                return;
            }

            imagePState.objects.push(graphicObject);

            var measuements = measuements;
            if (measurementType == MT_ANGLE) {
                measuements = measuements[0];
            }

            if (measuements.textBounds) {
                graphicObject = getGraphicObjectPState(measuements, MT_LABEL);
                if (graphicObject) {
                    imagePState.objects.push(graphicObject);
                }
            }

            imagePStates[imageKeyId] = imagePState;
        } catch (e) {}
    }

    /**
     * Get US measurement type
     * @param {Type} measurement - Specifies the measurement subtype
     */
    function getUSMeasurementType(measurementSubType) {
        switch (measurementSubType) {
            case "mitralValveAnteriorLeafletThickness":
                return MT_MVALT;

            case "mitralRegurgitationLength":
                return MT_MRL;

            case "aorticRegurgitationLength":
                return MT_ARL;

            case "mitralRegurgitationPeakVelocity":
                return MT_MRPV;

            case "aorticRegurgitationPeakVelocity":
                return MT_ARPV;

            case "aorticStenosisPeakVelocity":
                return MT_ASPV;
        }

        return undefined;
    }

    /**
     * Get the graphic style
     * @param {Type} measurements - Specifies the measuerment data
     * @param {Type} measurementType - Specifies the measuerment type
     */
    function getGrpahicStyle(measurements, measurementType, isEditable) {
        try {
            var measurementStyle = measurements.style;
            var type = null;
            if (measurementType !== undefined) {
                type = measurementType;
            } else {
                type = measurements.type;
            }

            var userMeasurementStyle = dicomViewer.measurement.draw.getUserMeasurementStyleByType((isEditable ? type : undefined));
            if (!measurementStyle) {
                measurementStyle = userMeasurementStyle;
            }

            if (measurementType == undefined && (measurements.style !== undefined && measurements.style.isUnderlined == undefined)) {
                measurementStyle.isUnderlined = userMeasurementStyle.isUnderlined;
                measurementStyle.isStrikeout = userMeasurementStyle.isStrikeout;
                measurementStyle.isFill = userMeasurementStyle.isFill;
                measurementStyle.fillColor = userMeasurementStyle.fillColor;
                measurementStyle.gaugeLength = userMeasurementStyle.gaugeLength;
                measurementStyle.gaugeStyle = userMeasurementStyle.gaugeStyle;
                measurementStyle.precision = userMeasurementStyle.precision;
                measurementStyle.measurementUnits = userMeasurementStyle.measurementUnits;
                measurementStyle.arcRadius = userMeasurementStyle.arcRadius;
            }

            var style = {
                lineColor: measurementStyle.lineColor,
                lineWidth: parseFloat(measurementStyle.lineWidth),
                textColor: measurementStyle.textColor,
                fontName: measurementStyle.fontName,
                fontSize: parseInt(measurementStyle.fontSize),
                isBold: measurementStyle.isBold,
                isItalic: measurementStyle.isItalic,
                isUnderlined: measurementStyle.isUnderlined,
                isStrikeout: measurementStyle.isStrikeout,
                isFill: measurementStyle.isFill,
                fillColor: measurementStyle.fillColor,
                gaugeLength: measurementStyle.gaugeLength,
                gauugeStyle: measurementStyle.gaugeStyle,
                precision: measurementStyle.precision,
                measurementUnits: measurementStyle.measurementUnits,
                arcRadius: measurementStyle.arcRadius
            };

            return style;
        } catch (e) {}
    }

    /**
     * Check whether the study is same
     * @param {Type} selectedStudyUid - Specifies the selected study Uid
     * @param {Type} measurementStudyUid  - Specifies the measurement study Uid
     */
    function isSameStudy(selectedStudyUid, measurementStudyUid) {
        if (measurementStudyUid === undefined || selectedStudyUid === undefined) {
            return false;
        }

        if (selectedStudyUid === measurementStudyUid) {
            return true;
        }

        return false;
    }

    /**
     * Update the presentation state
     * @param {Type} selctedPState - Specifies the presentation state
     * @param {Type} studyDetails - Specifies the study details
     */
    function updatePState(selctedPState, studyDetails) {
        try {
            // Delete all measurements and annotations
            deleteAllPStates(studyDetails.studyUid);

            if (selctedPState === undefined ||
                selctedPState === null ||
                studyDetails === undefined ||
                studyDetails === null) {
                // Invalid input parameters 
                return;
            }

            // Flag to edit the measurement or annotation
            var isEditable = true;
            if (selctedPState.isEditable !== undefined && selctedPState.isEditable !== null) {
                isEditable = selctedPState.isEditable;
            }

            selctedPState.presentationStates.forEach(function (pState) {
                var imageKeyId = getImageUidFromUrn(studyDetails, pState) + "_" + pState.frameNumber;
                pState.objects.forEach(function (graphicObjects) {
                    graphicObjects.studyUid = studyDetails.studyUid;
                    switch (graphicObjects.type) {
                        case MT_LENGTH:
                        case MT_LINE:
                        case MT_ARROW:
                        case MT_MVALT:
                        case MT_MRL:
                        case MT_ARL:
                        case MT_POINT:
                        case MT_MRPV:
                        case MT_ARPV:
                        case MT_ASPV:
                            {
                                loadLengthOrPointMeasurement(imageKeyId, graphicObjects.type, graphicObjects, isEditable);
                                break;
                            }

                        case MT_ANGLE:
                            {
                                loadAngleMeasurement(imageKeyId, graphicObjects, isEditable);
                                break;
                            }

                        case MT_ELLIPSE:
                        case MT_HOUNSFIELDELLIPSE:
                            {
                                loadEllipseMeasurement(imageKeyId, graphicObjects.type, graphicObjects, isEditable);
                                break;
                            }

                        case MT_RECT:
                        case MT_HOUNSFIELDRECT:
                        case MT_TEXT:
                            {
                                loadRectangleMeasurement(imageKeyId, graphicObjects.type, graphicObjects, isEditable);
                                break;
                            }

                        case MT_TRACE:
                            {
                                loadTraceMeasurement(imageKeyId, graphicObjects, isEditable);
                                break;
                            }

                        case MT_MG:
                        case MT_FREEHAND:
                            {
                                loadMitralGradientMeasurement(imageKeyId, graphicObjects.type, graphicObjects, isEditable);
                                break;
                            }
                        case MT_PEN:
                            {
                                loadPenMeasurement(imageKeyId, graphicObjects.type, graphicObjects, isEditable);
                                break;
                            }
                    }
                });
            });
        } catch (e) {}
    }

    /**
     * Update the study presentation states
     * @param {Type} pStates - Specifies the PStates
     * @param {Type} studyDetails - Specifies the study details
     * @param {Type} activePStateId - Specifies the active PState Id
     * @param {Type} isRefreshMenu - Specifies the flag to refesh PState menu
     */
    function updateStudyPStates(pStates, studyDetails, activePStateId, isRefreshMenu) {
        try {
            if (pStates == undefined ||
                pStates === null ||
                studyDetails === undefined ||
                studyDetails === null) {
                return;
            }

            // Create the object to hold the PState
            studyDetails.PStates = {};
            studyDetails.PStates.All = [];
            studyDetails.PStates.userDUZ = getUserDuz();

            pStates.forEach(function (pState) {
                var isOtherUser = (studyDetails.PStates.userDUZ !== parseInt(pState.userId));
                var isEditable = (isOtherUser ? false : pState.isEditable);
                var description = isNullOrUndefined(pState.description) ? pState.dateTime : pState.description;

                if (!isDuplicatePState(studyDetails.PStates.All, pState)) {
                    studyDetails.PStates.All.push({
                        id: pState.id,
                        name: description,
                        dateTime: pState.dateTime,
                        description: description,
                        isEditable: isEditable,
                        isOtherUser: isOtherUser,
                        isExternal: pState.isExternal,
                        contextId: pState.contextId,
                        tooltip: (!pState.tooltip ? description : pState.tooltip)
                    });
                }

                if (pState.id === activePStateId) {
                    studyDetails.PStates.Active = {
                        id: pState.id,
                        name: description,
                        dateTime: pState.dateTime,
                        description: description,
                        isEditable: isEditable,
                        isDirty: false,
                        imagePStates: pState.presentationStates,
                        isOtherUser: isOtherUser,
                        isExternal: pState.isExternal,
                        contextId: pState.contextId,
                        tooltip: (!pState.tooltip ? description : pState.tooltip)
                    };
                } else if (activePStateId == undefined && studyDetails.PStates.Active === undefined) {
                    studyDetails.PStates.Active = {
                        isEmpty: true
                    };
                }
            });

            // Sort by recent date
            studyDetails.PStates.All.sort(function (a, b) {
                if (!a.isExternal && !b.isExternal) {
                    return new Date(parseDate(b.dateTime)) - new Date(parseDate(a.dateTime));
                } else {
                    return -1;
                }
            });
            dicomViewer.updatePState(studyDetails.studyUid);
        } catch (e) {}
    }

    /**
     * Check the if a value is null or undefined
     **/
    function isNullOrUndefined(obj) {
        if (obj === undefined || obj === null || obj === "") {
            return true;
        }
        return false;
    }

    /**
     * Check whether the PState is duplicated or not
     * @param {Type} pStates - Specifies the PStates
     * @param {Type} pState - Specifies the selected PState
     */
    function isDuplicatePState(pStates, pState) {
        try {
            var isDuplicate = false;

            pStates.forEach(function (item) {
                if (pState.id === item.id) {
                    isDuplicate = true;
                    return false;
                }
            });

            return isDuplicate;
        } catch (e) {}

        return false;
    }

    /**
     * Delete all measurements
     * @param {Type} studyUid - Specifies the study Uid
     */
    function deleteAllPStates(studyUid) {
        try {
            if (studyUid === undefined || studyUid === null) {
                return;
            }
            var deleteAllPState = [];
            deleteAllPState.push(dicomImageMeasurements);
            deleteAllPState.push(dicomImageAngleMeasurements);
            deleteAllPState.push(dicomImageEllipseMeasurements);
            deleteAllPState.push(dicomImageRectangleMeasurements);
            deleteAllPState.push(dicomImageTraceMeasurements);
            deleteAllPState.push(dicomImageMitralGradientMeasurements);
            deleteAllPState.push(dicomImagePenMeasurements);
            var imageUids = [];
            var isIndex = false;

            dicomViewer.mouseTools.setPreviousTool(dicomViewer.mouseTools.getActiveTool());
            dicomViewer.mouseTools.setCursor(dicomViewer.mouseTools.getToolCursor(1));

            $.each(deleteAllPState, function (keyId, values) {
                $.each(values, function (id, ImageId) {
                    ImageId.some(function (o) {
                        var obj = o;
                        var studyId = (Object.prototype.toString.call(obj) === '[object Array]') ? obj[0].studyUid : obj.studyUid;
                        if (studyId === studyUid && !isIndex) {
                            imageUids.push(id);
                            return true;
                        } else if (studyId === studyUid && imageUids.indexOf(id) == -1) {
                            imageUids.push(id);
                            return true;
                        }
                    });
                });
                isIndex = true;
            });

            imageUids.forEach(function (imageUid) {
                var imageUidFrameNumber = imageUid.split("_");
                removeAllMeasurements(imageUidFrameNumber[0], imageUidFrameNumber[1]);
            });
        } catch (e) {}
    }

    /**
     * Create the new presentation state
     * @param {Type} e - Specifies the id
     */
    function newPState(e) {
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

            // Create the object to hold the PState
            if (studyDetails.PStates == undefined || studyDetails.PStates == null) {
                studyDetails.PStates = {};
            }

            // Create the array to hold all PStates
            if (studyDetails.PStates.All == undefined || studyDetails.PStates.All == null) {
                studyDetails.PStates.All = [];
            }

            var newId = null;
            var newTitle = "untitled";
            studyDetails.PStates.All.push({
                id: newId,
                name: newTitle,
                dateTime: "",
                description: ""
            });
            studyDetails.PStates.Active = {
                id: newId,
                name: newTitle,
                dateTime: "",
                description: "",
                isNew: true,
                isEditable: true
            };
            UpdateIsEditable();
            updateNewDirtyActivePState(studyDetails);
        } catch (e) {}
    }

    /**
     * Delete the presentation state
     * @param {Type} e - Specifies the id
     */
    function deletePState(e) {
        try {
            var studyUid = e.split("_")[1];
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            // Send the presentation state to server
            var contextId = studyDetails.modality == "General" ? studyDetails[0].contextId : studyDetails.contextId;
            var pStateUrl = dicomViewer.url.getPStateUrl(contextId);
            var pState = JSON.stringify({
                id: studyDetails.PStates.Active.id
            });
            $.ajax({
                    type: 'DELETE',
                    url: pStateUrl,
                    async: false,
                    data: pState,
                    cache: false
                })
                .success(function (data) {
                    var description = "Successfully deleted the presentation state for the context id: " + decodeURIComponent(studyDetails.contextId);
                    sendViewerStatusMessage("200", description);

                    // Refresh PStates
                    loadPState(studyUid, undefined, false);
                })
                .fail(function (data) {
                    var description = "Failed to delete the presentation state for the context id: " + decodeURIComponent(studyDetails.contextId);
                    sendViewerStatusMessage("500", description);
                })
                .error(function (xhr, status) {
                    var description = xhr.statusText + "\nFailed to delete the presentation state to server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                });
        } catch (e) {}
    }

    /**
     * Remove the unsaved PState
     * @param {Type} studyDetails - Specifies the study details
     */
    function removeUnSavedPState(studyDetails) {
        try {
            var unsavedPStateIndex = studyDetails.PStates.All.map(function (item) {
                return item.id;
            }).indexOf(studyDetails.PStates.Active.id);

            if (unsavedPStateIndex !== -1) {
                studyDetails.PStates.All.splice(unsavedPStateIndex, 1);
            }
        } catch (e) {}
    }

    /**
     * Reset the PStates
     * @param {Type} studyDetails - Specify the study details
     */
    function resetPState(studyDetails) {
        try {
            if (studyDetails.PStates === undefined || studyDetails.PStates === null) {
                return;
            }

            var studyUid = studyDetails.studyUid;
            studyDetails.PStates = undefined;

            dicomViewer.updatePState(studyUid);
            deleteAllPStates(studyUid);
            refreshPState(studyUid);
        } catch (e) {}
    }

    /**
     * Refresh the PStates
     * @param {Type} studyUid - Specify the study Uid
     */
    function refreshPState(studyUid) {
        try {
            var allViewports = dicomViewer.viewports.getAllViewports();
            if (allViewports === null || allViewports === undefined) {
                return;
            }

            // Refresh renderer
            $.each(allViewports, function (keyId, value) {
                if (value.studyUid === studyUid) {
                    $("#" + value.seriesLayoutId + " div").each(function () {
                        var imageLevelId = $(this).attr('id');
                        var imageRender = value.getImageRender(imageLevelId);
                        if (imageRender) {
                            imageRender.drawDicomImage(false);
                        }
                    });
                }
            });
        } catch (e) {}
    }

    /**
     * Save or delete the unsaved PState
     * @param {Type} studyDetails - Specifies the PState
     * @param {Type} isSave - Specify the flag to save or edit the PState
     */
    function saveOrDeleteUnSavedPState(studyDetails, isSave) {
        try {
            if (isSave == true) {
                savePState({
                    studyUid: studyDetails.studyUid,
                    isNew: true
                });
            } else {
                removeUnSavedPState(studyDetails);
                loadPState(studyDetails.studyUid, undefined, false);
            }
        } catch (e) {}
    }

    /**
     * Edit presentaion state 
     * @param {Type} e - Specifies the id
     */
    function editPState(e) {
        try {
            var studyDetails = dicomViewer.getStudyDetails(e.split("_")[1]);
            if (studyDetails === undefined || studyDetails === undefined) {
                // Invalid study details
                return;
            }

            if (studyDetails.PStates === undefined || studyDetails.PStates === null) {
                return null;
            }

            var activePState = studyDetails.PStates.Active;
            document.getElementById("presentationName").value = activePState.name;
            document.getElementById("editPStateDescription").value = (activePState.description == undefined) ? "" : activePState.description;
            $("#edit-PState").dialog("open");
        } catch (e) {}
    }

    /**
     * Show the confirmation message box
     */
    function showConfirmMessage(message) {
        return window.confirm(message);
    }

    /**
     * 
     * To get session type  
     */
    function getSessionType() {
        return selectedSessionType;
    }

    /**
     * To set session type
     * @param {int} sessionType, 0 - Session; 1 - Stored; 2 - All
     */
    function setSessionType(sessionType) {
        selectedSessionType = sessionType;
    }

    /**
     * To show measurements based on selected session type
     * @param {int} sessionType
     */
    function isMeasurementDrawable(sessionType) {
        if (selectedSessionType === 2) {
            return true;
        }
        return selectedSessionType === sessionType;
    }

    /**
     * Update dirty presentation state 
     * @param {Type} seriesLevelDivId - Specifies the viewport id
     * @param {Type} measurementData - Specifies the measurement data
     * @param {Type} isDelete - Specifies the flag to delete PState 
     * @param {Type} isUpdate - Specifies the flag to update PState 
     */
    function updateDirtyPState(seriesLevelDivId, measurementData, isDelete, isUpdate) {
        try {
            // Check whether the presentation state is enabled or not
            if (isPStateEnabled() !== true) {
                return;
            }

            var studyDiv = getStudyLayoutId(seriesLevelDivId);
            if (studyDiv === null || studyDiv === undefined) {
                return;
            }

            var viewport = dicomViewer.viewports.getViewport(seriesLevelDivId);
            if (viewport === null || viewport === undefined) {
                return;
            }

            var studyUid = viewport.studyUid;
            if (studyUid === null || studyUid === undefined) {
                return;
            }

            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails === undefined || studyDetails === undefined) {
                return;
            }

            // Create new presentation if an existing PState is invalid
            if (studyDetails.PStates == undefined ||
                studyDetails.PStates == null ||
                studyDetails.PStates.Active.isEmpty == true || studyDetails.PStates.Active.isNew == undefined) {
                return newPState("newPState_" + studyUid);
            }

            if (studyDetails.PStates.Active.isNew == true ||
                studyDetails.PStates.Active.isEditable == false) {
                updateNewDirtyActivePState(studyDetails);
                return;
            }

            if (studyDetails.PStates.Active.isDescriptionUpdated == true) {
                updateDirtyActivePState(studyDetails, studyDiv, true);
                return;
            }

            var isDirty = false;
            if (measurementData !== undefined && measurementData !== null) {
                var imagePStates = studyDetails.PStates.Active.imagePStates;
                var keyId = measurementData.keyId;
                var arrayIndex = measurementData.arryIndex;
                var measurementType = measurementData.measurmentType;
                var sessionType = measurementData.sessionType;
                var measurement = undefined;

                // Get the session type if we call delete all measurement/annotations
                if (sessionType === undefined && isUpdate !== true) {
                    sessionType = 0;
                    if (imagePStates !== undefined) {
                        var imageUids = keyId.split("_");
                        imagePStates.some(function (o) {
                            if (o.imageId === imageUids[0] && o.frameNumber == imageUids[1]) {
                                sessionType = 1;
                            }

                            return (sessionType == 1 ? true : false);
                        });
                    }
                }

                if (isDelete == true || isUpdate == true) {
                    var imageUids = keyId.split("_");
                    if (imagePStates !== undefined && sessionType == 1) {
                        imagePStates.some(function (o) {
                            if (o.imageId === imageUids[0] && o.frameNumber == imageUids[1]) {
                                o.isDirty = true;
                                isDirty = true;
                            }

                            return isDirty;
                        });
                    } else if (imagePStates !== undefined) {
                        imagePStates.some(function (o) {
                            if (o.isDirty == true) {
                                isDirty = true;
                            }

                            return isDirty;
                        });
                    }
                } else {
                    if (measurementType === "mitralGradient") {
                        measurement = dicomImageMitralGradientMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "Trace") {
                        measurement = dicomImageTraceMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "volume") {
                        measurement = dicomImageVolumeMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "line" || measurementType === "point") {
                        measurement = dicomImageMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "angle") {
                        measurement = dicomImageAngleMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "ellipse") {
                        measurement = dicomImageEllipseMeasurements[keyId][arrayIndex];
                    } else if (measurementType === "rectangle") {
                        measurement = dicomImageRectangleMeasurements[keyId][arrayIndex];
                    }

                    if (Object.prototype.toString.call(measurement) === '[object Array]') {
                        measurement = measurement[0];
                    }

                    isDirty = (measurement.sessionType == 1 ? true : false);
                    if (imagePStates !== undefined && isDirty == true) {
                        var imageUids = keyId.split("_");
                        imagePStates.some(function (o) {
                            if (o.imageId === imageUids[0] && o.frameNumber == imageUids[1]) {
                                o.isDirty = true;
                                return true;
                            }
                        });
                    }
                }

                if (!isDirty) {
                    isDirty = isNewPStateAddedInAnExistingPState(studyUid);
                }
            } else {
                isDirty = isNewPStateAddedInAnExistingPState(studyUid);
            }

            updateDirtyActivePState(studyDetails, studyDiv, isDirty);
        } catch (e) {}
    }

    /**
     * Check whether the measurement is dirty or not
     * @param {Type} values - Specifies the measurement values
     * @param {Type} studyUid - Specifies the study Uid
     */
    function isDirtyPState(values, studyUid) {
        try {
            var isDirty = false;
            values.some(function (o) {
                if (o.studyUid === studyUid && o.sessionType == 0) {
                    isDirty = true;
                }

                return isDirty;
            });
        } catch (e) {}

        return isDirty;
    }

    /**
     * update the dirty active presentation state
     * @param {Type} studyDetails - Specifies the study details
     * @param {Type} studyDiv - Specifies the study layout id
     * @param {Type} isDirty - Specifies the flag for dirty
     */
    function updateDirtyActivePState(studyDetails, studyLayoutId, isDirty) {
        try {
            var activePStateName = studyDetails.PStates.Active.name;

            var selectedPStateId = 0;
            var menuId = "#loadPSSubmenu_" + studyLayoutId + "_";
            studyDetails.PStates.All.some(function (pState) {
                if (pState.id === studyDetails.PStates.Active.id) {
                    selectedPStateId = pState.menuId;
                    return true;
                }
            });

            var innerHtml = ($(menuId + selectedPStateId)[0].innerHTML).replace("*", "");
            var updatedText = isDirty ? activePStateName + "<font color='red' size=4>*</font>" : "<font color='white'>" + activePStateName + "</font>";
            innerHtml = innerHtml.replace(studyDetails.PStates.Active.name, updatedText);
            $(menuId + selectedPStateId)[0].innerHTML = innerHtml;
            studyDetails.PStates.Active.isDirty = isDirty;
            dicomViewer.enableOrDisablePStatesMenu(studyDetails, studyLayoutId);

            return true;
        } catch (e) {}

        return false;
    }

    /**
     * Check whether the new PState is added in an existing PState
     * @param {Type} studyUid - Specifies the study Uid
     */
    function isNewPStateAddedInAnExistingPState(studyUid) {
        try {
            var isAdded = false;
            var allMeasurementPState = [];
            allMeasurementPState.push(dicomImageMeasurements);
            allMeasurementPState.push(dicomImageEllipseMeasurements);
            allMeasurementPState.push(dicomImageRectangleMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                $.each(values, function (id, measurementArray) {
                    isAdded = isDirtyPState(measurementArray, studyUid);
                    return (isAdded == true ? false : true);
                });
                return (isAdded == true ? false : true);
            });

            if (isAdded) {
                return isAdded;
            }

            allMeasurementPState = [];
            allMeasurementPState.push(dicomImageAngleMeasurements);
            allMeasurementPState.push(dicomImageTraceMeasurements);
            allMeasurementPState.push(dicomImageMitralGradientMeasurements);
            allMeasurementPState.push(dicomImagePenMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                $.each(values, function (id, measurementArray) {
                    measurementArray.some(function (o) {
                        isAdded = isDirtyPState(o, studyUid);
                        return isAdded;
                    });
                    return (isAdded == true ? false : true);
                });
                return (isAdded == true ? false : true);
            });

            if (isAdded) {
                return isAdded;
            }
        } catch (e) {}

        return false;
    }

    /**
     * Updated isEditale flag for newly cloned pState.
     * @param
     */
    function UpdateIsEditable() {
        try {
            var allMeasurementPState = [];
            allMeasurementPState.push(dicomImageMeasurements);
            allMeasurementPState.push(dicomImageEllipseMeasurements);
            allMeasurementPState.push(dicomImageRectangleMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                $.each(values, function (id, measurementArray) {
                    $.each(measurementArray, function (id, measurementData) {
                        measurementData.isEditable = true;
                    });
                });
            });

            allMeasurementPState = [];
            allMeasurementPState.push(dicomImageAngleMeasurements);
            allMeasurementPState.push(dicomImageTraceMeasurements);
            allMeasurementPState.push(dicomImageMitralGradientMeasurements);
            allMeasurementPState.push(dicomImagePenMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                $.each(values, function (id, measurementArray) {
                    measurementArray.some(function (o) {
                        $.each(o, function (id, measurementData) {
                            measurementData.isEditable = true;
                        });
                    });
                });
            });
        } catch (e) {}
    }

    /**
     * Update the active PState description
     * @param {Type} description - Specifies the description
     */
    function updateActivePStateDescription(description) {
        try {
            var viewport = dicomViewer.getActiveSeriesLayout();
            if (viewport == undefined || viewport == null) {
                return;
            }

            var studyUid = viewport.studyUid;
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            if (studyDetails == undefined || studyDetails == null) {
                return;
            }

            if (studyDetails.PStates == undefined || studyDetails.PStates == null) {
                return;
            }

            var isDirty = false;
            var activePState = studyDetails.PStates.Active;
            activePState.description = description;
            studyDetails.PStates.All.some(function (o) {
                if (activePState.description !== o.description && activePState.id == o.id) {
                    isDirty = true;
                    return true;
                }
            });

            studyDetails.PStates.Active.isDescriptionUpdated = isDirty;
            var imageRender = viewport.imageRenders;
            for (var keyId in imageRender) {
                var render = imageRender[keyId];
                var frameIndex = render.anUIDs.split("*")[1];
                updateDirtyPState(render.seriesLevelDivId, {
                        keyId: render.imageUid + "_" + frameIndex
                    },
                    false,
                    true);
            }
        } catch (e) {}
    }

    /**
     * update the new dirty active state
     * @param {Type} studyDetails - Specifies the study details
     */
    function updateNewDirtyActivePState(studyDetails) {
        try {
            if (studyDetails.PStates.Active.isNew !== true) {
                return;
            }

            studyDetails.PStates.Active.isDirty = !isEmptyPState(studyDetails.studyUid);
            if (studyDetails.PStates.All.length == 1 && studyDetails.PStates.Active.isDirty == false) {
                studyDetails.PStates = undefined;
            }

            dicomViewer.updatePState(studyDetails.studyUid);
        } catch (e) {}
    }

    /**
     * Check whether the PStates are empty or not
     * @param {Type} values - Specifies the measurement values
     * @param {Type} studyUid - Specifies the study Uid
     */
    function isEmptyPStates(values, studyUid) {
        try {
            var isEmpty = true;
            values.some(function (o) {
                if (o.studyUid === studyUid) {
                    isEmpty = false;
                }

                return (isEmpty == true ? false : true);
            });
        } catch (e) {}

        return isEmpty;
    }

    /**
     * Check whether the PState is empty or not
     * @param {Type} studyUid - Specifies the study Uid
     */
    function isEmptyPState(studyUid) {
        try {
            var isEmpty = true;
            var allMeasurementPState = [];
            allMeasurementPState.push(dicomImageMeasurements);
            allMeasurementPState.push(dicomImageEllipseMeasurements);
            allMeasurementPState.push(dicomImageRectangleMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                if (jQuery.isEmptyObject(values)) {
                    return true;
                }

                $.each(values, function (id, measurementArray) {
                    if (jQuery.isEmptyObject(measurementArray)) {
                        return true;
                    }

                    isEmpty = isEmptyPStates(measurementArray, studyUid);
                    return isEmpty;
                });

                return isEmpty;
            });

            if (!isEmpty) {
                return isEmpty;
            }

            allMeasurementPState = [];
            allMeasurementPState.push(dicomImageAngleMeasurements);
            allMeasurementPState.push(dicomImageTraceMeasurements);
            allMeasurementPState.push(dicomImageMitralGradientMeasurements);
            allMeasurementPState.push(dicomImagePenMeasurements);

            $.each(allMeasurementPState, function (keyId, values) {
                if (jQuery.isEmptyObject(values)) {
                    return true;
                }

                $.each(values, function (id, measurementArray) {
                    if (jQuery.isEmptyObject(measurementArray)) {
                        return true;
                    }

                    measurementArray.some(function (o) {
                        isEmpty = isEmptyPStates(o, studyUid);
                        return (isEmpty == true ? false : true);
                    });

                    return isEmpty;
                });

                return isEmpty;
            });

            if (!isEmpty) {
                return isEmpty;
            }
        } catch (e) {}

        return true;
    }

    /**
     * Return the position(i.e. left, right or top-left) of the hounsfield measurement text
     * @param {Type} data - Start and End value of the hounsfield shape(Ellipse/Rectangle)
     */
    function hounsfieldTextPosition(data, renderer) {
        startPoint = {
            x: data.start.x,
            y: data.start.y
        };
        var pos = "right";
        var widget = renderer.getRenderWidget();
        if ((startPoint.x >= widget.width / 2) && (startPoint.y >= widget.height / 2)) {
            pos = "top-left";
        } else if (startPoint.y >= widget.height / 2) {
            pos = "top";
        } else if (startPoint.x >= widget.width / 2) {
            pos = "left";
        }
        return pos;
    }

    /**
     * Return the position(i.e. left, right or top-left) of the hounsfield measurement text
     * @param {Type} data - Start and End value of the point, angle shape(Point/Angle)
     */
    function pointTextPosition(data, renderer) {
        var point = data.end;
        if (!data.end.x) {
            point = data.start;
        }

        startPoint = {
            x: point.x,
            y: point.y
        };
        var pos = "right";
        var widget = renderer.getRenderWidget();

        var headerInfo = renderer.headerInfo
        if (headerInfo && headerInfo.imageInfo) {
            var imageHeight = headerInfo.imageInfo.imageHeight;
            var imageWidth = headerInfo.imageInfo.imageWidth;

            var scaleValue = renderer.scaleValue;
            var imageCanvas_H = imageHeight * scaleValue;
            var imageCanvas_W = imageWidth * scaleValue;
            var diff_W = widget.width - imageCanvas_W;
            var diff_H = widget.height - imageCanvas_H;

            var pos = "right";
            if (startPoint.x >= (diff_W / 2 + imageCanvas_W / 2)) {
                pos = "left";
            } else if (startPoint.y >= (diff_H / 2 + imageCanvas_H / 2)) {
                pos = "top";
            }
        }
        return pos;

    }

    /**
     * set the flag if measurement is edited
     */
    function isEditMeasurement() {
        return isMeasurementEdit;
    }

    /**
     * Add the drawn measurements
     * @param {Type} imageUid 
     * @param {Type} frameIndex 
     * @param {Type} imageRenderer 
     * @param {Type} mosueData 
     * @param {Type} context 
     */
    function addPenMeasurements(imageUid, frameIndex, imageRenderer, mosueData, context) {
        removeTempdata();
        if (imageRenderer === undefined) {
            throw "addMitralGradientMeasurements : imageRenderer is null/undefined";
        }

        var penMeasurements = dicomImagePenMeasurements[imageUid + "_" + frameIndex];

        if (penMeasurements === undefined) {
            penMeasurements = [];
        }
        var measurements = penMeasurements[mosueData.measurementIndex];
        if (measurements === undefined) {
            measurements = [];
        }
        var imageData = getImageDataForMouseData(mosueData, imageRenderer, context);
        var measureLength = measurements.length;
        measurements[measureLength] = imageData;
        if (!mitralMeanGradientMeasurementEnd) {
            for (i = 0; i < measureLength; i++) {
                measurements[i].editMode = false;
            }
        }
        penMeasurements[mosueData.measurementIndex] = measurements;
        dicomImagePenMeasurements[imageUid + "_" + frameIndex] = penMeasurements;

        mosueData = undefined; // Release the memory for the data 
        imageData = undefined; // Release the memory for the data

        updateDirtyPState(imageRenderer.seriesLevelDivId);
    }

    /**
     * Get the drawn measuremnts
     * @param {Type} imageUid 
     * @param {Type} frameIndex 
     */
    function getPenMeasurements(imageUid, frameIndex) {
        if (imageUid === undefined) {
            throw "getMitralGradientMeasurements: imageUid is null/undefined";
        }
        if (frameIndex === undefined) {
            throw "getMitralGradientMeasurements : frameIndex is null/undefined";
        }
        return dicomImagePenMeasurements[imageUid + "_" + frameIndex];
    }

    /**
     * Find the mouse postion is near the drawn pen measurement to delete.
     * @param {Type} mouseData 
     * @param {Type} imageRenderer 
     */
    function findPenToDelete(mouseData, imageRenderer) {
        isPenDelete = true;
        activeImageRenderer = undefined;
        removeTempdata();
        var measurementKeyId = imageRenderer.anUIDs.replace("*", "_");

        var penMeasurements = dicomImagePenMeasurements[measurementKeyId];
        if (penMeasurements !== undefined) {
            for (var n = 0; n < penMeasurements.length; n++) {
                var measurements = penMeasurements[n];
                if (measurements !== undefined) {
                    for (var m = 0; m < measurements.length; m++) {
                        var data = measurements[m];
                        if (data !== undefined && data.measureType == "pen") {
                            var originalLineDistance = getLength(data);

                            var tempData = {
                                start: {
                                    x: data.start.x,
                                    y: data.start.y
                                },
                                end: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                measureType: "pen"
                            };
                            var firstDistance = getLength(tempData);

                            var tempData2 = {
                                start: {
                                    x: mouseData.x,
                                    y: mouseData.y
                                },
                                end: {
                                    x: data.end.x,
                                    y: data.end.y
                                },
                                measureType: "pen"
                            };

                            var secondDistance = getLength(tempData2);

                            var totalDistance = parseInt(firstDistance) + parseInt(secondDistance);
                            if (Math.abs(totalDistance - originalLineDistance) < 5) {
                                dataToDelete.measurmentType = "pen";
                                dataToDelete.keyId = measurementKeyId;
                                dataToDelete.arryIndex = n;
                                dataToDelete.isEditable = data.isEditable;
                                dataToDelete.sessionType = data.sessionType;
                                activeImageRenderer = imageRenderer;
                                return;
                            }
                        }
                    }
                }
            }
        }

        if (activeImageRenderer === undefined && isLineDeleteCheck === false) {
            findLineToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isPointDeleteCheck === false) {
            findPointToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isTraceDeleteCheck === false) {
            findTraceToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isVolumeDeleteCheck === false) {
            findVolumeToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isAngleDeleteCheck === false) {
            findAngleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isEllipseDeleteCheck === false) {
            findEllipseToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined && isRectangleDeleteCheck === false) {
            findRectangleToDelete(mouseData, imageRenderer)
        } else if (activeImageRenderer === undefined) {
            dataToDelete = {
                measurmentType: "",
                keyId: "",
                arryIndex: "",
                isEditable: "",
                sessionType: 0
            };
        }
    }

    var PenMeasurementId = -1;
    /**
     * set the no.of measuremts drawn in pen.
     * @param {Type} Id -  it specifies the integer.
     */
    function setPenMeasurementId(Id) {
        PenMeasurementId = Id;
    }

    /**
     * get the count of the drawn measurements
     */
    function getPenMeasurementId() {
        return PenMeasurementId;
    }

    /**
     * Update the pen measurements in to the array
     * @param {Type} mouseData 
     * @param {Type} imageRenderer 
     * @param {Type} context 
     * @param {Type} dataToEdit 
     */
    function updatePenintoArray(mouseData, imageRenderer, context, dataToEdit) {
        var imageData = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(mouseData, imageRenderer, context);
        var i;
        var data = undefined;
        var keyId = dataToEdit.keyId;
        var arrayIndex = dataToEdit.arryIndex;
        var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
        var measurements = dicomImagePenMeasurements[keyId];

        if (measurements === undefined)
            return;

        updateDirtyPState(imageRenderer.seriesLevelDivId, dataToEdit);
        measurements = measurements[arrayIndex];
        data = dicomImagePenMeasurements[keyId][arrayIndex];
        for (var index = indexToEditMitral; index < data.length; index++) {
            var tempData = data[index];
            if (tempData !== undefined) {
                var isNearToStartPoint = findNearHanleByPoint(imageData, tempData.start);
                if (isNearToStartPoint && index == 0) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint && index == data.length - 1 && tempData.measurementSubType == "pen") {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    tempData.end.x = imageData.x;
                    tempData.end.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImageMitralGradientMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                } else if (isNearToStartPoint) {
                    tempData.start.x = imageData.x;
                    tempData.start.y = imageData.y;
                    data[index - 1].end.x = imageData.x;
                    data[index - 1].end.y = imageData.y;
                    dicomImagePenMeasurements[keyId][arrayIndex] = data;
                    indexToEditMitral = index;
                    index = data.length;
                }
            }
            tempData.editMode = true;
        }
    }

    /**
     * Load the Mitral Gradient measurement
     * @param {Type} imageKeyId - Specifies the image key
     * @param {Type} measurementKeyId - Specifies the measurement key* 
     * @param {Type} measurement - Specifies the measurement array
     * @param {Type} isEditable - Specifies the flag to edit the measurement/annotation
     */
    function loadPenMeasurement(imageKeyId, measurementKeyId, measurement, isEditable) {
        try {
            if (imageKeyId === undefined || measurement === undefined) {
                // Invalid input parameters
                return;
            }

            var points = measurement.points;
            if (points === undefined || points === null || points.length == 0) {
                return;
            }

            var measurementSubType = undefined;
            var measurementType = undefined;

            switch (measurementKeyId) {
                case MT_PEN:
                    measurementSubType = "pen";
                    measurementType = 15;
                    break;
            }

            var penMeasurements = dicomImagePenMeasurements[imageKeyId];
            if (penMeasurements === undefined) {
                penMeasurements = [];
            }

            var measurementId = penMeasurements.length;
            var measurements = penMeasurements[measurementId];
            if (measurements === undefined) {
                measurements = [];
            }

            var start = {};
            var end = {};
            for (var index = 0; index < points.length; index += 4) {
                var start = {
                    handleActive: false,
                    x: parseFloat(points[index]),
                    y: parseFloat(points[index + 1])
                };

                var end = {
                    handleActive: false,
                    x: parseFloat(points[index + 2]),
                    y: parseFloat(points[index + 3])
                };

                var measurementData = {
                    start: start,
                    end: end,
                    measureType: "pen",
                    measurementSubType: measurementSubType,
                    measurementId: measurementId,
                    measurementComplete: true,
                    measurementType: measurementType,
                    measurementUnits: undefined,
                    editMode: false,
                    studyUid: measurement.studyUid,
                    isEditable: isEditable,
                    sessionType: 1,
                    style: getGrpahicStyle(measurement, undefined, isEditable)
                };

                measurements.push(measurementData);
            }

            penMeasurements[measurementId] = measurements;
            dicomImagePenMeasurements[imageKeyId] = penMeasurements;
        } catch (e) {}
    }

    /**
     * Gets ImageUid from ImageUrn
     */
    function getImageUidFromUrn(studyDetails, pState) {
        if (pState.imageUrn === undefined || pState.imageUrn === null) {
            return pState.imageId;
        } else if (studyDetails.imageUrns !== null && studyDetails.imageUrns !== undefined) {
            return studyDetails.imageUrns[pState.imageUrn];
        }
    }

    /**
     * Gets ImageUrn from ImageUid
     */
    function getImageUrnFromUId(studyDetails, imageUid) {
        var imageUrn = undefined;
        if (studyDetails.imageUrns !== null && studyDetails.imageUrns !== undefined) {
            $.each(studyDetails.imageUrns, function (keyId, value) {
                if (value === imageUid) {
                    imageUrn = keyId;
                    return false;
                }
            });
            return imageUrn;
        }
    }

    /**
     * Set the default global measurement style key/value pair
     * @param {Type} styleCol - Specifies the style color
     * @param {Type} type - Specifies the type
     * @param {Type} isFailed - Specifies the server status flag
     */
    function setDefaultStyleCol(styleCol, type, isFailed) {
        try {
            $.each(MT_PS_TypeCol, function (keyId, value) {
                value = (type == "SYSTEM") ? ("sys" + value) : value;
                var useDefault = isFailed ? false : true;
                dicomViewer.measurement.draw.setUserMeasurementStyleByType(value, useDefault, styleCol);
            });
        } catch (e) {}
    }

    /**
     * Get corresponding enum value for respective measurement type or subtype
     * @param {Type} measureType 
     * @param {Type} measureSubType 
     */
    function getEnumMT(measureType, measureSubType) {
        if (measureType == "line") {
            if (measureSubType == "2DLength") {
                return "LENGTH";
            } else if (measureSubType == "2DLine") {
                return "LINE";
            } else if (measureSubType == "Arrow") {
                return "ARROW";
            } else if (measureSubType == "mitralRegurgitationLength") {
                return "MRL";
            } else if (measureSubType == "aorticRegurgitationLength") {
                return "ARL";
            } else if (measureSubType == "mitralValveAnteriorLeafletThickness") {
                return "MVALT";
            }
            return "LENGTH";
        }
        if (measureType == "rectangle") {
            if (measureSubType == "hounsfield") {
                return "HOUNSFIELDRECT";
            } else if (measureSubType == "rectangle") {
                return "RECT";
            } else if (measureSubType == "text") {
                return "TEXT";
            }
        }
        if (measureType == "ellipse") {
            if (measureSubType == "hounsfield") {
                return "HOUNSFIELDELLIPSE";
            } else if (measureSubType == "ellipse") {
                return "ELLIPSE";
            }
        }
        if (measureType == "point") {
            if (measureSubType == "mitralRegurgitationPeakVelocity") {
                return "MRPV";
            } else if (measureSubType == "aorticRegurgitationPeakVelocity") {
                return "ARPV";
            } else if (measureSubType == "aorticStenosisPeakVelocity") {
                return "ASPV";
            }
            return "POINT";
        }
        if (measureType == "angle") {
            return "ANGLE";
        }
        if (measureType == "trace") {
            return "TRACE";
        }
        if (measureType == "mitralGradient") {
            if (measureSubType == "mitral") {
                return "MRL";
            } else if (measureSubType == "freehand") {
                return "FREEHAND";
            }
        }
        if (measureType == "pen") {
            return "PEN";
        }
    }

    dicomViewer.measurement = {
        getMeasurements: getMeasurements,
        addMeasurements: addMeasurements,
        updateMeasurements: updateMeasurements,
        getTraceMeasurements: getTraceMeasurements,
        addTraceMeasurements: addTraceMeasurements,
        updateTraceMeasurements: updateTraceMeasurements,
        getEllipseMeasurements: getEllipseMeasurements,
        addEllipseMeasurements: addEllipseMeasurements,
        updateEllipseMeasurements: updateEllipseMeasurements,
        updateTraceIntoArray: updateTraceIntoArray,
        updateAngleIntoArray: updateAngleIntoArray,
        getVolumeMeasurements: getVolumeMeasurements,
        addVolumeMeasurements: addVolumeMeasurements,
        addMitralGradientMeasurements: addMitralGradientMeasurements,
        getMitralGradientMeasurements: getMitralGradientMeasurements,
        removeAllMeasurements: removeAllMeasurements,
        setTempData: setTempData,
        getTempData: getTempData,
        findNearHandle: findNearHandle,
        getMouseDataForImageData: getMouseDataForImageData,
        getImageDataForMouseData: getImageDataForMouseData,
        getCanvasDataForImageData: getCanvasDataForImageData,
        setImageContext: setImageContext,
        getImageContext: getImageContext,
        setLineMeasurementEnd: setLineMeasurementEnd,
        setTraceMeasurementEnd: setTraceMeasurementEnd,
        setVolumeMeasurementEnd: setVolumeMeasurementEnd,
        setMitralMeanGradientMeasurementEnd: setMitralMeanGradientMeasurementEnd,
        isLineMeasurementEnd: isLineMeasurementEnd,
        isTraceMeasurementEnd: isTraceMeasurementEnd,
        isVolumeMeasurementEnd: isVolumeMeasurementEnd,
        isMitralMeanGradientMeasurementEnd: isMitralMeanGradientMeasurementEnd,
        setTraceMeasurementId: setTraceMeasurementId,
        setMitralMeanGradientMeasurementId: setMitralMeanGradientMeasurementId,
        getTraceMeasurementId: getTraceMeasurementId,
        setVolumeMeasurementId: setVolumeMeasurementId,
        getVolumeMeasurementId: getVolumeMeasurementId,
        getMitralMeanGradientMeasurementId: getMitralMeanGradientMeasurementId,
        updateMitralMeanGradientintoArray: updateMitralMeanGradientintoArray,
        findLineToDelete: findLineToDelete,
        findPointToDelete: findPointToDelete,
        findAngleToDelete: findAngleToDelete,
        findTraceToDelete: findTraceToDelete,
        findMitralToDelete: findMitralToDelete,
        deleteSelectedMeasurment: deleteSelectedMeasurment,
        findVolumeToDelete: findVolumeToDelete,
        resetMeasurementFlag: resetMeasurementFlag,
        setDataToEdit: setDataToEdit,
        getDataToEdit: getDataToEdit,
        getDataToDelete: getDataToDelete,
        findNearHandleToEdit: findNearHandleToEdit,
        resetHandeler: resetHandeler,
        removeTempdata: removeTempdata,
        updateVolumeintoArray: updateVolumeintoArray,
        setDataToDelete: setDataToDelete,
        isMeasurementBroken: isMeasurementBroken,
        setMeasurementBroken: setMeasurementBroken,
        getAngleMeasurements: getAngleMeasurements,
        setAngleMeasurementEnd: setAngleMeasurementEnd,
        isAngleMeasurementEnd: isAngleMeasurementEnd,
        setAngleMeasurementId: setAngleMeasurementId,
        getAngleMeasurementId: getAngleMeasurementId,
        addAngleMeasurements: addAngleMeasurements,
        resetMousePressedCounter: resetMousePressedCounter,
        getMousePressedCounter: getMousePressedCounter,
        increaseMousePressedCounter: increaseMousePressedCounter,
        setCoordinate: setCoordinate,
        getCoordinate: getCoordinate,
        findEllipseToDelete: findEllipseToDelete,
        getDefaultLineMeasurementUnit: getDefaultLineMeasurementUnit,
        isCalibratePixelSpacing: isCalibratePixelSpacing,
        resetEllipseEditMode: resetEllipseEditMode,
        resetAngleEditMode: resetAngleEditMode,
        resetTraceEditMode: resetTraceEditMode,
        resetMitralEditMode: resetMitralEditMode,
        getRectangleMeasurements: getRectangleMeasurements,
        addRectangleMeasurements: addRectangleMeasurements,
        updateRectangleMeasurements: updateRectangleMeasurements,
        resetRectangleEditMode: resetRectangleEditMode,
        findRectangleToDelete: findRectangleToDelete,
        savePState: savePState,
        loadPState: loadPState,
        editPState: editPState,
        updateMeasurementTextData: updateMeasurementTextData,
        newPState: newPState,
        deletePState: deletePState,
        saveOrDeleteUnSavedPState: saveOrDeleteUnSavedPState,
        getSessionType: getSessionType,
        setSessionType: setSessionType,
        isMeasurementDrawable: isMeasurementDrawable,
        updateActivePStateDescription: updateActivePStateDescription,
        hounsfieldTextPosition: hounsfieldTextPosition,
        isEditMeasurement: isEditMeasurement,
        showAndHideSplashWindow: showAndHideSplashWindow,
        pointTextPosition: pointTextPosition,
        setPenToolEnd: setPenToolEnd,
        isPenToolEnd: isPenToolEnd,
        addPenMeasurements: addPenMeasurements,
        getPenMeasurements: getPenMeasurements,
        findPenToDelete: findPenToDelete,
        updatePenintoArray: updatePenintoArray,
        getPenMeasurementId: getPenMeasurementId,
        setPenMeasurementId: setPenMeasurementId,
        udpateMeasurementProperty: udpateMeasurementProperty,
        setDefaultStyleCol: setDefaultStyleCol,
        getEnumMT: getEnumMT,
        getImageUrnFromUId: getImageUrnFromUId
    }

    return dicomViewer;
}(dicomViewer));
