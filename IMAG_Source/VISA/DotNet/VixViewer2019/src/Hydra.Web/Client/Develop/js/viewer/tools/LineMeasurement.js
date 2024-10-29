LineMeasurement.prototype = new MouseTool();
LineMeasurement.prototype.constructor = LineMeasurement;
var isLineExceededOutside = false;

function LineMeasurement() {
    this.ToolType = "lineMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measurementSubType: "2DLength",
        measureType: "line",
        measurementId: null,
        measurementType: null,
        measurementComplete: false,
        measurementUnits: null,
        isLineExceededOutside: false,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

LineMeasurement.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }
    if (dicomViewer.measurement.isMeasurementBroken()) {
        dicomViewer.measurement.setMeasurementBroken(false);
    }
    evt.preventDefault();
    var editData = dicomViewer.measurement.getDataToEdit();
    dicomViewer.measurement.setLineMeasurementEnd(false);
    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }
    this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
    this.measurementData.isEditable = true;
    this.measurementData.sessionType = 0;
    var widget = imageRenderer.getRenderWidget();
    if (evt.type === "mousedown" || evt.type === "touchstart") {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (pt.isPtInRegion || editData !== undefined) {
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var subType = this.measurementSubType;
                var measurementType = dicomViewer.measurement.draw.getMeasurementType();
                if (this.measurementSubType == undefined && measurementType.measurementId) {
                    subType = measurementType.measurementId;
                }
                var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, subType);
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
            }
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
    if (this.measurementData.style.measurementUnits !== undefined) {
        this.measurementData.measurementUnits = this.measurementData.style.measurementUnits;
    } else {
        this.measurementData.measurementUnits = measurementType.measurementUnits;
    }
    this.measurementData.measurementComplete = false;
    this.measurementData.textPosition = dicomViewer.measurement.hounsfieldTextPosition(this.measurementData, imageRenderer);
};

LineMeasurement.prototype.hanleMouseMove = function (evt) {
    var toolName = dicomViewer.mouseTools.getToolName();
    var value = dicomViewer.measurement.getDataToEdit();
    var imageRenderer = this.activeImageRenderer;

    if (toolName == 'lineMeasurement') {
        var cursorObj = document.getElementById('viewport_View');
        if (cursorObj != undefined && cursorObj != null) {
            var cursorName = cursorObj.style.cursor;
        }
        if (cursorName.indexOf("images/measurelength.cur") > 0) {
            dicomViewer.measurement.isCalibratePixelSpacing(imageRenderer);
        } else if (dicomViewer.tools.getLengthCalibrationFlag() && cursorName.indexOf("images/calibrate.cur") > 0 && !dicomViewer.tools.isCaliberEnabled(imageRenderer)) {
            var type = {
                id: "0_measurement"
            };
            dicomViewer.tools.do2DMeasurement(type);
        }
    }

    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }
    if (!this.isMousePressed && !this.isLineExceededOutside) {
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
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.handleActive = true;
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
        }

        if (value === undefined) {
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setTempData(this.measurementData);

        } else {
            if (value.measurmentType === "point") {
                dicomViewer.tools.do2DMeasurement(1, null, null)
            } else {
                this.measurementData.end.handleActive = true;
                dicomViewer.measurement.setLineMeasurementEnd(false);
                this.measurementData.measurementType = value.measurmentType;
                this.measurementData.measureType = value.measurmentType;
                this.measurementData.textPosition = dicomViewer.measurement.hounsfieldTextPosition(this.measurementData, imageRenderer);

                dicomViewer.measurement.setTempData(this.measurementData);
                this.measurementData = {
                    start: {
                        handleActive: false
                    },
                    end: {
                        handleActive: false
                    },
                    measureType: value.measurmentType
                };
            }
        }
        imageRenderer.drawDicomImage(false, undefined, true);
    }

};

