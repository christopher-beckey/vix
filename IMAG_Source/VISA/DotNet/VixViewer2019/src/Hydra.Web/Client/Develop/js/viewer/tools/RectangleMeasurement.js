RectangleMeasurement.prototype = new MouseTool();
RectangleMeasurement.prototype.constructor = RectangleMeasurement;
var isLineExceededOutside = false;
var isTextAreaVisible = false;
var isEdited = false;

function RectangleMeasurement() {
    this.ToolType = "rectangleMeasurement";
    this.measurementData = {
        start: {
            handleActive: false
        },
        end: {
            handleActive: false
        },
        style: {},
        studyUid: undefined,
        measureType: "rectangle",
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

RectangleMeasurement.prototype.hanleMouseDown = function (evt) {
    //Disable drawing measuremnts while playing cine
    if (dicomViewer.measurement.draw.isMeasuremntDisabled()) {
        return;
    }
    if (dicomViewer.measurement.isMeasurementBroken()) {
        dicomViewer.measurement.setMeasurementBroken(false);
    }
    evt.preventDefault();

    var editData = dicomViewer.measurement.getDataToEdit();
    if (this.measurementSubType === "text" && isTextAreaVisible && editData == undefined) {
        this.handleTextArea(this.getRegion(), true);
    }

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

            if (editData !== undefined) {
                // Check whether the mouse point is inside the text area
                var editRegion = (isEdited == false) ? this.isEditRegion(editData, pt) : undefined;
                if (editRegion !== undefined && editRegion !== null) {
                    if (this.measurementSubType === "text" && editRegion.isPtInRegion) {
                        this.isMousePressed = false;
                        this.handleTextArea(editRegion, undefined, true);
                        isEdited = true;
                        return;
                    }
                }
            }
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
            this.measurementData.measurementSubType = this.measurementSubType;
            if (jQuery.isEmptyObject(this.measurementData.style)) {
                var type = dicomViewer.measurement.getEnumMT(this.measurementData.measureType, this.measurementData.measurementSubType);
                if (type == "TEXT") {
                    this.measurementData.style = dicomViewer.measurement.draw.getUserMeasurementStyleByType(type);
                } else {
                    this.measurementData.style = dicomViewer.measurement.draw.getMeasurementStyle("RECT");
                }
            }
        } else {
            this.isMousePressed = false;
        }
    }

    var measurementType = dicomViewer.measurement.draw.getMeasurementType();
    this.measurementData.measurementId = measurementType.measurementId;
    this.measurementData.measurementType = measurementType.measurementType;
    this.measurementData.measurementUnits = measurementType.measurementUnits;
};

RectangleMeasurement.prototype.hanleMouseMove = function (evt, isTextAreaEvent) {
    var value = dicomViewer.measurement.getDataToEdit();
    if (this.measurementSubType === "text" && isTextAreaVisible == true && value === undefined) {
        this.handleTextArea(this.getRegion());
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
            var pt = this.hitTestAndGetMousePosition(evt, isTextAreaEvent);
            this.measurementData.start.x = pt.x;
            this.measurementData.start.y = pt.y;
        }

        this.isMousePressed = true;
    } else {
        if (evt.type === "mousemove" || evt.type === "touchmove") {
            var pt = this.hitTestAndGetMousePosition(evt, isTextAreaEvent);
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
                dicomViewer.measurement.setTempData(this.measurementData);
                this.measurementData = {
                    start: {
                        handleActive: false
                    },
                    end: {
                        handleActive: false
                    },
                    measureType: value.measurmentType,
                    measurementSubType: this.measurementData.measurementSubType
                };
            }
        }

        imageRenderer.drawDicomImage(false, undefined, true);

        // Show the text overlay
        if (this.measurementSubType === "text" && value !== undefined) {
            this.handleTextArea(this.getEditRegion(value, {
                x: 0,
                y: 0
            }), undefined, false, true);
        }
    }

};

