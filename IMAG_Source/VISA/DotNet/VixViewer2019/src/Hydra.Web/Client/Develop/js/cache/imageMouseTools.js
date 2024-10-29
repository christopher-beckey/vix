/*
 * Mouse Tools Manager
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var mouseTools = {
        pan: new Pan(),
        zoom: new ZoomTool(),
        windowLevel: new WindowLevel(),
        lineMeasure: new LineMeasurement(),
        traceMeasure: new TraceMeasurement(),
        volumeMeasure: new VolumeMeasurement(),
        pointMeasure: new PointMeasurement(),
        mitralMeanGradientMeasure: new MitralMeanGradientMeasurement(),
        angleMeasure: new AngleMeasurementTool(),
        ellipseMeasure: new EllipseMeasurement(),
        rectangleMeasure: new RectangleMeasurement(),
        defaultTool: new DefaultTool(),
        windowLevelROI: new WindowLevelROI(),
        xRefLineSelectionTool: new XRefLineSelectionTool(),
        link: new LinkTool(),
        sharpen: new SharpenTool(),
        pen: new PenTool(),
        brightness: new Brightness(),
        copyAttributes: new CopyAttributes()
    };

    var activeTool = mouseTools.windowLevel;

    var previousTool = undefined;

    var previousCursor = "default";

    var toolName = "WindowLevel";

    function getActiveTool() {
        return activeTool;
    }

    function setActiveTool(tool) {
        if (tool === undefined) {
            throw "active tool is null/undefined";
        }
        activeTool = tool;
    }

    /**
     * Set the current image tool as backup(previous)
     * @param {Type} tool - current tool
     */
    function setPreviousTool(tool) {
        if (tool === undefined) {
            throw "previous tool is null/undefined";
        }
        previousTool = tool;
    }

    /**
     * Return the previously selected tool
     */
    function getPreviousTool() {
        return previousTool;
    }

    /**
     * Set the current cursor value as backup(previous)
     * @param {Type} cursor - current cursor
     */
    function setCursor(cursor) {
        previousCursor = cursor;
    }

    /**
     * Get the cursor value
     * @param {Type} active(1/undefined)
     * 1 -> return the current cursor value; undefined -> return the previous cursor value
     */
    function getToolCursor(active) {
        if (active) {
            return $("#viewport_View")[0].style.cursor;
        } else {
            return previousCursor;
        }
    }

    function getWindowTool() {
        toolName = TOOLNAME_WINDOWLEVEL;
        return mouseTools.windowLevel;
    }

    function getDefaultTool() {
        toolName = TOOLNAME_DEFAULTTOOL;
        return mouseTools.defaultTool;
    }

    function getPanTool() {
        toolName = TOOLNAME_PAN;
        return mouseTools.pan;
    }

    function getZoomTool() {
        toolName = TOOLNAME_ZOOM;
        return mouseTools.zoom;
    }

    function getLinkTool() {
        toolName = TOOLNAME_LINK;
        return mouseTools.link;
    }

    function get2DLengthMeasureTool(typeId, measurementSubtype) {
        if (typeId == 1) {
            $('#viewport_View').css('cursor', 'url(images/mitrallength.cur), auto');
        } else if (typeId == 2) {
            $('#viewport_View').css('cursor', 'url(images/aorticlength.cur), auto');
        } else if (typeId == 3) {
            $('#viewport_View').css('cursor', 'url(images/mitralthickness.cur), auto');
        } else if (typeId == 4) {
            $('#viewport_View').css('cursor', 'url(images/annotateline.cur), auto');
        } else if (typeId == 5) {
            $('#viewport_View').css('cursor', 'url(images/annotatearrow.cur), auto');
        } else {
            $('#viewport_View').css('cursor', 'url(images/measurelength.cur), auto');
        }
        toolName = "lineMeasurement";
        if (measurementSubtype != undefined && measurementSubtype != null) {
            mouseTools.lineMeasure.measurementData.measurementSubType = measurementSubtype;
        }
        return mouseTools.lineMeasure;
    }

    function get2DLengthCalibrationTool() {
        $('#viewport_View').css('cursor', 'url(images/calibrate.cur), auto');
        toolName = "lineMeasurement";
        return mouseTools.lineMeasure;
    }

    function get2DPointMeasureTool(typeId, measurementSubtype) {
        if (typeId == 1) {
            $('#viewport_View').css('cursor', 'url(images/mitralvelocity.cur), auto');
        } else if (typeId == 2) {
            $('#viewport_View').css('cursor', 'url(images/aorticregurgitationvelocity.cur), auto');
        } else if (typeId == 3) {
            $('#viewport_View').css('cursor', 'url(images/aorticstenosisvelocity.cur), auto');
        } else {
            $('#viewport_View').css('cursor', 'url(images/probe.cur), auto');
        }
        toolName = "pointMeasurement";
        if (measurementSubtype != undefined && measurementSubtype != null) {
            mouseTools.pointMeasure.measurementData.measurementSubType = measurementSubtype;
        }
        return mouseTools.pointMeasure;
    }

    function getTraceMeasureTool() {
        $('#viewport_View').css('cursor', 'url(images/trace.cur), auto');
        toolName = "traceMeasurement";
        return mouseTools.traceMeasure;
    }

    function getVolumeMeasureTool() {
        $('#viewport_View').css('cursor', 'url(images/volume.cur), auto');
        toolName = "volumeMeasurement";
        return mouseTools.volumeMeasure;
    }

    function getMitralMeanGradientMeasureTool(typeId, measurementSubtype) {
        if (typeId == 1) {
            $('#viewport_View').css('cursor', 'url(images/annotatefreehand.cur), auto');
        } else {
            $('#viewport_View').css('cursor', 'url(images/mitralgradient.cur), auto');
        }
        toolName = "mitralMeanGradientMeasurement";
        if (measurementSubtype != undefined && measurementSubtype != null) {
            mouseTools.mitralMeanGradientMeasure.measurementData.measurementSubType = measurementSubtype;
        }
        return mouseTools.mitralMeanGradientMeasure;
    }

    function getAngleMeasureTool() {
        $('#viewport_View').css('cursor', 'url(images/angle.cur), auto');
        toolName = "angleMeasurement";
        return mouseTools.angleMeasure;
    }

    function getEllipseMeasureTool(typeId, measurementSubtype) {
        if (typeId == 1) {
            $('#viewport_View').css('cursor', 'url(images/annotateellipse.cur), auto');
        } else {
            $('#viewport_View').css('cursor', 'url(images/ellipse.cur), auto');
        }
        toolName = "ellipseMeasurement";
        if (measurementSubtype != undefined && measurementSubtype != null) {
            mouseTools.ellipseMeasure.measurementData.measurementSubType = measurementSubtype;
        }
        return mouseTools.ellipseMeasure;
    }

    function getRectangleMeasureTool(typeId, measurementSubtype) {
        if (typeId == 1) {
            $('#viewport_View').css('cursor', 'url(images/annotaterectangle.cur), auto');
        } else if (typeId == 2) {
            $('#viewport_View').css('cursor', 'url(images/annotatetext.cur), auto');
        } else {
            $('#viewport_View').css('cursor', 'url(images/rectangle.cur), auto');
        }
        toolName = "rectangleMeasurement";
        if (measurementSubtype != undefined && measurementSubtype != null) {
            mouseTools.rectangleMeasure.measurementData.measurementSubType = measurementSubtype;
        }
        return mouseTools.rectangleMeasure;
    }

    function getToolName() {
        return toolName;
    }

    function setToolName(tool) {
        toolName = tool;
    }

    function getWindowToolROI() {
        $('#viewport_View').css('cursor', 'url(images/AutoWindowLevel.cur), auto');
        toolName = TOOLNAME_WINDOWLEVEL_ROI;
        return mouseTools.windowLevelROI;
    }

    function getXRefLineSelectionTool() {
        $('#viewport_View').css('cursor', 'url(images/XRefline.cur), auto');
        toolName = TOOLNAME_XREFLINESELECTIONTOOL;
        return mouseTools.xRefLineSelectionTool;
    }

    function getSharpenTool() {
        $('#viewport_View').css('cursor', 'url(images/sharpen.cur), auto');
        toolName = TOOLNAME_SHARPENTOOL;
        return mouseTools.sharpen;
    }

    /**
     * 
     * get the pentool cursor details
     */
    function getPenTool() {
        $('#viewport_View').css('cursor', 'url(images/pen.cur), auto');
        toolName = TOOLNAME_PEN;
        return mouseTools.pen;
    }

    /**
     * 
     * get the brightness cursor details
     */
    function getBrightnessContrastTool() {
        toolName = TOOLNAME_WINDOWLEVEL;
        return mouseTools.brightness;
    }

    /**
     * 
     * Get the Copy Attributes
     */
    function getCopyAttributesTool() {
        $('#viewport_View').css('cursor', 'url(images/copyAttribute.cur), auto');
        toolName = TOOLNAME_COPYATTRIBUTES;
        return mouseTools.copyAttributes;
    }

    dicomViewer.mouseTools = {
        getActiveTool: getActiveTool,
        setActiveTool: setActiveTool,
        getPreviousTool: getPreviousTool,
        setPreviousTool: setPreviousTool,
        getToolCursor: getToolCursor,
        setCursor: setCursor,
        getWindowTool: getWindowTool,
        getPanTool: getPanTool,
        getZoomTool: getZoomTool,
        get2DLengthMeasureTool: get2DLengthMeasureTool,
        get2DPointMeasureTool: get2DPointMeasureTool,
        getTraceMeasureTool: getTraceMeasureTool,
        getVolumeMeasureTool: getVolumeMeasureTool,
        getToolName: getToolName,
        getMitralMeanGradientMeasureTool: getMitralMeanGradientMeasureTool,
        getAngleMeasureTool: getAngleMeasureTool,
        get2DLengthCalibrationTool: get2DLengthCalibrationTool,
        getEllipseMeasureTool: getEllipseMeasureTool,
        getRectangleMeasureTool: getRectangleMeasureTool,
        getDefaultTool: getDefaultTool,
        getWindowToolROI: getWindowToolROI,
        getXRefLineSelectionTool: getXRefLineSelectionTool,
        getLinkTool: getLinkTool,
        setToolName: setToolName,
        getSharpenTool: getSharpenTool,
        getPenTool: getPenTool,
        getBrightnessContrastTool: getBrightnessContrastTool,
        getCopyAttributesTool: getCopyAttributesTool
    };

    return dicomViewer;

}(dicomViewer));
