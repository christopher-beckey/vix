AngleMeasurementTool.prototype = new MouseTool();
AngleMeasurementTool.prototype.constructor = AngleMeasurementTool;

function AngleMeasurementTool() {
    this.ToolType = "angleMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "angle",
        measurementId: null,
        measurementType: null,
        measurementUnits: null,
        measurementComplete: false,
        displayMeasurement: false,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

var mouseDownCount = 0;
var mouseUpCount = 0;
var previousMousepointerX = 0;
var previousMousepointerY = 0;

AngleMeasurementTool.prototype.hanleMouseDown = function (evt) {
    if (mouseDownCount < 3) {
        mouseDownCount = mouseDownCount + 1;
    } else {
        mouseDownCount = 0;
    }
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (isMobileDevice && dataToEdit !== undefined) {
        this.isMousePressed = false;
    }
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }

    if (!dicomViewer.measurement.isAngleMeasurementEnd()) {
        dicomViewer.measurement.setAngleMeasurementEnd(true);
        dicomViewer.measurement.setAngleMeasurementId(dicomViewer.measurement.getAngleMeasurementId() + 1);
        this.measurementData.measurementId = dicomViewer.measurement.getAngleMeasurementId();
        var type = dicomViewer.measurement.getEnumMT("angle");
        this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
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
        this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
        this.measurementData.isEditable = true;
        this.measurementData.sessionType = 0;
        if (evt.type === "mouseup") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = false;
        } else if (evt.type === "touchstop") {
            evt.preventDefault();
            var touch = evt.touches[0];
            //this.measurementData.end.x = touch.pageX - offset.x;
            //this.measurementData.end.y = touch.pageY - offset.y;
        }
        dicomViewer.measurement.setLineMeasurementEnd(true);
        dicomViewer.measurement.setTempData(this.measurementData);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "angle",
            measurementId: dicomViewer.measurement.getAngleMeasurementId(),
            displayMeasurement: false
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
    if (evt.type === "mousedown") {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (pt.isPtInRegion || dataToEdit !== undefined) {
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var type = dicomViewer.measurement.getEnumMT("angle");
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
            if (mouseDownCount == 2) {
                this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
            }
        } else {
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var type = dicomViewer.measurement.getEnumMT("angle");
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type)
            }
            this.isMousePressed = false;
        }
    } else if (evt.type === "touchstart") {
        evt.preventDefault();
        if (this.isMousePressed) {
            var imageUid = undefined;
            var frameIndex = undefined;
            imageRenderer.imagePromise.then(function (image) {
                imageUid = image.imageUid;
                frameIndex = image.frameNumber;
            });
            this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
            this.measurementData.isEditable = true;
            this.measurementData.sessionType = 0;
        }
        var pt = this.hitTestAndGetMousePosition(evt);
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit == undefined) {
            if (this.isMousePressed && this.measurementData.measureType == 'angle') {
                dicomViewer.measurement.increaseMousePressedCounter();
                if (dicomViewer.measurement.getMousePressedCounter() == "1") {
                    if (jQuery.isEmptyObject(this.measurementData.style)) {
                        var type = dicomViewer.measurement.getEnumMT("angle");
                        this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
                    }
                    this.isMousePressed = false;
                    this.measurementData.start.x = pt.x;
                    this.measurementData.start.y = pt.y;
                    this.measurementData.end.x = pt.x;
                    this.measurementData.end.y = pt.y;
                    this.measurementData.end.handleActive = true
                    dicomViewer.measurement.setTempData(this.measurementData);
                    this.activeImageRenderer.drawDicomImage(false);
                } else if (dicomViewer.measurement.getMousePressedCounter() == "2") {
                    this.isMousePressed = false;
                    this.measurementData.measureType = "angle";
                    this.measurementData.end.x = pt.x;
                    this.measurementData.end.y = pt.y;
                    dicomViewer.measurement.setLineMeasurementEnd(true);
                    dicomViewer.measurement.setTempData(this.measurementData);
                    this.activeImageRenderer.drawDicomImage(false);
                } else if (dicomViewer.measurement.getMousePressedCounter() == "3") {
                    this.isMousePressed = false;
                    dicomViewer.measurement.resetMousePressedCounter();
                    this.measurementData.start.x = pt.x;
                    this.measurementData.start.y = pt.y;
                    dicomViewer.measurement.setLineMeasurementEnd(true);
                    dicomViewer.measurement.setAngleMeasurementEnd(false);
                    dicomViewer.measurement.setTempData(this.measurementData);
                    this.activeImageRenderer.drawDicomImage(false);
                }
            }
        } else if (pt.isPtInRegion = true || dataToEdit != undefined) {
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else {
            this.isMousePressed = false;
        }
    }
};

AngleMeasurementTool.prototype.hanleMouseMove = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (this.isMousePressed) {
        if (mouseDownCount == 3 && dataToEdit == undefined) {
            //this.hanleMouseOut(evt);
            return;
        }
    }
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }
    if (!this.isMousePressed && dicomViewer.measurement.getMousePressedCounter() == "0") {
        return;
    }

    var widget = imageRenderer.getRenderWidget();
    if (this.measurementData.start.x === undefined || this.measurementData.start.y === undefined) {
        if (evt.type === "mousemove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else if (evt.type === "touchmove") {
            evt.preventDefault();
            return;
            var touch = evt.touches[0];
            //this.measurementData.start.x = touch.pageX - offset.x;
            //.measurementData.start.y = touch.pageY - offset.y;
        }
        this.isMousePressed = true;

    } else {
        if (evt.type === "mousemove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = true;
        } else if (evt.type === "touchmove") {
            evt.preventDefault();
            //for mobile device, not allowing to draw angle shape while touch move
            if (dicomViewer.measurement.getDataToEdit() == undefined) {
                return;
            }
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.end.handleActive = true;
        }

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
};

