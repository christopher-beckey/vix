WindowLevel.prototype = new MouseTool();
WindowLevel.prototype.constructor = WindowLevel;

function WindowLevel() {
    this.mouseDrag = {
        start: {},
        end: {}
    }
    this.previousPos = {};

    // Brought the logic from ISI Rad
    this.startLevel = 0;
    this.startWindow = 0;
    this.windowUnitsPerPixelLeft = 0;
    this.windowUnitsPerPixelRight = 0;
    this.levelUnitsPerPixelUp = 0;
    this.levelUnitsPerPixelDown = 0;
    this.minLevelValue = 0;
    this.maxLevelValue = 0;
    this.minWindowValue = 1;
    this.maxWindowValue = 0;
    this.isWinLevReversed = false;
}

WindowLevel.prototype.hanleMouseDown = function (evt) {
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
                this.updateWindowLevel(imageCanvas);
                this.previousPos = this.mouseDrag.start;
            } else if (evt.type === "touchstart") {
                evt.preventDefault();
                var touch = evt.touches[0];
                this.mouseDrag.start.x = touch.pageX - offset.x;
                this.mouseDrag.start.y = touch.pageY - offset.y;
                this.updateWindowLevel(imageCanvas);
                this.previousPos = this.mouseDrag.start;
            }
        }
    }
};

WindowLevel.prototype.hanleMouseMove = function (evt) {
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
            //console.log(diffX, diffY);

            if (currentPos.x >= 0 &&
                currentPos.y >= 0 &&
                currentPos.x < imageRenderer.renderWidget.width &&
                currentPos.y < imageRenderer.renderWidget.height &&
                ((evt.type === "touchmove" && evt.touches.length == 1) || evt.type === "mousemove")) {
                var deltaX = diffX;
                var deltaY = diffY;
                var deltaWindow = 0;
                var deltaLevel = 0;

                if (this.isWinLevReversed) {
                    deltaWindow = deltaX;
                    deltaLevel = deltaY;
                    deltaWindow *= deltaX > 0 ? this.windowUnitsPerPixelRight : this.windowUnitsPerPixelLeft;
                    deltaLevel *= deltaY > 0 ? this.levelUnitsPerPixelUp : this.levelUnitsPerPixelDown;
                } else {
                    deltaWindow = deltaY;
                    deltaLevel = deltaX;
                    deltaWindow *= deltaY > 0 ? this.windowUnitsPerPixelRight : this.windowUnitsPerPixelLeft;
                    deltaLevel *= deltaX > 0 ? this.levelUnitsPerPixelUp : this.levelUnitsPerPixelDown;
                }

                var window = this.startWindow + deltaWindow;
                var level = this.startLevel + deltaLevel;

                // Validate the window level values.
                if (window < this.minWindowValue) {
                    window = this.minWindowValue;
                } else if (window > this.maxWindowValue) {
                    window = this.maxWindowValue;
                }

                if (level < this.minLevelValue) {
                    level = this.minLevelValue;
                } else if (level > this.maxLevelValue) {
                    level = this.maxLevelValue;
                }

                this.startWindow = window;
                this.startLevel = level;

                var seriesLayout = dicomViewer.getActiveSeriesLayout();
                $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                    var imageLevelId = $(this).attr('id');
                    var imageRender = seriesLayout.getImageRender(imageLevelId);
                    if (imageRender) {
                        imageRender.doWindowLevel(level, window, true);
                    }
                });
            }
        }
    }
};

WindowLevel.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
};

WindowLevel.prototype.hanleMouseOut = function (evt) {
    this.isMousePressed = false;
};

/**
 * Update the window/level values
 * @param {Type} image - Specifies the image
 */
WindowLevel.prototype.updateWindowLevel = function (image) {
    var presentation = image.presentation;
    this.minLevelValue = presentation.windowLevelLimits.wcLimit.min;
    this.maxLevelValue = presentation.windowLevelLimits.wcLimit.max;
    this.minWindowValue = presentation.windowLevelLimits.wwLimit.min;
    this.maxWindowValue = presentation.windowLevelLimits.wwLimit.max;

    var windowLeft = this.startWindow;
    var windowRight = this.maxWindowValue - windowLeft;
    var levelUp = this.maxLevelValue - this.startLevel;
    var levelDown = this.startLevel - this.minLevelValue;

    if (!image.isColorImage) {
        levelUp = this.minLevelValue - this.startLevel;
        levelDown = this.startLevel - this.maxLevelValue;
    }

    var pixelsLeft = 1;
    if (this.mouseDrag.start.x > 0) {
        pixelsLeft = this.mouseDrag.start.x;
    }

    var pixelsRight = this.activeImageRenderer.renderWidget.width - this.mouseDrag.start.x;
    var pixelsUp = 1;
    if (this.mouseDrag.start.y > 0) {
        pixelsUp = this.mouseDrag.start.y;
    }

    var pixelsDown = this.activeImageRenderer.renderWidget.height - this.mouseDrag.start.y;
    if (this.isWinLevReversed) {
        this.windowUnitsPerPixelLeft = windowLeft / pixelsLeft;
        this.windowUnitsPerPixelRight = windowRight / pixelsRight;
        this.levelUnitsPerPixelUp = levelUp / pixelsUp;
        this.levelUnitsPerPixelDown = levelDown / pixelsDown;
    } else {
        this.windowUnitsPerPixelLeft = windowLeft / pixelsDown;
        this.windowUnitsPerPixelRight = windowRight / pixelsUp;
        this.levelUnitsPerPixelUp = levelUp / pixelsRight;
        this.levelUnitsPerPixelDown = levelDown / pixelsLeft;
    }
};