LineMeasurement.prototype.hanleMouseUp = function (evt) {
    var flagFor2dLengthCalibration = dicomViewer.tools.getFlagFor2dLengthCalibration();
    var isTouchContextMenu = false;
    if (evt.event !== undefined && evt.event.eventPhase === 3) {
        isTouchContextMenu = true;
        if (this.isMousePressed = true) {
            this.isMousePressed = false;
        }
    }
    if (evt.which === 3 || isTouchContextMenu) {
        if (isTouchContextMenu) {
            var pt = this.hitTestAndGetMousePosition(evt.event.originalEvent);
            var measurementDelData = {
                x: pt.x,
                y: pt.y,
                measureType: "linedelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "linedelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        var imageRender = this.activeImageRenderer;
        //var auids = imageRender.anUIDs.split("*");
        var dContext = this.activeImageRenderer.getRenderWidget().getContext("2d");
        //dicomViewer.measurement.draw.drawMeasurements(auids[0], auids[1],dContext,imageRender.getPresentation(),imageRender);
        this.activeImageRenderer.drawDicomImage(true);
    }

    if (this.isMousePressed || this.isLineExceededOutside) {
        this.isMousePressed = false;
        this.isLineExceededOutside = false;
        var imageRenderer = this.activeImageRenderer;
        if (imageRenderer === undefined) {
            return;
        }
        var widget = imageRenderer.getRenderWidget();
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
        if (evt.type === "mouseup" || evt.type === "touchend" || evt.type === "mouseout") {
            var pt = this.hitTestAndGetMousePosition(evt);
            if (pt !== undefined) {
                this.measurementData.end.x = pt.x;
                this.measurementData.end.y = pt.y;
            } else {
                // touchend will return undefined. Maintain the last touchmove point as the end point
            }

            this.measurementData.end.handleActive = false;
            if (!flagFor2dLengthCalibration) {
                this.measurementData.measurementComplete = true;
            }
        }
        dicomViewer.measurement.setMeasurementBroken(false);
        dicomViewer.measurement.setLineMeasurementEnd(true);
        this.measurementData.textPosition = dicomViewer.measurement.hounsfieldTextPosition(this.measurementData, imageRenderer);
        dicomViewer.measurement.setTempData(this.measurementData);
        if (flagFor2dLengthCalibration) {
            if ((evt.type === "mouseup" || evt.type === "touchend") && !(this.measurementData.start.x == this.measurementData.end.x &&
                    this.measurementData.start.y == this.measurementData.end.y)) {

                if (this.measurementData.measurementSubType == "2DLength") {
                    this.measurementData.measurementComplete = true;
                }
                dicomViewer.tools.lengthCalibration();
            }
        }
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "line",
            measurementSubType: this.measurementData.measurementSubType
        };
        imageRenderer.drawDicomImage(false);
        if (flagFor2dLengthCalibration) {
            var pt = this.hitTestAndGetMousePosition(evt);
            var measurementDelData = {
                x: pt.x,
                y: pt.y,
                measureType: "linedelete"
            };
            dicomViewer.measurement.setTempData(measurementDelData);
            var imageRender = this.activeImageRenderer;
            var dContext = this.activeImageRenderer.getRenderWidget().getContext("2d");
            this.activeImageRenderer.drawDicomImage(true);
            dicomViewer.measurement.setTempData(undefined);
        }
        dicomViewer.measurement.resetHandeler();
    }

};

LineMeasurement.prototype.hanleDoubleClick = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
        var menuMesure = getMeasurements();
        var imageRenderer = this.activeImageRenderer;
        var widget = imageRenderer.getRenderWidget();
        if (evt === undefined || evt.which === 1 || evt.type === "mouseout") {
            var key = dataToEdit.keyId;
            var arrayIndex = dataToEdit.arryIndex;
            var keyArray = key.split("_");
            var parentDiv = $('#' + imageRenderer.parentElement).parent().closest('div').attr('id');
            if (isFullScreenEnabled) {
                parentDiv = previousLayoutSelection;
            }
            var measurement = dicomViewer.measurement.getMeasurements(keyArray[0], keyArray[1]);
            if (measurement === undefined)
                return;
            measurement = measurement[arrayIndex];
            measurementResult = dicomViewer.measurement.draw.drawLineMeasurement(keyArray[0], widget, measurement, imageRenderer.getPresentation(), imageRenderer, "edit");
            if (measurementResult != null) {
                sendMeasurement(measurementResult.id, measurementResult.value);
            }

            measurement.start.handleActive = false;
            measurement.end.handleActive = false;
            dicomViewer.measurement.setDataToEdit(undefined);
        }

        this.isMousePressed = false;
        if (imageRenderer === undefined) {
            return;
        }
        imageRenderer.drawDicomImage(false);
    }
};

LineMeasurement.prototype.hanleMouseOut = function (evt) {
    if (dicomViewer.measurement.getDataToEdit() !== undefined) {
        this.hanleDoubleClick(evt);
    } else {
        this.hanleMouseUp(evt);
    }
};

/**
 * set the measurement/Annotation type
 * @param {Type} type - It specifies the measurement type(arrow,2Dline,etc..)
 */
LineMeasurement.prototype.setMeasurementSubType = function (type) {
    this.measurementSubType = type;
};