RectangleMeasurement.prototype.hanleMouseUp = function (evt) {
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
                measureType: "rectangledelete"
            };
        } else {
            if (this.measurementSubType === "text" && isTextAreaVisible) {
                this.handleTextArea(this.getRegion(), true);
                return;
            }
            var pointX = (evt.offsetX || (evt.pageX - widget.offsetLeft)) - 5;
            var pointY = (evt.offsetY || (evt.pageY - widget.offsetTop)) - 5;
            var measurementDelData = {
                x: pointX,
                y: pointY,
                measureType: "rectangledelete"
            };
        }
        dicomViewer.measurement.setTempData(measurementDelData);
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
            } else {
                // touchend will return undefined. Maintain the last touchmove point as the end point
            }

            this.measurementData.end.handleActive = false;

            // Show the text overlay
            var value = dicomViewer.measurement.getDataToEdit();
            if (this.measurementSubType === "text" && value === undefined) {
                this.handleTextArea(this.getRegion(), undefined, true);
                return;
            }
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
            measureType: "rectangle",
            measurementSubType: this.measurementData.measurementSubType
        };
        imageRenderer.drawDicomImage(false);
        dicomViewer.measurement.resetHandeler();
    }

};

RectangleMeasurement.prototype.hanleDoubleClick = function (evt) {
    if (this.measurementSubType === "text") {
        this.handleTextArea(this.getRegion(), true);
        return;
    }
    this.isMousePressed = false;
    var dataToEdit = dicomViewer.measurement.getDataToEdit();
    if (dataToEdit != undefined) {
        var imageRenderer = this.activeImageRenderer;
        var widget = imageRenderer.getRenderWidget();
        if (evt === undefined || evt.which === 1 || evt.type === "mouseout") {
            var imageUid = undefined;
            var frameIndex = undefined;
            imageRenderer.imagePromise.then(function (image) {
                imageUid = image.imageUid;
                frameIndex = image.frameNumber;
            });
            dicomViewer.measurement.resetRectangleEditMode(imageUid, frameIndex, dataToEdit);
            dicomViewer.measurement.setLineMeasurementEnd(false);
            dicomViewer.measurement.setDataToEdit(undefined);
            imageRenderer.drawDicomImage(false);
        }
    }
};

RectangleMeasurement.prototype.hanleMouseOut = function (evt) {
    if (evt.toElement !== null && evt.toElement !== undefined) {
        if (evt.toElement.id === "textarea_annotation") {
            return;
        }
    }
    if (this.measurementSubType === "text" && this.activeImageRenderer !== undefined) {
        var canvas = this.activeImageRenderer.getRenderWidget();
        var viewportRect = canvas.getBoundingClientRect();
        var pointX = 0;
        var pointY = 0;
        if (evt.touches === undefined) {
            if (evt.offsetX !== undefined && evt.offsetY !== undefined) {
                pointX = evt.offsetX - 5;
                pointY = evt.offsetY - 5;
            } else {
                pointX = evt.pageX - viewportLeftOffset;
                pointY = evt.pageY - viewportTopOffset;
            }
        } else {
            pointX = evt.touches[0].pageX - viewportLeftOffset;
            pointY = evt.touches[0].pageY - viewportTopOffset;
        }

        if ((pointX > viewportRect.left && pointX < viewportRect.width) &&
            (pointY > viewportRect.top && pointY < viewportRect.height)) {
            this.handleTextArea(this.getRegion());
        } else {
            this.hanleMouseUp(evt);
            this.handleTextArea(this.getRegion(), true);
        }
        return;
    }

    if (dicomViewer.measurement.getDataToEdit() !== undefined) {
        this.hanleDoubleClick(evt);
    } else {
        this.hanleMouseUp(evt);
    }
};

/**
 * set the measurement sub type
 * @param {Type} type - It specifies the measurement sub type(hounsfield or rectangle)
 */
RectangleMeasurement.prototype.setMeasurementSubType = function (type) {
    this.measurementSubType = type;
};

/**
 * Set the focus to text overlay
 */
RectangleMeasurement.prototype.hanleMouseOver = function (evt) {
    if (this.measurementSubType === "text" && isTextAreaVisible == true) {
        this.handleTextArea(this.getRegion());
        return;
    }
};

/**
 * show the text area
 */
