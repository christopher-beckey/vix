var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    function drawUSRegions(context, imageInfo, presentation) {
        var usRegions = imageInfo.getUSRegions();
        if (usRegions === undefined) {
            return;
        }
        for (var i = 0; i < usRegions.length; i++) {
            drawRegions(context, usRegions[i], presentation);
        }
    }

    function drawRegions(context, region, presentation) {
        var cordinates = getRegionCordinatesInCanvas(region, presentation);

        context.beginPath();
        context.rect(cordinates.x0, cordinates.y0, (cordinates.x1 - cordinates.x0), (cordinates.y1 - cordinates.y0));
        context.lineWidth = 1 / presentation.getZoom();
        context.strokeStyle = 'blue';
        context.setLineDash([15]);
        context.stroke();
    }

    function getRegionCordinatesInCanvas(region, presentation) {
        if (presentation === undefined) {
            throw "getRegionCordinatesInCanvas: presentation is null/undefined";
        }
        var pan = presentation.getPan();
        var canvasCoordinates = {};
        canvasCoordinates.x0 = region.regionLocationMinX0 + pan.x;
        canvasCoordinates.x1 = region.regionLocationMaxX1 + pan.x;
        canvasCoordinates.y0 = region.regionLocationMinY0 + pan.y;
        canvasCoordinates.y1 = region.regionLocationMaxY1 + pan.y;

        return canvasCoordinates;
    }

    dicomViewer.draw = {
        usRegion: {
            drawUSRegions: drawUSRegions,
            drawRegions: drawRegions
        }
    };

    return dicomViewer;

}(dicomViewer));
