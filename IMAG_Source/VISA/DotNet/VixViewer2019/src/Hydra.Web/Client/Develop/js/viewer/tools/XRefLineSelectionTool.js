/**
 * XRefLineSelectionTool Tool
 */
XRefLineSelectionTool.prototype = new MouseTool();
XRefLineSelectionTool.prototype.constructor = XRefLineSelectionTool;

/**
 * Constructor
 */
function XRefLineSelectionTool() {
    this.ToolType = "XRefLineSelectionTool";
    this.measurementData = {
        x: 0,
        y: 0
    };
}

/**
 * Mouse Down Event
 */
XRefLineSelectionTool.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    if (this.activeImageRenderer !== undefined && this.activeImageRenderer !== null) {
        if (evt.type === "mousedown" || evt.type === "touchstart") {
            var pt = this.hitTestAndGetMousePosition(evt);
            if (pt.isPtInRegion) {
                this.measurementData = pt;
            } else {
                this.isMousePressed = false;
            }
        }
    }

    evt.preventDefault();
};

/**
 * Mouse Up Event
 */
XRefLineSelectionTool.prototype.hanleMouseUp = function (evt) {
    if (this.isMousePressed === true) {
        this.findAndNavigateImage(evt);
        this.isMousePressed = false;
    }
};

/**
 * Find the shortest distance and navigate the corresponding image
 */
XRefLineSelectionTool.prototype.findAndNavigateImage = function (evt) {
    try {
        var allViewports = dicomViewer.viewports.getAllViewports();
        if (allViewports === null || allViewports === undefined) {
            return;
        }

        var layout = dicomViewer.getActiveSeriesLayout();
        var imageRenders = layout.getAllImageRenders();
        var sourceImageUid = undefined;
        var imageRenderer = undefined;
        var mouseData = this.measurementData;
        for (var iKey in imageRenders) {
            imageRenderer = imageRenders[iKey];
            sourceImageUid = imageRenderer.getImageUid();
            break;
        }

        if (imageRenderer === null ||
            imageRenderer === undefined ||
            sourceImageUid === null ||
            sourceImageUid === undefined) {
            return;
        }

        $.each(allViewports, function (key, value) {
            if (value.studyUid !== undefined &&
                value.studyUid === layout.studyUid &&
                value.seriesIndex !== undefined &&
                value.seriesIndex !== layout.seriesIndex) {

                var minDistance = undefined;
                var targetImageUid = undefined;
                var targetImageIndex = undefined;
                var imageIndex = 0;
                var images = dicomViewer.Series.getAllImages(value.studyUid, value.seriesIndex);

                images.forEach(function (image) {
                    var imageRefLine = dicomViewer.xRefLine.getRefLine(image.imageUid, sourceImageUid);
                    if (imageRefLine !== null && imageRefLine !== undefined) {
                        var scale = parseFloat(imageRenderer.scaleValue);
                        var x1 = imageRefLine.x1 * scale;
                        var y1 = imageRefLine.y1 * scale;
                        var x2 = imageRefLine.x2 * scale;
                        var y2 = imageRefLine.y2 * scale;
                        var x = (mouseData.x - mouseData.xOffset);
                        var y = (mouseData.y - mouseData.yOffset);

                        // Calculate the point distance and hold the shortest distance
                        var distance = getPtDistance(x, y, x1, y1, x2, y2);
                        if (minDistance === undefined) {
                            minDistance = Math.round(distance);
                            targetImageUid = image.imageUid;
                            targetImageIndex = imageIndex;
                        } else {
                            distance = Math.min(minDistance, distance);
                            if (Math.round(distance) !== Math.round(minDistance)) {
                                minDistance = Math.round(distance);
                                targetImageUid = image.imageUid;
                                targetImageIndex = imageIndex;
                            }
                        }

                        // Dump the output in console
                        var logMessage = "XrefLine => x1: " + x1 + " y1: " + y1 + " x2: " + x2 + " y2: " + y2;
                        logMessage += "\n distance => " + distance;
                        logMessage += "\n minDistance => " + minDistance;
                        dumpConsoleLogs(LL_DEBUG, undefined, "findAndNavigateImage", logMessage);
                    }
                    imageIndex++;
                });

                // Navigate the target image
                if (targetImageUid !== undefined && targetImageIndex !== undefined) {
                    dicomViewer.scroll.loadimages(value, value.seriesIndex, targetImageIndex, 0);

                    // Dump the output in console
                    var logMessage = "targetImageUid => " + targetImageUid;
                    logMessage += "\n targetImageIndex => " + targetImageIndex;
                    dumpConsoleLogs(LL_DEBUG, undefined, undefined, logMessage);
                }
            }
        });
    } catch (e) {}
};

/**
 * Get the distance
 * @param {Type} x - Specifies the mouse point X  
 * @param {Type} y - Specifies the mouse point Y
 * @param {Type} x1 - Specifies the Line point X1
 * @param {Type} y1 - Specifies the Line point Y1
 * @param {Type} x2 - Specifies the Line point X2
 * @param {Type} y2 - Specifies the Line point Y2
 */
function getPtDistance(x, y, x1, y1, x2, y2) {
    var A = x - x1;
    var B = y - y1;
    var C = x2 - x1;
    var D = y2 - y1;

    var dot = A * C + B * D;
    var len_sq = C * C + D * D;
    var param = -1;

    // In case of 0 length line
    if (len_sq != 0) {
        param = dot / len_sq;
    }

    var xx, yy;
    if (param < 0) {
        xx = x1;
        yy = y1;
    } else if (param > 1) {
        xx = x2;
        yy = y2;
    } else {
        xx = x1 + param * C;
        yy = y1 + param * D;
    }

    var dx = x - xx;
    var dy = y - yy;

    return Math.sqrt(dx * dx + dy * dy);
}