RectangleMeasurement.prototype.handleTextArea = function (region, cancel, isNew, isResize) {
    try {
        if (this.activeImageRenderer === undefined || this.activeImageRenderer === null) {
            return;
        }

        if (document.getElementById("textarea_annotation") && isNew) {
            isNew = undefined;
            isResize = undefined;
            isTextAreaVisible = true;
            cancel = true;
        }

        if (isNew == true || isResize == true) {
            if (region.width < 5 || region.height < 5) {
                return;
            }
            var textArea = undefined;
            if (isNew) {
                textArea = document.createElement('textarea');
            } else if (isResize) {
                if (isTextAreaVisible) {
                    textArea = document.getElementById("textarea_annotation");
                } else {
                    return;
                }
            }
            if (isNew) {
                textArea.id = "textarea_annotation"
                textArea.type = 'text';
                textArea.maxLength = 100;
                textArea.style.position = 'fixed';
                textArea.style.fontSize = "medium";
                textArea.style.backgroundColor = 'black';
                textArea.style.color = 'white';
                textArea.style.overflow = 'hidden';
                textArea.value = region.text;
                textArea.style.resize = "none";
                textArea.onkeydown = this.handleTextAreakeydown;
                textArea.onmousemove = this.handleTextAreamousemove;
            }
            textArea.style.left = region.left + 'px';
            textArea.style.top = region.top + 'px';
            textArea.style.width = region.width + 'px';
            textArea.style.height = region.height + 'px';
            textArea.focus();
            textArea.measurementData = this.measurementData;
            textArea.activeImageRenderer = this.activeImageRenderer;
            textArea.tool = this;
            document.body.appendChild(textArea);
            isTextAreaVisible = true;
        } else {
            var textArea = undefined;
            if (isTextAreaVisible) {
                textArea = document.getElementById("textarea_annotation");
                if (textArea !== undefined && textArea !== null) {
                    textArea.focus();
                }
            }

            if (cancel == true) {
                this.isMousePressed = false;
                var dataToEdit = dicomViewer.measurement.getDataToEdit();
                if (dataToEdit != undefined) {
                    var imageRenderer = this.activeImageRenderer;
                    var widget = imageRenderer.getRenderWidget();
                    var imageUid = undefined;
                    var frameIndex = undefined;
                    imageRenderer.imagePromise.then(function (image) {
                        imageUid = image.imageUid;
                        frameIndex = image.frameNumber;
                    });
                    if (isTextAreaVisible) {
                        this.measurementData.measurementText = getText("textarea_annotation");
                        if (this.measurementData.measurementText !== "") {
                            dicomViewer.measurement.updateMeasurementTextData(dataToEdit, this.measurementData.measurementText);
                        } else {
                            if (isTextAreaVisible) {
                                document.body.removeChild(textArea);
                                isTextAreaVisible = false;
                                isEdited = false;
                            }
                            dicomViewer.measurement.deleteSelectedMeasurment();
                            dicomViewer.measurement.resetHandeler();
                            return;
                        }
                    }
                    dicomViewer.measurement.resetRectangleEditMode(imageUid, frameIndex, dataToEdit);
                    dicomViewer.measurement.setLineMeasurementEnd(false);
                    dicomViewer.measurement.setDataToEdit(undefined);
                    imageRenderer.drawDicomImage(false);
                } else if (isTextAreaVisible) {
                    dicomViewer.measurement.setMeasurementBroken(false);
                    dicomViewer.measurement.setLineMeasurementEnd(true);
                    this.measurementData.measurementText = getText("textarea_annotation");
                    if (this.measurementData.measurementText !== "") {
                        dicomViewer.measurement.setTempData(this.measurementData);
                    } else {
                        dicomViewer.measurement.setTempData(undefined);
                    }
                    this.measurementData = {
                        start: {
                            handleActive: false
                        },
                        end: {
                            handleActive: false
                        },
                        measureType: "rectangle",
                        measurementSubType: this.measurementSubType
                    };
                    this.activeImageRenderer.drawDicomImage(false);
                }
                dicomViewer.measurement.resetHandeler();
                if (isTextAreaVisible) {
                    document.body.removeChild(textArea);
                    isTextAreaVisible = false;
                    isEdited = false;
                }
            }
        }
    } catch (e) {}
};

/**
 * Handle the text area mousemove event 
 */
RectangleMeasurement.prototype.handleTextAreamousemove = function (evt) {
    this.tool.hanleMouseMove(evt, true);
}

/**
 * Handle the text area keydown event 
 */
RectangleMeasurement.prototype.handleTextAreakeydown = function (e) {
    var keyCode = e.keyCode;
    if (e.ctrlKey && e.keyCode == 13) {
        $('#textarea_annotation').val($('#textarea_annotation').val() + "\n");
    } else if (e.keyCode == 13 || e.keyCode == 27) {
        var dataToEdit = dicomViewer.measurement.getDataToEdit();
        if (dataToEdit != undefined) {
            this.tool.handleTextArea(this.tool.getEditRegion(), true);
        } else {
            this.tool.handleTextArea(this.tool.getRegion(), true);
        }
    }
}

