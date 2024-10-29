MitralMeanGradientMeasurement.prototype = new MouseTool();
MitralMeanGradientMeasurement.prototype.constructor = MitralMeanGradientMeasurement;
var leftClickEndPoints = undefined;

function MitralMeanGradientMeasurement() {
    this.ToolType = "mitralMeanGradientMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "mitralGradient",
        measurementId: null,
        measurementType: null,
        measurementUnits: null,
        measurementComplete: false,
        displayMeasurement: false,
        measurementIndex: null,
        measurementSubType: "mitral",
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

MitralMeanGradientMeasurement.prototype.hanleMouseDown = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (isMobileDevice && dataToEdit !== undefined) {
        this.isMousePressed = true;
    }
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }
    if (evt.which == "3") {
        return;
    }

    if (!dicomViewer.measurement.isMitralMeanGradientMeasurementEnd()) {
        dicomViewer.measurement.setMitralMeanGradientMeasurementEnd(true);
        dicomViewer.measurement.setMitralMeanGradientMeasurementId(dicomViewer.measurement.getMitralMeanGradientMeasurementId() + 1);
        this.measurementData.measurementIndex = dicomViewer.measurement.getMitralMeanGradientMeasurementId();
    }
    if (this.isMousePressed) {
        this.isMousePressed = false;
        var imageRenderer = this.activeImageRenderer;
        if (imageRenderer === undefined) {
            return;
        }
        this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
        this.measurementData.isEditable = true;
        this.measurementData.sessionType = 0;
        var widget = imageRenderer.getRenderWidget();
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
        if (evt.type === "mouseup" || evt.type === "touchstart") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = false;
        }
        leftClickEndPoints = this.measurementData.end;
        this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
        dicomViewer.measurement.setLineMeasurementEnd(true);
        dicomViewer.measurement.setTempData(this.measurementData);
        //dicomViewer.measurement.addMeasurements(imageUid,frameIndex,imageRenderer,this.measurementData);
        var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, this.measurementSubType);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "mitralGradient",
            measurementIndex: dicomViewer.measurement.getMitralMeanGradientMeasurementId(),
            displayMeasurement: false,
            style: dicomViewer.measurement.draw.getMeasurementStyle(type)
        };
        imageRenderer.drawDicomImage(false);
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit != undefined) {
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.resetHandeler();
            return;
        }
    }
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    dicomViewer.measurement.setLineMeasurementEnd(false);
    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }

    var widget = imageRenderer.getRenderWidget();
    if (evt.type === "mousedown" || evt.type === "mouseout" || evt.type === "touchstart") {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (pt.isPtInRegion || evt.type === "mouseout" || dataToEdit !== undefined) {
            var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, this.measurementSubType);
            this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
            this.measurementData.measurementSubType = this.measurementSubType;
        } else {
            this.isMousePressed = false;
        }
    }
    var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;
    //for mobile devices not getting the touchend that's why drawing the point on every touchstart
    if (evt.type == "touchstart") {
        dicomViewer.measurement.setTempData(this.measurementData);
        imageRenderer.drawDicomImage(false);
    }
};

MitralMeanGradientMeasurement.prototype.hanleMouseMove = function (evt, isDoubleClick) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (isMobileDevice && dataToEdit !== undefined) {
        this.isMousePressed = true;
    }
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }
    if (!this.isMousePressed) {
        return;
    }

    if (evt.which == "3") {
        return;
    }
    var widget = imageRenderer.getRenderWidget();
    if (this.measurementData.start.x === undefined || this.measurementData.start.y === undefined) {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        }
        this.isMousePressed = true;
    } else {
        if (evt.type === "mousemove" || evt.type === "touchmove" || isDoubleClick) {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = true;
        }
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit != undefined) {
            if (dataToEdit.measurmentType === "line") {
                dicomViewer.tools.do2DMeasurement(0, null, null)
            } else if (dataToEdit.measurmentType === "point") {
                dicomViewer.tools.do2DMeasurement(1, null, null)
            } else {
                var pt = this.hitTestAndGetMousePosition(evt);
                this.measurementData.start.x = pt.x;
                this.measurementData.start.y = pt.y;
                dicomViewer.measurement.setLineMeasurementEnd(false);
                dicomViewer.measurement.setTempData(this.measurementData);
            }
        } else {
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setTempData(this.measurementData);
        }
        imageRenderer.drawDicomImage(false, undefined, true);
    }
    //evt.target.style.cursor = "crosshair";
};

