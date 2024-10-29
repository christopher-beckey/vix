VolumeMeasurement.prototype = new MouseTool();
VolumeMeasurement.prototype.constructor = VolumeMeasurement;

function VolumeMeasurement() {
    this.ToolType = "volumeMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        studyUid: undefined,
        measureType: "volume",
        measurementId: null,
        measurementType: null,
        measurementComplete: false,
        measurementUnits: null
    };
}

VolumeMeasurement.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit === undefined) {
        this.measurementData.measureType = "volume";
    }

    if (!dicomViewer.measurement.isVolumeMeasurementEnd()) {
        dicomViewer.measurement.setVolumeMeasurementEnd(true);
        dicomViewer.measurement.setVolumeMeasurementId(dicomViewer.measurement.getVolumeMeasurementId() + 1);
        this.measurementData.measurementId = dicomViewer.measurement.getVolumeMeasurementId();
    }
    if (this.isMousePressed) {
        this.isMousePressed = false;
        var imageRenderer = this.activeImageRenderer;
        if (imageRenderer === undefined) {
            return;
        }
        this.measurementData.studyUid = getMeasurementStudyUid(imageRenderer.seriesLevelDivId);
        var widget = imageRenderer.getRenderWidget();
        var imageUid = undefined;
        var frameIndex = undefined;
        imageRenderer.imagePromise.then(function (image) {
            imageUid = image.imageUid;
            frameIndex = image.frameNumber;
        });
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


        //dicomViewer.measurement.addMeasurements(imageUid,frameIndex,imageRenderer,this.measurementData);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "volume",
            measurementId: dicomViewer.measurement.getVolumeMeasurementId(),
            measurementComplete: false
        };
        imageRenderer.drawDicomImage(false);
    }
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (this.measurementData.measureType === "volumeedit" || (this.measurementData.measureType === "volume" && dataToEdit !== undefined)) {
        this.measurementData.measureType = "volumeeditmove";
    }

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
        if (pt.isPtInRegion) {
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else {
            this.isMousePressed = false;
        }
    } else if (evt.type === "touchstart") {
        evt.preventDefault();
        var touch = evt.touches[0];
        //this.measurementData.start.x = touch.pageX - offset.x;
        //this.measurementData.start.y = touch.pageY - offset.y;
    }

    /*var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;*/
};

VolumeMeasurement.prototype.hanleMouseMove = function (evt) {
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
        if (evt.type === "mousemove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        } else if (evt.type === "touchmove") {
            evt.preventDefault();
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
            var touch = evt.touches[0];
            //this.measurementData.end.x = touch.pageX - offset.x;
            //this.measurementData.end.y = touch.pageY - offset.y;
        }
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit != undefined) {
            if (dataToEdit.measurmentType === "line") {
                dicomViewer.tools.do2DMeasurement(0, null, null)
            } else if (dataToEdit.measurmentType === "point") {
                dicomViewer.tools.do2DMeasurement(1, null, null)
            }
        } else {
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setTempData(this.measurementData);
        }

        if (this.measurementData.measureType === "volumeeditmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;

            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setTempData(this.measurementData);
        }

        imageRenderer.drawDicomImage(false);
    }
    //evt.target.style.cursor = "crosshair";
};

VolumeMeasurement.prototype.hanleMouseUp = function (evt) {
    if (evt.which === 3) {
        var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
        var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
        var measurementDelData = {
            x: pointX,
            y: pointY,
            measureType: "volumedelete"
        };

        dicomViewer.measurement.setTempData(measurementDelData);
        if (!dicomViewer.measurement.isVolumeMeasurementEnd()) {
            if (this.measurementData.measureType === "volumeeditmove") {
                this.measurementData.measureType = "volume";
            }
        }

        this.activeImageRenderer.drawDicomImage(false);
    } else if (evt.which === 1) {
        if (this.measurementData.measureType === "volumeeditmove") {
            this.measurementData.measureType = "volumeedit";
            this.isMousePressed = false;
            dicomViewer.measurement.setVolumeMeasurementEnd(false);
            this.activeImageRenderer.drawDicomImage(false);
            dicomViewer.measurement.setDataToEdit('edit');
        }
    }

};


VolumeMeasurement.prototype.hanleDoubleClick = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    this.isMousePressed = false;
    if (imageRenderer === undefined) {
        return;
    }
    if (evt === undefined) {
        this.measurementData.end.handleActive = false;
        this.measurementData.measureType = "volume";
        dicomViewer.measurement.setTempData(this.measurementData);
        dicomViewer.measurement.setVolumeMeasurementEnd(false);
    } else if (evt.type === "dblclick") {
        var widget = imageRenderer.getRenderWidget();
        var pt = this.hitTestAndGetMousePosition(evt);
        this.measurementData.end.x = pt.x;
        this.measurementData.end.y = pt.y;
        this.measurementData.end.handleActive = false;
        this.measurementData.measureType = "volume";
        dicomViewer.measurement.setTempData(this.measurementData);
        dicomViewer.measurement.setVolumeMeasurementEnd(false);
    }

    dicomViewer.measurement.setDataToEdit(undefined);
    this.activeImageRenderer.drawDicomImage(false);
    dicomViewer.measurement.setTempData(undefined);
};
