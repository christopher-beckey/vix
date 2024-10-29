PenTool.prototype = new MouseTool();
PenTool.prototype.constructor = PenTool;
var leftClickEndPoints = undefined;

function PenTool() {
    this.ToolType = "pen";
    this.painting = true;
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "pen",
        measurementId: null,
        measurementType: null,
        measurementSubType: "pen",
        measurementComplete: false,
        measurementUnits: null,
        isLineExceededOutside: false,
        measurementIndex: 0,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

PenTool.prototype.hanleMouseDown = function (evt) {

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

    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }

    if (!dicomViewer.measurement.isPenToolEnd()) {
        dicomViewer.measurement.setPenToolEnd(true);
        dicomViewer.measurement.setPenMeasurementId(dicomViewer.measurement.getPenMeasurementId() + 1);
        this.measurementData.measurementIndex = dicomViewer.measurement.getPenMeasurementId();
        this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
        this.measurementData.sessionType = 0;
        this.measurementData.isEditable = true;
    }

    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    dicomViewer.measurement.setLineMeasurementEnd(false);


    var widget = imageRenderer.getRenderWidget();
    if (evt.type === "mousedown" || evt.type === "mouseout" || evt.type === "touchstart") {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (pt.isPtInRegion || evt.type === "mouseout" || dataToEdit !== undefined) {
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var type = dicomViewer.measurement.getEnumMT("pen");
                this.measurementData.style = dicomViewer.measurement.draw.getUserMeasurementStyleByType(type);
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
            this.measurementData.measurementSubType = "pen";
        } else {
            this.isMousePressed = false;
        }
    }

    var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    //for mobile devices not getting the touchend that's why drawing the point on every touchstart
    if (evt.type == "touchstart") {
        dicomViewer.measurement.setTempData(this.measurementData);
    }

};

PenTool.prototype.hanleMouseMove = function (evt, isDoubleClick) {

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
                this.measurementData.measurementIndex = dicomViewer.measurement.getPenMeasurementId();
                dicomViewer.measurement.setTempData(this.measurementData);
            }
        } else {
            this.measurementData.measurementIndex = dicomViewer.measurement.getPenMeasurementId();
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setTempData(this.measurementData);
        }
        imageRenderer.drawDicomImage(false, undefined, true);
    }

    if (this.measurementData.end.x !== this.measurementData.start.x ||
        this.measurementData.end.y !== this.measurementData.start.y) {
        this.measurementData.start.x = this.measurementData.end.x;
        this.measurementData.start.y = this.measurementData.end.y;
    }



};

PenTool.prototype.hanleMouseUp = function (evt) {
    this.painting = false;
    dicomViewer.measurement.setPenToolEnd(false);

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
                measureType: "pendelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "pendelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        var imageRender = this.activeImageRenderer;
        //var auids = imageRender.anUIDs.split("*");
        var dContext = this.activeImageRenderer.getRenderWidget().getContext("2d");
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
            measureType: "pen",
            measurementSubType: "pen"
        };
        imageRenderer.drawDicomImage(false);
        dicomViewer.measurement.resetHandeler();
    }

};

/**
 * finishing the update over selected pen annotation
 * @param {Type} evt - event
 */
PenTool.prototype.hanleDoubleClick = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
        var imageRenderer = this.activeImageRenderer;
        var widget = imageRenderer.getRenderWidget();
        if (evt === undefined || evt.which === 1 || evt.type === "mouseout") {
            dicomViewer.measurement.setDataToEdit(undefined);
        }
    }
};

PenTool.prototype.hanleMouseOut = function (evt) {
    this.hanleMouseUp(evt);
};

/**
 * set the measurement/Annotation type
 * @param {Type} type - It specifies the measurement type(arrow,2Dline,etc..)
 */
PenTool.prototype.setMeasurementSubType = function (type) {
    this.measurementSubType = type;
};