MitralMeanGradientMeasurement.prototype.hanleMouseUp = function (evt) {
    if (evt.which == "3" && dicomViewer.measurement.isMitralMeanGradientMeasurementEnd()) {
        var imageRenderer = this.activeImageRenderer;
        if (imageRenderer === undefined) {
            return;
        }
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
        var mitralMeasurements = dicomViewer.measurement.getMitralGradientMeasurements(imageUid, frameIndex);
        if (mitralMeasurements != undefined && leftClickEndPoints != undefined) {
            dicomViewer.measurement.setLineMeasurementEnd(true);
            if (this.measurementData != undefined) {
                this.measurementData.start.x = leftClickEndPoints.x;
                this.measurementData.start.y = leftClickEndPoints.y;
                this.measurementData.end.x = leftClickEndPoints.x;
                this.measurementData.end.y = leftClickEndPoints.y;
            }
            leftClickEndPoints = undefined;
            dicomViewer.measurement.setTempData(this.measurementData);
            this.measurementData = {
                start: {
                    handleActive: false
                },
                end: {
                    handleActive: false
                },
                measureType: "mitralGradient",
                measurementIndex: dicomViewer.measurement.getMitralMeanGradientMeasurementId(),
                displayMeasurement: false
            };
            imageRenderer.drawDicomImage(false);
            dicomViewer.measurement.setLineMeasurementEnd(false);
            this.hanleDoubleClick(evt);
            dicomViewer.measurement.setDataToDelete();
        }
        return;
    }

    var isTouchContextMenu = false;
    if (evt.event !== undefined && evt.event.eventPhase === 3) {
        isTouchContextMenu = true;
    }
    if (evt.which === 3 || isTouchContextMenu) {
        this.hanleDoubleClick();
        if (isTouchContextMenu) {
            var pt = this.hitTestAndGetMousePosition(evt.event.originalEvent);
            var measurementDelData = {
                x: pt.x,
                y: pt.y,
                measureType: "mitralGradientdelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "mitralGradientdelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        this.activeImageRenderer.drawDicomImage(false);
    }
};

MitralMeanGradientMeasurement.prototype.hanleMouseOut = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (this.isMousePressed || dataToEdit != undefined) {
        this.hanleMouseDown(evt);
        this.hanleMouseMove(evt, true);
        this.hanleMouseDown(evt);
        this.hanleDoubleClick(evt);
    }
};

MitralMeanGradientMeasurement.prototype.hanleDoubleClick = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    this.isMousePressed = false;
    if (imageRenderer === undefined) {
        return;
    }

    if (evt === undefined || evt.type === "dblclick" || evt.type === "mouseout" || evt.which == "3" || evt.type === "mousewheel") {
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
        var mitralMeasurements = dicomViewer.measurement.getMitralGradientMeasurements(imageUid, frameIndex);
        if (mitralMeasurements != undefined) {
            dicomViewer.measurement.resetMitralEditMode(imageUid, frameIndex, dataToEdit);
        }
        this.measurementData.displayMeasurement = true;
        dicomViewer.measurement.setMitralMeanGradientMeasurementEnd(false);
        if (dataToEdit != undefined) {
            dicomViewer.measurement.setTempData(undefined);
            dicomViewer.measurement.setDataToEdit(undefined);
        }
        imageRenderer.drawDicomImage(false);
        dicomViewer.measurement.resetHandeler();
    }
};

/**
 * set the sub type
 * @param {Type} type - It specifies the measurement type(arrow,2Dline,etc..)
 */
MitralMeanGradientMeasurement.prototype.setMeasurementSubType = function (type) {
    this.measurementSubType = type;
};