AngleMeasurementTool.prototype.hanleMouseUp = function (evt) {

    var pt = this.hitTestAndGetMousePosition(evt);
    previousMousepointerX = pt.x;
    previousMousepointerY = pt.y;

    if (mouseUpCount < 3) {
        mouseUpCount = mouseUpCount + 1;
    } else {
        mouseUpCount = 0;
    }

    dicomViewer.measurement.resetHandeler();
    var isTouchContextMenu = false;
    if (evt.event !== undefined && evt.event.eventPhase === 3) {
        isTouchContextMenu = true;
        if (this.isMousePressed = true) {
            this.isMousePressed = false;
        }
    }
    if ((evt.type === "mouseup" && evt.which === 3) || isTouchContextMenu) {
        if (isTouchContextMenu) {
            var pt = this.hitTestAndGetMousePosition(evt.event.originalEvent);
            var measurementDelData = {
                x: pt.x,
                y: pt.y,
                measureType: "angledelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "angledelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        this.activeImageRenderer.drawDicomImage(false);
    }

    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit == undefined) {
        if (this.isMousePressed && this.measurementData.measureType == 'angle') {
            dicomViewer.measurement.increaseMousePressedCounter();
        }

        if (dicomViewer.measurement.getMousePressedCounter() == "3") {
            mouseDownCount = 0;
            mouseUpCount = 0;
            dicomViewer.measurement.resetMousePressedCounter();
            this.isMousePressed = false;
            this.measurementData.displayMeasurement = true;
            dicomViewer.measurement.setAngleMeasurementEnd(false);
            this.activeImageRenderer.drawDicomImage(false);
        }
    }
};

AngleMeasurementTool.prototype.hanleDoubleClick = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    if (evt != undefined) {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (previousMousepointerX == pt.x && previousMousepointerY == pt.y) {
            var imageUid = undefined;
            var frameIndex = undefined;
            imageRenderer.imagePromise.then(function (image) {
                imageUid = image.imageUid;
                frameIndex = image.frameNumber;
            });
            var angleMeasurements = dicomViewer.measurement.getAngleMeasurements(imageUid, frameIndex);
            if (angleMeasurements !== undefined && angleMeasurements.length !== 0) {
                measurements = angleMeasurements[angleMeasurements.length - 1];
                if (measurements != undefined && measurements.length >= 2) {
                    var firstArray = measurements[0];
                    var secondArray = measurements[1];
                    if ((isNaN(secondArray.end.x) || isNaN(secondArray.end.y)) || ((secondArray.start.x == secondArray.end.x) || (secondArray.start.y == secondArray.end.y))) {
                        secondArray.end.x = firstArray.start.x + 50;
                        secondArray.end.y = firstArray.start.y + 50;
                    }
                    this.activeImageRenderer.drawDicomImage(false);
                }
            }
        } else {
            previousMousepointerX = pt.x;
            previousMousepointerY = pt.y;
        }
    }

    this.isMousePressed = false;
    dicomViewer.measurement.resetMousePressedCounter();
    if (imageRenderer === undefined) {
        return;
    }

    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
        if (evt === undefined || evt.type === "dblclick" || evt.type === "mouseout" || evt.type == "mousewheel") {
            var imageUid = undefined;
            var frameIndex = undefined;
            imageRenderer.imagePromise.then(function (image) {
                imageUid = image.imageUid;
                frameIndex = image.frameNumber;
            });
            dicomViewer.measurement.resetAngleEditMode(imageUid, frameIndex, dataToEdit);
            this.measurementData.displayMeasurement = true;
            dicomViewer.measurement.setAngleMeasurementEnd(false);
            dicomViewer.measurement.setDataToEdit(undefined);
            if (isMobileDevice()) {
                dicomViewer.measurement.removeTempdata();
            }
            imageRenderer.drawDicomImage(false);
        }
    }
    mouseDownCount = 0;
    mouseUpCount = 0;
};

AngleMeasurementTool.prototype.hanleMouseOut = function (evt) {
    var pt = this.hitTestAndGetMousePosition(evt);
    if (dicomViewer.measurement.getDataToEdit() !== undefined) {
        mouseDownCount = 0;
        mouseUpCount = 0;
        dicomViewer.measurement.removeTempdata();
        this.hanleDoubleClick(evt);
    } else if (dicomViewer.measurement.getMousePressedCounter() == 1 && mouseDownCount == 1) {
        mouseDownCount = 0;
        mouseUpCount = 0;
        this.hanleDoubleClick(evt);
        if (evt.which === 0 || evt.button == 0) {
            dicomViewer.measurement.setTempData({
                x: pt.x,
                y: pt.y,
                measureType: "angledelete"
            });
            this.activeImageRenderer.drawDicomImage(true);
        }
    } else if ((dicomViewer.measurement.getMousePressedCounter() == 2 && mouseDownCount == 2)) {
        mouseDownCount = 0;
        mouseUpCount = 0;
        dicomViewer.measurement.setLineMeasurementEnd(true);
        dicomViewer.measurement.setTempData(this.measurementData);
        this.hanleMouseUp(evt);
    } else if (dicomViewer.measurement.getMousePressedCounter() == 2 && mouseDownCount == 3) {
        mouseDownCount = 0;
        mouseUpCount = 0;
        dicomViewer.measurement.setLineMeasurementEnd(true);
        this.hanleMouseUp(evt);
    }
};