RectangleMeasurement.prototype.getRegion = function (data) {
    try {
        var canvas = this.activeImageRenderer.getRenderWidget();
        var viewportRect = canvas.getBoundingClientRect();
        var viewportLeftOffset = (viewportRect.left < 0 ? 0 : viewportRect.left);
        var viewportTopOffset = (viewportRect.top < 0 ? 0 : viewportRect.top);

        var measureData = data;
        if (data === undefined) {
            measureData = this.measurementData;
        }

        var startPt = measureData.start;
        var endPt = measureData.end;
        var left = startPt.x + viewportLeftOffset;
        var top = startPt.y + viewportTopOffset;

        if (endPt.x < startPt.x) {
            left = endPt.x + viewportLeftOffset;
        }

        if (endPt.y < startPt.y) {
            top = endPt.y + viewportTopOffset;
        }

        var width = endPt.x - startPt.x;
        var height = endPt.y - startPt.y;
        if (endPt.x < startPt.x) {
            width = startPt.x - endPt.x;
        }
        if (endPt.y < startPt.y) {
            height = startPt.y - endPt.y;
        }

        return {
            left: left,
            top: top,
            width: width,
            height: height,
            text: ""
        };
    } catch (e) {}

    return undefined;
}

RectangleMeasurement.prototype.getEditRegion = function (editData, pt) {
    var region = {
        isPtInRegion: false
    };

    try {
        if (this.measurementSubType !== "text") {
            return region;
        }

        if (editData === undefined || editData.key === "") {
            return region;
        }

        var imageUids = editData.key.split("_");
        if (imageUids === undefined || imageUids === null || imageUids.length != 2) {
            return region;
        }

        var measurementData = dicomViewer.measurement.getRectangleMeasurements(imageUids[0], imageUids[1]);
        if (measurementData === undefined || measurementData === null) {
            return region;
        }

        measurementData = measurementData[editData.arryIndex];
        if (measurementData === undefined || measurementData === null) {
            return region;
        }

        // Get the image object to get the current presentation 
        var imageCanvas = null;
        this.activeImageRenderer.imagePromise.then(function (image) {
            imageCanvas = image;
        });

        // Calculate the image region with in the viewport region
        var canvas = this.activeImageRenderer.getRenderWidget();
        var viewportRect = canvas.getBoundingClientRect();
        var viewportLeftOffset = (viewportRect.left < 0 ? 0 : viewportRect.left);
        var viewportTopOffset = (viewportRect.top < 0 ? 0 : viewportRect.top);

        var context = this.activeImageRenderer.renderWidgetCtx;
        var presentation = this.activeImageRenderer.presentationState;
        var scaleFactor = presentation.getZoom();
        context.save();
        measurementData = dicomViewer.measurement.getImageDataForMouseData(measurementData, this.activeImageRenderer, context);
        measurementData = dicomViewer.measurement.getMouseDataForImageData(measurementData, this.activeImageRenderer, context);
        context.rotate(presentation.getRotation() * Math.PI / 180);
        if (presentation.isFlipHoriRequired()) {
            context.scale(-scaleFactor, scaleFactor);
        } else {
            context.scale(scaleFactor, scaleFactor);
        }

        measurementData = dicomViewer.measurement.getMouseDataForImageData(measurementData, this.activeImageRenderer, context);
        context.restore();

        var widthPos = (measurementData.end.x - measurementData.start.x);
        var heightPos = (measurementData.end.y - measurementData.start.y);
        if (measurementData.end.x < measurementData.start.x) {
            widthPos = measurementData.start.x - measurementData.end.x;
        }
        if (measurementData.end.y < measurementData.start.y) {
            heightPos = measurementData.start.y - measurementData.end.y;
        }

        var leftPos = measurementData.start.x;
        var topPos = measurementData.start.y;

        if (measurementData.end.x < measurementData.start.x) {
            leftPos = measurementData.end.x;
        }
        if (measurementData.end.y < measurementData.start.y) {
            topPos = measurementData.end.y;
        }

        var isPtInRegion = false;
        var left = ((leftPos) + viewportLeftOffset);
        var top = ((topPos) + viewportTopOffset);
        var width = widthPos;
        var height = heightPos;

        region = {
            left: left,
            top: top,
            width: width,
            height: height,
            isPtInRegion: isPtInRegion,
            text: measurementData.measurementText
        };
        measurementData = dicomViewer.measurement.getImageDataForMouseData(measurementData, this.activeImageRenderer, context);
        return region;
    } catch (e) {}

    return region;
}

