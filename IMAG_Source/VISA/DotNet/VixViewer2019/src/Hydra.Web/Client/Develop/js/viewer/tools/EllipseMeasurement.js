EllipseMeasurement.prototype = new MouseTool();
EllipseMeasurement.prototype.constructor = EllipseMeasurement;
var isLineExceededOutside = false;

function EllipseMeasurement() {
    this.ToolType = "ellipseMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        first: {},
        second: {},
        third: {},
        fourth: {},
        center: {},
        style: {},
        isCustomEllipse: false,
        studyUid: undefined,
        measureType: "ellipse",
        measurementSubType: "hounsfield",
        measurementId: null,
        measurementType: null,
        measurementComplete: false,
        measurementUnits: null,
        isLineExceededOutside: false,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

EllipseMeasurement.prototype.hanleMouseDown = function (evt) {
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
                var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, this.measurementSubType);
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle("RECT");
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
            this.measurementData.first.x = pt.x;
            this.measurementData.first.y = pt.y;
            this.measurementData.measurementSubType = this.measurementSubType;
        } else {
            this.isMousePressed = false;
        }
    }

    var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;
};

EllipseMeasurement.prototype.hanleMouseMove = function (evt) {
    var value = dicomViewer.measurement.getDataToEdit();
    var imageRenderer = this.activeImageRenderer;
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
            this.measurementData.first.x = pt.x;
            this.measurementData.first.y = pt.y;
        }

        this.isMousePressed = true;
    } else {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.handleActive = true;
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
            this.measurementData.second.x = pt.x;
            this.measurementData.second.y = pt.y;
            if (value == undefined) {
                this.adjustQuadrantsOfEllipse();
            }
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
                dicomViewer.measurement.setTempData(this.measurementData);
                this.measurementData = {
                    start: {
                        handleActive: false
                    },
                    end: {
                        handleActive: false
                    },
                    first: {},
                    second: {},
                    third: {},
                    fourth: {},
                    center: {},
                    style: {},
                    isCustomEllipse: false,
                    measureType: value.measurmentType,
                    measurementSubType: this.measurementData.measurementSubType
                };
            }
        }

        imageRenderer.drawDicomImage(false, undefined, true);
    }

};

EllipseMeasurement.prototype.hanleMouseUp = function (evt) {
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
                measureType: "ellipsedelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "ellipsedelete"
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
        if (evt.type === "mouseup" || evt.type === "mouseout" || evt.type === "touchend") {
            var pt = this.hitTestAndGetMousePosition(evt);
            if (pt !== undefined) {
                this.measurementData.end.x = pt.x;
                this.measurementData.end.y = pt.y;
                this.measurementData.second.x = pt.x;
                this.measurementData.second.y = pt.y;
                var value = dicomViewer.measurement.getDataToEdit();
                if (value == undefined) {
                    this.adjustQuadrantsOfEllipse();
                }
            } else {
                // touchend will return undefined. Maintain the last touchmove point as the end point
            }

            this.measurementData.end.handleActive = false;
        }
        this.measurementData.textPosition = dicomViewer.measurement.hounsfieldTextPosition(this.measurementData, imageRenderer);
        dicomViewer.measurement.setMeasurementBroken(false);
        dicomViewer.measurement.setLineMeasurementEnd(true);
        dicomViewer.measurement.setTempData(this.measurementData);

        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            first: {},
            second: {},
            third: {},
            fourth: {},
            center: {},
            style: {},
            isCustomEllipse: false,
            measureType: "ellipse",
            measurementSubType: this.measurementData.measurementSubType
        };
        imageRenderer.drawDicomImage(false);
        dicomViewer.measurement.resetHandeler();
    }

};

EllipseMeasurement.prototype.hanleDoubleClick = function (evt) {
    this.isMousePressed = false;
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
        var imageRenderer = this.activeImageRenderer;
        var widget = imageRenderer.getRenderWidget();
        if (evt === undefined || evt.which === 1 || evt.type === "mouseout" || evt.type === "touchend") {
            var imageUid = undefined;
            var frameIndex = undefined;
            imageRenderer.imagePromise.then(function (image) {
                imageUid = image.imageUid;
                frameIndex = image.frameNumber;
            });
            dicomViewer.measurement.resetEllipseEditMode(imageUid, frameIndex, dataToEdit);
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setDataToEdit(undefined);
            imageRenderer.drawDicomImage(false);
        }
    }
};

EllipseMeasurement.prototype.hanleMouseOut = function (evt) {
    if (dicomViewer.measurement.getDataToEdit() !== undefined) {
        this.hanleDoubleClick(evt);
    } else {
        this.hanleMouseUp(evt);
    }
};

/**
 * set the measurement sub type
 * @param {Type} type - It specifies the measurement sub type(hounsfield or ellipse)
 */
EllipseMeasurement.prototype.setMeasurementSubType = function (type) {
    this.measurementSubType = type;
};

/**
 * Adjust all the quadrants of ellipse when rotating from any one of the quadrant point.
 */
EllipseMeasurement.prototype.adjustQuadrantsOfEllipse = function () {
    var centerX = (this.measurementData.start.x + this.measurementData.end.x) / 2;
    var centerY = (this.measurementData.start.y + this.measurementData.end.y) / 2;
    this.measurementData.center.x = centerX;
    this.measurementData.center.y = centerY;
    var point = {
        x: Math.abs(this.measurementData.second.x),
        y: Math.abs(this.measurementData.second.y)
    };
    this.measurementData.third = this.rotate(centerX, centerY, point);
    point = {
        x: Math.abs(this.measurementData.first.x),
        y: Math.abs(this.measurementData.first.y)
    };
    this.measurementData.fourth = this.rotate(centerX, centerY, point);
};

/**
 * Rotate a point to given radians with given center point.
 */
EllipseMeasurement.prototype.rotate = function (cx, cy, point) {
    var radians = Math.PI / 2,
        cos = Math.cos(radians),
        sin = Math.sin(radians),
        nx = (cos * (point.x - cx)) + (sin * (point.y - cy)) + cx,
        ny = (cos * (point.y - cy)) - (sin * (point.x - cx)) + cy;
    return {
        x: nx,
        y: ny
    };
};
