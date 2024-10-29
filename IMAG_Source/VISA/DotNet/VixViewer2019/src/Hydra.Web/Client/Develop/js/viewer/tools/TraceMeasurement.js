TraceMeasurement.prototype = new MouseTool();
TraceMeasurement.prototype.constructor = TraceMeasurement;

function TraceMeasurement() {
    this.ToolType = "traceMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "trace",
        measurementId: null,
        measurementType: null,
        measurementUnits: null,
        measurementComplete: false,
        displayMeasurement: false,
        isEditable: "undefined",
        sessionType: "undefined"
    };
}

TraceMeasurement.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }

    if (!dicomViewer.measurement.isTraceMeasurementEnd()) {
        dicomViewer.measurement.setTraceMeasurementEnd(true);
        dicomViewer.measurement.setTraceMeasurementId(dicomViewer.measurement.getTraceMeasurementId() + 1);
        this.measurementData.measurementId = dicomViewer.measurement.getTraceMeasurementId();
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
        this.measurementData.textPosition = dicomViewer.measurement.pointTextPosition(this.measurementData, imageRenderer);
        this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle("TRACE");
        dicomViewer.measurement.setLineMeasurementEnd(true);
        dicomViewer.measurement.setTempData(this.measurementData);
        //dicomViewer.measurement.addMeasurements(imageUid,frameIndex,imageRenderer,this.measurementData);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "trace",
            measurementId: dicomViewer.measurement.getTraceMeasurementId(),
            displayMeasurement: false,
            style: this.measurementData.style
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
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var type = dicomViewer.measurement.getEnumMT("trace");
                this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle(type);
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else {
            this.isMousePressed = false;
        }
    }

    /*var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;*/
    //for mobile devices not getting the touchend that's why drawing the point on every touchstart
    if (evt.type == "touchstart") {
        dicomViewer.measurement.setTempData(this.measurementData);
        imageRenderer.drawDicomImage(false);
    }
};

TraceMeasurement.prototype.hanleMouseMove = function (evt, isDoubleClick) {
    var imageRenderer = this.activeImageRenderer;
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
                //Dreasing 5 for viewer offset
                this.measurementData.start.x = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
                this.measurementData.start.y = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
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

TraceMeasurement.prototype.hanleMouseUp = function (evt) {
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
                measureType: "linedelete"
            };
        } else {
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "tracedelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
        this.activeImageRenderer.drawDicomImage(false);
    }
};

TraceMeasurement.prototype.hanleDoubleClick = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    this.isMousePressed = false;
    if (imageRenderer === undefined) {
        return;
    }
    if (evt === undefined || evt.type === "dblclick" || evt.type === "mouseout" || evt.type === "mousewheel") {
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
        var traceMeasurements = dicomViewer.measurement.getTraceMeasurements(imageUid, frameIndex);
        if (traceMeasurements != undefined) {
            dicomViewer.measurement.resetTraceEditMode(imageUid, frameIndex, dataToEdit);
        }
        this.measurementData.displayMeasurement = true;
        dicomViewer.measurement.setTraceMeasurementEnd(false);
        if (dataToEdit != undefined) {
            dicomViewer.measurement.setTempData(undefined);
            dicomViewer.measurement.setDataToEdit(undefined);
        }
        imageRenderer.drawDicomImage(false);
        dicomViewer.measurement.resetHandeler();
        /*var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft))-5;
        var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop))-5;
        var measurementDelData = {
                                x : pointX,
                                y : pointY,
                                measureType : "tracedelete" 
                               };
        dicomViewer.measurement.setTempData(measurementDelData);        
        imageRenderer.drawDicomImage(false);*/
    }
};

TraceMeasurement.prototype.hanleMouseOut = function (evt) {
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (this.isMousePressed || dataToEdit != undefined) {
        this.hanleMouseDown(evt);
        this.hanleMouseMove(evt, true);
        this.hanleMouseDown(evt);
        this.hanleDoubleClick(evt);
    }
};