/**
 * Check the mouse point is in edit region
 * @param {Type} editData - Specifies the text area id
 * @param {Type} pt - Specifies the point
 * @param {Type} isMove - Specifies the ismove flag
 */
RectangleMeasurement.prototype.isEditRegion = function (editData, pt, isMove) {
    var region = {
        isPtInRegion: false
    };

    try {
        if (this.measurementSubType !== "text") {
            return region;
        }

        if (editData === undefined || editData.key === "") {
            return region;
        }

        var imageUids = editData.key.split("_");
        if (imageUids === undefined || imageUids === null || imageUids.length != 2) {
            return region;
        }

        var measurementData = dicomViewer.measurement.getRectangleMeasurements(imageUids[0], imageUids[1]);
        if (measurementData === undefined || measurementData === null) {
            return region;
        }

        measurementData = measurementData[editData.arryIndex];
        if (measurementData === undefined || measurementData === null) {
            return region;
        }

        // Get the image object to get the current presentation 
        var imageCanvas = null;
        this.activeImageRenderer.imagePromise.then(function (image) {
            imageCanvas = image;
        });

        // Calculate the image region with in the viewport region
        var canvas = this.activeImageRenderer.getRenderWidget();
        var viewportRect = canvas.getBoundingClientRect();
        var viewportLeftOffset = (viewportRect.left < 0 ? 0 : viewportRect.left);
        var viewportTopOffset = (viewportRect.top < 0 ? 0 : viewportRect.top);

        var context = this.activeImageRenderer.renderWidgetCtx;
        var presentation = this.activeImageRenderer.presentationState;
        var scaleFactor = presentation.getZoom();
        context.save();
        // Rotate the image
        context.rotate(presentation.getRotation() * Math.PI / 180);
        if (presentation.isFlipHoriRequired()) {
            context.scale(-scaleFactor, scaleFactor);
        } else {
            context.scale(scaleFactor, scaleFactor);
        }
        measurementData.start = dicomViewer.measurement.draw.getMousePointForImageCoordinates(measurementData.start, this.activeImageRenderer, context);
        measurementData.end = dicomViewer.measurement.draw.getMousePointForImageCoordinates(measurementData.end, this.activeImageRenderer, context);

        var imageX = pt.x;
        var imageY = pt.y;

        var left = measurementData.start.x;
        var top = measurementData.start.y;
        var right = measurementData.end.x;
        var bottom = measurementData.end.y;

        left = (left > right) ? ((left + right) - (right = left)) : left;
        top = (top > bottom) ? ((top + bottom) - (bottom = top)) : top;
        var isPtInRegion = false;

        if ((imageX > left && imageX < right) && (imageY > top && imageY < bottom)) {
            isPtInRegion = true;
        }

        var width = (measurementData.end.x - measurementData.start.x);
        var height = (measurementData.end.y - measurementData.start.y);
        if (measurementData.end.x < measurementData.start.x) {
            width = measurementData.start.x - measurementData.end.x;
        }
        if (measurementData.end.y < measurementData.start.y) {
            height = measurementData.start.y - measurementData.end.y;
        }

        var left = measurementData.start.x;
        var top = measurementData.start.y;
        if (measurementData.end.x < measurementData.start.x) {
            left = measurementData.end.x;
        }
        if (measurementData.end.y < measurementData.start.y) {
            top = measurementData.end.y;
        }

        region = {
            left: ((left) + viewportLeftOffset),
            top: ((top) + viewportTopOffset),
            width: width,
            height: height,
            isPtInRegion: isPtInRegion,
            text: measurementData.measurementText
        };
        measurementData.start = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(measurementData.start, this.activeImageRenderer, context);
        measurementData.end = dicomViewer.measurement.draw.getImageCoordinatesForMousePoint(measurementData.end, this.activeImageRenderer, context);
        context.restore();

        return region;
    } catch (e) {}

    return region;
}

/**
 * Get the text area text
 * @param {Type} strTextAreaId - Specifies the text area id
 */
function getText(strTextAreaId) {
    var textArea = document.getElementById(strTextAreaId);
    return textArea.value.replace(new RegExp("\\n", "g"), "\n");
}
