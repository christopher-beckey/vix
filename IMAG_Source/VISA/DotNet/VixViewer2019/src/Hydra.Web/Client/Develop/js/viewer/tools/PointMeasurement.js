PointMeasurement.prototype = new MouseTool();
PointMeasurement.prototype.constructor = PointMeasurement;

function PointMeasurement() {
    this.ToolType = "pointMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "point",
        measurementId: null,
        measurementType: null,
        measurementUnits: null,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

PointMeasurement.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }
    dicomViewer.measurement.setLineMeasurementEnd(false);
    var editData = dicomViewer.measurement.getDataToEdit();
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
                var subType = this.measurementData.measurementSubType;
                var measurementType = dicomViewer.measurement.draw.getMeasurementType();
                if (measurementType.measurementId) {
                    subType = measurementType.measurementId;
                }
                var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, subType);
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else {
            this.isMousePressed = false;
        }
    }

    var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;
    this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
};

PointMeasurement.prototype.hanleMouseMove = function (evt) {
    this.measurementData.start.handleActive = true;
    var imageRenderer = this.activeImageRenderer;
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }
    if (!this.isMousePressed) {
        return;
    }
    var widget = imageRenderer.getRenderWidget();
    if (this.measurementData.start.x === undefined || this.measurementData.start.y === undefined) {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        }

        dicomViewer.measurement.setTempData(this.measurementData);
        this.isMousePressed = true;
    } else {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = true;
        }

        if (dataToEdit === undefined) {
            dicomViewer.measurement.setLineMeasurementEnd(false);
            this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
            dicomViewer.measurement.setTempData(this.measurementData);
        } else {
            /* if (dataToEdit.measurmentType === "point") {
                 dicomViewer.tools.do2DMeasurement(1, null, null)
             } else */
            {
                this.measurementData.measurementType = 1;
                dicomViewer.measurement.setLineMeasurementEnd(false);
                this.measurementData.start.handleActive = true;
                this.measurementData.measureType = dataToEdit.measurmentType;
                this.measurementData.measurementType = 1; //dataToEdit.measurmentType;
                dicomViewer.measurement.setTempData(this.measurementData);
            }
        }
        this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
        imageRenderer.drawDicomImage(false);
    }
};

PointMeasurement.prototype.hanleMouseUp = function (evt) {
    dicomViewer.measurement.resetHandeler();
    var isTouchContextMenu = false;
    if (evt.event !== undefined && evt.event.eventPhase === 3) {
        isTouchContextMenu = true;
        if (this.isMousePressed = true) {
            this.isMousePressed = false;
        }
    }
    if (evt.type === "mouseup" && evt.which === 3 || isTouchContextMenu) {
        if (isTouchContextMenu) {
            var pt = this.hitTestAndGetMousePosition(evt.event.originalEvent);
            var measurementDelData = {
                x: pt.x,
                y: pt.y,
                measureType: "pointdelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "pointdelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        this.activeImageRenderer.drawDicomImage(false);
    }
    if (this.isMousePressed) {
        this.isMousePressed = false;
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
        if (evt.type === "mouseup" || evt.type === "mouseout" || evt.type === "touchend") {
            var pt = this.hitTestAndGetMousePosition(evt);
            if (pt !== undefined) {
                this.measurementData.end.x = pt.x;
                this.measurementData.end.y = pt.y;
            } else {
                // touchend will return undefined. Maintain the last touchmove point as the end point
                if (this.measurementData.end.x === undefined || this.measurementData.end.y === undefined) {
                    this.measurementData.end.x = this.measurementData.start.x;
                    this.measurementData.end.y = this.measurementData.start.y;
                }
            }

            this.measurementData.end.handleActive = false;
        }

        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit == undefined) {
            dicomViewer.measurement.setLineMeasurementEnd(true);
            this.measurementData.start.handleActive = false;
            dicomViewer.measurement.setTempData(this.measurementData);
            this.measurementData = {
                start: {
                    handleActive: false
                },
                end: {
                    handleActive: false
                },
                measureType: "point"
            };
        } else {
            this.measurementData.measureType = dataToEdit.measurmentType;
            this.measurementData.start.handleActive = true;
            dicomViewer.measurement.setTempData(this.measurementData);
            this.measurementData = {
                start: {
                    handleActive: false
                },
                end: {
                    handleActive: false
                },
                measureType: dataToEdit.measurmentType
            };

        }
        if (dataToEdit == undefined) {
            this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
            imageRenderer.drawDicomImage(false, undefined, true);
        }
    }
};

PointMeasurement.prototype.hanleDoubleClick = function (evt) {

    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
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

            measurement.start.handleActive = false;
            measurement.end.handleActive = false;
            dicomViewer.measurement.setDataToEdit(undefined);
            this.measurementData = {
                start: {
                    handleActive: false
                },
                end: {
                    handleActive: false
                },
                measureType: "point"
            };
            measurementResult = dicomViewer.measurement.draw.drawPointMeasurement(keyArray[0], widget, measurement, imageRenderer.getPresentation(), imageRenderer, "edit");
            if (measurementResult != null) {
                sendMeasurement(measurementResult.id, measurementResult.value);
            }
            dicomViewer.measurement.removeTempdata();
            this.activeImageRenderer.drawDicomImage(false, undefined, true);

        }
    }
};

PointMeasurement.prototype.hanleMouseOut = function (evt) {
    this.hanleDoubleClick(evt);
};
