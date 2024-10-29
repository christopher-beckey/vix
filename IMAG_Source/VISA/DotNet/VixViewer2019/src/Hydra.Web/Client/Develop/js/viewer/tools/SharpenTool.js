SharpenTool.prototype = new MouseTool();
SharpenTool.prototype.constructor = SharpenTool;

/**
 * Constructor
 */
function SharpenTool() {
    this.oldx = 0;
    this.oldy = 0;
    this.mouseDrag = {
        start: {},
        end: {}
    }
    this.previousPos = {};
    this.minLevelValue = 0;
    this.maxLevelValue = 8;
}

SharpenTool.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    var imageRenderer = this.activeImageRenderer;
    if (imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        var presentation = imageRenderer.getPresentation();
        if (presentation) {
            var imageCanvas = null;
            imageRenderer.imagePromise.then(function (image) {
                imageCanvas = image;
            });
            var offset = imageRenderer.locationOnScreen();
            if (evt.type === "mousedown") {
                this.mouseDrag.start.x = evt.pageX - offset.x;
                this.mouseDrag.start.y = evt.pageY - offset.y;
                this.previousPos = this.mouseDrag.start;
                this.startPos = this.mouseDrag;
            } else if (evt.type === "touchstart") {
                evt.preventDefault();
                var touch = evt.touches[0];
                this.mouseDrag.start.x = touch.pageX - offset.x;
                this.mouseDrag.start.y = touch.pageY - offset.y;
                this.previousPos = this.mouseDrag.start;
                this.startPos = this.mouseDrag;
            }
        }
    }
};

SharpenTool.prototype.hanleMouseMove = function (evt) {
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
            this.previousPos = currentPos;

            var mouseRegion = this.hitTestAndGetMousePosition(evt);
            if (!mouseRegion) {
                return;
            }

            if (mouseRegion.isPtInRegion) {
                this.updateSharpen(diffX, diffY, imageRenderer);
            }
        }
    }
};

SharpenTool.prototype.hanleMouseUp = function (evt) {
    var presentation = (this.activeImageRenderer).getPresentation();
    var sharpen = Math.round(presentation.sharpen);

    if (this.minLevelValue > sharpen) {
        presentation.sharpen = this.minLevelValue;
    } else if (this.maxLevelValue < sharpen) {
        presentation.sharpen = this.maxLevelValue;
    }
    presentation.setSharpen(presentation.sharpen);
    this.isMousePressed = false;
};

SharpenTool.prototype.hanleMouseOut = function (evt) {

    var presentation = (this.activeImageRenderer).getPresentation();
    var sharpen = Math.round(presentation.sharpen);

    if (this.minLevelValue > sharpen) {
        presentation.sharpen = this.minLevelValue;
    } else if (this.maxLevelValue < sharpen) {
        presentation.sharpen = this.maxLevelValue;
    }
    presentation.setSharpen(presentation.sharpen);
    this.isMousePressed = false;
};

/**
 * Update the brightness values
 * @param {Type} image - Specifies the image
 */
SharpenTool.prototype.updateSharpen = function (diffX, diffY, imageRender) {
    var presentation = imageRender.getPresentation();
    var incrSharpeness = false;

    if ((diffX >= 0 && diffY < 0) || (diffX < 0 && diffY < 0)) {
        presentation.sharpen = parseFloat(presentation.sharpen) - parseFloat(0.5);
    } else if ((diffX < 0 && diffY > 0) || (diffX > 0 && diffY > 0)) {
        presentation.sharpen = parseFloat(presentation.sharpen) + parseFloat(0.5);
    } else {
        return;
    }

    presentation.sharpen = (Math.abs(presentation.sharpen)).toFixed(1);
    if (presentation.sharpen % 1 !== 0) {
        return;
    }
    presentation.setSharpen(parseInt(presentation.sharpen));

    if (this.minLevelValue > presentation.sharpen) {
        presentation.sharpen = this.minLevelValue;
    } else if (this.maxLevelValue < presentation.sharpen) {
        presentation.sharpen = this.maxLevelValue;
    }

    (this.activeImageRenderer).applyOrRevertDisplaySettings(presentation, undefined, undefined, true);

    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
        var imageLevelId = $(this).attr('id');
        var imageRender = seriesLayout.getImageRender(imageLevelId);
        if (imageRender) {
            imageRender.renderImage(false);
        }
    });
};
