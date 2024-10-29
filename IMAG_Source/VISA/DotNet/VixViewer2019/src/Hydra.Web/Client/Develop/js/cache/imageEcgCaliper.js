/**
 * Use to draw Vertical and horizontal caliper in ECG images
 **/
var dicomViewer = (function (dicomViewer) {
    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var isHorizontalCaliper = false;
    var isHorizontalLeftHandler = false;
    var isHorizontalRightHandler = false;
    var isHorizontalMove = true;
    var mousePreviousPosition = {
        x: 0,
        y: 0
    };

    var isVerticalCaliperStart = false;
    var isVerticalCaliperEnd = false;
    var isVerticalMove = true;
    var showCaliper = {};
    var showCaliperStatus = {};

    var isCaliperEnable = false;

    //horizontal caliper measuremnts unit
    var ms = undefined;
    var bpm = undefined;

    //vertical caliper measuremnts unit
    var uv = undefined;
    var mm = undefined;

    // Static values used for caliper calculation
    var mm_Per_Inch = 25.4;
    var Inch_Per_mm = 1.0 / mm_Per_Inch;
    var _mm_Per_GridLine = 5.0;

    //values saved in horizontal caliper based on the imageid(key)
    var horizontalCaliperValues = {};

    //values saved in vertical caliper based on the imageid(key)
    var verticalCaliperValues = {};

    /**
     * Get the Mouse position
     */
    function getMousePos(canvas, evt) {
        var rect = canvas.getBoundingClientRect();
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imgRender = activeSeriesLayout.getImageRender("ecgData");
        var scaleValue = imgRender.tempEcgScale; //getScaleValue();
        return {
            x: (evt.clientX - rect.left) / scaleValue,
            y: (evt.clientY - rect.top) / scaleValue
        };
    }

    /**
     * Draw the caliper on first click on the ECG image.
     */
    function initEcgCaliper() {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        var horizontalValues = getHorizontalCaliper(imageId);
        //check if the caliper value is already aviable for the particular image or not
        //If the value is not avilble horizontalValues is undefined
        if (horizontalValues === undefined) {
            var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
            var context = canvas.getContext('2d');

            canvas.addEventListener('mousedown', function (evt) {
                horizontalValues = getHorizontalCaliper(imageId);
                if (horizontalValues === undefined) {
                    drawVerticalCanvas(evt);
                    drawHorizontalCanvas(evt);
                }
            }, false);

            canvas.addEventListener('mouseup', function (evt) {
                if (activeSeriesLayout.isCaliperEnable) {
                    activeSeriesLayout.setCaliperEnable(false);

                    // Save the preference 
                    var imageRender = activeSeriesLayout.getImageRender("ecgData");
                    if (imageRender !== undefined) {
                        imageRender.applyOrRevertDisplaySettings(undefined, undefined, undefined, true);
                    }
                }
            }, false);

            $("#imageEcgCanvas" + activeSeriesLayout.getSeriesLayoutId()).mousemove(clickAndMove);
            //display caliper 
            setShowCaliper(imageId, true);
            setCaliperStatus(activeSeriesLayout.getSeriesLayoutId(), "visible");
        }
    }

    var clickAndMove = function (evt) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        if (!isShowcaliper(imageId)) {
            return;
        }
        var horizontalCaliper = getHorizontalCaliper(imageId);
        var verticalCaliper = getVerticalCaliper(imageId);
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var imageData = activeSeriesLayout.getEcgCanvas();
        var mousePosition = getMousePos(canvas, evt);

        if (horizontalCaliper === undefined || verticalCaliper === undefined) {
            return;
        }
        if (activeSeriesLayout.isCaliperEnable) {
            return;
        }

        if (evt.which == 1 && evt.buttons == 1) {
            if (isHorizontalCaliper) {
                if (isHorizontalLeftHandler) {
                    horizontalCaliper["centerLineStartX"] = mousePosition.x;
                    horizontalCaliper["centerLineEndX"] = horizontalCaliper["lastLineStartX"];

                    horizontalCaliper["firstLineStartX"] = mousePosition.x;
                    horizontalCaliper["firstLineEndX"] = mousePosition.x;

                    clearCurrentImage(context);
                    drawHorizontalCaliper(context, horizontalCaliper);
                    drawVerticalCaliper(context, verticalCaliper);
                } else if (isHorizontalRightHandler) {
                    horizontalCaliper["centerLineStartX"] = horizontalCaliper["firstLineStartX"];
                    horizontalCaliper["centerLineEndX"] = mousePosition.x;

                    horizontalCaliper["lastLineStartX"] = mousePosition.x;
                    horizontalCaliper["lastLineEndX"] = mousePosition.x;

                    clearCurrentImage(context);
                    drawHorizontalCaliper(context, horizontalCaliper);
                    drawVerticalCaliper(context, verticalCaliper);
                } else if (isHorizontalMove) {
                    var deltaPointX = mousePosition.x - mousePreviousPosition.x;
                    var deltaPointY = mousePosition.y - mousePreviousPosition.y;

                    horizontalCaliper["centerLineStartX"] = horizontalCaliper["centerLineStartX"] + deltaPointX;
                    horizontalCaliper["centerLineEndX"] = horizontalCaliper["centerLineEndX"] + deltaPointX;

                    horizontalCaliper["firstLineStartX"] = horizontalCaliper["firstLineStartX"] + deltaPointX;
                    horizontalCaliper["firstLineEndX"] = horizontalCaliper["firstLineEndX"] + deltaPointX;

                    horizontalCaliper["lastLineStartX"] = horizontalCaliper["lastLineStartX"] + deltaPointX;
                    horizontalCaliper["lastLineEndX"] = horizontalCaliper["lastLineEndX"] + deltaPointX;

                    horizontalCaliper["centerLineStartY"] = horizontalCaliper["centerLineStartY"] + deltaPointY;
                    horizontalCaliper["centerLineEndY"] = horizontalCaliper["centerLineEndY"] + deltaPointY;

                    horizontalCaliper["firstLineStartY"] = horizontalCaliper["firstLineStartY"] + deltaPointY;
                    horizontalCaliper["firstLineEndY"] = horizontalCaliper["firstLineEndY"] + deltaPointY;

                    horizontalCaliper["lastLineStartY"] = horizontalCaliper["lastLineStartY"] + deltaPointY;
                    horizontalCaliper["lastLineEndY"] = horizontalCaliper["lastLineEndY"] + deltaPointY;

                    clearCurrentImage(context);
                    drawHorizontalCaliper(context, horizontalCaliper);
                    drawVerticalCaliper(context, verticalCaliper);
                }
            } else if (isVerticalCaliperStart) {
                var mouseX = mousePosition.x;
                var mouseY = mousePosition.y;

                verticalCaliper["firstLineStartX"] = verticalCaliper["firstLineStartX"];
                verticalCaliper["firstLineStartY"] = mouseY;
                verticalCaliper["firstLineEndX"] = verticalCaliper["firstLineEndX"];
                verticalCaliper["firstLineEndY"] = mouseY;

                var secondYVertical = mouseY;

                verticalCaliper["centerLineStartY"] = secondYVertical;

                clearCurrentImage(context);
                drawVerticalCaliper(context, verticalCaliper);
                drawHorizontalCaliper(context, horizontalCaliper);
            } else if (isVerticalCaliperEnd) {
                var mouseX = mousePosition.x;
                var mouseY = mousePosition.y;

                verticalCaliper["centerLineEndY"] = mouseY;

                verticalCaliper["lastLineStartY"] = mouseY;
                verticalCaliper["lastLineEndY"] = mouseY;

                clearCurrentImage(context);
                drawVerticalCaliper(context, verticalCaliper);
                drawHorizontalCaliper(context, horizontalCaliper);
            } else if (isVerticalMove) {
                var deltaPointX = mousePosition.x - mousePreviousPosition.x;
                var deltaPointY = mousePosition.y - mousePreviousPosition.y;
                verticalCaliper["centerLineStartX"] = verticalCaliper["centerLineStartX"] + deltaPointX;
                verticalCaliper["centerLineEndX"] = verticalCaliper["centerLineEndX"] + deltaPointX;

                verticalCaliper["firstLineStartX"] = verticalCaliper["firstLineStartX"] + deltaPointX;
                verticalCaliper["firstLineEndX"] = verticalCaliper["firstLineEndX"] + deltaPointX;

                verticalCaliper["lastLineStartX"] = verticalCaliper["lastLineStartX"] + deltaPointX;
                verticalCaliper["lastLineEndX"] = verticalCaliper["lastLineEndX"] + deltaPointX;

                verticalCaliper["centerLineStartY"] = verticalCaliper["centerLineStartY"] + deltaPointY;
                verticalCaliper["centerLineEndY"] = verticalCaliper["centerLineEndY"] + deltaPointY;

                verticalCaliper["firstLineStartY"] = verticalCaliper["firstLineStartY"] + deltaPointY;
                verticalCaliper["firstLineEndY"] = verticalCaliper["firstLineEndY"] + deltaPointY;

                verticalCaliper["lastLineStartY"] = verticalCaliper["lastLineStartY"] + deltaPointY;
                verticalCaliper["lastLineEndY"] = verticalCaliper["lastLineEndY"] + deltaPointY;
            }
            clearCurrentImage(context);
            drawVerticalCaliper(context, verticalCaliper);
            drawHorizontalCaliper(context, horizontalCaliper);
        } else {
            isClickandMoveHorizontal(evt);
            if (!isHorizontalCaliper) {
                isClickandMoveVertical(evt);
            } else if (mouseInMidLine(evt) && !isHorizontalCaliper) {
                $('#viewport_View').css('cursor', 'move');
            } else if ((!isHorizontalCaliper)) {
                $('#viewport_View').css('cursor', 'default');
            }
        }

        mousePreviousPosition.x = mousePosition.x;
        mousePreviousPosition.y = mousePosition.y;
    };

    function mouseInMidLine(evt) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        var horizontalCaliper = getHorizontalCaliper(imageId);
        var verticalCaliper = getVerticalCaliper(imageId);

        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var mousePos = getMousePos(canvas, evt);
        var mouseX = mousePos.x;
        var mouseY = mousePos.y;
        if (calulateNearPoint(mouseY, horizontalCaliper["centerLineStartY"]) && (mouseX > horizontalCaliper["centerLineStartX"]) && (mouseX < horizontalCaliper["centerLineEndX"])) {
            return true;
        } else {
            return false;
        }
    }

    function drawHorizontalCanvas(evt) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var horizontalCaliper = {};
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var mousePos = getMousePos(canvas, evt);

        mousePos.x = mousePos.x - 60;
        mousePos.y = mousePos.y - 30;

        var scaleValue = getScaleValue();

        horizontalCaliper["centerLineStartX"] = mousePos.x - (50 / scaleValue);
        horizontalCaliper["centerLineStartY"] = mousePos.y;
        horizontalCaliper["centerLineEndX"] = mousePos.x + (50 / scaleValue);
        horizontalCaliper["centerLineEndY"] = mousePos.y;

        horizontalCaliper["firstLineStartX"] = mousePos.x - (50 / scaleValue);
        horizontalCaliper["firstLineStartY"] = mousePos.y - (12 / scaleValue);
        horizontalCaliper["firstLineEndX"] = mousePos.x - (50 / scaleValue);
        horizontalCaliper["firstLineEndY"] = mousePos.y + (70 / scaleValue);

        horizontalCaliper["lastLineStartX"] = mousePos.x + (50 / scaleValue);
        horizontalCaliper["lastLineStartY"] = mousePos.y - (12 / scaleValue);
        horizontalCaliper["lastLineEndX"] = mousePos.x + (50 / scaleValue);
        horizontalCaliper["lastLineEndY"] = mousePos.y + (70 / scaleValue);

        drawHorizontalCaliper(context, horizontalCaliper);
    }

    function drawVerticalCanvas(evt) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var verticalCaliper = {};

        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var mousePos = getMousePos(canvas, evt);

        var scaleValue = getScaleValue();
        verticalCaliper["firstLineStartX"] = mousePos.x + (9 / scaleValue);
        verticalCaliper["firstLineStartY"] = mousePos.y - (40 / scaleValue);
        verticalCaliper["firstLineEndX"] = mousePos.x + (90 / scaleValue);
        verticalCaliper["firstLineEndY"] = mousePos.y - (40 / scaleValue);

        verticalCaliper["centerLineStartX"] = mousePos.x + (80 / scaleValue);
        verticalCaliper["centerLineStartY"] = mousePos.y - (40 / scaleValue);
        verticalCaliper["centerLineEndX"] = mousePos.x + (80 / scaleValue);
        verticalCaliper["centerLineEndY"] = mousePos.y + (40 / scaleValue);

        verticalCaliper["lastLineStartX"] = mousePos.x + (9 / scaleValue);
        verticalCaliper["lastLineStartY"] = mousePos.y + (40 / scaleValue);
        verticalCaliper["lastLineEndX"] = mousePos.x + (90 / scaleValue);
        verticalCaliper["lastLineEndY"] = mousePos.y + (40 / scaleValue);

        drawVerticalCaliper(context, verticalCaliper);
    }

    function isClickandMoveHorizontal(evt) {
        isHorizontalCaliper = false;
        isHorizontalLeftHandler = false;
        isHorizontalRightHandler = false;
        isHorizontalMove = false;
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout)
        var horizontalCaliper = getHorizontalCaliper(imageId);
        var verticalCaliper = getVerticalCaliper(imageId);

        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var mousePos = getMousePos(canvas, evt);
        var mouseX = mousePos.x;
        var mouseY = mousePos.y;
        if (calulateNearPoint(horizontalCaliper["firstLineStartX"], mouseX) && (horizontalCaliper["firstLineStartY"] <= mouseY && horizontalCaliper["firstLineEndY"] >= mouseY)) {
            $('#viewport_View').css('cursor', 'e-resize');
            isHorizontalCaliper = true;
            isHorizontalLeftHandler = true;
        } else if (calulateNearPoint(horizontalCaliper["lastLineStartX"], mouseX) && (horizontalCaliper["lastLineStartY"] <= mouseY && horizontalCaliper["lastLineEndY"] >= mouseY)) {
            $('#viewport_View').css('cursor', 'e-resize');
            isHorizontalCaliper = true;
            isHorizontalRightHandler = true;
        } else if (calulateNearPoint(mouseY, horizontalCaliper["centerLineStartY"]) && ((mouseX >= horizontalCaliper["centerLineStartX"]) && (mouseX <= horizontalCaliper["centerLineEndX"]) || (mouseX <= horizontalCaliper["centerLineStartX"]) && (mouseX >= horizontalCaliper["centerLineEndX"]))) {
            $('#viewport_View').css('cursor', 'move');
            isHorizontalMove = true;
            isHorizontalCaliper = true;
        }
    }

    function isClickandMoveVertical(evt) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);

        var verticalCaliper = getVerticalCaliper(imageId);

        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var mousePos = getMousePos(canvas, evt);
        var mousePosX = mousePos.x;
        var mousePosY = mousePos.y;

        if (calulateNearPoint(mousePosY, verticalCaliper["firstLineStartY"]) && (mousePosX > verticalCaliper["firstLineStartX"]) && (mousePosX < verticalCaliper["firstLineEndX"])) {
            $('#viewport_View').css('cursor', 's-resize');
            isVerticalCaliperStart = true;
            isVerticalCaliperEnd = false;
            isVerticalMove = false;
        } else if (calulateNearPoint(mousePosY, verticalCaliper["lastLineStartY"]) && (mousePosX > verticalCaliper["lastLineStartX"]) && (mousePosX < verticalCaliper["lastLineEndX"])) {
            $('#viewport_View').css('cursor', 's-resize');
            isVerticalCaliperStart = false;
            isVerticalCaliperEnd = true;
            isVerticalMove = false;
        } else if (calulateNearPoint(mousePosX, verticalCaliper["centerLineStartX"]) && ((mousePosY > verticalCaliper["centerLineStartY"]) && (mousePosY < verticalCaliper["centerLineEndY"]) || (mousePosY < verticalCaliper["centerLineStartY"]) && (mousePosY > verticalCaliper["centerLineEndY"]))) {
            $('#viewport_View').css('cursor', 'move');
            isVerticalCaliperStart = false;
            isVerticalCaliperEnd = false;
            isVerticalMove = true;
        } else {
            isVerticalCaliperStart = false;
            isVerticalCaliperEnd = false;
            isVerticalMove = false;
            $('#viewport_View').css('cursor', 'default');
        }
    }

    function drawCaliper() {
        initEcgCaliper();
    }

    function calulateNearPoint(firstValue, secondValue) {
        var result;
        if (firstValue >= secondValue) {
            result = firstValue - secondValue;
        } else if (secondValue > firstValue) {
            result = secondValue - firstValue;
        }

        if (result <= 5) {
            return true;
        }
        return false;
    }

    /**
     *@param verticalCaliper
     *return the length of the vertical caliper
     */
    function getLengthOfVerticalCaliper(verticalCaliper) {
        var dx = Math.abs(verticalCaliper["centerLineStartX"] - verticalCaliper["centerLineEndX"]);
        var dy = Math.abs(verticalCaliper["centerLineStartY"] - verticalCaliper["centerLineEndY"]);

        var lengthInCM = getDistance(dx, dy);
        dumpConsoleLogs(LL_DEBUG, undefined, "getLengthOfVerticalCaliper", "Length : " + lengthInCM + "cm");
        return lengthInCM;
    }

    /**
     *@param horizontalCaliper
     *return the length of the horizontal caliper
     */
    function getLengthOfHorizontalCaliper(horizontalCaliper) {
        var dx = Math.abs(horizontalCaliper["centerLineStartX"] - horizontalCaliper["centerLineEndX"]);
        var dy = Math.abs(horizontalCaliper["centerLineStartY"] - horizontalCaliper["centerLineEndY"]);

        var lengthInCM = getDistance(dx, dy);
        dumpConsoleLogs(LL_DEBUG, undefined, "getLengthOfHorizontalCaliper", "Length : " + lengthInCM + "cm");
        return lengthInCM;
    }

    /**
     * Get the distance between two points in pixel.
     */
    function getDistance(firstPoint, secondPoint) {
        var x1MinusX2Square = Math.pow(firstPoint, 2.0);
        var y1MinusY2Square = Math.pow(secondPoint, 2.0);

        return Math.sqrt(x1MinusX2Square + y1MinusY2Square);
    }

    function getGain(gain) {
        switch (gain) {
            case 0:
                return 5.0;
            case 1:
                return 10.0;
            case 2:
                return 20.0;
            case 3:
                return 40.0;
            default:
                return 10.0;
        }
    }

    function overlayElement(lengthOfLine, isVertical) {
        var preferenceInfo = dicomViewer.getActiveSeriesLayout().preferenceInfo;
        var aScaleFactor = 1;

        var aGain = getGain(preferenceInfo.selectedEcgFormat.Gain);
        var aPtsDistance = lengthOfLine;
        var aDotsPerInchX = aScaleFactor * 100;
        var aDotsPerInchY = aScaleFactor * 100;
        var aGridCellWidth = Math.round((aDotsPerInchX * Inch_Per_mm) * _mm_Per_GridLine);
        var aGridCellHeight = Math.round((aDotsPerInchY * Inch_Per_mm) * _mm_Per_GridLine);
        var aTotalMillimeters = (aPtsDistance / aGridCellWidth) * _mm_Per_GridLine;
        var grid200PercentCellWidth = 40; // Initialize the cell grid size for 200%

        if (isVertical) {
            var aStandardGain = 10.0;
            var aMillimeterPeruV = 100.0;
            var aAverageGain = (aStandardGain / aGain);
            var aMilliMeter = (aAverageGain * aTotalMillimeters);

            if (aMilliMeter == 0) {
                aMilliMeter = 0.1;
            }

            var aTotaluV = (aMilliMeter * aMillimeterPeruV);
            mm = aMilliMeter;
            uv = Math.round(aTotaluV);
            var logMessage = "Millimeter => " + mm + "\n \
                              Total volts => " + uv;
            dumpConsoleLogs(LL_DEBUG, "Vertical caliper measurement units", "overlayElement", logMessage);
        } else {
            var aTotalMilliSecond = aTotalMillimeters * grid200PercentCellWidth;
            if (aTotalMilliSecond == 0) {
                aTotalMilliSecond = 1;
            }
            var aBeatsPerMinute = 60000;
            var aTotalBreatsPerMinute = aBeatsPerMinute / aTotalMilliSecond;

            bpm = Math.round(aTotalBreatsPerMinute);
            ms = Math.round(aTotalMilliSecond);

            var logMessage = "Beats per minute => " + bpm + "\n \
                              Total milliseconds => " + ms;
            dumpConsoleLogs(LL_DEBUG, "Horizontal caliper measurement units", "overlayElement", logMessage);
        }
    }

    function horizonatlMeasurementText(context) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        var horizontalCaliper = getHorizontalCaliper(imageId);

        context.font = '12pt Calibri';
        context.textAlign = 'center';
        context.textAlign = 'center';

        if (activeSeriesLayout.preferenceInfo.preferenceData.gridColor === 'greyGrid') {
            context.fillStyle = 'white';
        } else {
            context.fillStyle = 'blue';
        }

        /*
         *Identify the middle point of stright straight line
         * MidPoint = (x+x1)/2,(y+y1)/2
         */
        var middlePointOfXaxis = (horizontalCaliper["centerLineStartX"] + horizontalCaliper["centerLineEndX"]) / 2;
        var middlePointOfYaxis = (horizontalCaliper["centerLineStartY"] + horizontalCaliper["centerLineEndY"]) / 2;

        context.fillText(ms + ' ms', middlePointOfXaxis - 5, middlePointOfYaxis - 30);
        context.fillText(bpm + ' BPM', middlePointOfXaxis - 5, middlePointOfYaxis - 10);
    }

    function verticalMeasurementText(context) {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = activeSeriesLayout.getImageRender("ecgData").getImageUid();
        var verticalCaliper = getVerticalCaliper(imageId); /*activeSeriesLayout.verticalCaliper;*/

        context.font = '12pt Calibri';
        context.textAlign = 'left';

        if (activeSeriesLayout.preferenceInfo.preferenceData.gridColor === 'greyGrid') {
            context.fillStyle = 'white';
        } else {
            context.fillStyle = 'blue';
        }

        /*
         *Identify the middle point of stright straight line
         * MidPoint = (x+x1)/2,(y+y1)/2
         */
        var middlePointOfXaxis = (verticalCaliper["centerLineStartX"] + verticalCaliper["centerLineEndX"]) / 2;
        var middlePointOfYaxis = (verticalCaliper["centerLineStartY"] + verticalCaliper["centerLineEndY"]) / 2;

        context.fillText(mm.toFixed(2) + ' mm', middlePointOfXaxis + 10, middlePointOfYaxis);
        context.fillText(uv + ' uv', middlePointOfXaxis + 10, middlePointOfYaxis + 20);

    }

    function drawHorizontalCaliper(context, horizontalCaliper) {
        context.moveTo(horizontalCaliper["centerLineStartX"], horizontalCaliper["centerLineStartY"]);
        context.lineTo(horizontalCaliper["centerLineEndX"], horizontalCaliper["centerLineEndY"]);

        context.moveTo(horizontalCaliper["firstLineStartX"], horizontalCaliper["firstLineStartY"]);
        context.lineTo(horizontalCaliper["firstLineEndX"], horizontalCaliper["firstLineEndY"]);

        context.moveTo(horizontalCaliper["lastLineStartX"], horizontalCaliper["lastLineStartY"]);
        context.lineTo(horizontalCaliper["lastLineEndX"], horizontalCaliper["lastLineEndY"]);

        if (dicomViewer.getActiveSeriesLayout().preferenceInfo.preferenceData.gridColor === 'greyGrid') {
            context.strokeStyle = 'white';
        } else {
            context.strokeStyle = 'blue';
        }

        context.stroke();

        var imageId = getImageIdFromSeriesLayout(dicomViewer.getActiveSeriesLayout());
        setHorizontalCaliper(imageId, horizontalCaliper);

        var length = getLengthOfHorizontalCaliper(horizontalCaliper);
        overlayElement(length, false);
        horizonatlMeasurementText(context);
    }

    function drawVerticalCaliper(context, verticalCaliper) {
        context.moveTo(verticalCaliper["firstLineStartX"], verticalCaliper["firstLineStartY"]);
        context.lineTo(verticalCaliper["firstLineEndX"], verticalCaliper["firstLineEndY"]);

        context.moveTo(verticalCaliper["centerLineStartX"], verticalCaliper["centerLineStartY"]);
        context.lineTo(verticalCaliper["centerLineEndX"], verticalCaliper["centerLineEndY"]);

        context.moveTo(verticalCaliper["lastLineStartX"], verticalCaliper["lastLineStartY"]);
        context.lineTo(verticalCaliper["lastLineEndX"], verticalCaliper["lastLineEndY"]);

        if (dicomViewer.getActiveSeriesLayout().preferenceInfo.preferenceData.gridColor === 'greyGrid') {
            context.strokeStyle = 'white';
        } else {
            context.strokeStyle = 'blue';
        }
        context.stroke();

        var imageId = getImageIdFromSeriesLayout(dicomViewer.getActiveSeriesLayout());
        setVerticalCaliper(imageId, verticalCaliper);

        var length = getLengthOfVerticalCaliper(verticalCaliper);
        overlayElement(length, true);
        verticalMeasurementText(context);
    }

    function redrawBothCaliper(activeSeriesLayout) {
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        if (dicomViewer.isShowcaliper(imageId)) {
            clearCurrentImage(context);
            drawHorizontalCaliper(context, getHorizontalCaliper(imageId));
            drawVerticalCaliper(context, getVerticalCaliper(imageId));
            setCaliperStatus(activeSeriesLayout.getSeriesLayoutId(), "visible");
        }
        $("#imageEcgCanvas" + activeSeriesLayout.getSeriesLayoutId()).mousemove(clickAndMove);
    }

    function clearCurrentImage(context) {
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
        var imageData = dicomViewer.getActiveSeriesLayout().getEcgCanvas();
        context.putImageData(imageData, 0, 0);
        context.beginPath();
    }

    /**
     *@param seriesLayout
     * retun the image id from the series layout
     */
    function getImageIdFromSeriesLayout(seriesLayout) {
        if (seriesLayout === null || seriesLayout === undefined) {
            throw "seriesLayout cannot be null or undefined"
        }
        return seriesLayout.getImageRender("ecgData").getImageUid();
    }

    function getScaleValue() {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');

        var imageRenderer = activeSeriesLayout.getImageRender("ecgData");

        var scaleValue = imageRenderer.getZoomLevel();
        if (scaleValue === undefined || scaleValue === null || scaleValue === Infinity) {
            scaleValue = 1;
        }
        return scaleValue;
    }

    function hideCaliper() {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        //hide caliper
        setShowCaliper(imageId, false);
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        clearCurrentImage(context);
        setCaliperStatus(activeSeriesLayout.getSeriesLayoutId(), "invisible");
        $('#viewport_View').css('cursor', 'default');
    }

    function displayCaliper() {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imageId = getImageIdFromSeriesLayout(activeSeriesLayout);
        //display caliper
        setShowCaliper(imageId, true);
        var canvas = document.getElementById('imageEcgCanvas' + activeSeriesLayout.getSeriesLayoutId());
        var context = canvas.getContext('2d');
        clearCurrentImage(context);
        drawHorizontalCaliper(context, getHorizontalCaliper(imageId));
        drawVerticalCaliper(context, getVerticalCaliper(imageId));
        setCaliperStatus(activeSeriesLayout.getSeriesLayoutId(), "visible");
    }

    /**
     *@param imageId
     *@param value
     * save the horizontal caliper values to draw in the ecg canvas based on the image Id
     */
    function setHorizontalCaliper(imageId, values) {
        horizontalCaliperValues[imageId] = values;
    }

    /**
     *@param imageId
     *@param value
     * save the vertical caliper values to draw in the ecg canvas based on the image Id
     */
    function setVerticalCaliper(imageId, values) {

        verticalCaliperValues[imageId] = values;
    }

    /**
     *@param imageId
     * Retrive the horizontal caliper values based on the imageId
     */
    function getHorizontalCaliper(imageId) {

        return horizontalCaliperValues[imageId];
    }

    /**
     *@param imageId
     *Retrive the Vertical caliper values based on the imageId
     */
    function getVerticalCaliper(imageId) {

        return verticalCaliperValues[imageId];
    }

    function setShowCaliper(imageId, flag) {
        showCaliper[imageId] = flag;
    }

    function isShowcaliper(imageId) {
        return showCaliper[imageId];
    }

    function setCaliperStatus(layoutID, status) {
        showCaliperStatus[layoutID] = status;
    }

    function getCaliperStatus(layoutID) {
        return showCaliperStatus[layoutID];
    }

    function removeAllCaliperStatus() {
        for (var key in showCaliperStatus) {
            delete showCaliperStatus[key];
        }
    }

    /**
     * Revert the applied horizontal and vertical caliper values
     */
    function RevertCaliper() {
        var imageId = getImageIdFromSeriesLayout(dicomViewer.getActiveSeriesLayout());
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var imgRenderer = activeSeriesLayout.getImageRender("ecgData");
        if (imgRenderer !== undefined) {
            setHorizontalCaliper(imageId, undefined);
            setVerticalCaliper(imageId, undefined);
            setShowCaliper(imageId, false);
            setCaliperStatus(activeSeriesLayout.seriesLayoutId, undefined);
        }
    }

    /**
     * Print the horizontal/vertical caliper
     * @param {Type} context - specifies the print context
     * @param {Type} imageUid - specifies the image Uid
     */
    function printCaliper(context, imageUid) {
        try {
            var horizontalCaliper = getHorizontalCaliper(imageUid);
            var verticalCaliper = getVerticalCaliper(imageUid);
            if (horizontalCaliper && verticalCaliper) {
                drawHorizontalCaliper(context, horizontalCaliper);
                drawVerticalCaliper(context, verticalCaliper);
            }
        } catch (e) {}
    }

    dicomViewer.drawCaliper = drawCaliper;
    dicomViewer.redrawBothCaliper = redrawBothCaliper;
    dicomViewer.getHorizontalCaliper = getHorizontalCaliper;
    dicomViewer.isShowcaliper = isShowcaliper;
    dicomViewer.hideCaliper = hideCaliper;
    dicomViewer.displayCaliper = displayCaliper;
    dicomViewer.removeAllCaliperStatus = removeAllCaliperStatus;
    dicomViewer.getCaliperStatus = getCaliperStatus;
    dicomViewer.RevertCaliper = RevertCaliper;
    dicomViewer.printCaliper = printCaliper;
    return dicomViewer;
}(dicomViewer));
