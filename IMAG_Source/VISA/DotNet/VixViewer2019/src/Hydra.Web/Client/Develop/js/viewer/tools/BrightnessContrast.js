Brightness.prototype = new MouseTool();
Brightness.prototype.constructor = Brightness;

function Brightness() {
    this.mouseDrag = {
        start: {},
        end: {}
    }
    this.previousPos = {};

    this.startLevel = 0;
    this.startWindow = 0;
    this.minBrightnessValue = 0;
    this.maxBrightnessValue = 500;
    this.minContrastValue = 0;
    this.maxContrastValue = 500;
}

Brightness.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        var presentation = imageRenderer.getPresentation();
        if (presentation) {
            var imageCanvas = null;
            imageRenderer.imagePromise.then(function (image) {
                imageCanvas = image;
            });
            this.startWindow = presentation.getWindowWidth();
            this.startLevel = presentation.getWindowCenter();
            var offset = imageRenderer.locationOnScreen();
            if (evt.type === "mousedown") {
                this.mouseDrag.start.x = evt.pageX - offset.x;
                this.mouseDrag.start.y = evt.pageY - offset.y;
                this.previousPos = this.mouseDrag.start;
            } else if (evt.type === "touchstart") {
                evt.preventDefault();
                var touch = evt.touches[0];
                this.mouseDrag.start.x = touch.pageX - offset.x;
                this.mouseDrag.start.y = touch.pageY - offset.y;
                this.previousPos = this.mouseDrag.start;
            }
        }
    }
};

Brightness.prototype.hanleMouseMove = function (evt) {
    var activeSeries = dicomViewer.getActiveSeriesLayout();
    if (!activeSeries) {
        return;
    }
    if (dicomViewer.scroll.isCineRunning(activeSeries.getSeriesLayoutId())) {
        return;
    }

    var currentPos = {};
    var imageRenderer = this.activeImageRenderer;
    if (this.isMousePressed && imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        var presentation = imageRenderer.getPresentation();
        if (presentation) {
            var offset = imageRenderer.locationOnScreen();
            if (evt.type === "mousemove") {
                currentPos.x = (evt.pageX - offset.x);
                currentPos.y = (evt.pageY - offset.y);
            } else if (evt.type === "touchmove") {
                evt.preventDefault();
                if (evt.touches.length == 1) {
                    var touch = evt.touches[0];
                    currentPos.x = (touch.pageX - offset.x);
                    currentPos.y = (touch.pageY - offset.y);
                }
            }

            var diffX = 0,
                diffY = 0;
            if (currentPos.x > this.previousPos.x) {
                diffX = -(Math.abs(this.previousPos.x - currentPos.x));
            }
            if (currentPos.x < this.previousPos.x) {
                diffX = (Math.abs(this.previousPos.x - currentPos.x));
            }
            if (currentPos.y > this.previousPos.y) {
                diffY = -(Math.abs(this.previousPos.y - currentPos.y));
            }
            if (currentPos.y < this.previousPos.y) {
                diffY = (Math.abs(this.previousPos.y - currentPos.y));
            }

            if (diffX == 0 && diffY == 0) {
                return;
            }

            var mouseRegion = this.hitTestAndGetMousePosition(evt);
            if (!mouseRegion) {
                return;
            }

            if (mouseRegion.isPtInRegion) {
                this.updateBrightness(diffX, diffY, imageRenderer);
            }
        }
    }
};

Brightness.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
};

Brightness.prototype.hanleMouseOut = function (evt) {
    this.isMousePressed = false;
};

/**
 * Update the brightness values
 * @param {Type} image - Specifies the image
 */
Brightness.prototype.updateBrightness = function (diffX, diffY, imageRender) {
    var presentation = imageRender.getPresentation();

    var incrBrightness = false,
        incrContrast = false;
    if (diffX == 0 && diffY > 0) {
        incrBrightness = true;
    } else if (diffX < 0 && diffY == 0) {
        incrContrast = true;
    } else if (diffX > 0 && diffY > 0) {
        incrBrightness = true;
    } else if (diffX < 0 && diffY > 0) {
        incrBrightness = true;
        incrContrast = true;
    } else if (diffX < 0 && diffY < 0) {
        incrContrast = true;
    }

    if (incrBrightness) {
        presentation.brightness += 4;
    } else {
        presentation.brightness -= 4;
    }

    if (incrContrast) {
        presentation.contrast += 4;
    } else {
        presentation.contrast -= 4;
    }

    if (this.minBrightnessValue > presentation.brightness) {
        presentation.brightness = this.minBrightnessValue;
    } else if (this.maxBrightnessValue < presentation.brightness) {
        presentation.brightness = this.maxBrightnessValue;
    }

    if (this.minContrastValue > presentation.contrast) {
        presentation.contrast = this.minContrastValue;
    } else if (this.maxContrastValue < presentation.contrast) {
        presentation.contrast = this.maxContrastValue;
    }

    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
        var imageLevelId = $(this).attr('id');
        var imageRender = seriesLayout.getImageRender(imageLevelId);
        if (imageRender) {
            imageRender.doBrightnessContrast(presentation.brightness, presentation.contrast, true);
        }
    });
};
