var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var isRefLineEnabled = true;

    function updateXRefLine(imageRenderer, actualDC, presentation) {
        //Gets the active viewport
        var layout = dicomViewer.getActiveSeriesLayout();
        var isScoutLineVisible = dicomViewer.tools.isScoutLineVisible();
        //Get all image renderer 
        var imageRenders = layout.getAllImageRenders();
        var sourceImageUid = undefined;
        for (var iKey in imageRenders) {
            var activeLayoutId = layout.getSeriesLayoutId();
            if (imageRenders[iKey].parentElement.indexOf(activeLayoutId) != -1) {
                sourceImageUid = imageRenders[iKey].getImageUid();
                break;
            }
        }
        var targetImageUid = imageRenderer.getImageUid();
        var refLine = dicomViewer.xRefLine.getRefLine(sourceImageUid, targetImageUid);
        if (refLine === undefined) {
            return;
        } else if (isScoutLineVisible) {
            var start = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates({
                x: refLine.x1,
                y: refLine.y1
            }, imageRenderer);
            var end = dicomViewer.measurement.draw.getCanvasCoordinatesForImageCoordinates({
                x: refLine.x2,
                y: refLine.y2
            }, imageRenderer);
            var scale = presentation.getZoom();

            var scoutLineStyle = dicomViewer.measurement.draw.getScoutLineStyle();
            actualDC.strokeStyle = scoutLineStyle.lineColor; // line color
            var fontStyle = "normal";
            if (scoutLineStyle.isItalic && scoutLineStyle.isBold) {
                fontStyle = "italic bold";
            } else if (scoutLineStyle.isItalic) {
                fontStyle = "italic";
            }
            if (scoutLineStyle.isBold) {
                fontStyle = "bold";
            }
            actualDC.font = fontStyle + " " + (scoutLineStyle.fontSize / imageRenderer.scaleValue) + "px" + " " + scoutLineStyle.fontName;
            actualDC.lineWidth = scoutLineStyle.lineWidth / imageRenderer.scaleValue;
            actualDC.beginPath();
            actualDC.moveTo(start.x, start.y);
            actualDC.lineTo(end.x, end.y);
            actualDC.setLineDash([]);
            actualDC.closePath();
            actualDC.stroke();
        }
    }

    dicomViewer.refLine = {
        updateXRefLine: updateXRefLine
    };


    return dicomViewer;
}(dicomViewer));
