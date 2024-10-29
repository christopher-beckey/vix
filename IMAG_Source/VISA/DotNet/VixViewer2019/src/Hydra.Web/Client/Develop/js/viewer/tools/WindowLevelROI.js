WindowLevelROI.prototype = new MouseTool();
WindowLevelROI.prototype.constructor = WindowLevelROI;
var isLineExceededOutside = false;

function WindowLevelROI() {
    this.toolName = "WindowLevelROI";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        measureType: "WindowLevelROI",
        measurementId: null,
        measurementType: null,
        measurementComplete: false,
        measurementUnits: null,
        isLineExceededOutside: false
    };
}

WindowLevelROI.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled() || evt.which == 2) {
        this.isMousePressed = false;
        return;
    }

    evt.preventDefault();
    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer === undefined) {
        this.isMousePressed = false;
        return;
    }

    if (imageRenderer && imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        var presentation = null;
        var imageCanvas = null;
        imageRenderer.imagePromise.then(function (image) {
            presentation = image.presentation;
            imageCanvas = image;
        });

        if (presentation) {
            imageCanvas.presentation.setPresetWindowLevelValue(0);
        }
    }

    var widget = imageRenderer.getRenderWidget();
    if (evt.type === "mousedown" || evt.type === "touchstart") {
        var pt = this.hitTestAndGetMousePosition(evt);
        if (pt.isPtInRegion) {
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                this.measurementData.style = dicomViewer.measurement.draw.getUserMeasurementStyleByType();
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
};

WindowLevelROI.prototype.hanleMouseMove = function (evt) {
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        this.isMousePressed = false;
        dicomViewer.measurement.setTempData(undefined);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "WindowLevelROI"
        };
        return;
    }

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
        }
        this.isMousePressed = true;
    } else {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt);
            this.measurementData.end.handleActive = true;
            this.measurementData.end.x = pt.x;
            this.measurementData.end.y = pt.y;
        }

        dicomViewer.measurement.setLineMeasurementEnd(false);
        dicomViewer.measurement.setTempData(this.measurementData);
        imageRenderer.drawDicomImage(false, undefined, undefined, true);
    }

};

WindowLevelROI.prototype.hanleMouseUp = function (evt) {
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        this.isMousePressed = false;
        dicomViewer.measurement.setTempData(undefined);
        this.measurementData = {
            start: {
                handleActive: false
            },
            end: {
                handleActive: false
            },
            measureType: "WindowLevelROI"
        };
        return;
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
            } else {
                // touchend will return undefined. Maintain the last touchmove point as the end point
            }

            this.measurementData.end.handleActive = false;
            this.applyWindowLevel();
        }
        dicomViewer.measurement.resetHandeler();
    }
};

WindowLevelROI.prototype.hanleDoubleClick = function (evt) {

};

WindowLevelROI.prototype.hanleMouseOut = function (evt) {
    if (this.isMousePressed) {
        if (this.measurementData.start.x != undefined || this.measurementData.start.y != undefined) {
            this.hanleMouseUp(evt);
        }
    }
};

WindowLevelROI.prototype.applyWindowLevel = function () {
    try {
        var imageRender = this.activeImageRenderer;
        var activeImageLevelId = imageRender.parentElement;
        if (imageRender == undefined || imageRender == null) {
            return;
        }

        var auids = imageRender.anUIDs.split("*");
        var context = imageRender.getRenderWidget().getContext("2d");
        imageRender.drawDicomImage(true);

        var imageData = dicomViewer.measurement.getImageDataForMouseData(this.measurementData, imageRender, context);
        var presentation = imageRender.getPresentation();
        var windowLevelValue = dicomViewer.measurement.draw.GetROIWindowLevelValues(auids[0],
            context,
            imageData,
            presentation,
            imageRender);
        if (windowLevelValue != undefined) {
            var window = windowLevelValue.window;
            var level = windowLevelValue.level;
            var LS_ROI_VARIANCE = 2.5;
            var minLevelValue = presentation.windowLevelLimits.wcLimit.min;
            var maxLevelValue = presentation.windowLevelLimits.wcLimit.max;
            var minWindowValue = presentation.windowLevelLimits.wwLimit.min;
            var maxWindowValue = presentation.windowLevelLimits.wwLimit.max;
            var slope = presentation.lookupObj.rescaleSlope;
            var intercept = presentation.lookupObj.rescaleIntercept;

            window = LS_ROI_VARIANCE * window;
            if (slope != 0) {
                window = window * slope;
                level = (level * slope) + intercept;
            }

            dicomViewer.measurement.setTempData(undefined);
            dicomViewer.measurement.setMeasurementBroken(false);
            dicomViewer.measurement.setLineMeasurementEnd(true);

            this.measurementData = {
                start: {
                    handleActive: false
                },
                end: {
                    handleActive: false
                },
                measureType: "WindowLevelROI"
            };

            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                var imageLevelId = $(this).attr('id');
                var imageRender = seriesLayout.getImageRender(imageLevelId);
                if (imageRender) {
                    imageRender.doWindowLevel(level, window, true);
                }
            });
        }
    } catch (e) {}
};
